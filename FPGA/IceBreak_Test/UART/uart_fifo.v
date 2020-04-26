//`timescale 1ns/1ps

// `include "./RAM_fifo/fifo_sync.v"
// `include "uart.v"

module uart_fifo #(
	parameter pClkFreq=12_000_000, //12MHz default
	parameter pBaudRate=9600,
	parameter pTxFifoDepth=8,
	parameter pRxFifoDepth=8
)
(
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
	//UART Interface
	iRx,	//External Rx line
	oTx, 	//Extnernal TX Line
	oRcvErr
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


//UART Lines
input iRx;
output oTx;
output oRcvErr;



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
)tx_uart_fifo_inst(
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

//UART interface
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
)rx_uart_fifo_inst(
	.iClk			(iClk),
	.iRst			(iRst),
	.iWrEn			(wRxWrEn),
	.oWrFull		(wRxWrFull),
	.iWrData		(wRxWrData),
	.iRdEn			(wRxRdEn),
	.oRdEmpty		(wRxRdEmpty),
	.oRdData		(wRxRdData)
);

//////////////////////////UART Module//////////////////////
wire wRx;
assign wRx = iRx;
wire wTx;
assign oTx = wTx;
wire wRecvErr;
assign oRecvErr = wRecvErr;


uart#(
	.pClkFreq(pClkFreq),
	.pBaudRate(pBaudRate)
) uart_inst0(
	////Internal inputs////
	.iClk			(iClk),		//48mhz sys clock for async
	.iRst			(iRst),
	////Tx Input Fifo////
	.oTxRdEn		(wTxRdEn),
	.iTxRdEmpty		(wTxRdEmpty),
	.iTxData		(wTxRdData),
	////Rx Output Fifo////
	.oRxWrEn		(wRxWrEn),
	.iRxWrFull		(wRxWrFull),
	.oRxData		(wRxWrData),
	//UART
	.iRx 			(wRx),	//External Rx line
	.oTx 			(wTx), 	//Extnernal TX Line
	.oRcvErr		(wRcvErr)
);

endmodule
