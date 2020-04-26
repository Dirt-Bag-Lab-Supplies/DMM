-- ******************************************************************************

-- iCEcube Netlister

-- Version:            2017.08.27940

-- Build Date:         Sep 11 2017 17:29:57

-- File Generated:     Mar 21 2020 22:38:42

-- Purpose:            Post-Route Verilog/VHDL netlist for timing simulation

-- Copyright (C) 2006-2010 by Lattice Semiconductor Corp. All rights reserved.

-- ******************************************************************************

-- VHDL file for cell "uart_fifo_tb" view "INTERFACE"

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library ice;
use ice.vcomponent_vital.all;

-- Entity of uart_fifo_tb
entity uart_fifo_tb is
port ();
end uart_fifo_tb;

-- Architecture of uart_fifo_tb
-- View name is \INTERFACE\
architecture \INTERFACE\ of uart_fifo_tb is

signal \VCCG0\ : std_logic;
signal \GNDG0\ : std_logic;
signal \_gnd_net_\ : std_logic;

begin

    \VCC\ : VCC
    port map (
            Y => \VCCG0\
        );

    \GND\ : GND
    port map (
            Y => \GNDG0\
        );

    \GND_Inst\ : GND
    port map (
            Y => \_gnd_net_\
        );
end \INTERFACE\;
