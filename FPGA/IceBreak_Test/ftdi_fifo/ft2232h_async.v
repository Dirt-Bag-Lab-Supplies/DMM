module ft2232h_async(
	////Internal inputs////
	iClk,		//48mhz sys clock for async
	iRst,
	////Tx Input Fifo////
	oTxRdEn,
	iTxRdEmpty,
	iTxData,
	////Rx Output Fifo////
	oRxWrEn,
	iRxWrFull,
	oRxData,
	////FTDI Interface////
	ioFifoData,
	iRxF_n,		//RxBuffer on the Fifo has data
	iTxE_n,		//Tx Buffer on fifo is not full
	oRx_n,		//Start Rx from Ftdi
	oTx_n,		//Start Tx to Ftdi
	oSiwu,		//Enable the usb to wake up the computer. 
);

//Internal Inputs
input iClk, iRst;

//Tx Fifo
output oTxRdEn;
input iTxRdEmpty;
input [7:0] iTxData;

//Rx Fifo
output oRxWrEn;
input iRxWrFull;
output [7:0] oRxData;

//FTDI Interface
inout [7:0] ioFifoData;
input iRxF_n; //RxBuffer on the Fifo has data
input iTxE_n; //Tx Buffer on fifo is not full
output	oRx_n;		//Start Rx from Ftdi
output	oTx_n;		//Start Tx to Ftdi
output	oSiwu;		//Enable the usb to wake up the computer. 


//Output registers to system
reg rTxRdEn;
assign oTxRdEn = rTxRdEn;
reg rRxWrEn;
assign oRxWrEn = rRxWrEn;
reg [7:0] rRxData;	//Register incoming data to write to fifo
assign oRxData = rRxData;

//Output registers to FTDI
reg rRx_n;
assign oRx_n = rRx_n;
reg rTx_n;
assign oTx_n = rTx_n;
reg rSiwu;
assign oSiwu = rSiwu;

//Flow control
wire wRxEn; //Wire to determine if everything is ready to receive
assign wRxEn = !iRxF_n && !iRxWrFull; //If ftdi has data and buffer is not full
wire wTxEn;
//assign wTxEn = !iTxE_n && !iTxRdEmpty; //FTDI has data and buffer has data
assign wTxEn = !iTxE_n; //ignore the empty flag for now. 

//Input registers to sync flags
//--Currently not using since it eats clock cycles pretty quick and complicates the state machine. 
// reg [2:0] rRxF_n;
// reg [2:0] rTxE_n;

// FTDI FSM
parameter IDLE = 0;
parameter RD_START = 1;
parameter RD_DATA = 2;
parameter WR_START = 3;
parameter WR_DATA = 4;
parameter ERROR = 5;

//Internal Registers

reg [2:0] rFifoState;
reg rWrDelay; //Delay the entire chain by 1 clk to meet 30ns width for write flag. 

reg rTxBusReady; //flag to set direction  of bus hi-z vs output

//Data bus is hi-z unless writing. Tx_n = 0: bus = ram data
assign ioFifoData = rTxBusReady ? 8'h41 : 8'hZZ;


////FSM////
always@ (posedge iClk) begin
	if(iRst) begin
		//FSM Variables
		rFifoState <= IDLE;
		rWrDelay <= 1'b0; 
		rTxBusReady <= 1'b0;
		//FTDI Outputs
		rRx_n <= 1'b1;
		rTx_n <= 1'b1;
		rSiwu <= 1'b1;
		//Fifo
		rTxRdEn <= 1'b0;
		rRxWrEn <= 1'b0;
		rRxData <= 7'b0;

	end else begin
		case(rFifoState)
			IDLE:begin

				//Start the read:
				//Wait for falling edge of the Rx Full flag. 
				//Put bus in high-z
				//Set the read flag to signal the fifo to put data on the bus. 
				if(wRxEn) begin 	
					rFifoState <= RD_START;	//Go here wait for next clk edge
					rRx_n <= 1'b0; //Set read flag immediately
				end else if(wTxEn) begin 
				//Start transmitting if tx isn't full and data is available
				 	rTxBusReady <= 1'b1; //Put tx data on the bus
					rFifoState <= WR_START;
				end
			end
			RD_START:begin	
				//Wait 14ns min before reading the data. 
				//Sys clock is 48mhz, so 1clk is 20ns
				rRxWrEn <= 1'b1; //Write data to rx fifo
				rFifoState <= RD_DATA;
				rRxData <= ioFifoData;
				//rTxData <= iRamRdData; //Register data while we go to the next state
				//oRx_n <= 1'b0; //Tell fifo to start sending data
			end
			RD_DATA:begin
				//Min time of RD pulse is 30ns, must wait one addl clk before deasserting
				rRxWrEn <= 1'b0;
				rFifoState <= IDLE;
				rRx_n <= 1'b1; //Deassert read flag
				//Not setting the data here, just in case I screwed something up
			end
			WR_START:begin
				//Assert the write flag. Must wait 30ns before deassert. 
				rTx_n <= 1'b0;
				rFifoState <= WR_DATA; 
			end
			WR_DATA:begin
				//Wait 2clk cycles (40ns) before reasserting write flag. 
				//The flag the buffer. Increment read address
				if(!rWrDelay) begin
					rWrDelay <= 1'b1; //delay one cycle. 
					rTxRdEn <= 1'b1; //Flag that something was written to the chip
				end else begin
					rTxRdEn <= 1'b0; //Signal we are done writing; 
					rWrDelay <= 1'b0; // reset delay
					rFifoState <= IDLE;
					//oPacketRead <= 1'b1; //Flag the ram that a packet was read -- reset to 0 in idle
					rTx_n <= 1'b1; //Clear the write flag/ 
					rTxBusReady <= 1'b0;
					//oRamRdAddr <= (oRamRdAddr == pMaxData) ? 8'h00 : oRamRdAddr + 1;
				end
			end
			ERROR:begin
				rFifoState <= IDLE;
				rRx_n <= 1'b1;
				rTx_n <= 1'b1;
				rSiwu <= 1'b1;
			end
			default:begin
				rFifoState <= IDLE;
			end
		endcase // rFifoState

	end
end

endmodule