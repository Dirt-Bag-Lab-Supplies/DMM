//-----------------------------------------------------------------------------
//
// Title       : packet_to_fifo_tb
// Design      : DMM_top
// Author      : Aldec, Inc
// Company     : Aldec, Inc
//
//-----------------------------------------------------------------------------
//
// File        : packet_to_fifo_TB.v
// Generated   : Sun Apr  5 16:06:37 2020
// From        : C:\Users\birdman\Documents\DirtBagLabSupplies\DMM\DMM_trunk\FPGA\IceBreak_Test\RAM_Fifo\packet_to_fifo_TB_settings.txt
// By          : tb_verilog.pl ver. ver 1.2s
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------

`timescale 1ps / 1ps
module packet_to_fifo_tb;
//Parameters declaration: 

parameter pPacketSize = 64;

parameter pFifoDataWidth = 2;

//Counting parameters
localparam pFifoBitWidth = pFifoDataWidth * 8; 
localparam pPacketBitWidth = pPacketSize * 8;

//Internal signals declarations:
reg iClk;
reg iRst;
reg iPacketWr;
reg [pPacketBitWidth-1:0]iPacketData;
wire oPacketDone;
wire oErr;
wire oWrEn;
reg iWrFull;
wire [pFifoBitWidth-1:0]oWrData;

reg [pPacketBitWidth-1:0] rRecvPacket;

// Unit Under Test port map
packet_to_fifo #(
		.pPacketSize(pPacketSize),
		.pFifoDataWidth(pFifoDataWidth)
)UUT(
		.iClk(iClk),
		.iRst(iRst),
		.iPacketWr(iPacketWr),
		.iPacketData(iPacketData),
		.oPacketDone(oPacketDone),
		.oErr(oErr),
		.oWrEn(oWrEn),
		.iWrFull(iWrFull),
		.oWrData(oWrData));

initial begin
	$display("####################################");
	iClk = 0;
	iRst = 0;
	rRecvPacket = 0;
	//System Inputs
	iPacketWr = 0;

	//fifo Inputs
	iWrFull = 0;
	#40 -> reset_start; //start reset logic
	@(reset_done); //Reset is complete; 
	for(int i = 0; i < pPacketSize; i = i + 1) begin
	//@(posedge iClk);
	iPacketData[i*8 +: 8] = i; //Save a counter variable; 
	end
	#10 -> packet_write;
	@(packet_write_complete);
	#10 -> check_packet;
	@(check_packet_complete);
	#5 -> terminate_sim; //End sim
end

//Write packet to DUT
event packet_write;
event packet_write_complete;

initial begin
	forever begin
		@(packet_write);
		$display("Start Write Packet");
		@(posedge iClk);
		iPacketWr = 1; //Set write flag
		@(posedge iClk); 
		iPacketWr = 0;
		$display("Write packet complete");
		#1 -> packet_write_complete;
	end
end

event check_packet;
event check_packet_complete;
reg [15:0] rRecvBytes;
initial begin
	forever begin
		@(check_packet);
		$display("Start Check Packet");
		for(int i = 0; i < pPacketSize; i = i + 1) begin
			@(posedge iClk);
			if(oWrEn) begin //Wait for write packet
				rRecvPacket[i*pFifoBitWidth +: pFifoBitWidth] = oWrData;
				//rRecvBytes = oWrData; 
				if(rRecvPacket[i*pFifoBitWidth +: pFifoBitWidth] != iPacketData[i*pFifoBitWidth +: pFifoBitWidth]) begin
				//if(rRecvBytes != iPacketData[i*pFifoBitWidth +: pFifoBitWidth]) begin
					$display("Failed Check Packet. Sent:%h, Recv:%h", iPacketData[i*pFifoBitWidth +: pFifoBitWidth], rRecvPacket[i*pFifoBitWidth +: pFifoBitWidth] );
					#1 -> terminate_sim; 
				end
			end
		end
		if(rRecvPacket != iPacketData) begin
			$display("Failed final check. ");
			#1 -> terminate_sim; 
		end else begin
			$display("Check Packet Complete");
			#1 -> check_packet_complete;
		end
	end
end
		


/////////////CLK LOGIC /////////////////////////////
	always
		#20 iClk = !iClk;
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
		// $display("All vectors passed.");
		// $fdisplay(report_file,"All vectors passed.");
		$display("Test Completed");
		$display("##############################################.");
		//$fdisplay("##############################################");
		//$fclose(report_file);
		$finish;
end
endmodule
