setactivelib -work
#Compiling UUT module design files
comp -include c:\Users\birdman\Documents\DirtBagLabSupplies\DMM\DMM_trunk\FPGA\IceBreak_Test\ftdi_fifo\ftdi_fifo.v
comp -include "C:\Users\birdman\Documents\DirtBagLabSupplies\DMM\DMM_trunk\FPGA\IceBreak_Test\ftdi_fifo\ftdi_fifo_async_TB.v"
asim +access +r ftdi_fifo_async_tb

wave
wave -noreg iClk
wave -noreg iRst
wave -noreg iTxEn
wave -noreg oTxFull
wave -noreg oTxFull_actual
wave -noreg iTxData
wave -noreg iRxEn
wave -noreg oRxEmpty
wave -noreg oRxEmpty_actual
wave -noreg oRxData
wave -noreg oRxData_actual
wave -noreg ioFifoData
wave -noreg ioFifoData_bidir
wave -noreg iRxF_n
wave -noreg iTxE_n
wave -noreg oRx_n
wave -noreg oRx_n_actual
wave -noreg oTx_n
wave -noreg oTx_n_actual
wave -noreg oSiwu
wave -noreg oSiwu_actual

run -all

#End simulation macro
