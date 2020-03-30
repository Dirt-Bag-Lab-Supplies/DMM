
module ftdi_fifo_async #(
	parameter pTxFifoDepth=8,
	parameter pRxFifoDepth=8
)(
	//Tx FPGA Interface
	iClk,	//FPGA Clock
	iRst,
	//TX
	iTxEn,  // Data valid writing data to dual port ram
	oTxFull, 	//Ram is full, stop writing
	iTxData, //Data to transmit from FPGA to FTDI
	//RX
	iRxEn,
	oRxEmpty,
	oRxData,
	//FTDI interface
	ioFifoData,	//Data bus to the FTDI
	iRxF_n,		//RxBuffer on the Fifo has data
	iTxE_n,		//Tx Buffer on fifo is empty
	oRx_n,		//Start Rx from Ftdi
	oTx_n,		//Start Tx to Ftdi
	oSiwu,		//Enable the usb to wake up the computer. 
);

//General inputs
input iClk, iRst;

//////Tx Fifo  /////
input [7:0] iTxData;
input iTxEn; 	//Active high - write data to fifo 
output oTxFull;	//Output to system, fifo is full. Fifo does not write any more data

////Rx Fifo////
output [7:0] oRxData;
input iRxEn; //Active high -- data is read from buffer
output oRxEmpty; //Active high -- no data in buffer


////FTDI Interface////
inout [7:0] ioFifoData; //Bi-dir bus to ftdi
input iRxF_n;		//RxBuffer on the Fifo has data
input iTxE_n;		//Tx Buffer on fifo is empty
output oRx_n;		//Start Rx from Ftdi
output oTx_n;		//Start Tx to Ftdi
output oSiwu;		//Enable the usb to wake up the computer. 



///////////////// Tx Fifo//////////////////

//FPGA interface
wire wTxWrEn;
assign wTxWrEn = iTxEn;
wire wTxWrFull;
assign oTxFull = wTxWrFull;
wire [7:0] wTxWrData;
assign wTxWrData = iTxData;

//FTDI interface
wire wTxRdEn;
wire wTxRdEmpty;
wire [7:0] wTxRdData;



fifo_sync_8bit#(
	.pFifoDepth(pTxFifoDepth)
)tx_fifo_inst(
	.iClk			(iClk),
	.iRst			(iRst),
	.iWrEn			(wTxWrEn),
	.oWrFull		(wTxWrFull),
	.iWrData		(wTxWrData),
	.iRdEn			(wTxRdEn),
	.oRdEmpty		(wTxRdEmpty),
	.oRdData		(wTxRdData)
);

///////////////////// RX Fifo///////////////////////

//FTDI interface
wire wRxWrEn;
wire wRxWrFull;
wire [7:0] wRxWrData;

//FPGA interface
wire wRxRdEn;
assign wRxRdEn = iRxEn;
wire wRxRdEmpty;
assign oRxEmpty = wRxRdEmpty;
wire [7:0] wRxRdData;
assign oRxData = wRxRdData;



fifo_sync_8bit#(
	.pFifoDepth(pRxFifoDepth)
)rx_fifo_inst(
	.iClk			(iClk),
	.iRst			(iRst),
	.iWrEn			(wRxWrEn),
	.oWrFull		(wRxWrFull),
	.iWrData		(wRxWrData),
	.iRdEn			(wRxRdEn),
	.oRdEmpty		(wRxRdEmpty),
	.oRdData		(wRxRdData)
);


////FTDI Interface////
wire wRxF_n;		//RxBuffer on the Fifo has data
assign wRxF_n = iRxF_n;
wire wTxE_n;		//Tx Buffer on fifo is not full
assign wTxE_n = iTxE_n;
wire wRx_n;		//Start Rx from Ftdi
assign oRx_n = wRx_n;
wire wTx_n;		//Start Tx to Ftdi
assign oTx_n = wTx_n;
wire wSiwu;		//Enable the usb to wake up the computer. 
assign oSiwu = wSiwu;

ft2232h_async ft2232h_inst
(
	////Internal inputs////
	.iClk			(iClk),		//48mhz sys clock for async
	.iRst			(iRst),
	////Tx Input Fifo////
	.oTxRdEn		(wTxRdEn),
	.iTxRdEmpty		(wTxRdEmpty),
	.iTxData		(wTxWrData),
	////Rx Output Fifo////
	.oRxWrEn		(wRxWrEn),
	.iRxWrFull		(wRxWrFull),
	.oRxData		(wRxWrData),
	////FTDI Interface////
	.ioFifoData		(ioFifoData),
	.iRxF_n			(wRxF_n),		//RxBuffer on the Fifo has data
	.iTxE_n			(wTxE_n),		//Tx Buffer on fifo is not full
	.oRx_n			(wRx_n),		//Start Rx from Ftdi
	.oTx_n			(wTx_n),		//Start Tx to Ftdi
	.oSiwu			(wSiwu)		//Enable the usb to wake up the computer. 
);


endmodule