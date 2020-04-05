setactivelib -work
#Compiling UUT module design files
comp -include c:\Users\birdman\Documents\DirtBagLabSupplies\DMM\DMM_trunk\FPGA\IceBreak_Test\RAM_Fifo\fifo_sync.v
comp -include "$dsn\src\TestBench\fifo_sync_8bit_TB.v"
asim +access +r fifo_sync_8bit_tb

wave
wave -noreg iClk
wave -noreg iRst
wave -noreg iWrEn
wave -noreg oWrFull
wave -noreg iWrData
wave -noreg iRdEn
wave -noreg oRdEmpty
wave -noreg oRdData

run

#End simulation macro
