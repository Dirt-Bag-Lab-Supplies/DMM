module ftdi_output #(
	parameter pDataWidth=8,
	parameter pMaxData=8
)(
	//External inputs
	iClk,		//48mhz sys clock for async
	iRst,
	ioFifoData,	//Data bus bidir
	//External Outputs 
	iRxF_n,		//RxBuffer on the Fifo has data
	iTxE_n,		//Tx Buffer on fifo is not full
	oRx_n,		//Start Rx from Ftdi
	oTx_n,		//Start Tx to Ftdi
	//oOe_n,	 	//Select Rd/Wr direction on bus. 0 = Read : 1 = Write
	oSiwu,		//Enable the usb to wake up the computer. 
	//Internal Inputs
	iRamRdData,
	iPacketAvail,
	//Internal Outputs
	oRamRdAddr,
	oPacketRead,
	oRxData,
	oRxFlag
);

input iClk, iRst, iRxF_n, iTxE_n, iPacketAvail;
input [pDataWidth-1:0] iRamRdData;
inout [7:0] ioFifoData;
output reg oRx_n, oTx_n, oSiwu, oPacketRead; // oOe_n,
output reg [$clog2(pMaxData)-1:0] oRamRdAddr;
output [7:0] oRxData;
output reg oRxFlag;

assign oRxData = rRxData; 
//////////////////////////////////////Read from RAM, write to FTDI/////////////////////////////////

// Internal parameters
parameter SIZE = 3;
parameter IDLE = 0;
parameter RD_START = 1;
parameter RD_DATA = 2;
parameter WR_START = 3;
parameter WR_DATA = 4;
parameter ERROR = 5;

//Internal Registers

reg [SIZE-1:0] rFifoState = IDLE;
//reg [7:0] rTxData;	//Reg to store Tx data
reg [7:0] rRxData;	//Reg to store Rx data

reg [2:0] rRxF_n;
reg [2:0] rTxE_n;
reg rWrDelay; //Delay the entire chain by 1 clk to meet setup times for write flag. 
wire wRxF_posEdge; //wire to remove metastability from input
wire wTxE_posEdge; //wire to remove metastability
wire wRxF_negEdge; //wire to remove metastability from input
wire wTxE_negEdge; //wire to remove metastability
reg rTxBusReady;

assign wRxF_posEdge = rRxF_n[0] & rRxF_n[1]; 
assign wTxE_n = rTxE_n[0] & rTxE_n[1];
//Data bus is hi-z unless writing. Tx_n = 0: bus = ram data
assign ioFifoData = rTxBusReady ? 8'h41 : 8'hZZ;
////FSM////
always@ (posedge iClk) begin
	if(iRst) begin
		rFifoState <= IDLE;
		oRx_n <= 1'b1;
		oTx_n <= 1'b1;
		rRxData <= 8'b0;
		oSiwu <= 1'b1;
		rWrDelay <= 1'b0; 
		oRxFlag <= 1'b0; //Clear rx flag
		rTxBusReady <= 1'b0;
	end else begin
		rRxF_n[2:0] <= {rRxF_n[2:1], iRxF_n};
		rTxE_n[2:0] <= {rTxE_n[2:1], iTxE_n};

		// rRxF_n[0] <= iRxF_n;
		// rRxF_n[1] <= rRxF_n[0]; //Sync the input
		// rTxE_n[0] <= iTxE_n;
		// rTxE_n[1] <= rTxE_n[0];
		//FSM
		//rTxData <= iRamRdData; //Always register the incoming data. 

		case(rFifoState)
			// oReadn <= 1'b1;
			// oWriten <= 1'b1;
			// oOe_n <= 1'b0; //Default to readdfghdfgh

			IDLE:begin

				//Start the read:
				//Wait for falling edge of the Rx Full flag. 
				//Put bus in high-z
				//Set the read flag to signal the fifo to put data on the bus. 
				if(iRxF_n == 1'b0) begin 	
					//ioFifoData <= 8'hZZ; //Set data bus to hi-z
					rFifoState <= RD_START;	//Go here wait for next clk edge
					oRx_n <= 1'b0; //Set read flag immediately

				end else if(iTxE_n == 1'b0 ) begin 
				//Start transmitting if tx isn't full and data is available
					//ioFifoData <= iRamRdData; //Put data on bus. REquires 5ns setup time before write flag
				 	//oTx_n <= 1'b0; //Write immediately
				 	rTxBusReady <= 1'b1;
					rFifoState <= WR_START;
				end
			end
			RD_START:begin	
				//Wait 14ns min before reading the data. 
				//Sys clock is 48mhz, so 1clk is 20ns
				oRxFlag <= 1'b1;
				rFifoState <= RD_DATA;
				rRxData <= ioFifoData;
				//rTxData <= iRamRdData; //Register data while we go to the next state
				//oRx_n <= 1'b0; //Tell fifo to start sending data
			end
			RD_DATA:begin
				//Min time of RD pulse is 30ns, must wait one addl clk before deasserting
				oRxFlag <= 1'b0;
				rFifoState <= IDLE;
				oRx_n <= 1'b1; //Deassert read flag
				//Not setting the data here, just in case I screwed something up
			end
			WR_START:begin
				//Assert the write flag. Must wait 30ns before deassert. 
				oTx_n <= 1'b0;
				rFifoState <= WR_DATA; 
			end
			WR_DATA:begin
				//Wait 2clk cycles (40ns) before reasserting write flag. 
				//The flag the buffer. Increment read address
				if(!rWrDelay) begin
					rWrDelay <= 1'b1; //delay one cycle. 
				end else begin
					rWrDelay <= 1'b0; // reset delay
					rFifoState <= IDLE;
					//oPacketRead <= 1'b1; //Flag the ram that a packet was read -- reset to 0 in idle
					oTx_n <= 1'b1; //Clear the write flag/ 
					rTxBusReady <= 1'b0;
					//oRamRdAddr <= (oRamRdAddr == pMaxData) ? 8'h00 : oRamRdAddr + 1;
				end
			end
			ERROR:begin
				rFifoState <= IDLE;
				oRx_n <= 1'b1;
				oTx_n <= 1'b1;
				oSiwu <= 1'b1;
			end
			default:begin
				rFifoState <= IDLE;
			end
		endcase // rFifoState

	end
end

endmodule