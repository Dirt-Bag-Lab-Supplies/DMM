setactivelib -work
#Compiling UUT module design files
comp -include c:\Users\birdman\Documents\DirtBagLabSupplies\DMM\DMM_trunk\FPGA\IceBreak_Test\ftdi_fifo\ft2232h_async.v
comp -include "C:\Users\birdman\Documents\DirtBagLabSupplies\DMM\DMM_trunk\FPGA\IceBreak_Test\ftdi_fifo\ft2232h_async_TB.v"
asim +access +r ft2232h_async_wb

wave
wave -noreg iClk
wave -noreg iRst
wave -noreg oTxRdEn
wave -noreg oTxRdEn_actual
wave -noreg iTxRdEmpty
wave -noreg iTxData
wave -noreg oRxWrEn
wave -noreg oRxWrEn_actual
wave -noreg iRxWrFull
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
