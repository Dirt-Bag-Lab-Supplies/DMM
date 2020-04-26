//-----------------------------------------------------------------------------
//
// Title       : adc_to_packet_tb
// Design      : DMM_top
// Author      : Aldec, Inc
// Company     : Aldec, Inc
//
//-----------------------------------------------------------------------------
//
// File        : adc_to_packet_TB.v
// Generated   : Sun Apr  5 23:34:47 2020
// From        : C:\Users\birdman\Documents\DirtBagLabSupplies\DMM\DMM_trunk\FPGA\IceBreak_Test\adc\adc_to_packet_TB_settings.txt
// By          : tb_verilog.pl ver. ver 1.2s
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------

`timescale 1ps / 1ps
module adc_to_packet_tb;
//Parameters declaration: 
parameter pPacketSize = 244;  // pSamplesPerPacket * 2 bytes per ADC * 8 channels + 4 byte header
parameter pPacketVersion = 0;
parameter pSamplesPerPacket = 15;
parameter pAdcDataWidth = 16;

//Internal
parameter pPacketBitWidth = pPacketSize*8;
parameter pHeaderOffset = 32;

//Internal signals declarations:
reg iClk;
reg iRst;
wire oErr;
reg iWrEn;
reg [pAdcDataWidth*8-1:0]iAdcSampleData;
wire oPacketWr;
reg iPackerWrFull;
wire [pPacketBitWidth-1:0]oPacketData;

reg [pPacketBitWidth-1:0] rPacketData; //Holds the expected output data

reg [3:0] rSampleCount;
wire [11:0] rNextSampleAddr; //Determine where to save next data
assign rNextSampleAddr = ((rSampleCount * (pAdcDataWidth * 8) ) + pHeaderOffset); //#of samples * size of sample + offset

// Unit Under Test port map
	adc_to_packet #(
		.pPacketSize(pPacketSize),
		.pPacketVersion(pPacketVersion),
		.pSamplesPerPacket(pSamplesPerPacket),
		.pAdcDataWidth(pAdcDataWidth)
	) UUT(
		.iClk(iClk),
		.iRst(iRst),
		.oErr(oErr),
		.iWrEn(iWrEn),
		.iAdcSampleData(iAdcSampleData),
		.oPacketWr(oPacketWr),
		.iPackerWrFull(iPackerWrFull),
		.oPacketData(oPacketData));

initial begin
	$display("####################################");
	iClk = 0;
	iRst = 0;
	iWrEn = 0;
	iPackerWrFull = 0;
	rSampleCount = 0;
	rPacketData = 0;
	for(int i = 0; i < 8; i = i + 1) begin
		@(posedge iClk);
		iAdcSampleData[i*16 +: 16] = i; //Save a counter variable; 
	end

	#40 -> reset_start; //start reset logic
	@(reset_done); //Reset is complete; 



	for(int i = 0; i < pSamplesPerPacket; i = i + 1) begin
		#10 -> write_sample;
		@(write_sample_complete);
	end
	#10 -> check_packet;
	@(check_packet_complete);
	#5 -> terminate_sim; //End sim
end

//Write packet to DUT
event write_sample;
event write_sample_complete;

initial begin
	forever begin
		@(write_sample);
		$display("Start Sample:%d", rSampleCount);
		for(int i = 0; i < 8; i = i + 1) begin
			@(posedge iClk);
			iAdcSampleData[i*16 +: 16] = i + (rSampleCount * 8); //Save a counter variable; 		
		end
		rPacketData[rNextSampleAddr +: pAdcDataWidth * 8] = iAdcSampleData;
		@(posedge iClk);
		iWrEn = 1;
		@(posedge iClk); 
		iWrEn = 0;
		rSampleCount = rSampleCount == pSamplesPerPacket ? 0 : rSampleCount + 1;

		$display("Sample complete");
		#1 -> write_sample_complete;
	end
end

event check_packet;
event check_packet_complete;
//reg [15:0] rRecvBytes;
initial begin
	forever begin
		@(check_packet);
		$display("Start Check Packet");
		@(posedge oPacketWr);
		if(rPacketData[pPacketBitWidth-1:32] != oPacketData[pPacketBitWidth-1:32]) begin
			$display("Failed final check. ");
			#1 -> terminate_sim; 
		end else begin
		// for(int i = 0; i < pPacketSize; i = i + 1) begin
		// 	@(posedge iClk);
		// 	if(oWrEn) begin //Wait for write packet
		// 		rRecvPacket[i*pFifoBitWidth +: pFifoBitWidth] = oWrData;
		// 		//rRecvBytes = oWrData; 
		// 		if(rRecvPacket[i*pFifoBitWidth +: pFifoBitWidth] != iPacketData[i*pFifoBitWidth +: pFifoBitWidth]) begin
		// 		//if(rRecvBytes != iPacketData[i*pFifoBitWidth +: pFifoBitWidth]) begin
		// 			$display("Failed Check Packet. Sent:%h, Recv:%h", iPacketData[i*pFifoBitWidth +: pFifoBitWidth], rRecvPacket[i*pFifoBitWidth +: pFifoBitWidth] );
		// 			#1 -> terminate_sim; 
		// 		end
		// 	end
		// end
		// if(rRecvPacket != iPacketData) begin
		// 	$display("Failed final check. ");
		// 	#1 -> terminate_sim; 
		// end else begin
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
