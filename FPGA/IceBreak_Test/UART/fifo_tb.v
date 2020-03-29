
/////////////////////////////////////////////////////////
module fifo_tb; 
	parameter c_CLOCK_PERIOD_NS = 10;
	parameter pDelayX10 = 100;
	parameter pFifoDepth = 16;
	parameter pFifoDataWidth = 8;
	parameter pTestDataDepth = 32;

	reg iClk, iRst, iWriteEn, iReadEn;
	wire oFifoFull, oFifoEmpty;
	reg [pFifoDataWidth -1:0] iWriteData [pTestDataDepth-1:0];
	wire [pFifoDataWidth-1:0] oReadData;


	integer i;

	reg [pTestDataDepth-1:0] writeData;


fifo #(
	.pFifoDepth(pFifoDepth),
	.pFifoDataWidth(pFifoDataWidth)

) DUT(
	.iClk		(iClk),
	.iRst		(iRst),
	//Fifo Write INterface
	.iWriteEn	(iWriteEn),
	.iWriteData	(writeData),
	.oFifoFull	(oFifoFull),
	//Fifo Read Interface
	.iReadEn	(iReadEn),
	.oReadData	(oReadData),
	.oFifoEmpty	(oFifoEmpty)
);


initial begin
	iWriteEn <= 0;
	iReadEn <= 0;
	iClk <= 0;
	iRst <= 0;
	for(i=0; i<pTestDataDepth;i=i+1) begin
		iWriteData[i] <= i+1'b1;
	end
	writeData <= 8'hFF;
	@(negedge iClk);
	#(c_CLOCK_PERIOD_NS) iRst <= 1; 	
	
	#(c_CLOCK_PERIOD_NS) iRst <= 0;
	
	#(pDelayX10);
	for(i=0; i<pTestDataDepth;i=i+1) begin
		#(c_CLOCK_PERIOD_NS);
		writeData <= iWriteData[i];
		iWriteEn <= 1'b1;
		#(c_CLOCK_PERIOD_NS);
		iWriteEn <= 1'b0;
	end

	#(pDelayX10);

	for(i=0; i<pTestDataDepth;i=i+1) begin
		#(c_CLOCK_PERIOD_NS);
		iReadEn <= 1;
		#(c_CLOCK_PERIOD_NS);
		#(c_CLOCK_PERIOD_NS);
		iReadEn <= 1'b0;
	end
	#(pDelayX10);
	#(c_CLOCK_PERIOD_NS) iRst <= 1; 	
	
	#(c_CLOCK_PERIOD_NS) iRst <= 0;
	
	
end

always begin
	#(c_CLOCK_PERIOD_NS) iClk <= !iClk;
end

endmodule