setactivelib -work
#Compiling UUT module design files
comp -include c:\Users\birdman\Documents\DirtBagLabSupplies\DMM\DMM_trunk\FPGA\IceBreak_Test\adc\adc_to_packet.v
comp -include "C:\Users\birdman\Documents\DirtBagLabSupplies\DMM\DMM_trunk\FPGA\IceBreak_Test\adc\adc_to_packet_TB.v"
asim +access +r adc_to_packet_tb

wave
wave -noreg iClk
wave -noreg iRst
wave -noreg oErr
wave -noreg iWrEn
wave -noreg iAdcSampleData
wave -noreg oPacketWr
wave -noreg iPackerWrFull
wave -noreg oPacketData

run

#End simulation macro
