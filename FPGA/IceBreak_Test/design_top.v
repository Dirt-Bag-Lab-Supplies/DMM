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
assign P1A2 = wRxEn;
assign P1A3 = oRx_n; 
assign P1A4 = oTx_n;


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
assign wRst = !wPllLocked;


///////////////////UART///////////////////////
localparam pClkFreq = 48_000_000; // 42MHz
//localparam baud = 57600;
localparam pBaudRate = 115200;

	// reg iClk;
	// reg iResetn;
	// reg iRx;
	// wire oTx;

reg rUartTxEn;
reg [7:0] rUartTxData;
reg rUartRxEn;
reg [7:0] rUartRxData;
//Tx wires
wire wUartTxEn;
assign wUartTxEn = rUartTxEn;
wire wUartTxFull;
wire [7:0] wUartTxData;
assign wUartTxData = rUartTxData;
//Rx Wires
wire wUartRxEn;
assign wUartRxEn = rUartRxEn;
wire wUartRxEmpty;
wire [7:0] wUartRxData;	

//UART -- Inputs 
//input iRx;
wire wRx;
assign wRx = P1A1;
//UART -- Outputs
//output oTx;
wire wTx;
assign P1A7 = wTx; 

uart_fifo #(
	.pClkFreq(pClkFreq),
	.pBaudRate(pBaudRate),
	.pTxFifoDepth(8), //Dont change these. It doesnt handle that right now
	.pRxFifoDepth(8)
)uart_inst0(
	.iClk			(clk_48mhz),	//FPGA Clock
	.iRst 			(wRst),
	//TX
	.iTxEn 			(wUartTxEn),  // Data valid writing data to dual port ram
	.oTxFull  		(wUartTxFull), 	//Ram is full, stop writing
	.iTxData		(wUartTxData), //Data to transmit from FPGA to FTDI
	//RX
	.iRxEn			(wUartRxEn),
	.oRxEmpty 		(wUartRxEmpty),
	.oRxData		(wUartRxData),
	//UART
	.iRx 			(wRx),	//External Rx line
	.oTx 			(wTx), 	//Extnernal TX Line
	.oRcvErr		(wUartRcvErr)
);

///////UART TX Machine///////// 
always @(posedge clk_48mhz) begin
	if(wRst) begin
		rUartTxEn <= 0;
		rUartTxData <= 8'h40;

	end else begin
		if(!wUartTxFull) begin //If - uart isn't full look for data to send
			if(rUartRxFlag) begin //Loop back from uart module
				rUartTxData <= rUartRxData; 
				rUartTxEn <= 1'b1;			  		
			end else if(rRxEn) begin
				rUartTxData <= rRxData; 
				rUartTxEn <= 1'b1;
			end else begin
				rUartTxEn <= 1'b0; //clear write flag
			end
		end else begin
			rUartTxEn <= 1'b0; //Clear flag
		end
	end
end

localparam RX_IDLE = 0;
localparam RX_START = 1;
localparam RX_DONE = 2;
reg [2:0] rUartRxState;
reg rUartRxFlag; 
///////RX Machine/////////
always @(posedge clk_48mhz) begin
	if(wRst) begin
		rUartRxEn <= 0;
		rUartRxData <= 8'b0;
		rUartRxFlag <= 1'b0;
		rUartRxState <= RX_IDLE;
	end else begin
		case(rUartRxState)
			RX_IDLE : begin
				rUartRxFlag <= 1'b0;
				if(!wUartRxEmpty) begin //Rx Data
					rUartRxEn <= 1'b1; //Start reading
					rUartRxState <= RX_START;
				end else 
					rUartRxEn <= 1'b0;
			end
			RX_START : begin
				rUartRxEn <= 1'b0;
				rUartRxState <= RX_IDLE;
				rUartRxData <= wUartRxData;
				rUartRxFlag <= 1'b1; 
			end
		endcase // rUartRxState
	end
end
/////////////////////////////////////////////////////////////
//This module writes data to RAM as long as TxEn is high. There is no error checking for TxFull. 
//The output continuosly writes to the ftdi as long as data is in the buffer. 
//First test. 
// Continuosly write counter to the fifo while TxFull is low. 

reg rTxEn;
reg [7:0] rTxData;
reg rRxEn;
reg [7:0] rRxData;
//Tx wires
wire wTxEn;
assign wTxEn = rTxEn;
wire wTxFull;
wire [7:0] wTxData;
assign wTxData = rTxData;
//Rx Wires
wire wRxEn;
assign wRxEn = rRxEn;
wire wRxEmpty;
wire [7:0] wRxData;

