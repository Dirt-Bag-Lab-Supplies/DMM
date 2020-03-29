// Author: N. Bergman

// Description: Creates synchronous register fifo
// 			Base: pFifoDepth sets the depth of fifo created
// 			Base: pFifoDataWidth sets the width of fifo created
// Total fifo register usage will be width * depth
// Fifo not to be used to cross clock domains. 

// Fifo Full Flag will assert when last word is written
// Fifo Empty flag will assert when last word is read




//`timescale 1ns/1ps

module fifo#(
	parameter pFifoDepth = 4,
	parameter pFifoDataWidth = 1

)(
	input iClk,
	input iRst,
	//Fifo Write INterface
	input iWriteEn,
	input [pFifoDataWidth-1:0] iWriteData,
	output oFifoFull,
	//Fifo Read Interface
	input iReadEn,
	output [pFifoDataWidth-1:0] oReadData,
	output oFifoEmpty
);


reg [pFifoDataWidth - 1:0] rFifoData [pFifoDepth - 1:0]; //Array of data widthBits x depth
reg [$clog2(pFifoDepth - 1) : 0] rWritePtr;
reg [$clog2(pFifoDepth - 1) : 0] rReadPtr;
reg [$clog2(pFifoDepth - 1) : 0] rFifoCount;

integer i;

assign oReadData = rFifoData[rReadPtr]; //Always have output ready
assign oFifoEmpty = rFifoCount == 0 ? 1 : 0;
assign oFifoFull = rFifoCount >= pFifoDepth ? 1 : 0;
//always @(posedge iClk, iWriteEn, iRst, iReadEn) begin //This starts writing all the data 
always @(posedge iClk) begin
	if(iRst) begin
		for(i=0; i<pFifoDepth; i=i+1) begin
			rFifoData[i] <= {pFifoDataWidth{1'b0}}; //REplication operator https://stackoverflow.com/questions/21246782/using-parameters-to-create-constant-in-verilog/21247003
		end 
		rWritePtr <= {pFifoDataWidth{1'b0}};
		rReadPtr <= {pFifoDataWidth{1'b0}};
		rFifoCount <= {pFifoDepth{1'b0}}; 
	end else begin
		//////// Fifo counter///////
		if(iWriteEn == 1'b1 && iReadEn == 1'b0 && oFifoFull == 1'b0) begin
			rFifoCount <= rFifoCount + 1;
		end else if(iWriteEn == 1'b0 && iReadEn == 1'b1 && oFifoEmpty == 1'b0) begin
			rFifoCount <= rFifoCount - 1;
		end
		//Else +1-1 = 0;

		/////////Write Pointer logic//////
		if(iWriteEn == 1'b1 && oFifoFull == 1'b0) begin
			if(rWritePtr == pFifoDepth-1) begin
				rWritePtr <= 0;
			end else begin
				rWritePtr <= rWritePtr + 1;
				//rReadPtr <= rReadPtr + 1'b1;
			end
		end

		///////Read pointer logic//////
		if(iReadEn == 1'b1 && oFifoEmpty == 1'b0) begin
			if(rReadPtr == pFifoDepth-1) begin
				rReadPtr <= {pFifoDataWidth{1'b0}};
			end else begin
				rReadPtr <= rReadPtr + 1'b1;
			end
		end	
		////////Data writing//////
		if(iWriteEn == 1'b1 && oFifoFull == 1'b0) begin
			rFifoData[rWritePtr] <= iWriteData;
		end 
	end ///Reset
end //always 
endmodule
