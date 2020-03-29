// Cause yosys to throw an error when we implicitly declare nets
//`default_nettype none

module design_top_tb;

	reg 	iClk;
	reg 	BTN_N;		//Reset button
	wire 	LEDR_N;
	wire 	LEDG_N;
	wire 	P1A7; // Debug pins 
	wire 	P1A8;  // 
	wire 	P1A9;
	reg  	BTN1;
	wire 	oTx;
	reg 	iRx;
	
	reg iRestetn;
		  // Testbench uses a 48 MHz clock
  // Want to interface to 115200 baud UART
  parameter c_CLOCK_PERIOD_NS = 5;
//////////////////////Top Module////////////////
 top DUT(
	.iClk 		(iClk),
	.BTN_N 		(BTN_N)	,	//Reset button
	.LEDR_N 	(LEDR_N),
	.LEDG_N 	(LEDG_N),
	.P1A7 		(P1A7), // Debug pins 
	.P1A8 		(P1A8),  // 
	.P1A9 		(P1A9),
	.BTN1  		(BTN1),
	.oTx 		(oTx),
	.iRx 		(iRx),
)
///////////////////FTDI UART///////////////////////
// localparam pClkFreq = 48_000_000; // 42MHz
// // localparam baud = 57600;
// localparam pBaudRate = 115200;

	// // reg iClk;
	// // reg iResetn;
	// // reg iRx;
	// // wire oTx;
	// wire [7:0] wRxByteOut;
	// reg rRxRead;
	// wire wRxBufferEmpty;
	// wire wUartError;
	// reg [7:0] rTxByte;
	// reg rTxWrite;
	// wire wUartTxBusy;


// uart_fifo #(
	// .pClkFreq(pClkFreq),
	// .pBaudRate(pBaudRate),
	// .pRxFifoByteLength(4),
	// .pTxFifoByteLength(4)
// )uart_fifo_inst(
	// .iClk				(iClk),
	// .iResetn			(iResetn),
	// .iRx				(iRx),
	// .oTx				(oTx),
	// .oRxByteOut			(wRxByteOut),
	// .wRxRead			(rRxRead),
	// .rRxBufferEmpty		(wRxBufferEmpty),
	// .rUartError			(wUartError),
	// .iTxByte			(rTxByte),
	// .iTxWrite			(rTxWrite),
	// .oUartTxBusy		(wUartTxBusy)
// );

//////////////////////////Base UART///////////////////////////////
	// reg rTransmit;
	// wire wRcvd, wIsReceiving, wIsTransmitting, wRcvErr;

	// reg [7:0] rTxByte;
	// wire [7:0] wRxByte;

	// wire wUartLine; //This is the loopback wire for testing
	// assign wUartLine = wIsTransmitting ? oTx : 1'b1; //Keep uart line pulled high. IF moduel transmitting loopback data


// uart uart_inst0 #(
	// .pClkFreq(pClkFreq),
	// .pBaudRate(pBaudRate)
// )(
	// .rst		(~iResetn),
	// .clk 		(iClk),
	// .rx			(iRx), 	//TODO Change this to be correct
	// .tx			(oTx),	//TODO change this to be correct
	// .transmit 	(rTransmit),
	// .tx_byte	(rTxByte),
	// .received	(wRcvd),		//Indicate byte has been received
	// .rx_byte		(wRxByte),	//received byte
	// .is_receiving	(wIsReceiving),		//Low when rx line is idle
	// .is_transmitting(wIsTransmitting),	//Low when tx line is idle
	// .recv_error		(wRcvErr)			//indicates error in rx packet
// );

initial	 begin
	#100 iClk = !iClk;
end

endmodule