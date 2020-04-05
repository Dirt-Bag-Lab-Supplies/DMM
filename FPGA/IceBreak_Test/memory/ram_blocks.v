module ram_dp_512x8(
	RDATA,
	RADDR,
	RCLK,
	RE,
	WADDR,
	WCLK,
	WDATA,
	WE
);

//Read IO
output reg [7:0] RDATA; //8bit data output
input	[8:0] RADDR; //9bit read address
input 	RCLK;
input RE;		//Read the data at addr

//Write IO
input [8:0] WADDR; //9bit write address
input WCLK;
input [7:0] WDATA; //16bit data to write
input WE; //Write data to memory. 


//Memory
reg [7:0] mem [511:0]; 

//READ MACHINE
always @(negedge RCLK) begin
	if(RE)
		RDATA <= mem[RADDR];
end

//WRITE MACHINE
always @(negedge WCLK) begin
	if(WE)
		mem[WADDR] <= WDATA;
end

endmodule
