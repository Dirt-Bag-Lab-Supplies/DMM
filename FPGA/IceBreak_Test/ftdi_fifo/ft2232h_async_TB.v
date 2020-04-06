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

////////////////////////Test Bench 
initial
	begin
		$display("##############################################################");
		report_file=$fopen("C:\\Users\\birdman\\Documents\\DirtBagLabSupplies\\DMM\\DMM_trunk\\FPGA\\IceBreak_Test\\ftdi_fifo\\compare_report.log");
		errors_counter = 0;
		/////////////////////////////////////
		iClk = 0;
		iRst = 0;
		iTxRdEmpty = 1;
		iTxData = 8'b0;
		iRxWrFull = 0;
		iRxF_n = 1;
		iTxE_n = 1;
		ioFifoData = 8'hZZ;
		#40 -> reset_start; //start reset logic
		@(reset_done); //Reset is complete; 
		#5 -> write_data_to_DUT;
		@(write_complete); //Write test completed.
		@(negedge iClk) //Sample data bus at negative clock
		@(negedge iClk) //Sample data bus at negative clock
		@(negedge iClk) //Sample data bus at negative clock
		#5 -> recv_data_from_DUT;
		@(recv_complete);
		#5 -> terminate_sim; //End sim
	end


always
	#20 iClk = !iClk;


///////////////////Send data///////////////////
event write_data_to_DUT; //Send character to DUT
event write_complete; //Wait for comfirmation
reg [7:0] rTbTxData; 

initial begin
	forever begin
		@(write_data_to_DUT); //Start the transmission
		$display("Start Write",);
		rTbTxData = 8'hAA;	//TODO: make this read from file
		iRxF_n = 1'b0; //Assert tx ready flag. 
		@(negedge oRx_n_actual); //Wait for receive ready flag
		ioFifoData = rTbTxData; //Put tx data on the bus
		////////////////////////////////////////DUT Receive/////////////
		@(posedge oRxWrEn_actual); //Look for this signal
		ioFifoData = 8'hZZ; //Put back in high z
		iRxF_n = 1; //Flag goes back high after read
		if(oRxData_actual != rTbTxData) begin
			$display("Write Failed. Sent:%h, Recv:%h ", rTbTxData, oRxData);
			#1 -> terminate_sim; //Stop the simulation here
		end else begin
			$display("Write Passed.");
			#5 -> write_complete; //
		end
	end
end

///////////////////Send data///////////////////
event recv_data_from_DUT; //Send character to DUT
event recv_complete; //Wait for comfirmation
reg [7:0] rDutTxData; //Data to send from the DUT

initial begin
	forever begin
		@(recv_data_from_DUT); //Start the transmission
		$display("Start Recv",);
		ioFifoData = 8'hZZ;
		iTxRdEmpty = 0; //Clear Tx buffer empty flag
		iTxData = 8'h00; //Simulate RAM read and set to previous values
		iTxE_n = 0; //Set FTDI flag
		rDutTxData = 8'hAA;		//TODO: read from file
		@(posedge oTxRdEn_actual); //"read" from RAM fifo
		iTxData = rDutTxData;
		@(negedge oTx_n_actual); //Wait for bus write flag
		//Clear the Tx Buffer flag
		iTxRdEmpty = 0;
		iTxE_n = 1; //Clear TXE flag
		@(negedge iClk) //Sample data bus at negative clock
		if(rDutTxData != ioFifoData_bidir) begin
			$display("Recv Failed. Sent:%h, Recv:%h", rDutTxData, ioFifoData_bidir);
			#1 -> terminate_sim;
		end else begin
			$display("Recv Passed");
			#5 -> recv_complete;
		end
	end
end
/////////////////////////////////////////////////////


////////////////////RESET LOGIC///////////////////
event reset_start;
event reset_done;

initial begin
	forever begin
		@(reset_start);
		$display("Applying Reset");
		@(negedge iClk); //
		iRst = 1;
		@(negedge iClk);
		iRst = 0;
		#1 -> reset_done; 
		$display("Rest Done");
	end
end

//////////////////////////////////////////////////////

//////////////////END SIM EVENT/////////////////////
event terminate_sim;
initial begin
	@(terminate_sim);
	if (errors_counter)	begin
		$display("Errors were encountered, differences are listed in compare_report.log");
		$fdisplay(report_file,"Some vectors failed.");
	end	else begin
		$display("All vectors passed.");
		$fdisplay(report_file,"All vectors passed.");
		$display("##############################################.");
		//$fdisplay("##############################################");
	end
		$fclose(report_file);
		$finish;
end
//Set of always bloks for ports monitoring.
//One block per output port.

endmodule