////FTDI Interface////
wire wRxF_n;		//RxBuffer on the Fifo has data
assign wRxF_n = iRxF_n;
wire wTxE_n;		//Tx Buffer on fifo is not full
assign wTxE_n = iTxE_n;
wire wRx_n;		//Start Rx from Ftdi
assign oRx_n = wRx_n;
wire wTx_n;		//Start Tx to Ftdi
assign oTx_n = wTx_n;
wire wSiwu;		//Enable the usb to wake up the computer. 
assign oSiwu = wSiwu;


////////////////////////////FTDI FIFO///////////////////////
ftdi_fifo_async #(
	.pTxFifoDepth(8), //Dont change these. It doesnt handle that right now
	.pRxFifoDepth(8)
)fifo_inst(
	.iClk			(clk_48mhz),	//FPGA Clock
	.iRst 			(wRst),
	//TX
	.iTxEn 			(wTxEn),  // Data valid writing data to dual port ram
	.oTxFull  		(wTxFull), 	//Ram is full, stop writing
	.iTxData		(wTxData), //Data to transmit from FPGA to FTDI
	//RX
	.iRxEn			(wRxEn),
	.oRxEmpty 		(wRxEmpty),
	.oRxData		(wRxData),
	//FTDI interface
	.ioFifoData 	(ioFifoData),	//Data bus to the FTDI
	.iRxF_n 		(wRxF_n),		//RxBuffer on the Fifo has data
	.iTxE_n 		(wTxE_n),		//Tx Buffer on fifo is empty
	.oRx_n    		(wRx_n),		//Start Rx from Ftdi
	.oTx_n 			(wTx_n),		//Start Tx to Ftdi
	.oSiwu			(wSiwu)		//Controller by external button
);


///////TX Machine///////// 
always @(posedge clk_48mhz) begin
	if(wRst) begin
		rTxEn <= 0;
		rTxData <= 8'h40;
	end else begin
		if(!wTxFull) begin // The fifo is empty, clear to send
			rTxData <= 8'h41; //"A"
			rTxEn <= 1'b1;
		end else begin
			rTxEn <= 1'b0; //Clear flag
		end
	end
end

/////RX Machine/////////
reg [2:0] rFtdiRxState;
reg rFtdiRxFlag; 

always @(posedge clk_48mhz) begin
	if(wRst) begin
		rRxEn <= 0;
		rFtdiRxState <= RX_IDLE;
		rFtdiRxFlag <= 1'b0;

	end else begin
		case(rFtdiRxState)
			RX_IDLE : begin
				rFtdiRxFlag <= 1'b0;
				if(!wRxEmpty) begin //Rx Data
					rRxEn <= 1'b1; //Start reading
					rFtdiRxState <= RX_START;
				end else 
					rRxEn <= 1'b0;
			end
			RX_START : begin
				rRxEn <= 1'b0;
				rFtdiRxState <= RX_IDLE;
				rRxData <= wRxData;
				rFtdiRxFlag <= 1'b1; 
			end
		endcase // rFtdiRxState
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

// //-----------------------------------------------------------------------------
// //
// // Title       : top_tb
// // Design      : top_tb
// // Author      : Aldec, Inc.
// // Company     : Aldec, Inc.
// //
// //-----------------------------------------------------------------------------
// //
// // File        : top_TB.v
// // Generated   : Mon Mar 30 17:17:18 2020
// // From        : C:\Users\birdman\Documents\DirtBagLabSupplies\DMM\DMM_trunk\FPGA\IceBreak_Test\testbench\top_TB_settings.txt
// // By          : tb_verilog.pl ver. ver 1.2s
// //
// //-----------------------------------------------------------------------------
// //
// // Description : 
// //
// //-----------------------------------------------------------------------------

// `timescale 10ns / 1ps
// module top_tb;
// //Parameters declaration: 

// parameter C12M_CLK_PERIOD = 84; //12MHz ~= 83.3ns  
// parameter CLK_48_PER = 21;


// //////////////////////////UART Module//////////////////////	


 
// wire wUartTxRdEn; //Output to read data
//  reg rUartTxRdEmpty;
// wire wUartTxRdEmpty;   
// assign wUartTxRdEmpty = rUartTxRdEmpty; //Set low to send data. 
// reg [7:0] rUartTxRdData;
// wire [7:0] wUartTxRdData; 
// assign wTxRdData = rUartTxRdData; //external tx to module		
	
// ///Read from device
// wire wUartRxWrEn;  //Use this as flag the device read something

