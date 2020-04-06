
module packet_to_fifo #(
	parameter pPacketSize,	//Packet size in number of bytes
	parameter pFifoDataWidth	//Fifo bus width in bytes (1 or 2)
)(
	//System
	iClk,	//sys clock
	iRst,	//Active high reset
	//System IO
	iPacketWr, //Flag to ready 
	iPacketData,	//Word to write to fifo
	oPacketDone,	//Output flag when packet is in the fifo
	oErr,			//If new data is clocked in before previous packet is complete
	//Fifo Interface
	oWrEn,			//Write data to fifo
	iWrFull,		//Fifo is full -- wait to write -- TODO: Add fifo almost full /almost empty
	oWrData,
);

//Counting parameters
localparam pFifoBitWidth = pFifoDataWidth * 8; 
localparam pPacketBitWidth = pPacketSize * 8;


//System
input iClk, iRst;

//System IO
input iPacketWr;
input [pPacketBitWidth - 1 : 0] iPacketData; 
output oPacketDone, oErr;

//Fifo
output oWrEn;
input iWrFull;
output [pFifoBitWidth-1 : 0] oWrData;


//System IO wiring
wire wPacketWr;
assign wPacketWr = iPacketWr;

wire [pPacketBitWidth-1 : 0] wPacketData; 
assign wPacketData = iPacketData;

reg rPacketDone;
assign oPacketDone = rPacketDone;

reg rErr;
assign oErr = rErr;

//Fifo Wiring
reg rWrEn;
assign oWrEn = rWrEn;

wire wWrFull;
assign wWrFull = iWrFull;

//wire [pFifoBitWidth-1 : 0] wWrData; 
//assign oWrData = wWrData; 
assign oWrData = rPacketData[rDataPtr +: pFifoBitWidth];


//Internal registers
reg [pPacketBitWidth-1 : 0] rPacketData; //Stores the current packet data
reg [(pPacketSize - 1):0] rDataPtr; //Ptr to fifo write data

wire wPacketCountDone;
assign wPacketCountDone = rDataPtr >= pPacketBitWidth - 1 ? 1'b1 : 1'b0;


//FSM
localparam IDLE = 0;
localparam READ_PACKET = 1;
localparam START_WRITE = 2; 
localparam WRITE_COMPLETE = 3;
localparam ERROR = 4 ; 

reg [2:0] rState;

//FSM
always @(posedge iClk) begin
	if(iRst) begin
		rState <= IDLE;
		rPacketDone <= 1'b0;
		rWrEn <= 1'b0;
		rErr <= 1'b0;
		//rWrData <= 0;
		rPacketData <= 0;
		rDataPtr <= 0;

	end else begin
		case(rState)
			IDLE : begin
				rDataPtr <= 0;
				if(iPacketWr) begin
					rPacketData <= wPacketData; //Store incoming data only in idle state
					rState <= READ_PACKET;
					rPacketDone <= 1'b0; // Clear done flag
				end
			end
			READ_PACKET : begin
				rState <= START_WRITE; 
				if(!wWrFull) begin
					rWrEn <= 1'b1; //Set flag high while waiting for next cycle -- TODO: does not handle intermittent write cycles
					//rDataPtr <= rDataPtr + pFifoBitWidth; //Incrememt ptr to next send
				end 
			end
			START_WRITE : begin
				if(wPacketCountDone) begin
					rState <= WRITE_COMPLETE;
					rWrEn <= 1'b0;
				end else if(!wWrFull) begin
					rWrEn <= 1'b1;
					rDataPtr <= rDataPtr + pFifoBitWidth; //Incrememt ptr to next send
				end else begin
					rWrEn <= 1'b0;
				end
			end 
			WRITE_COMPLETE : begin
				rState <= IDLE;
				rPacketDone <= 1'b1; //Set flag high until next packet
			end 
			ERROR : begin
				rState <= IDLE;
			end
		endcase // rState
	end
end



endmodule //Packet_to_fifo






