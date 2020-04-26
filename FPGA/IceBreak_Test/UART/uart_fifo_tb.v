
////////////////////////////////////////Test Bench//////////////////////////////////////////////////////////
module uart_fifo_tb ;

	reg iClk;
	reg iResetn;
	reg iRx;
	wire oTx;
	wire [7:0] wRxByteOut;
	reg rRxRead;
	wire wRxBufferEmpty;
	wire wUartError;
	reg [7:0] rTxByte;
	reg rTxWrite;
	wire wUartTxBusy;



uart_fifo #(
	.pClkFreq(48_000_000),
	.pBaudRate(115200),
	.pRxFifoByteLength(4),
	.pTxFifoByteLength(4)
)DUT(
	.iClk				(iClk),
	.iResetn			(iResetn),
	.iRx				(iRx),
	.oTx				(oTx),
	.oRxByteOut			(wRxByteOut),
	.wRxRead			(rRxRead),
	.rRxBufferEmpty		(wRxBufferEmpty),
	.rUartError			(wUartError),
	.iTxByte			(rTxByte),
	.iTxWrite			(rTxWrite),
	.oUartTxBusy		(wUartTxBusy)
);

endmodule