module ftdi_output #(
	parameter pDataWidth=8,
	parameter pMaxData=8
)(
	//External inputs
	iClk,		//RAM Read clk - 60mhz
	iRst,
	ioFifoData,	//Data bus bidir
	//External Outputs 
	iRxF_n,		//RxBuffer on the Fifo has data
	iTxE_n,		//Tx Buffer on fifo is empty
	oRx_n,		//Start Rx from Ftdi
	oTx_n,		//Start Tx to Ftdi
	oOe_n,	 	//Select Rd/Wr direction on bus. 0 = Read : 1 = Write
	oSiwu,		//Enable the usb to wake up the computer. 
	//Internal Inputs
	iRamRdData,
	iPacketAvail,
	//Internal Outputs
	oRamRdAddr,
	oPacketRead
);

input iClk, iRst, iRxF_n, iTxE_n, iPacketAvail;
input [pDataWidth-1:0] iRamRdData;
inout [7:0] ioFifoData;
output reg oRx_n, oTx_n, oOe_n, oSiwu, oPacketRead;
output reg [$clog2(pMaxData)-1:0] oRamRdAddr;

//////////////////////////////////////Read from RAM, write to FTDI/////////////////////////////////
/// 60MHz clock from FTDI

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
reg [7:0] rTxData;	//Reg to store Tx data
reg [7:0] rRxData;	//Reg to store Rx data


wire wTxEn;
reg [2:0] rPacketAvail;
assign wTxEn = rPacketAvail[1:0] == 2'b11 ? 1'b1 : 1'b0; //Buffering from 48mhz 
//Assign blocks
assign ioFifoData = (oOe_n == 1'b1 ? rTxData[7:0] : 8'bZ); //Bus is high-z input if reading from fifo

////FSM////
always@ (posedge iClk) begin
	if(iRst) begin
		rFifoState <= IDLE;
		oOe_n <= 1'b0; //Read by default for now
		oRx_n <= 1'b1;
		oTx_n <= 1'b1;
		rRxData <= 8'b0;
		oSiwu <= 1'b1;
		rPacketAvail <= 0;
	end else begin
		//FSM
		rTxData <= iRamRdData; //Always register the incoming data. 

		case(rFifoState)
			// oReadn <= 1'b1;
			// oWriten <= 1'b1;
			// oOe_n <= 1'b0; //Default to readdfghdfgh

			IDLE:begin
				if(iRxF_n == 1'b0) begin 	//READ
					oOe_n <= 1'b0; //Tell fifo to output data
					//ioFifoData <= 8'hZZ; //Set data bus to hi-z
					rFifoState <= RD_START;	//Go here wait for next clk edge
				end else if(iTxE_n == 1'b0 && rPacketAvail) begin //WRITE
					oOe_n <= 1'b1; //FPGA drives the bus	//
					rFifoState <= WR_START;
				end
			end
			RD_START:begin	//Wait for next clk edge 
				rFifoState <= RD_DATA;
				//rTxData <= iRamRdData; //Register data while we go to the next state
				oRx_n <= 1'b0; //Tell fifo to start sending data
			end
			RD_DATA:begin
				rRxData <= ioFifoData; 
				if(!iRxF_n) begin //RX Buffer is empty, return to idle
					oRx_n <= 1'b1; 
					oOe_n <= 1'b1;
					rFifoState <= IDLE;
				end
			end
			WR_START:begin
				//ioFifoData <= rTxData;	
				oTx_n <= 1'b0;
				rFifoState <= WR_DATA;
				oPacketRead <= 1'b1; 
			end
			WR_DATA:begin
				oPacketRead <= 1'b0;
				if(iTxE_n) begin //Tx buffer is full; stop sending data
					oTx_n <= 1'b1; //Stop writing
					rFifoState <= IDLE;
					
				end else begin
					if(iTxE_n) begin //Still data to transmit
						rFifoState <= WR_START;
						oRamRdAddr <= (oRamRdAddr == pMaxData) ? 8'h00 : oRamRdAddr + 1;
					end else begin
						rFifoState <= IDLE;
					end
				end
			end
			ERROR:begin
				rFifoState <= IDLE;
				oOe_n <= 1'b0; //Read by default for now
				oRx_n <= 1'b1;
				oTx_n <= 1'b1;
				rRxData <= 7'b0;
				oSiwu <= 1'b1;
			end
			default:begin
				rFifoState <= IDLE;
			end
		endcase // rFifoState

	end
end

endmodule