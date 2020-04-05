//-----------------------------------------------------------------------------
//
// Title       : ftdi_fifo_async_tb
// Design      : DMM_top
// Author      : Aldec, Inc
// Company     : Aldec, Inc
//
//-----------------------------------------------------------------------------
//
// File        : ftdi_fifo_async_TB.v
// Generated   : Sat Apr  4 23:09:23 2020
// From        : C:\Users\birdman\Documents\DirtBagLabSupplies\DMM\DMM_trunk\FPGA\IceBreak_Test\ftdi_fifo\ftdi_fifo_async_TB_settings.txt
// By          : tb_verilog.pl ver. ver 1.2s
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------

`timescale 1ps / 1ps
module ftdi_fifo_async_tb;
//Parameters declaration: 
parameter pTxFifoDepth = 8;
parameter pRxFifoDepth = 8;

//Internal signals declarations:
reg iClk;
reg iRst;
reg iTxEn;
wire oTxFull_actual;
reg oTxFull;
reg [7:0]iTxData;
reg iRxEn;
wire oRxEmpty_actual;
reg oRxEmpty;
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
parameter oTxFull_WaitTime = Default_wait_time;//WaitTime Parameter for port oTxFull
parameter oRxEmpty_WaitTime = Default_wait_time;//WaitTime Parameter for port oRxEmpty
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
	ftdi_fifo_async UUT (
		.iClk(iClk),
		.iRst(iRst),
		.iTxEn(iTxEn),
		.oTxFull(oTxFull_actual),
		.iTxData(iTxData),
		.iRxEn(iRxEn),
		.oRxEmpty(oRxEmpty_actual),
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
		iTxEn = 0;
		iTxData = 8'b0;
		iRxEn = 0;
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
		// #5 -> recv_data_from_DUT;
		// @(recv_complete);
		// @(negedge iClk) //Sample data bus at negative clock
		// @(negedge iClk) //Sample data bus at negative clock
		// @(negedge iClk) //Sample data bus at negative clock
		// #5 -> write_data_to_DUT; 
		// @(write_complete);
		#5 -> terminate_sim; //End sim
	end


always
	#20 iClk = !iClk;

///////////////////Send data to DUT///////////////////
//Intent: Fill DUT buffer with data, then read the entire buffer and check each value
//Data sent is a counter variable. 

event write_data_to_DUT; //Send character to DUT
event write_complete; //Wait for comfirmation
reg [7:0] rTbTxData; //Counter to send

initial begin
	forever begin
		@(write_data_to_DUT); //Start the transmission
		$display("Start Write");
		for(int i = 0; i < pRxFifoDepth; i = i + 1) begin
			rTbTxData = i;	//TODO: make this read from file
			#1 -> write_byte_to_DUT; 
			@(write_byte_complete);
		end
		//////Check the RX buffer on DUT/////
		#5 -> check_tx_data;
		@(check_tx_complete);
		#1 -> write_complete;
		$display("Write complete");
	end
end

//Write single byte to DUT, then return
event write_byte_to_DUT;
event write_byte_complete;
wire [7:0] wTxByte;
assign wTxByte = rTbTxData; //Change source
initial begin
	forever begin
		@(write_byte_to_DUT);
		$display("Write Byte: %h", wTxByte);
		iRxF_n = 0; //Clear TX flag
		@(negedge oRx_n_actual); //Wait for receive ready flag
		ioFifoData = wTxByte; //Put tx data on the bus
		////////////////////////////////////////DUT Receive/////////////
		@(posedge oRx_n_actual); //Look for this signal
		ioFifoData = 8'hZZ; //Put back in high z
		iRxF_n = 1; //Flag goes back high after read
		#1 -> write_byte_complete;
	end
end

//Read data from the RX buffer on the DUT
event check_tx_data;
event check_tx_complete;

initial begin
	forever begin
		@(check_tx_data);
		$display("Checking RX Data");

		for(int j = 0; j < pRxFifoDepth; j = j + 1) begin
			@(posedge iClk); //Align to clock boundary
			//Check for data before reading
			if(oRxEmpty_actual == 1) begin //No data in the buffer. Throw error
				$display("Check failed, no data in buffer");
				#5 -> terminate_sim;
			end else begin
				iRxEn = 1; //Set flag to read
				@(posedge iClk); //Wait for RAM read
				iRxEn = 0; //Clear flag to read
				if(oRxData_actual != j) begin
					$display("Check failed, Exp:%h, Recv:%h", j, oRxData_actual);
					#5 -> terminate_sim; 
				end
			end
		end
		#1 -> check_tx_complete;
		$display("Check RX complete");
	end
end

////////////////////////Recv Data from DUT//////////////////////
//Intent: Fill DUT Tx buffer with data, then read the entire buffer and check each value
//Data sent is a counter variable. 

event recv_data_from_DUT; //Send character to DUT
event recv_complete; //Wait for comfirmation
reg [7:0] rDutTxData; //Counter to send

initial begin
	forever begin
		@(recv_data_from_DUT); //Start the transmission
		$display("Start Recv");
		ioFifoData = 8'hZZ;
		for(int i = 0; i < pTxFifoDepth; i = i + 1) begin
			rDutTxData = i;	//TODO: make this read from file
			#1 -> write_byte_dut_fifo; 
			@(write_byte_fifo_complete);
		end
		//////Check the RX buffer on DUT/////
		#5 -> check_recv_data;
		@(check_recv_complete);
		#1 -> recv_complete;
		$display("Recv complete");
	end
end

//Write single byte to DUT, then return
event write_byte_dut_fifo;
event write_byte_fifo_complete;
wire [7:0] wDutTxByte;
assign wDutTxByte = rDutTxData; 
initial begin
	forever begin
		@(write_byte_dut_fifo);
		$display("Write Fifo Byte: %h", wDutTxByte);
		@(posedge iClk); //Wait for clock edge
		if(oTxFull_actual) begin //This shouldn't happen 
			$display("DUT TX Buffer is full -- cannot write");
			#5 -> terminate_sim;
		end else begin
			iTxData = wDutTxByte;
			iTxEn = 1; //Set buffer flag
			@(posedge iClk); 
			iTxEn = 0;
		end
		#1 -> write_byte_fifo_complete;
	end
end

//Read data from the Fifo bus
event check_recv_data;
event check_recv_complete;

initial begin
	forever begin
		@(check_recv_data);
		$display("Checking recv Data");

		for(int i = 0; i < pTxFifoDepth; i = i + 1) begin
			@(negedge iClk);
			iTxE_n = 0; //Flag to start sending data
			@(negedge oTx_n_actual); //Wait for falling edge of read
			iTxE_n = 1; //Clear Tx flag until next write
			@(negedge iClk); //Wait for clk cycle to sample RX data
			if(ioFifoData_bidir != i) begin
				$display("Recv Failed. Sent:%h, Recv:%h", i, ioFifoData_bidir);
				#1 -> terminate_sim;
			end
		end
		#1 -> check_recv_complete;
		$display("Check recv complete");
	end
end

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
		// $display("All vectors passed.");
		// $fdisplay(report_file,"All vectors passed.");
		$display("##############################################.");
		$fdisplay("##############################################");
	end
		$fclose(report_file);
		$finish;
end
//Set of always bloks for ports monitoring.
//One block per output port.
endmodule
