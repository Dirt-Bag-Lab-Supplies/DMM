####---- CreateClock list ----3
create_clock  -period 13.03 -waveform {0.00 6.52} -name {top|iClk} [get_ports {iClk}] 
create_clock  -period 83.33 -name {iClk} [get_ports {iClk}] 
create_clock  -period 20.83 -name {clk_48mhz} [get_nets {clk_48mhz}] 

