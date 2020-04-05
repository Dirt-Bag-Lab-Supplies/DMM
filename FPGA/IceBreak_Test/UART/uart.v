//`timescale 1ns / 1ps
// Documented Verilog UART
// Copyright (C) 2010 Timothy Goddard (tim@goddard.net.nz)
// Distributed under the MIT licence.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
// 
module uart #(
	parameter pClkFreq=12000000, //12MHz default
	parameter pBaudRate=115200,
	parameter pOverSampling = 1
)(
	////Internal inputs////
	iClk,		//48mhz sys clock for async
	iRst,
	////Tx Input Fifo////
	oTxRdEn,
	iTxRdEmpty,
	iTxData,
	////Rx Output Fifo////
	oRxWrEn,
	iRxWrFull,
	oRxData,
	//UART Interface
	iRx,	//External Rx line
	oTx, 	//Extnernal TX Line
	oRcvErr
);

//Internal Inputs
input iClk, iRst;

//Tx Fifo
output oTxRdEn;
input iTxRdEmpty;
input [7:0] iTxData;

//Rx Fifo
output oRxWrEn;
input iRxWrFull;
output [7:0] oRxData;

//UART Lines
input iRx;
output oTx;
output oRcvErr;

///Fifo registers
reg rTxRdEn;
assign oTxRdEn = rTxRdEn;
reg rRxWrEn;
assign oRxWrEn = rRxWrEn;
reg [7:0] rRxData;	//Register incoming data to write to fifo
assign oRxData = rRxData;
reg [7:0] rTxData; //Register to store incoming data.


wire [7:0] wTxData;
assign wTxData = iTxData;

//Flow control
wire wRxEn; //Wire to determine if everything is ready to receive
assign wRxEn = !iRxWrFull; //If ftdi has data and buffer is not full
wire wTxEn;
assign wTxEn = tx_state == TX_IDLE && !iTxRdEmpty; //FTDI has data and buffer has data




//UART Registers
wire wRx;
assign wRx = iRx;
reg rTx; //Tx Driver
assign oTx = rTx;
reg rRcvErr; //Reg to flag errors 
assign oRcvErr = rRcvErr;

//Clock divider for uart 
localparam pClkDivideWidth = $clog2(pClkFreq / pBaudRate) + 8;

localparam CLOCK_DIVIDE = (pClkFreq / (pBaudRate * 4));
reg [pClkDivideWidth:0] rx_clk_divider = CLOCK_DIVIDE;
reg [pClkDivideWidth:0] tx_clk_divider = CLOCK_DIVIDE;




/////STATE Machine //////

// States for the receiving state machine.
// These are just constants, not parameters to override.
parameter RX_IDLE = 0;
parameter RX_CHECK_START = 1;
parameter RX_READ_BITS = 2;
parameter RX_CHECK_STOP = 3;
parameter RX_DELAY_RESTART = 4;
parameter RX_ERROR = 5;
parameter RX_RECEIVED = 6;

// States for the transmitting state machine.
// Constants - do not override.
parameter TX_IDLE = 0;
parameter TX_START = 1;
parameter TX_SENDING = 2;
parameter TX_DELAY_RESTART = 3;



reg [2:0] rx_state = RX_IDLE;
reg [5:0] rx_countdown;
reg [3:0] rx_bits_remaining;


reg [1:0] tx_state = TX_IDLE;
reg [5:0] tx_countdown;
reg [3:0] tx_bits_remaining;

//////Rx FSM///////
always @(posedge iClk) begin
	if (iRst) begin
		rx_state <= RX_IDLE;
		rRxData <= 8'b0;
		rRxWrEn <= 1'b0;
		rRcvErr <= 1'b0;
	end else begin
		// Receive state machine
		case (rx_state)
			RX_IDLE: begin
				rRxWrEn <= 1'b0; 
				rRcvErr <= 1'b0; //Write and error
				// A low pulse on the receive line indicates the
				// start of data.
				if (!wRx) begin //Look for low signal on RX line
					rx_state <= RX_CHECK_START;
				end
			end
			RX_CHECK_START: begin
				if (!rx_countdown) begin
					// Check the pulse is still there
					if (!wRx) begin
						// Pulse still there - good
						// Wait the bit period to resume half-way
						// through the first bit.
						rx_bits_remaining <= 7;
						rx_state <= RX_READ_BITS;
					end else begin
						// Pulse lasted less than half the period -
						// not a valid transmission.
						rx_state <= RX_ERROR;
					end
				end
			end
			RX_READ_BITS: begin
				if (!rx_countdown) begin
					// Should be half-way through a bit pulse here.
					// Read this bit in, wait for the next if we
					// have more to get.
					rRxData <= {wRx, rRxData[7:1]};
					rx_bits_remaining <= rx_bits_remaining - 1'b1;
					rx_state <= rx_bits_remaining ? RX_READ_BITS : RX_CHECK_STOP;
				end
			end
			RX_CHECK_STOP: begin
				if (!rx_countdown) begin
					// Should resume half-way through the stop bit
					// This should be high - if not, reject the
					// transmission and signal an error.
					rx_state <= wRx ? RX_RECEIVED : RX_ERROR;
				end
			end
			RX_DELAY_RESTART: begin
				// Waits a set number of cycles before accepting
				// another transmission.
				rRcvErr <= 1'b0; //Write and error
				rx_state <= rx_countdown ? RX_DELAY_RESTART : RX_IDLE;
			end
			RX_ERROR: begin
				// There was an error receiving.
				// Raises the recv_error flag for one clock
				// cycle while in this state and then waits
				// 2 bit periods before accepting another
				// transmission.
				rRcvErr <= 1'b1; //Write and error
				rx_state <= RX_DELAY_RESTART;
			end
			RX_RECEIVED: begin
				if(wRxEn) begin //If the buffer isn't full; otherwise throw away data
					rRxWrEn <= 1'b1;
				end else
					rRcvErr <= 1'b1; //Write and error
				// Successfully received a byte.
				// Raises the received flag for one clock
				// cycle while in this state.
				rx_state <= RX_IDLE;
			end
		endcase
	end
