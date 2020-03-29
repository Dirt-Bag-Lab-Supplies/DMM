module ftdi_input_simple #(
	parameter pDataWidth=8,
	parameter pMaxData=8 //Number of data pieces 
)(
	iWClk,		//Write clk -- 48MHz
	iRst,		//Reset high
	iTxEn,	//Write data to RAM
	iTxData, //Data to write to RAM
	oTxFull,	//Ram is full
	oPacketAvail, //Output that data is available in the buffer
	//60MHz Clock
	iRClk,		//Read clk -- 60MHz from FTDI
	iRamRdAddr, //Addr from RAM to read from
	oRamRdData, //Data output from RAM
	iPacketRead //Flag to remove data from the queue
);





//INputs -- sys clock / FPGA
input iWClk, iRst, iTxEn;
input [7:0] iTxData;
//Outputs -- Sys clock
output wire oTxFull; //output to fpga
output reg oPacketAvail; //output to consumer

//Inputs -- 60mhz
input iRClk, iPacketRead;
input [$clog2(pMaxData)-1:0] iRamRdAddr;
//Outputs -- 60mhz
wire [8:0] wRamRdAddr;
assign wRamRdAddr = iRamRdAddr[$clog2(pMaxData)-1:0] ;

output [7:0] oRamRdData;


//Write Specific stuff
reg [$clog2(pMaxData)-1:0] rRamWrAddr;
wire [8:0] wRamWrAddr;
assign wRamWrAddr = 8'b0 | rRamWrAddr; //Get the address lines to fit the address width


reg [pDataWidth-1:0] rRamWrData; 
reg rRamWrEn; //Direct control of the write lines
reg [$clog2(pMaxData-1):0] rPacketCount;


// Read specific stuff -- 60mhz
reg [2:0] rPacketRead;
wire wPacketRdPosEdge;


//Create the RAM
SB_RAM512x8 ram512x8_inst (
	.RDATA(oRamRdData),
	.RADDR(wRamRdAddr),
	.RCLK(iRClk),
	.RCLKE(1'b1), //always enable
	.RE(1'b1),    //Always read for now. TODO: Find out if this needs to change 
	.WADDR(wRamWrAddr),
	.WCLK(iWClk),
	.WCLKE(1'b1),	//Always enabled
	.WDATA(rRamWrData),
	.WE(rRamWrEn)
	//.MASK(8'h00) //Write operations enabled for all bits 
);
////////////////////////////////////////Write to RAM///////////////
// wire [pDataWidth-1:0] iWData;
// wire iWEn;
// reg  oWFull;
// reg rTxAvail; 
// reg [$clog2(pMaxData)-1:0] rPacketCount; 
// reg [$clog2(pMaxData)-1:0] rWAddr;

reg [1:0] rWrState;
localparam WR_IDLE = 0;
localparam WR_START = 1;
localparam WR_WRITE = 2;
localparam WR_ERROR = 3; 


//Packet counting
assign wPacketRdPosEdge = rPacketRead == 3'b011 ? 1'b1 : 1'b0; //Edge detector for crossing 60mhz 
assign oTxFull = rPacketCount == pMaxData ? 1'b1 : 1'b0; //Full if there is too much data.  
//Ram Write State Machine
always @(iWClk or iRst) begin
	if(iRst) begin
		//Reset state and counters
		rWrState <= WR_IDLE;
		rRamWrAddr <= 0;
		rRamWrData <= 0;
		rRamWrEn <= 0;
		rPacketCount <= 0;
		rPacketRead <= 0;
	end else begin

		case(rWrState)
			WR_IDLE : begin
				if(iTxEn) begin
					rWrState <= WR_WRITE;
				end
			end
			WR_START : begin
				//Increment addr
			end
			WR_WRITE : begin
				if(!iTxEn) begin
					rWrState <= WR_IDLE;
					rRamWrEn <= 0;
				end else begin
					rRamWrEn <= 1; 
					rRamWrAddr <= rRamWrAddr == pMaxData ? 0 : rRamWrAddr + 1;
				end
			end
			WR_ERROR : begin
				rWrState <= WR_IDLE;
			end
		endcase // rWrState


		///// packet counting logic/////
		rPacketRead <= {rPacketRead[2:0],iPacketRead}; //Save the next sample for packet read
		oPacketAvail <= rPacketCount > 0 ? 1'b1 : 1'b0; //Flag for data if packet count is high
		//// Packet count state machine
		if(wPacketRdPosEdge) begin //Reading from RAM
			if(!rRamWrEn && rPacketCount > 0) begin //nOot writing
				rPacketCount <= rPacketCount - 1'b1;
			end
		end else begin //not reading
			if(rRamWrEn && rPacketCount < pMaxData) begin //Writing
				rPacketCount <= rPacketCount + 1'b1;
			end
		end
	end
end

endmodule
