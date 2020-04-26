//-----------------------------------------------------------------------------
//
// Title       : ft2232h_async_wb
// Design      : DMM_top
// Author      : Aldec, Inc
// Company     : Aldec, Inc
//
//-----------------------------------------------------------------------------
//
// File        : ft2232h_async_TB.v
// Generated   : Sat Apr  4 18:28:03 2020
// From        : .\ftdi_fifo\ft2232h_async_TB_settings.txt
// By          : tb_verilog.pl ver. ver 1.2s
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------

`timescale 1ps / 1ps
module ft2232h_async_tb;
//Parameters declaration: 

parameter IDLE = 0;
parameter RD_START = 1;
parameter RD_DATA = 2;
parameter WR_START = 3;
parameter WR_DATA = 4;
parameter ERROR = 5;

//Internal signals declarations:
reg iClk;
reg iRst;
wire oTxRdEn_actual;
reg oTxRdEn;
reg iTxRdEmpty;
reg [7:0]iTxData;
wire oRxWrEn_actual;
reg oRxWrEn;
reg iRxWrFull;
wire [7:0]oRxData_actual;
reg [7:0]oRxData;
tri [7:0]ioFifoData_bidir;
reg [7:0]ioFifoData;
//Continous assignment for inout port "ioFifoData".
assign ioFifoData_bidir = ioFifoData;

reg iRxF_n;
reg iTxE_n;
wire oRx_n_actual;
reg oRx_n;
wire oTx_n_actual;
reg oTx_n;
wire oSiwu_actual;
reg oSiwu;
//LOG file declaration.
integer report_file;

//Wait time declaration used in ports monitoring.
//One parameter is declared for every port.
parameter Default_wait_time = 10;
parameter oTxRdEn_WaitTime = Default_wait_time;//WaitTime Parameter for port oTxRdEn
parameter oRxWrEn_WaitTime = Default_wait_time;//WaitTime Parameter for port oRxWrEn
parameter oRxData_WaitTime = Default_wait_time;//WaitTime Parameter for port oRxData
parameter ioFifoData_WaitTime = Default_wait_time;//WaitTime Parameter for port ioFifoData
parameter oRx_n_WaitTime = Default_wait_time;//WaitTime Parameter for port oRx_n
parameter oTx_n_WaitTime = Default_wait_time;//WaitTime Parameter for port oTx_n
parameter oSiwu_WaitTime = Default_wait_time;//WaitTime Parameter for port oSiwu

//Simulation time
parameter SimulationTime = Default_wait_time + 1;

//Errors counter
integer errors_counter;

//Block of Comparison functions declarations. A separate function for each output port is defined.

// Unit Under Test port map
	ft2232h_async UUT (
		.iClk(iClk),
		.iRst(iRst),
		.oTxRdEn(oTxRdEn_actual),
		.iTxRdEmpty(iTxRdEmpty),
		.iTxData(iTxData),
		.oRxWrEn(oRxWrEn_actual),
		.iRxWrFull(iRxWrFull),
		.oRxData(oRxData_actual),
		.ioFifoData(ioFifoData_bidir),
		.iRxF_n(iRxF_n),
		.iTxE_n(iTxE_n),
		.oRx_n(oRx_n_actual),
		.oTx_n(oTx_n_actual),
		.oSiwu(oSiwu_actual));

initial
	begin
		$display("##############################################################");
		report_file=$fopen("C:\\Users\\birdman\\Documents\\DirtBagLabSupplies\\DMM\\DMM_trunk\\FPGA\\IceBreak_Test\\ftdi_fifo\\compare_report.log");
		errors_counter = 0;
		#SimulationTime;
		if (errors_counter)
		begin
			$display("Errors were encountered, differences are listed in compare_report.log");
			$fdisplay(report_file,"Some vectors failed.");
		end
		else
		begin
			$display("All vectors passed.");
			$fdisplay(report_file,"All vectors passed.");
		end
		$fclose(report_file);
		$finish;
	end

///////////////////////Actual teset case//////////////////////////
initial begin
	iClk = 0;
	iRst = 0;
	iTxRdEmpty = 1;
	iTxData = 8'b0;
	iRxWrFull = 0;
	iRxF_n = 1;
	iTxE_n = 1;
	#40 -> reset_start; //start reset logic
	@(reset_done); //Reset is complete; 
	@(negedge iClk);


	#5 -> terminate_sim; //End sim
end


always
	#20 iClk = !iClk;


////////////////////RESET LOGIC///////////////////
event reset_start;
event reset_done;

initial begin
	forever begin
		@(reset_start);
		@(negedge iClk); //
		iRst = 1;
		@(negedge iClk);
		iRst = 0;
		-> reset_done; 
	end
end

//////////////////////////////////////////////////////

//////////////////END SIM EVENT/////////////////////
event terminate_sim;
initial begin
	@(terminate_sim);
	#5 $finish;
end
//Set of always bloks for ports monitoring.
//One block per output port.

endmodule
