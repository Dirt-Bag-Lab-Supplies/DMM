
#Begin clock constraint
define_clock -name {top|iClk} {p:top|iClk} -period 10.969 -clockgroup Autoconstr_clkgroup_0 -rise 0.000 -fall 5.484 -route 0.000 
#End clock constraint

#Begin clock constraint
define_clock -name {top_pll|PLLOUTGLOBAL_derived_clock} {n:top_pll|PLLOUTGLOBAL_derived_clock} -period 10.969 -clockgroup Autoconstr_clkgroup_0 -rise 0.000 -fall 5.484 -route 0.000 
#End clock constraint
