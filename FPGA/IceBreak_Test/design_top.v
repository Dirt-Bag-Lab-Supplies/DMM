// Cause yosys to throw an error when we implicitly declare nets
//`timescale 1ns/1ps
//`default_nettype none


module top (
	iClk,
	BTN_N,	//Input from BTN, system reset for now
	BTN1,
	P1A1,	// Debug Rx
	P1A2,	//Fifo Rx Data Flag
	P1A3,	//Fifo oRx_n
	P1A4,	//Fifo oTx_n
	P1A7, 	// Debug TX
	P1A8,  
	P1A9,
		//UART
	//oTx,
	//iRx,	
		//FTDI interface
	//clk_60mhz,	//Clk from FTDI fifo
	ioFifoData,	//Data bus to the FTDI
	iRxF_n,		//RxBuffer on the Fifo has data
	iTxE_n,		//Tx Buffer on fifo is empty
	oRx_n,		//Start Rx from Ftdi
	oTx_n,		//Start Tx to Ftdi
	//oOe_n	 	//Select Rd/Wr direction on bus. 0 = Read : 1 = Write
	//oSiwu		//Enable the usb to wake up the computer. Connected to BTN_N 
);

//inputs general
input iClk; //12mhz generates 48mhz pll
input BTN_N,  BTN1, P1A1;
output P1A7, P1A8, P1A9, P1A2, P1A3, P1A4;
assign P1A2 = oRxFlag;
assign P1A3 = oRx_n; 
assign P1A4 = oTx_n;

//UART -- Inputs 
//input iRx;
wire iRx;
assign iRx = P1A1;
//UART -- Outputs
//output oTx;
wire oTx;
assign P1A7 = oTx; 
//FTDI FIFO Bus
//Inputs 60Mhz
input iRxF_n, iTxE_n; //clk_60mhz, 
inout [7:0] ioFifoData;
//Outputs 60mhz
output oRx_n, oTx_n; // oOe_n //oSiwu -- not used, connected to BTN_N




//wire clk_60mhz; //This is only for the fifo
wire clk_48mhz;
wire wPllLocked;
top_pll top_pll_inst(
					.PACKAGEPIN(iClk),
					.PLLOUTCORE(),
					.PLLOUTGLOBAL(clk_48mhz),
					.RESET(BTN_N),
					.LOCK(wPllLocked)
);
////////////////////////////////  RESET Block ////////////////////////////
wire wRst; //Global reset. Reset active high
//reg [5:0] rRESETCNT;

assign wRst = !wPllLocked;
//Wait for a few clocks system clocks
// always @(posedge clk_48mhz)
// begin
	// if(!BTN_N) begin
		// rRESETCNT <= 5'b0; //Set reset low
	// end else begin
		// if (!rRESETCNT[5]) begin
			// rRESETCNT<=rRESETCNT+1;
		// end
	// end
// end

///////////////////Common registers/////////////////////////////
wire [7:0] wRxFifoData; //bus coming from output of async fifo. not permanent. 
wire oRxFlag;

///////////////////FTDI UART///////////////////////
localparam pClkFreq = 48_000_000; // 42MHz
//localparam baud = 57600;
localparam pBaudRate = 115200;

	// reg iClk;
	// reg iResetn;
	// reg iRx;
	// wire oTx;
	wire [7:0] wRxByteOut;
	reg rRxRead;
	wire wRxBufferEmpty;
	wire wUartError;
	reg [7:0] rTxByte;
	reg rTxWrite;
	wire wUartTxBusy;


uart_fifo #(
	.pClkFreq(pClkFreq),
	.pBaudRate(pBaudRate),
	.pRxFifoByteLength(4),
	.pTxFifoByteLength(4)
)DUT(
	.iClk				(clk_48mhz),
	.iResetn			(wRst),
	.iRx				(iRx),
	.oTx				(oTx),
	.oRxByteOut			(wRxByteOut),
	.iRxRead			(rRxRead),
	.oRxBufferEmpty		(wRxBufferEmpty),
	.rUartError			(wUartError),
	.iTxByte			(rTxByte),
	.iTxWrite			(rTxWrite),
	.oUartTxBusy		(wUartTxBusy)
);


