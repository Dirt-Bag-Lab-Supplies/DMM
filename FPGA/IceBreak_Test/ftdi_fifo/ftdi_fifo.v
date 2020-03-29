
`include "ftdi_input_simple.v"
`include "ftdi_output_async.v"

module ftdi_fifo #(
	parameter pDataWidth=8,
	parameter pMaxData=8
)(
	//Tx FPGA Interface
	iClk,	//FPGA Clock
	iRst,
	iTxData, //Data to transmit from FPGA to FTDI
	iTxEn,  // Data valid writing data to dual port ram
	oTxFull, 	//Ram is full, stop writing
	//FTDI interface
	//iFifoClk,	//Clk from FTDI fifo -- Sync only
	ioFifoData,	//Data bus to the FTDI
	iRxF_n,		//RxBuffer on the Fifo has data
	iTxE_n,		//Tx Buffer on fifo is empty
	oRx_n,		//Start Rx from Ftdi
	oTx_n,		//Start Tx to Ftdi
	//oOe_n,	 	//Select Rd/Wr direction on bus. 0 = Read : 1 = Write
	oSiwu,		//Enable the usb to wake up the computer. 
	oRxData,
	oRxFlag
);

//Inputs - Sys Clock
input iClk, iRst, iTxEn;
input [pDataWidth-1:0] iTxData;
//Outputs -- sys clk
output oTxFull;

//Inputs for async
input iRxF_n, iTxE_n; //iFifoClk, -- sync only
inout [7:0] ioFifoData;
//Outputs for asyncx
output oRx_n, oTx_n, oSiwu; // oOe_n, -- sync only
output [7:0] oRxData;
output oRxFlag; //Flag for new data received. 

/////////////////////////////////

//Data wires between modules 
wire wPacketAvail, wPacketRead;
wire [$clog2(pMaxData)-1:0] wRamRdAddr;

wire [pDataWidth-1:0] wRamRdData;

ftdi_input_simple #(
	.pDataWidth(8),
	.pMaxData(8) //Number of data pieces 
)ftdi_input_inst(
	.iWClk			(iClk),//Write clk -- 48MHz
	.iRst			(iRst),//Reset high
	.iTxEn			(iTxEn),//Write data to RAM
	.iTxData 		(iTxData),//Data to write to RAM
	.oTxFull		(oTxFull),//Ram is full
	.oPacketAvail 	(wPacketAvail),//Output that data is available in the buffer
	//60MHz Clock
	.iRClk			(iFifoClk),//Read clk -- 60MHz from FTDI
	.iRamRdAddr 	(wRamRdAddr),//Addr from RAM to read from
	.oRamRdData 	(wRamRdData),//Data output from RAM
	.iPacketRead 	(wPacketRead)//Flag to remove data from the queue
);

//Async setup for icebreaker
ftdi_output #(
	.pDataWidth(8),
	.pMaxData(8) //Number of data pieces 
)ftdi_output_inst(
			//External inputs
	.iClk				(iClk), //48mhz   -- (iFifoClk),sync RAM Read clk - 60mhz
	.iRst				(iRst),
	.ioFifoData			(ioFifoData),//Data bus bidir
			//External Outputs 
	.iRxF_n				(iRxF_n),//RxBuffer on the Fifo has data
	.iTxE_n				(iTxE_n),//Tx Buffer on fifo is empty
	.oRx_n				(oRx_n),//Start Rx from Ftdi
	.oTx_n				(oTx_n),//Start Tx to Ftdi
	.oSiwu				(oSiwu),//Enable the usb to wake up the computer. 
			//Internal Inputs
	.iRamRdData			(wRamRdData),
	.iPacketAvail		(wPacketAvail),
			//Internal Outputs
	.oRamRdAddr			(wRamRdAddr),	
	.oPacketRead		(wPacketRead),
	.oRxData			(oRxData),
	.oRxFlag			(oRxFlag)
);

//Sync setup for later
// ftdi_output #(
// 	.pDataWidth(8),
// 	.pMaxData(8) //Number of data pieces 
// )ftdi_output_inst(
// 			//External inputs
// 	.iClk				(iFifoClk),//RAM Read clk - 60mhz
// 	.iRst				(iRst),
// 	.ioFifoData			(ioFifoData),//Data bus bidir
// 			//External Outputs 
// 	.iRxF_n				(iRxF_n),//RxBuffer on the Fifo has data
// 	.iTxE_n				(iTxE_n),//Tx Buffer on fifo is empty
// 	.oRx_n				(oRx_n),//Start Rx from Ftdi
// 	.oTx_n				(oTx_n),//Start Tx to Ftdi
// 	.oOe_n	 			(oOe_n),//Select Rd/Wr direction on bus. 0 = Read : 1 = Write
// 	.oSiwu				(oSiwu),//Enable the usb to wake up the computer. 
// 			//Internal Inputs
// 	.iRamRdData			(wRamRdData),
// 	.iPacketAvail		(wPacketAvail),
// 			//Internal Outputs
// 	.oRamRdAddr			(wRamRdAddr),	
// 	.oPacketRead		(wPacketRead)
// );


endmodule