end

/////RX Clock Divider
always @(posedge iClk) begin
	if(iRst) begin
		rx_clk_divider <= CLOCK_DIVIDE;
		rx_countdown <= 0;
	end else begin

		rx_clk_divider <= rx_clk_divider - 1'b1;
		if (!rx_clk_divider) begin
			rx_clk_divider <= CLOCK_DIVIDE;
			rx_countdown <= rx_countdown - 1'b1;
		end

		case (rx_state)
			RX_IDLE: begin
				rx_clk_divider <= CLOCK_DIVIDE;
				rx_countdown <= 2;
			end
			RX_CHECK_START: begin
				if(!rx_countdown) begin //
					rx_countdown <= 4;
					//recv_state = RX_READ_BITS;
				end
			end
			RX_READ_BITS: begin
				if(!rx_countdown) begin //
					rx_countdown <= 4;
					//recv_state = RX_READ_BITS;
				end
			end
			RX_ERROR: begin
				// There was an error receiving.
				// Raises the recv_error flag for one clock
				// cycle while in this state and then waits
				// 2 bit periods before accepting another
				// transmission.
				rx_countdown <= 8;
			end
			// RX_CHECK_STOP:
			// RX_DELAY_RESTART:
			// RX_RECEIVED:
			default: begin
				//do nothing
			end
		endcase
	end
end
///////TX State machine//////

always @(posedge iClk) begin
	if(iRst) begin
		tx_state <= TX_IDLE;
		rTx <= 1'b1; //Set line high 
		rTxRdEn <= 1'b0;
		rTxData <= 8'b0;
		tx_bits_remaining <= 0;
				// Transmit state machine
	end else begin
		case (tx_state)
			TX_IDLE: begin
				if (wTxEn) begin //Flag that the TX Buffer has data
					tx_state <= TX_START;
					rTxRdEn <= 1'b1; //Set flag to read data -- data on bus next clock
				end
			end
			TX_START : begin //SEnd the start bit, read data from fifo
					tx_state <= TX_SENDING; 
					tx_bits_remaining <= 8;
					rTxData <= wTxData; //Register data from fifo. 
					rTxRdEn <= 1'b0; //Clear flag for now
					rTx <= 1'b0;
									// Send the initial, low pulse of 1 bit period
					// to signal the start, followed by the data
			end
			TX_SENDING: begin
				if (!tx_countdown) begin
					if (tx_bits_remaining) begin
						tx_bits_remaining <= tx_bits_remaining - 1'b1;
						rTx <= rTxData[0];
						rTxData <= {1'b0, rTxData[7:1]};
						tx_state <= TX_SENDING;
					end else begin
						// Set delay to send out 2 stop bits.
						rTx <= 1'b1;
						tx_state <= TX_DELAY_RESTART;
					end
				end
			end
			TX_DELAY_RESTART: begin
				// Wait until tx_countdown reaches the end before
				// we send another transmission. This covers the
				// "stop bit" delay.
				tx_state <= tx_countdown ? TX_DELAY_RESTART : TX_IDLE;
			end
		endcase
	end
end

//TX Clock dividers 
always @(posedge iClk) begin
	if(iRst) begin
		tx_clk_divider <= CLOCK_DIVIDE;
		tx_countdown <= 0;

	end else begin

		// The clk_divider counter counts down from
		// the CLOCK_DIVIDE constant. Whenever it
		// reaches 0, 1/16 of the bit period has elapsed.
		// Countdown timers for the receiving and transmitting
		// state machines are decremented.
		if(tx_countdown) begin //if still counting down
			tx_clk_divider <= tx_clk_divider - 1'b1;
			if (!tx_clk_divider) begin
				tx_clk_divider <= CLOCK_DIVIDE;
				tx_countdown <= tx_countdown - 1'b1;
			end	
		end else begin //Check what to reset tx count down to. 
			case (tx_state)
				TX_START : begin //SEnd the start bit, read data from fifo
						// Send the initial, low pulse of 1 bit period
						// to signal the start, followed by the data
					tx_countdown <= 4;
				end
				TX_SENDING:begin
					tx_countdown <= 4; 
				end
				TX_DELAY_RESTART : begin
					tx_countdown <= 8;
				end
				default : begin

				end

			endcase
		end
	end
end
endmodule