// reg rUartRxWrFull;			//Set this low before trying to receive
// wire wUartRxWrFull;		
// assign wUartRxWrFull = rUartRxWrFull;
// wire [7:0] wUartRxWrData;

// //Module error
// wire wExtRecvErr; 
// //UART to Top Interface
// wire wTopRx;
// assign wTopRx = P1A1;
// wire wTopTx;
// assign wTopTx = P1A7;
 
// parameter pUartClkFreq = 12000000; 
// parameter pUartBaudRate = 115200;
// uart#(
// 	.pClkFreq(pUartClkFreq),
// 	.pBaudRate(pUartBaudRate)
// ) uart_ext_inst(
// 	////Internal inputs////
// 	.iClk			(iClk),		//48mhz sys clock for async
// 	.iRst			(iRst),
// 	////Tx Input Fifo////
// 	.oTxRdEn		(wTxRdEn),
// 	.iTxRdEmpty		(wTxRdEmpty),
// 	.iTxData		(wTxRdData),
// 	////Rx Output Fifo////
// 	.oRxWrEn		(wRxWrEn),
// 	.iRxWrFull		(wRxWrFull),
// 	.oRxData		(wRxWrData),
// 	//UART
// 	.iRx 			(wTopTx),	//External Rx line
// 	.oTx 			(wTopRx), 	//Extnernal TX Line
// 	.oRcvErr		(wExtRecvErr)
	
//  );

// //////////////////////////////////////////////////////

// //////////////DUT PORTS///////////////////////
// reg iClk;
// reg BTN_N;
// reg BTN1;
// reg P1A1;
// wire P1A2;
// wire P1A3;
// wire P1A4;
// wire P1A7;
// wire P1A8;
// wire P1A9;
// wire [7:0]ioFifoData_bidir;

// reg iRxF_n;
// reg iTxE_n;
// wire oRx_n;
// wire oTx_n;
// /////////////////////////////////////////////////


// // Unit Under Test port map
// 	top UUT (
// 		.iClk(iClk),
// 		.BTN_N(BTN_N),
// 		.BTN1(BTN1),
// 		.P1A1(P1A1),
// 		.P1A2(P1A2),
// 		.P1A3(P1A3),
// 		.P1A4(P1A4),
// 		.P1A7(P1A7),
// 		.P1A8(P1A8),
// 		.P1A9(P1A9),
// 		.ioFifoData(ioFifoData_bidir),
// 		.iRxF_n(iRxF_n),
// 		.iTxE_n(iTxE_n),
// 		.oRx_n(oRx_n),
// 		.oTx_n(oTx_n));

// initial	 begin
// 	$monitor($realtime,,"ps %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h ",iClk,BTN_N,BTN1,P1A1,P1A2,P1A3,P1A4,P1A7,P1A8,P1A9,ioFifoData_bidir,iRxF_n,iTxE_n,oRx_n,oTx_n);
//  	iClk <= 1'b0;
// 	BTN_N <= 1'b0; 
// 	iRxF_n <= 1'b1;
// 	iTxE_n <= 1'b1;
// 	rUartTxRdData <= 8'h00;
// 	rUartTxRdEmpty <= 1'b1;
// 	rUartRxWrFull <= 1'b0; //Clear the buffer to read from;
	
// 	#(C12M_CLK_PERIOD);	
// 	#(C12M_CLK_PERIOD);
// 	#(C12M_CLK_PERIOD);
// 	#(C12M_CLK_PERIOD);
// 	#(C12M_CLK_PERIOD) BTN_N <= 0;	 //Reset   
// 	#(C12M_CLK_PERIOD);
// 	#(C12M_CLK_PERIOD);
// 	#(C12M_CLK_PERIOD);
// 	#(C12M_CLK_PERIOD) BTN_N <= 1;
// 	#(C12M_CLK_PERIOD);
// 	#(C12M_CLK_PERIOD);
// 	#(C12M_CLK_PERIOD);
// 	#(C12M_CLK_PERIOD);
// 	#(C12M_CLK_PERIOD);
// 	#(C12M_CLK_PERIOD);
// 	rUartTxRdData <= 8'hAA; //Data to send
// 	rUartTxRdEmpty <= 1'b0; //Start sending;
// 	@(posedge wUartRxWrEn); //Wait for this to work;
// 		if(wUartRxWrData == rUartTxRdData) begin
// 			$display ("Test Passed - Correct byte received");
// 		end else begin
// 			$display("Failed - uart test. Sent: AA, Rcvd: %h", wUartRxWrData);
// 		end
// end


//  always begin
// 	#(C12M_CLK_PERIOD / 2) iClk <= !iClk; 
	
// end	
	
	
	
// endmodule
