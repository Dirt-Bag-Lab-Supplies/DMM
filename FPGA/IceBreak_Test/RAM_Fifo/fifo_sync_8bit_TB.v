//-----------------------------------------------------------------------------
//
// Title       : fifo_sync_8bit_tb
// Design      : icebreaker_tb
// Author      : Aldec, Inc
// Company     : Aldec, Inc
//
//-----------------------------------------------------------------------------
//
// File        : fifo_sync_8bit_TB.v
// Generated   : Sun Mar 29 23:29:51 2020
// From        : C:\Users\birdman\Documents\DirtBagLabSupplies\DMM\DMM_trunk\FPGA\IceBreak_Test\RAM_Fifo\fifo_sync_8bit_TB_settings.txt
// By          : tb_verilog.pl ver. ver 1.2s
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------

`timescale 1ps / 1ps
module fifo_sync_8bit_tb;
//Parameters declaration: 
defparam UUT.pFifoDepth = 8;
parameter pFifoDepth = 8;

parameter CLK_PER = 1;
//Internal signals declarations:
reg iClk;
reg iRst;
reg iWrEn;
wire oWrFull;
reg [7:0]iWrData;
reg iRdEn;
wire oRdEmpty;
wire [7:0]oRdData;



// Unit Under Test port map
	fifo_sync_8bit UUT (
		.iClk(iClk),
		.iRst(iRst),
		.iWrEn(iWrEn),
		.oWrFull(oWrFull),
		.iWrData(iWrData),
		.iRdEn(iRdEn),
		.oRdEmpty(oRdEmpty),
		.oRdData(oRdData));

initial	begin
	$monitor($realtime,,"ps %h %h %h %h %h %h %h %h ",iClk,iRst,iWrEn,oWrFull,iWrData,iRdEn,oRdEmpty,oRdData);	  
	iClk = 1'b0;
	iRst = 1'b0;
	iWrEn = 1'b0;
	iWrData = 8'b0;
	iRdEn = 1'b0;
	#(CLK_PER) iRst = 1'b1;		 //Start reset
	#(CLK_PER) iRst = 1'b0;		//End reset	  
	#(CLK_PER);
	#(CLK_PER);
	#(CLK_PER);
	#(CLK_PER);
	#(CLK_PER);
	iRdEn = 1'b1;
end

always @(iClk) begin
	if(iRst) begin 
		iWrEn <= 1'b0;
		iWrData <= 8'b0;
		iRdEn <= 1'b0;
	end else begin
		if(!oWrFull) begin
			iWrData <= iWrData + 1'b1;
			iWrEn <= 1'b1;
		end else begin
			iWrEn <= 1'b0;	
		end 
	end 
end

		

	
	
	
always begin
	#(CLK_PER) iClk <= !iClk;
end 

endmodule
