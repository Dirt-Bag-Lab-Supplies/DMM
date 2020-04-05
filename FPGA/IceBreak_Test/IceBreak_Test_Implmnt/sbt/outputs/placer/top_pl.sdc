create_clock -period 13.03 -name {top|iClk} -waveform [list 0.00 6.52] [get_ports iClk]
create_clock -period 83.33 -name {iClk} [get_ports iClk]
create_clock -period 20.83 -name {clk_48mhz} [get_nets clk_48mhz]
