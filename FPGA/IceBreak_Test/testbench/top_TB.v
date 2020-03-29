//-----------------------------------------------------------------------------
//
// Title       : top_tb
// Design      : top_tb
// Author      : Aldec, Inc
// Company     : Aldec, Inc
//
//-----------------------------------------------------------------------------
//
// File        : top_TB.v
// Generated   : Sun Mar 22 00:33:54 2020
// From        : C:\Users\birdman\Documents\DirtBagLabSupplies\DMM\FPGA\IceBreaker_Test\IceBreak_Test\testbench\top_TB_settings.txt
// By          : tb_verilog.pl ver. ver 1.2s
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------

`timescale 1ns / 10ps
module top_tb;
//Parameters declaration: 
//defparam UUT.pClkFreq = 48000000;
parameter pClkFreq = 48000000;
//defparam UUT.pBaudRate = 115200;
parameter pBaudRate = 115200;
parameter C12M_CLK_PERIOD = 84; //12MHz ~= 83.3ns  
parameter CLK_48_PER = 21;
//Internal signals declarations:
reg iClk;
reg BTN_N;
wire LEDR_N;
wire LEDG_N;
wire P1A7;
wire P1A8;
wire P1A9;
reg BTN1;
wire oTx;
wire iRx;

wire iResetn;
assign iResetn = BTN_N;


//////// UART Driver ///////
//Wire the UART module to the top module uart. 
wire wRxUut;								
reg [7:0] rTxByte;	
reg rTransmit;
wire wRcvd;
wire [7:0] wRxByte;
wire wIsRcving;
wire wIsXmit;
wire wRcvErr; 

uart Label1 (
	.clk(iClk),
	.rst(iReset),
	.rx(oTx),
	.tx(iRx),
	.transmit(rTransmit),
	.tx_byte(rTxByte),
	.received(wRcvd),
	.rx_byte(wRxByte),
	.is_receiving(wIsRcving),
	.is_transmitting(wIsXmit),
	.recv_error(wRcvErr)
);

////////////////////////////////////


initial	 begin	
	iClk <= 0; 
	BTN1 <= 1'b0;
	BTN_N <= 1;
	rTxByte <= 0;
	rTransmit <= 0;
	//Wait for PLL
	#(C12M_CLK_PERIOD);	
	#(C12M_CLK_PERIOD);
	#(C12M_CLK_PERIOD);
	#(C12M_CLK_PERIOD);
	//#(CLK_48_PER) iRx <= 1'b1;
	#(C12M_CLK_PERIOD) BTN_N <= 0;	 //Reset   
	#(C12M_CLK_PERIOD);
	#(C12M_CLK_PERIOD);
	#(C12M_CLK_PERIOD);
	#(C12M_CLK_PERIOD) BTN_N <= 1;
	#(C12M_CLK_PERIOD);
	#(C12M_CLK_PERIOD);
	#(C12M_CLK_PERIOD);
	#(C12M_CLK_PERIOD);
	#(C12M_CLK_PERIOD);
	#(C12M_CLK_PERIOD);
	#(C12M_CLK_PERIOD) rTxByte <= 8'hAA;	 //Prep the buffer
	#(C12M_CLK_PERIOD) rTransmit <= 1'b1;	 //send
	#(C12M_CLK_PERIOD) rTransmit <= 0'b0;	 //start waiting
	#(C12M_CLK_PERIOD) BTN_N <= 1;	 //Reset
	#(C12M_CLK_PERIOD) BTN_N <= 1;	 //Reset
	@(posedge wRcvd); //Wait for this to work;
	if(rTxByte == wRxByte) begin
		$display ("Test Passed - Correct byte received");
	end else begin
		$display("Failed - uart test. Sent: AA, Rcvd: %h", wRxByte);
	end
	 $finish;
	
	
	$monitor($realtime,,"ps %h %h %h %h %h %h %h %h %h %h ",iClk,BTN_N,LEDR_N,LEDG_N,P1A7,P1A8,P1A9,BTN1,oTx,iRx);
end	 

always begin
	#(C12M_CLK_PERIOD / 2) iClk <= !iClk; 
	
	
end
/////////////////////// UUT ///////////////////////////////////////
// Unit Under Test port map
	top UUT (
		.iClk(iClk),
		.BTN_N(BTN_N),
		.LEDR_N(LEDR_N),
		.LEDG_N(LEDG_N),
		.P1A7(P1A7),
		.P1A8(P1A8),
		.P1A9(P1A9),
		.BTN1(BTN1),
		.oTx(oTx),
		.iRx(iRx));
endmodule
