setactivelib -work
#Compiling UUT module design files
comp -include $dsn\src\packet_to_fifo.v
comp -include "C:\Users\birdman\Documents\DirtBagLabSupplies\DMM\DMM_trunk\FPGA\IceBreak_Test\RAM_Fifo\packet_to_fifo_TB.v"
asim +access +r packet_to_fifo_tb

wave
wave -noreg iClk
wave -noreg iRst
wave -noreg iPacketWr
wave -noreg iPacketData
wave -noreg oPacketDone
wave -noreg oErr
wave -noreg oWrEn
wave -noreg iWrFull
wave -noreg oWrData

run

#End simulation macro
