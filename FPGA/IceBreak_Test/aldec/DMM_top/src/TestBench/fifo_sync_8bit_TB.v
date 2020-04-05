//-----------------------------------------------------------------------------
//
// Title       : fifo_sync_8bit_tb
// Design      : DMM_top
// Author      : Aldec, Inc
// Company     : Aldec, Inc
//
//-----------------------------------------------------------------------------
//
// File        : fifo_sync_8bit_TB.v
// Generated   : Sat Apr  4 14:32:27 2020
// From        : c:\Users\birdman\Documents\DirtBagLabSupplies\DMM\DMM_trunk\FPGA\IceBreak_Test\aldec\DMM_top\src\TestBench\fifo_sync_8bit_TB_settings.txt
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

initial
	$monitor($realtime,,"ps %h %h %h %h %h %h %h %h ",iClk,iRst,iWrEn,oWrFull,iWrData,iRdEn,oRdEmpty,oRdData);

endmodule
