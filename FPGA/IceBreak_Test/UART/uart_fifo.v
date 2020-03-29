//`timescale 1ns/1ps

`include "fifo.v"
`include "uart.v"

module uart_fifo #(
	parameter pClkFreq=12_000_000, //12MHz default
	parameter pBaudRate=9600,
	parameter pRxFifoByteLength=4,
	parameter pTxFifoByteLength=4
)
(
	iClk,
	iResetn,
	iRx,
	oTx,
	oRxByteOut,
	iRxRead,
	oRxBufferEmpty,
	rUartError,
	iTxByte,
	iTxWrite,
	oUartTxBusy
);




input iClk;
input iResetn;
input iRx;
output oTx;
output [7:0] oRxByteOut;
input iRxRead;
output wire oRxBufferEmpty;
output reg rUartError;
input [7:0] iTxByte;
input iTxWrite;
output reg oUartTxBusy;




///////// FIFO TX ///////
//TX write
//reg rTxFifoWriteEn;
wire wTxFifoFull;
//TX read
//reg rTxFifoReadEn;
wire [7:0] wTxFifoReadData;
wire wTxFifoEmpty;

//////// FIFO RX ////////
//RX write
//reg rRxFifoWriteEn;
wire wRxFifoFull;
//RX read
reg rRxFifoReadEn;
wire [7:0] rRxFifoReadData;
wire wRxFifoEmpty;
///// data out is always output from the fifo
assign oRxByteOut = rRxFifoReadData; //
assign oRxBufferEmpty = wRxFifoEmpty;

////////////UART ///////////
reg rTransmit;
wire wRcvd, wIsReceiving, wIsTransmitting, wRcvErr;


wire [7:0] wRxByte;

uart #(
	.pClkFreq(pClkFreq),
	.pBaudRate(pBaudRate)
)uart_inst0 (
	.rst		(iResetn),
	.clk 		(iClk),
	.rx			(iRx), 	//TODO Change this to be correct
	.tx			(oTx),	//TODO change this to be correct
	.transmit 	(rTransmit),
	.tx_byte	(wTxFifoReadData),
	.received	(wRcvd),		//Indicate byte has been received
	.rx_byte		(wRxByte),	//received byte
	.is_receiving	(wIsReceiving),		//Low when rx line is idle
	.is_transmitting(wIsTransmitting),	//Low when tx line is idle
	.recv_error		(wRcvErr)			//indicates error in rx packet			//indicates error in rx packet
);

////////RX Fifo/////
fifo #(
	.pFifoDepth(pRxFifoByteLength),
	.pFifoDataWidth(8)

) fifo_rx_inst(
	.iClk		(iClk),
	.iRst		(iResetn),
	//Fifo Write INterface
	.iWriteEn	(wRcvd),
	.iWriteData	(wRxByte),
	.oFifoFull	(wRxFifoFull),
	//Fifo Read Interface
	.iReadEn	(iRxRead),
	.oReadData	(rRxFifoReadData),
	.oFifoEmpty	(wRxFifoEmpty)
);

/////////TX Fifo/////
fifo #(
	.pFifoDepth(pTxFifoByteLength),
	.pFifoDataWidth(8)

) fifo_tx_inst(
	.iClk		(iClk),
	.iRst		(iResetn),
	//Fifo Write INterface
	.iWriteEn	(iTxWrite),
	.iWriteData	(iTxByte),
	.oFifoFull	(wTxFifoFull),
	//Fifo Read Interface
	.iReadEn	(rTransmit),
	.oReadData	(wTxFifoReadData),
	.oFifoEmpty	(wTxFifoEmpty)
);

//UART RX Handling
always @(posedge iClk) begin
	if(iResetn) begin
		rUartError <= 0;
	end else begin
	
	end
end

//UART TX Handling
always @(posedge iClk) begin
	if(iResetn) begin
		oUartTxBusy <= 0;
		rTransmit <= 0;
	end else begin
		if(!wIsTransmitting) begin
			if(!wTxFifoEmpty) begin
				rTransmit <= 1'b1;
			end else begin
				rTransmit <= 1'b0;
			end
		end else begin
			rTransmit <= 1'b0;
		end
		
		if(wTxFifoFull) begin
			oUartTxBusy <= 1'b0;
		end
	end

end

endmodule
