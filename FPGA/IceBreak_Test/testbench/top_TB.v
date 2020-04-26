
//-----------------------------------------------------------------------------
//
// Title       : top_tb
// Design      : top_tb
// Author      : Noah Bergman
// Company     : Dirt Bag Lab Supplies
//
//-----------------------------------------------------------------------------
//
// File        : top_TB.v
// Generated   : Mon Mar 30 17:17:18 2020
// From        : C:\Users\birdman\Documents\DirtBagLabSupplies\DMM\DMM_trunk\FPGA\IceBreak_Test\testbench\top_TB_settings.txt
// By          : tb_verilog.pl ver. ver 1.2s
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------

`timescale 1ns / 1ps
module top_tb;
//Parameters declaration: 

parameter C12M_CLK_PERIOD = 84; //12MHz ~= 83.3ns  
parameter CLK_48_PER = 21;

//Clk and reset
 reg iClk;
reg BTN_N;
wire iRst;
assign iRst = !BTN_N;

//////////////DUT PORTS///////////////////////

reg BTN1;
wire P1A1; //This is driven from the uart module. 
wire P1A2;
wire P1A3;
wire P1A4;
wire P1A7;
wire P1A8;
wire P1A9;
wire [7:0]ioFifoData_bidir;

reg iRxF_n;
reg iTxE_n;
wire oRx_n;
wire oTx_n;
/////////////////////////////////////////////////

//////////////////////////UART Module//////////////////////	 
wire wUartTxRdEn; //Output to read data
 reg rUartTxRdEmpty;
wire wUartTxRdEmpty;   
assign wUartTxRdEmpty = rUartTxRdEmpty; //Set low to send data. 
reg [7:0] rUartTxRdData;
wire [7:0] wUartTxRdData; 
assign wUartTxRdData = rUartTxRdData; //external tx to module		
	
///Read from device
wire wUartRxWrEn;  //Use this as flag the device read something

reg rUartRxWrFull;			//Set this low before trying to receive
wire wUartRxWrFull;		
assign wUartRxWrFull = rUartRxWrFull;
wire [7:0] wUartRxWrData;

//Module error
wire wExtRecvErr; 
//UART to Top Interface
wire wTopRx;
assign P1A1 = wTopRx;
wire wTopTx;
assign wTopTx = P1A7;
 
parameter pUartClkFreq = 12000000; 
parameter pUartBaudRate = 115200;
uart#(
	.pClkFreq(pUartClkFreq),
	.pBaudRate(pUartBaudRate)
) uart_ext_inst(
	////Internal inputs////
	.iClk			(iClk),		//48mhz sys clock for async
	.iRst			(iRst),
	////Tx Input Fifo////
	.oTxRdEn		(wUartTxRdEn),
	.iTxRdEmpty		(wUartTxRdEmpty),
	.iTxData		(wUartTxRdData),
	////Rx Output Fifo////
	.oRxWrEn		(wUartRxWrEn),
	.iRxWrFull		(wUartRxWrFull),
	.oRxData		(wUartRxWrData),
	//UART
	.iRx 			(wTopTx),	//External Rx line
	.oTx 			(wTopRx), 	//Extnernal TX Line
	.oRcvErr		(wExtRecvErr)
	
 );

//////////////////////////////////////////////////////




// Unit Under Test port map
	top UUT (
		.iClk(iClk),
		.BTN_N(BTN_N),
		.BTN1(BTN1),
		.P1A1(P1A1),
		.P1A2(P1A2),
		.P1A3(P1A3),
		.P1A4(P1A4),
		.P1A7(P1A7),
		.P1A8(P1A8),
		.P1A9(P1A9),
		.ioFifoData(ioFifoData_bidir),
		.iRxF_n(iRxF_n),
		.iTxE_n(iTxE_n),
		.oRx_n(oRx_n),
		.oTx_n(oTx_n));

initial	 begin
	$monitor($realtime,,"ps %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h ",iClk,BTN_N,BTN1,P1A1,P1A2,P1A3,P1A4,P1A7,P1A8,P1A9,ioFifoData_bidir,iRxF_n,iTxE_n,oRx_n,oTx_n);
 	iClk <= 1'b0;
	BTN_N <= 1'b0; 
	iRxF_n <= 1'b1;
	iTxE_n <= 1'b1;
	rUartTxRdData <= 8'h00;
	rUartTxRdEmpty <= 1'b1;
	rUartRxWrFull <= 1'b0; //Clear the buffer to read from;
	
	#(C12M_CLK_PERIOD);	
	#(C12M_CLK_PERIOD);
	#(C12M_CLK_PERIOD);
	#(C12M_CLK_PERIOD);
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
	rUartTxRdData <= 8'hAA; //Data to send
	rUartTxRdEmpty <= 1'b0; //Start sending;
	@(posedge wUartRxWrEn); //Wait for this to work;
		if(wUartRxWrData == rUartTxRdData) begin
			$display ("Test Passed - Correct byte received");
		end else begin
			$display("Failed - uart test. Sent: AA, Rcvd: %h", wUartRxWrData);
		end
end


 always begin
	#(C12M_CLK_PERIOD / 2) iClk <= !iClk; 
	
end	
	
	
	
endmodule