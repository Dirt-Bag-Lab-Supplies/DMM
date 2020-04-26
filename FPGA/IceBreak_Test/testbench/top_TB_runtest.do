setactivelib -work
#Compiling UUT module design files
comp -include C:\Users\birdman\Documents\DirtBagLabSupplies\DMM\DMM_trunk\FPGA\IceBreak_Test\design_top.v
comp -include "C:\Users\birdman\Documents\DirtBagLabSupplies\DMM\DMM_trunk\FPGA\IceBreak_Test\testbench\top_TB.v"
asim +access +r top_tb

wave
wave -noreg iClk
wave -noreg BTN_N
wave -noreg BTN1
wave -noreg P1A1
wave -noreg P1A2
wave -noreg P1A3
wave -noreg P1A4
wave -noreg P1A7
wave -noreg P1A8
wave -noreg P1A9
wave -noreg ioFifoData
wave -noreg ioFifoData_bidir
wave -noreg iRxF_n
wave -noreg iTxE_n
wave -noreg oRx_n
wave -noreg oTx_n

run

#End simulation macro
