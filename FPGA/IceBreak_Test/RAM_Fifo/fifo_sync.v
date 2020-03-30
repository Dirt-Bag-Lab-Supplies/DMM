module fifo_sync_8bit #(
	parameter pFifoDepth=8 //Number of bytes the buffer can handle
)(
	iClk,
	iRst,
	iWrEn,
	oWrFull,
	iWrData,
	iRdEn,
	oRdEmpty,
	oRdData
);

//Input to module
input iClk, iRst;
input iWrEn; //Input telling fifo to write current data to fifo
input iRdEn; //Read next data in fifo

output oWrFull; //The fifo is full
output oRdEmpty; //The fifo does not have data to read

input [7:0] iWrData; //8bit data input to fifo
output [7:0] oRdData; //8bit data output from fifo

//RAM Registers
reg [8:0] rRamWrAddr; //512x8 RAM takes 9bit address
reg [8:0] rRamRdAddr; //9bit address to read from
wire [7:0] wRamWrData; //Data input to RAM
wire [7:0] wRamRdData; //Data output from RAM
assign wRamWrData = iWrData;
assign oRdData = wRamRdData;

wire wRamWrEn; //Enable going the ram module
wire wRamRdEn;


//Fifo Specific
reg [$clog2(pFifoDepth)-1:0] rDataCount; //Current count of data in the buffer

//Create the RAM
SB_RAM512x8 ram512x8_inst (
	.RDATA(wRamRdData),
	.RADDR(rRamRdAddr),
	.RCLK(iClk),
	.RCLKE(1'b1), //always enable
	.RE(wRamRdEn), 
	.WADDR(rRamWrAddr),
	.WCLK(iClk),
	.WCLKE(1'b1),	//Always enabled
	.WDATA(wRamWrData),
	.WE(wRamWrEn)
);


//Output flags if data is full or empty
assign oWrFull = rDataCount >= pFifoDepth ? 1'b1 : 1'b0;
assign oRdEmpty = rDataCount == 0 ? 1'b1 : 1'b0;

//Output flags if data is full or empty
assign wRamWrEn = iWrEn; //&& oWrFull;
assign wRamRdEn = iRdEn; //&& oRdEmpty; 



///Writing interface/////
always @(iClk) begin
	if(iRst) begin
		rRamWrAddr <= 9'b0;
	end else begin
		if(wRamWrEn) begin
			//Data was already written to ram on the rising clk. 
			rRamWrAddr <= rRamWrAddr == pFifoDepth ? 9'b0 : rRamWrAddr + 1; 
		end
	end
end

//Read interface
always @(iClk) begin
	if(iRst) begin
		rRamRdAddr <= 9'b0;
	end else begin
		if(wRamRdEn) begin
			rRamRdAddr <= rRamRdAddr == pFifoDepth ? 9'b0 : rRamRdAddr + 1;
		end
	end 
end 

//Counter process
always @(iClk) begin
	if(iRst) begin
		rDataCount <= 0;
	end else begin
		//Read from fifo
		if(wRamRdEn) begin //If reading
			if(!wRamWrEn) begin //NOT Writing
				rDataCount <= rDataCount - 1'b1; //Not doing zero detectin since rRamRdEn is protected  
			end else
				rDataCount <= rDataCount;
		
		end else if(wRamWrEn) begin //If writing
			if (!wRamRdEn) begin //NOT Reading -- technnically this has to be the case otherwise we wouldn't be here
				rDataCount <= rDataCount + 1'b1; //Not doing overflow detction since rRamWrEn is protected
			end else
				rDataCount <= rDataCount;
		end else //do nothing
			rDataCount <= rDataCount;
	end
end

endmodule