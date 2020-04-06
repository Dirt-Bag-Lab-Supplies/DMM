module adc_to_packet #(
	parameter pPacketSize = 244, //4 byte header, 15x16bit x 8 channels of ADC data
	parameter pPacketVersion = 0, 
	parameter pSamplesPerPacket = 15,
	parameter pAdcDataWidth = 16 	//Testing only. 
)(
	//System
	iClk,
	iRst, 	//Active sync high reset
	oErr,

	//ADC Side
	iWrEn, //Clock toggles at the end of sample
	// iAdc0AData,	//16bit value 15:14 = config, 13:0 = ADC value
	// iAdc0BData,
	// iAdc1AData,
	// iAdc1BData,
	// iAdc2AData,
	// iAdc2BData,
	// iAdc3AData,
	// iAdc3BData,
	iAdcSampleData, //8 x 16bit sample data -- This is hidden to account for various ADC data configurations. 
	//System IO
	oPacketWr,		//Write packet output
	iPackerWrFull, 		//This should throw error if this needs to write when this is high
	oPacketData //Output data bus
);

localparam pPacketBitWidth = pPacketSize * 8; //Packet size in bits
//System
input iClk, iRst;
output oErr; 

//ADC
input iWrEn; 
//input [15:0] iAdc0AData, iAdc0BData, iAdc1AData, iAdc1BData, iAdc2AData, iAdc2BData, iAdc3AData, iAdc3BData;
input [(pAdcDataWidth * 8) - 1 : 0] iAdcSampleData;

//System IO
output oPacketWr;
input iPackerWrFull;
output [pPacketBitWidth-1:0] oPacketData;


////////Internal wiring//////////
//System
reg rErr;
assign oErr = rErr; 

//ADC
wire wWrEn;
assign wWrEn = iWrEn;

wire [(pAdcDataWidth * 8) -1 :0 ] wAdcSampleData;
assign wAdcSampleData = iAdcSampleData; //Concatenate all input data onto input bus
reg [(pAdcDataWidth * 8) -1 :0 ] rAdcSampleData; //Store sample data on WiteEnable

//Packetizer
reg [3:0] rSampleCount; //Increments on each sample
wire [11:0] rNextSampleAddr; //Determine where to save next data
assign rNextSampleAddr = ((rSampleCount * (pAdcDataWidth * 8) ) + pHeaderOffset); //#of samples * size of sample + offset


//Packet
reg rPacketWr;
assign oPacketWr = rPacketWr; 

wire wPacketWrFull;
assign wPacketWrFull = iPackerWrFull;

reg [pPacketBitWidth -1 : 0] rPacketData; 
assign oPacketData = rPacketData;



////Header Info/////

reg [1:0] rVersion; 
reg [1:0] rSource;
reg rControlBit;
reg [2:0] rRsrvd;
reg [7:0] rPacketLength; //Length in 16bit samples
reg [15:0] rPacketCount;
localparam pHeaderOffset = 32; //Data count offset on where to write data
wire [pHeaderOffset - 1 :0] wHeaderInfo; 
assign wHeaderInfo = {rVersion, rSource, rControlBit, rRsrvd, rPacketLength, rPacketCount}; 


///////FSM////////////
localparam IDLE = 0;
localparam READ_ADC = 1;
localparam WRITE_HEADER = 2;
localparam PACKET_WRITE = 3;
localparam PACKET_DONE = 4;	
localparam ERROR = 5;

reg [3:0] rState;


always @(posedge iClk) begin
	if(iRst) begin
		rState <= IDLE;
		rErr <= 1'b0;
	end else begin
		case(rState)
			IDLE : begin
				if(iWrEn) begin
					rState <= READ_ADC;
				end
			end
			READ_ADC : begin
				if(rSampleCount == pSamplesPerPacket) begin
					rState <= WRITE_HEADER;
				end
			end 
			WRITE_HEADER : begin
				 rState <= PACKET_WRITE; 
			end
			PACKET_WRITE : begin
				rState <= PACKET_DONE;
			end 
			PACKET_DONE : begin
				rState <= IDLE; 
			end
			ERROR : begin
				rState <= IDLE;
			end
		endcase // rState
	end
end

////Packet Stuff
always @(posedge iClk) begin
	if(iRst) begin
		rPacketData <= 0;
		rPacketWr <= 1'b0;
		rVersion <= 2'b01;
		rSource <= 2'b00;
		rControlBit <= 1'b0;
		rRsrvd <= 3'b000;
		rPacketLength <= pPacketSize;
		rPacketCount <= 16'hAAAA;
	end else begin
		case(rState)
			IDLE : begin
				if(iWrEn) begin
					rPacketData[rNextSampleAddr +: pAdcDataWidth * 8] <= wAdcSampleData; //Store data
					//rAdcSampleData <= wAdcSampleData; //Store data
				end
			end
			READ_ADC : begin
				if(iWrEn) begin
					rPacketData[rNextSampleAddr +: pAdcDataWidth * 8] <= wAdcSampleData; //Store data
				end
			end 
			WRITE_HEADER : begin
				rPacketData[pHeaderOffset - 1 : 0] <= wHeaderInfo;
			end
			PACKET_WRITE : begin
				rPacketWr <= 1'b1;
			end 
			PACKET_DONE : begin
				rPacketWr <= 1'b0;
			end
			ERROR : begin
				rState <= IDLE;
			end
		endcase // rState
	end
end

always @(posedge iClk) begin
	if(iRst) begin
		rSampleCount <= 4'b0; //Clear sample counter
	end else begin
		case(rState)
			IDLE : begin
				if(iWrEn) begin
					rSampleCount <= rSampleCount + 1; //Increment on every write enable
				end
			end
			READ_ADC : begin
				if(iWrEn) begin
					rSampleCount <= rSampleCount + 1; //Increment on every write enable
				end
			end 
			WRITE_HEADER : begin
			end
			PACKET_WRITE : begin
			end 
			PACKET_DONE : begin
				rSampleCount <= 4'b0;
			end
			ERROR : begin
			end
		endcase // rState
	end
end
endmodule