always @(posedge clk_48mhz) begin
	if(wRst) begin
		rRxRead <= 1'b0;
		rTxByte <= 8'b0;
		rTxWrite <= 1'b0;
		
	end else begin
		if(oRxFlag) begin //Received byte from the fifo
			rTxByte <= wRxFifoData; //Put fifo data on the uart bus
			rTxWrite <= 1'b1;
		end else 
			if(!wUartTxBusy) begin

				if(!wRxBufferEmpty) begin	
					rTxByte <= wRxByteOut;
					rRxRead <= 1'b1;
					rTxWrite <= 1'b1;
				end else begin
					rRxRead <= 1'b0;
					rTxWrite <= 1'b0;
				end
			end else begin 
				rRxRead <= 1'b0;
				rTxWrite <= 1'b0;
			end 
	end
end
/////////////////////////////////////////////////////////////
//This module writes data to RAM as long as TxEn is high. There is no error checking for TxFull. 
//The output continuosly writes to the ftdi as long as data is in the buffer. 
//First test. 
// Continuosly write counter to the fifo while TxFull is low. 
//Module inputs
wire wTxData;
reg wTxEn;
wire wTxFull;

//Test variables
reg [7:0] counter;

assign wTxData = 8'hAA;

////////////////////////////FTDI FIFO///////////////////////
ftdi_fifo #(
	.pDataWidth(8), //Dont change these. It doesnt handle that right now
	.pMaxData(8)
)fifo_inst(
	//Tx FPGA Interface
	.iClk			(clk_48mhz),	//FPGA Clock
	.iRst 			(wRst),
	.iTxData		(wTxData), //Data to transmit from FPGA to FTDI
	.iTxEn 			(wTxEn),  // Data valid writing data to dual port ram
	.oTxFull  		(wTxFull), 	//Ram is full, stop writing
	//FTDI interface
	//.iFifoClk 		(clk_60mhz),	//Clk from FTDI fifo
	.ioFifoData 	(ioFifoData),	//Data bus to the FTDI
	.iRxF_n 		(iRxF_n),		//RxBuffer on the Fifo has data
	.iTxE_n 		(iTxE_n),		//Tx Buffer on fifo is empty
	.oRx_n    		(oRx_n),		//Start Rx from Ftdi
	.oTx_n 			(oTx_n),		//Start Tx to Ftdi
//	.oOe_n  		(oOe_n),	 	//Select Rd/Wr direction on bus. 0 = Read : 1 = Write
	.oSiwu			(oSiwu),		//Controller by external button
	.oRxData		(wRxFifoData),
	.oRxFlag		(oRxFlag)
);

always @(clk_48mhz) begin
	if(wRst) begin
		counter <= 0;
		wTxEn <= 0;
	end else begin
		if(!wTxFull) begin //buffer is not full, increment counter and send
			//counter <= counter == 8'hFF ? 8'h00 : counter + 1; 
			wTxEn <= 1; 
		end else begin
			wTxEn <= 0;
		end 
	end
end


/*
// Loopback the TX and RX lines with no processing
// Useful as a sanity check ;-)
//assign TX = RX;
// PWM generator
reg [15:0] pwm_counter = 0;
reg [15:0] pwm_compare = 256;
reg pwm_out;
always @(posedge clk_48mhz) begin
	// Divide clock by 65535
	// Results in a 183.11Hz PWM
	pwm_counter <= pwm_counter + 1;

	// Set pwm output according to the compare
	// Set output high when the counter is smaller than the compare value
	// Set output low when the counter is equal or higher than the compare
	// value
	if (pwm_counter < pwm_compare) begin
		pwm_out <= 1;
	end else begin
		pwm_out <= 0;
	end
end

// PWM compare generator
// Fading up and down creating a slow sawtooth output
// The fade up down takes about 11.18 seconds
// Note: You will see that the LEDs spend more time being very bright
// than visibly fading, this is because our vision is non linear. Take a look
// at the pwm_fade_gamma example that fixes this issue. :)
reg [17:0] pwm_inc_counter = 0;
reg [16-7:0] pwm_compare_value = 0;
always @(posedge clk_48mhz) begin
	// Divide clock by 131071
	pwm_inc_counter <= pwm_inc_counter + 1;

	// increment/decrement pwm compare value at 91.55Hz
	if (pwm_inc_counter[17]) begin
		pwm_compare_value <= pwm_compare_value + 1;
		pwm_inc_counter <= 0;
	end

	if (pwm_compare_value[16-7])
		pwm_compare <= ~pwm_compare_value << 7;
	else
		pwm_compare <=  pwm_compare_value << 7;
end

assign LEDG_N = ~pwm_out;
assign LEDR_N =  pwm_out;
assign P1A7 = pwm_counter[10]; // 50% duty cycle PWM clock out
assign P1A8 = pwm_out; // PWM output on a GPIO pin
assign P1A9 = BTN1;

*/
endmodule