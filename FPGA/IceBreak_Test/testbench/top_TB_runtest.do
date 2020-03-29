setactivelib -work
#Compiling UUT module design files
comp -include C:\Users\birdman\Documents\DirtBagLabSupplies\DMM\FPGA\IceBreaker_Test\IceBreak_Test\design_top.v
comp -include "C:\Users\birdman\Documents\DirtBagLabSupplies\DMM\FPGA\IceBreaker_Test\IceBreak_Test\testbench\top_TB.v"
asim +access +r top_tb

wave
wave -noreg iClk
wave -noreg BTN_N
wave -noreg LEDR_N
wave -noreg LEDG_N
wave -noreg P1A7
wave -noreg P1A8
wave -noreg P1A9
wave -noreg BTN1
wave -noreg oTx
wave -noreg iRx

run

#End simulation macro
