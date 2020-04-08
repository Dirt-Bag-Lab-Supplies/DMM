EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 3
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L DBLS_USB:FT600Q U?
U 1 1 5E83910A
P 5350 800
AR Path="/5E83910A" Ref="U?"  Part="1" 
AR Path="/5E81C490/5E83910A" Ref="U?"  Part="1" 
F 0 "U?" H 5900 800 50  0000 C CNN
F 1 "FT600Q" H 5500 -2800 50  0000 C CNN
F 2 "" H 8550 0   50  0001 C CNN
F 3 "" H 8550 0   50  0001 C CNN
	1    5350 800 
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E839116
P 4850 4450
AR Path="/5E839116" Ref="#PWR?"  Part="1" 
AR Path="/5E81C490/5E839116" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 4850 4200 50  0001 C CNN
F 1 "GND" H 4855 4277 50  0000 C CNN
F 2 "" H 4850 4450 50  0001 C CNN
F 3 "" H 4850 4450 50  0001 C CNN
	1    4850 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	4950 4150 4850 4150
Wire Wire Line
	4850 4150 4850 4250
Wire Wire Line
	4950 4250 4850 4250
Connection ~ 4850 4250
Wire Wire Line
	4850 4250 4850 4450
$Comp
L power:GND #PWR?
U 1 1 5E839121
P 6100 4450
AR Path="/5E839121" Ref="#PWR?"  Part="1" 
AR Path="/5E81C490/5E839121" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 6100 4200 50  0001 C CNN
F 1 "GND" H 6105 4277 50  0000 C CNN
F 2 "" H 6100 4450 50  0001 C CNN
F 3 "" H 6100 4450 50  0001 C CNN
	1    6100 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	6100 4250 6050 4250
Wire Wire Line
	6100 4250 6100 4450
$Comp
L power:GND #PWR?
U 1 1 5E839129
P 2650 2800
AR Path="/5E839129" Ref="#PWR?"  Part="1" 
AR Path="/5E81C490/5E839129" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 2650 2550 50  0001 C CNN
F 1 "GND" H 2750 2800 50  0000 C CNN
F 2 "" H 2650 2800 50  0001 C CNN
F 3 "" H 2650 2800 50  0001 C CNN
	1    2650 2800
	1    0    0    -1  
$EndComp
$Comp
L DBLS_Diode:ESD122 U?
U 1 1 5E839133
P 2100 2850
AR Path="/5E839133" Ref="U?"  Part="1" 
AR Path="/5E81C490/5E839133" Ref="U?"  Part="1" 
F 0 "U?" H 2400 2750 50  0000 L CNN
F 1 "ESD122" H 2150 2950 50  0000 L CNN
F 2 "" H 2250 3000 50  0001 C CNN
F 3 "" H 2250 3050 50  0001 C CNN
F 4 "Texas Instruments" H 2210 3470 50  0001 C CNN "mfg"
F 5 "ESD122DMXR" H 2200 3360 50  0001 C CNN "mfg_pn"
F 6 "Digikey" H 2190 3270 50  0001 C CNN "vendor"
F 7 "296-48543-1-ND" H 2210 3180 50  0001 C CNN "vendor_pn"
	1    2100 2850
	1    0    0    -1  
$EndComp
$Comp
L DBLS_Diode:ESD122 U?
U 1 1 5E83913D
P 2100 2550
AR Path="/5E83913D" Ref="U?"  Part="1" 
AR Path="/5E81C490/5E83913D" Ref="U?"  Part="1" 
F 0 "U?" H 2400 2450 50  0000 L CNN
F 1 "ESD122" H 2150 2650 50  0000 L CNN
F 2 "" H 2250 2700 50  0001 C CNN
F 3 "" H 2250 2750 50  0001 C CNN
F 4 "Texas Instruments" H 2210 3170 50  0001 C CNN "mfg"
F 5 "ESD122DMXR" H 2200 3060 50  0001 C CNN "mfg_pn"
F 6 "Digikey" H 2190 2970 50  0001 C CNN "vendor"
F 7 "296-48543-1-ND" H 2210 2880 50  0001 C CNN "vendor_pn"
	1    2100 2550
	1    0    0    -1  
$EndComp
$Comp
L DBLS_Diode:ESD122 U?
U 1 1 5E839147
P 2100 2250
AR Path="/5E839147" Ref="U?"  Part="1" 
AR Path="/5E81C490/5E839147" Ref="U?"  Part="1" 
F 0 "U?" H 2400 2150 50  0000 L CNN
F 1 "ESD122" H 2100 2350 50  0000 L CNN
F 2 "" H 2250 2400 50  0001 C CNN
F 3 "" H 2250 2450 50  0001 C CNN
F 4 "Texas Instruments" H 2210 2870 50  0001 C CNN "mfg"
F 5 "ESD122DMXR" H 2200 2760 50  0001 C CNN "mfg_pn"
F 6 "Digikey" H 2190 2670 50  0001 C CNN "vendor"
F 7 "296-48543-1-ND" H 2210 2580 50  0001 C CNN "vendor_pn"
	1    2100 2250
	1    0    0    -1  
$EndComp
$Comp
L DBLS_Diode:ESD122 U?
U 1 1 5E839151
P 2100 3150
AR Path="/5E839151" Ref="U?"  Part="1" 
AR Path="/5E81C490/5E839151" Ref="U?"  Part="1" 
F 0 "U?" H 2450 3050 50  0000 C CNN
F 1 "ESD122" H 2300 3250 50  0000 C CNN
F 2 "" H 2250 3300 50  0001 C CNN
F 3 "" H 2250 3350 50  0001 C CNN
F 4 "Texas Instruments" H 2210 3770 50  0001 C CNN "mfg"
F 5 "ESD122DMXR" H 2200 3660 50  0001 C CNN "mfg_pn"
F 6 "Digikey" H 2190 3570 50  0001 C CNN "vendor"
F 7 "296-48543-1-ND" H 2210 3480 50  0001 C CNN "vendor_pn"
	1    2100 3150
	1    0    0    -1  
$EndComp
$Comp
L DBLS_Diode:TPD4E05U06 U?
U 1 1 5E83915B
P 2300 1800
AR Path="/5E83915B" Ref="U?"  Part="1" 
AR Path="/5E81C490/5E83915B" Ref="U?"  Part="1" 
F 0 "U?" H 2400 1950 50  0000 L CNN
F 1 "TPD4E05U06" H 2400 1550 50  0000 L CNN
F 2 "" H 2050 2150 50  0001 C CNN
F 3 "" H 2370 1990 50  0001 C CNN
F 4 "Texas Instruments" H 2210 2540 50  0001 C CNN "mfg"
F 5 "TPD4E05U06DQAR" H 2220 2440 50  0001 C CNN "mfg_pn"
F 6 "Digikey" H 2200 2360 50  0001 C CNN "vendor"
F 7 "296-35765-1-ND" H 2200 2270 50  0001 C CNN "vendor_pn"
	1    2300 1800
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E839161
P 2500 1900
AR Path="/5E839161" Ref="#PWR?"  Part="1" 
AR Path="/5E81C490/5E839161" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 2500 1650 50  0001 C CNN
F 1 "GND" H 2600 1900 50  0000 C CNN
F 2 "" H 2500 1900 50  0001 C CNN
F 3 "" H 2500 1900 50  0001 C CNN
	1    2500 1900
	1    0    0    -1  
$EndComp
Wire Wire Line
	2350 1750 2400 1750
Wire Wire Line
	2400 1750 2400 1850
Wire Wire Line
	2400 1950 2350 1950
Connection ~ 2400 1850
Wire Wire Line
	2400 1850 2400 1950
$Comp
L DBLS_Diode:TPD4E05U06 U?
U 1 1 5E839170
P 2600 1300
AR Path="/5E839170" Ref="U?"  Part="1" 
AR Path="/5E81C490/5E839170" Ref="U?"  Part="1" 
F 0 "U?" H 2550 1550 50  0000 L CNN
F 1 "TPD4E05U06" H 2700 1050 50  0000 L CNN
F 2 "" H 2350 1650 50  0001 C CNN
F 3 "" H 2670 1490 50  0001 C CNN
F 4 "Texas Instruments" H 2510 2040 50  0001 C CNN "mfg"
F 5 "TPD4E05U06DQAR" H 2520 1940 50  0001 C CNN "mfg_pn"
F 6 "Digikey" H 2500 1860 50  0001 C CNN "vendor"
F 7 "296-35765-1-ND" H 2500 1770 50  0001 C CNN "vendor_pn"
	1    2600 1300
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E839176
P 2750 1350
AR Path="/5E839176" Ref="#PWR?"  Part="1" 
AR Path="/5E81C490/5E839176" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 2750 1100 50  0001 C CNN
F 1 "GND" H 2755 1177 50  0000 C CNN
F 2 "" H 2750 1350 50  0001 C CNN
F 3 "" H 2750 1350 50  0001 C CNN
	1    2750 1350
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2650 1250 2700 1250
Wire Wire Line
	2700 1250 2700 1350
Wire Wire Line
	2700 1450 2650 1450
Wire Wire Line
	2700 1350 2750 1350
Connection ~ 2700 1350
Wire Wire Line
	2700 1350 2700 1450
Wire Wire Line
	2050 1650 1800 1650
Wire Wire Line
	1800 1750 2050 1750
Wire Wire Line
	2050 1950 1800 1950
Wire Wire Line
	1800 2050 2050 2050
Wire Wire Line
	1800 1550 2350 1550
Wire Wire Line
	2350 1450 1800 1450
Wire Wire Line
	1800 1250 2350 1250
Wire Wire Line
	2350 1150 1800 1150
Text Label 1850 1450 0    50   ~ 0
D-
Text Label 1850 1550 0    50   ~ 0
D-
Text Label 1850 1650 0    50   ~ 0
D+
Text Label 1850 1750 0    50   ~ 0
D+
Wire Wire Line
	2450 2300 2550 2300
Wire Wire Line
	2550 2300 2550 2600
Wire Wire Line
	2550 3200 2450 3200
Wire Wire Line
	2450 2900 2550 2900
Connection ~ 2550 2900
Wire Wire Line
	2550 2900 2550 3200
Wire Wire Line
	2450 2600 2550 2600
Connection ~ 2550 2600
Wire Wire Line
	2550 2600 2550 2750
Connection ~ 2550 2750
Wire Wire Line
	2550 2750 2550 2900
Wire Wire Line
	2050 2550 1800 2550
Wire Wire Line
	2050 2650 1800 2650
Wire Wire Line
	2050 2850 1800 2850
Wire Wire Line
	2050 2950 1800 2950
Wire Wire Line
	1800 3150 2050 3150
Wire Wire Line
	2050 3250 1800 3250
Wire Wire Line
	2050 2350 1800 2350
Wire Wire Line
	1800 2250 2050 2250
Text Label 1850 1150 0    50   ~ 0
CC1
Text Label 1850 1250 0    50   ~ 0
CC2
Text Label 1850 1950 0    50   ~ 0
SBU1
Text Label 1850 2050 0    50   ~ 0
SBU2
Text Label 1850 2250 0    50   ~ 0
RX-
Text Label 1850 2350 0    50   ~ 0
RX+
Text Label 1850 2550 0    50   ~ 0
TX-
Text Label 1850 2650 0    50   ~ 0
TX+
Text Label 1850 2850 0    50   ~ 0
RX-
Text Label 1850 2950 0    50   ~ 0
RX+
Text Label 1850 3150 0    50   ~ 0
TX-
Text Label 1850 3250 0    50   ~ 0
TX+
Wire Wire Line
	900  3550 900  3650
Text Label 4750 2750 0    50   ~ 0
D+
Text Label 4750 2850 0    50   ~ 0
D-
Wire Wire Line
	4750 2750 4950 2750
Wire Wire Line
	4750 2850 4950 2850
$Comp
L DBLS_Capacitor:SMD-CAP-100NF-0402 C?
U 1 1 5E8391C9
P 4700 3250
AR Path="/5E8391C9" Ref="C?"  Part="1" 
AR Path="/5E81C490/5E8391C9" Ref="C?"  Part="1" 
F 0 "C?" V 4650 3350 40  0000 C CNN
F 1 "SMD-CAP-100NF-0402" H 4500 3825 20  0001 L CNN
F 2 "DBLS_Capacitor:C_0402_1005Metric" H 4700 3575 20  0001 C CNN
F 3 "N/A" H 4700 3475 20  0001 C CNN
F 4 "311-1345-1-ND" H 4700 3625 20  0001 C CNN "vendor_pn"
F 5 "Digikey" H 4700 3675 20  0001 C CNN "vendor"
F 6 "CC0402KRX7R6BB104" H 4700 3725 20  0001 C CNN "mfg_pn"
F 7 "Yageo" H 4700 3775 20  0001 C CNN "mfg"
F 8 "YES" H 4625 3325 20  0001 C CNN "place"
F 9 "0.1uF" V 4750 3400 30  0000 C CNN "capacitance"
	1    4700 3250
	0    1    1    0   
$EndComp
$Comp
L DBLS_Capacitor:SMD-CAP-100NF-0402 C?
U 1 1 5E8391D5
P 4500 3350
AR Path="/5E8391D5" Ref="C?"  Part="1" 
AR Path="/5E81C490/5E8391D5" Ref="C?"  Part="1" 
F 0 "C?" V 4450 3450 40  0000 C CNN
F 1 "SMD-CAP-100NF-0402" H 4300 3925 20  0001 L CNN
F 2 "DBLS_Capacitor:C_0402_1005Metric" H 4500 3675 20  0001 C CNN
F 3 "N/A" H 4500 3575 20  0001 C CNN
F 4 "311-1345-1-ND" H 4500 3725 20  0001 C CNN "vendor_pn"
F 5 "Digikey" H 4500 3775 20  0001 C CNN "vendor"
F 6 "CC0402KRX7R6BB104" H 4500 3825 20  0001 C CNN "mfg_pn"
F 7 "Yageo" H 4500 3875 20  0001 C CNN "mfg"
F 8 "YES" H 4425 3425 20  0001 C CNN "place"
F 9 "0.1uF" V 4550 3500 30  0000 C CNN "capacitance"
	1    4500 3350
	0    1    1    0   
$EndComp
Wire Wire Line
	4600 3350 4950 3350
Wire Wire Line
	4950 3250 4800 3250
Wire Wire Line
	4950 3000 4750 3000
Wire Wire Line
	4950 3100 4750 3100
Text Label 4300 3250 0    50   ~ 0
TX+
Text Label 4300 3350 0    50   ~ 0
TX-
Text Label 4750 3100 0    50   ~ 0
RX-
Text Label 4750 3000 0    50   ~ 0
RX+
Wire Wire Line
	4450 3350 4300 3350
Wire Wire Line
	4650 3250 4300 3250
$Comp
L DBLS_LDO:LP5912 U?
U 1 1 5E8391EA
P 3750 950
AR Path="/5E8391EA" Ref="U?"  Part="1" 
AR Path="/5E81C490/5E8391EA" Ref="U?"  Part="1" 
F 0 "U?" H 3850 1050 50  0000 C CNN
F 1 "LP5912" H 3750 650 50  0000 C CNN
F 2 "DBLS_SON:WSON-6-1EP_2x2mm_P0.65mm_EP1x1.6mm_ThermalVias" H 3750 1150 50  0001 C CNN
F 3 "" H 3750 1150 50  0001 C CNN
F 4 "Texas Instruments" H 3750 1550 50  0001 C CNN "mfg"
F 5 "LP5912-3.3DRVT" H 3750 1450 50  0001 C CNN "mfg_pn"
F 6 "Digikey" H 3750 1350 50  0001 C CNN "vendor"
F 7 "296-44153-1-ND" H 3750 1250 50  0001 C CNN "vendor_pn"
F 8 "YES" H 3950 700 25  0001 C CNN "place"
	1    3750 950 
	1    0    0    -1  
$EndComp
$Comp
L DBLS_Resistor:SMD-RES-0-0603 R?
U 1 1 5E8391F6
P 3100 1050
AR Path="/5E8391F6" Ref="R?"  Part="1" 
AR Path="/5E81C490/5E8391F6" Ref="R?"  Part="1" 
F 0 "R?" H 3100 1100 45  0000 L CNN
F 1 "SMD-RES-0-0603" H 2750 1750 50  0001 L BNN
F 2 "DBLS_Resistor:R_0603_1608Metric_Pad1.05x0.95mm_HandSolder" H 3100 1250 50  0001 C CNN
F 3 "N/A" H 3100 1250 50  0001 C CNN
F 4 "0" H 3150 1000 40  0000 L CNN "resistance"
F 5 "Vishay Dale" H 3100 1650 50  0001 C CNN "mfg"
F 6 "CRCW06030000Z0EAHP" H 3100 1550 50  0001 C CNN "mfg_pn"
F 7 "Digikey" H 3100 1450 50  0001 C CNN "vendor"
F 8 "541-0.0SBCT-ND" H 3100 1350 50  0001 C CNN "vendor_pn"
F 9 "YES" H 3000 1100 20  0001 C CNN "place"
	1    3100 1050
	1    0    0    -1  
$EndComp
Wire Wire Line
	3000 1050 3000 950 
$Comp
L power:GND #PWR?
U 1 1 5E8391FD
P 3450 1200
AR Path="/5E8391FD" Ref="#PWR?"  Part="1" 
AR Path="/5E81C490/5E8391FD" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 3450 950 50  0001 C CNN
F 1 "GND" H 3450 1050 50  0000 C CNN
F 2 "" H 3450 1200 50  0001 C CNN
F 3 "" H 3450 1200 50  0001 C CNN
	1    3450 1200
	1    0    0    -1  
$EndComp
Wire Wire Line
	3450 1200 3450 1150
Wire Wire Line
	3450 1150 3550 1150
$Comp
L power:GND #PWR?
U 1 1 5E839205
P 4050 1200
AR Path="/5E839205" Ref="#PWR?"  Part="1" 
AR Path="/5E81C490/5E839205" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 4050 950 50  0001 C CNN
F 1 "GND" H 4050 1050 50  0000 C CNN
F 2 "" H 4050 1200 50  0001 C CNN
F 3 "" H 4050 1200 50  0001 C CNN
	1    4050 1200
	1    0    0    -1  
$EndComp
Wire Wire Line
	4050 1200 4050 1150
Wire Wire Line
	4050 1150 3950 1150
Text Label 3250 1050 0    50   ~ 0
LDO_EN
$Comp
L DBLS_Capacitor:SMD-CAP-1UF-0402 C?
U 1 1 5E839214
P 2900 1100
AR Path="/5E839214" Ref="C?"  Part="1" 
AR Path="/5E81C490/5E839214" Ref="C?"  Part="1" 
F 0 "C?" H 2800 1200 40  0000 L CNN
F 1 "SMD-CAP-1UF-0402" H 2450 1950 50  0001 L CNN
F 2 "DBLS_Capacitor:C_0402_1005Metric" H 2900 1450 50  0001 C CNN
F 3 "" H 2900 1325 20  0001 C CNN
F 4 "1uF" H 2800 1050 30  0000 L CNN "capacitance"
F 5 "Murata Electronics" H 2900 1850 50  0001 C CNN "mfg"
F 6 "GRM155R61E105KA12D" H 2900 1750 50  0001 C CNN "mfg_pn"
F 7 "Digikey" H 2900 1650 50  0001 C CNN "vendor"
F 8 "490-10017-1-ND" H 2900 1550 50  0001 C CNN "vendor_pn"
F 9 "YES" H 2825 1175 20  0001 C CNN "place"
	1    2900 1100
	1    0    0    -1  
$EndComp
Wire Wire Line
	2900 1000 2900 950 
$Comp
L DBLS_Resistor:SMD-RES-10K-0603 R?
U 1 1 5E839221
P 4400 1050
AR Path="/5E839221" Ref="R?"  Part="1" 
AR Path="/5E81C490/5E839221" Ref="R?"  Part="1" 
F 0 "R?" H 4400 1100 45  0000 C CNN
F 1 "SMD-RES-10K-0603" H 4050 1750 50  0001 L BNN
F 2 "DBLS_Resistor:R_0603_1608Metric_Pad1.05x0.95mm_HandSolder" H 4400 1250 50  0001 C CNN
F 3 "N/A" H 4400 1250 50  0001 C CNN
F 4 "10K" H 4300 1000 40  0000 C CNN "resistance"
F 5 "Vishay Dale" H 4400 1650 50  0001 C CNN "mfg"
F 6 "CRCW060310K0JNEAHP" H 4400 1550 50  0001 C CNN "mfg_pn"
F 7 "Digikey" H 4400 1450 50  0001 C CNN "vendor"
F 8 "541-10KSACT-ND" H 4400 1350 50  0001 C CNN "vendor_pn"
F 9 "YES" H 4300 1100 20  0001 C CNN "place"
	1    4400 1050
	1    0    0    -1  
$EndComp
Text Label 4000 1050 0    50   ~ 0
LDO_PG
Wire Wire Line
	3550 950  3000 950 
Connection ~ 2900 950 
Wire Wire Line
	2900 950  1800 950 
Connection ~ 3000 950 
Wire Wire Line
	3000 950  2900 950 
Wire Wire Line
	3200 1050 3550 1050
Wire Wire Line
	2900 1150 3450 1150
Connection ~ 3450 1150
Wire Wire Line
	3950 950  4550 950 
Wire Wire Line
	3950 1050 4300 1050
Wire Wire Line
	4500 1050 4550 1050
Wire Wire Line
	4550 1050 4550 950 
Connection ~ 4550 950 
Wire Wire Line
	4550 950  4650 950 
$Comp
L DBLS_Capacitor:SMD-CAP-1UF-0402 C?
U 1 1 5E839242
P 4650 1100
AR Path="/5E839242" Ref="C?"  Part="1" 
AR Path="/5E81C490/5E839242" Ref="C?"  Part="1" 
F 0 "C?" H 4650 1200 40  0000 L CNN
F 1 "SMD-CAP-1UF-0402" H 4200 1950 50  0001 L CNN
F 2 "DBLS_Capacitor:C_0402_1005Metric" H 4650 1450 50  0001 C CNN
F 3 "" H 4650 1325 20  0001 C CNN
F 4 "1uF" H 4700 1050 30  0000 L CNN "capacitance"
F 5 "Murata Electronics" H 4650 1850 50  0001 C CNN "mfg"
F 6 "GRM155R61E105KA12D" H 4650 1750 50  0001 C CNN "mfg_pn"
F 7 "Digikey" H 4650 1650 50  0001 C CNN "vendor"
F 8 "490-10017-1-ND" H 4650 1550 50  0001 C CNN "vendor_pn"
F 9 "YES" H 4575 1175 20  0001 C CNN "place"
	1    4650 1100
	1    0    0    -1  
$EndComp
Wire Wire Line
	4650 1150 4050 1150
Connection ~ 4050 1150
Wire Wire Line
	4650 1000 4650 950 
Connection ~ 4650 950 
Wire Wire Line
	4650 950  4850 950 
Wire Wire Line
	4950 1100 4850 1100
Wire Wire Line
	4850 1100 4850 950 
Connection ~ 4850 950 
Wire Wire Line
	4850 950  4950 950 
Wire Wire Line
	4950 1200 4850 1200
Wire Wire Line
	4850 1200 4850 1100
Connection ~ 4850 1100
Wire Wire Line
	4950 1300 4850 1300
Wire Wire Line
	4850 1300 4850 1200
Connection ~ 4850 1200
Wire Wire Line
	4950 1450 4850 1450
Wire Wire Line
	4850 1450 4850 1300
Connection ~ 4850 1300
Wire Wire Line
	4950 1550 4850 1550
Wire Wire Line
	4850 1550 4850 1450
Connection ~ 4850 1450
Wire Wire Line
	4950 1650 4850 1650
Wire Wire Line
	4850 1650 4850 1550
Connection ~ 4850 1550
Wire Wire Line
	2650 2750 2650 2800
Wire Wire Line
	2550 2750 2650 2750
Wire Wire Line
	2500 1850 2500 1900
Wire Wire Line
	2400 1850 2500 1850
Wire Wire Line
	4950 1800 4850 1800
Wire Wire Line
	4850 1800 4850 1900
Wire Wire Line
	4850 2350 4950 2350
Wire Wire Line
	4950 2200 4850 2200
Connection ~ 4850 2200
Wire Wire Line
	4850 2200 4850 2350
Wire Wire Line
	4950 2100 4850 2100
Connection ~ 4850 2100
Wire Wire Line
	4850 2100 4850 2200
Wire Wire Line
	4950 2000 4850 2000
Connection ~ 4850 2000
Wire Wire Line
	4850 2000 4850 2100
Wire Wire Line
	4950 1900 4850 1900
Connection ~ 4850 1900
Wire Wire Line
	4850 1900 4850 2000
$Comp
L power:GND #PWR?
U 1 1 5E839273
P 4500 2600
AR Path="/5E839273" Ref="#PWR?"  Part="1" 
AR Path="/5E81C490/5E839273" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 4500 2350 50  0001 C CNN
F 1 "GND" H 4500 2450 50  0000 C CNN
F 2 "" H 4500 2600 50  0001 C CNN
F 3 "" H 4500 2600 50  0001 C CNN
	1    4500 2600
	1    0    0    -1  
$EndComp
Wire Notes Line
	1950 750  1950 1050
Wire Notes Line
	1950 1050 2500 1050
Wire Notes Line
	2500 1050 2500 750 
Wire Notes Line
	2500 750  1950 750 
Text Notes 2000 950  0    50   ~ 0
Ferrite may\nbe needed
Text Label 2550 950  0    50   ~ 0
VBUS
Wire Wire Line
	4750 2600 4950 2600
Text Label 4750 2600 0    50   ~ 0
VBUS
$Comp
L DBLS_Capacitor:SMD-CAP-4.7UF-0402 C?
U 1 1 5E839287
P 4500 2500
AR Path="/5E839287" Ref="C?"  Part="1" 
AR Path="/5E81C490/5E839287" Ref="C?"  Part="1" 
F 0 "C?" H 4581 2555 40  0000 L CNN
F 1 "SMD-CAP-4.7UF-0402" H 4050 3350 50  0001 L CNN
F 2 "DBLS_Capacitor:C_0402_1005Metric" H 4500 2850 50  0001 C CNN
F 3 "" H 4500 2725 20  0001 C CNN
F 4 "4.7uF" H 4581 2487 30  0000 L CNN "capacitance"
F 5 "Murata Electronics" H 4500 3250 50  0001 C CNN "mfg"
F 6 "GRM155R61A475MEAAD" H 4500 3150 50  0001 C CNN "mfg_pn"
F 7 "Digikey" H 4500 3050 50  0001 C CNN "vendor"
F 8 "490-14306-1-ND" H 4500 2950 50  0001 C CNN "vendor_pn"
F 9 "YES" H 4425 2575 20  0001 C CNN "place"
	1    4500 2500
	1    0    0    -1  
$EndComp
Wire Wire Line
	4500 2550 4500 2600
Wire Wire Line
	4500 2400 4500 2350
Wire Wire Line
	4500 2350 4850 2350
Connection ~ 4850 2350
Wire Wire Line
	6050 950  6100 950 
Wire Wire Line
	6050 1050 6100 1050
Wire Wire Line
	6050 1150 6100 1150
Wire Wire Line
	6050 1250 6100 1250
Wire Wire Line
	6050 1350 6100 1350
Wire Wire Line
	6050 1450 6100 1450
Wire Wire Line
	6050 1550 6100 1550
Wire Wire Line
	6050 1650 6100 1650
Wire Wire Line
	6050 1750 6100 1750
Wire Wire Line
	6050 1850 6100 1850
Wire Wire Line
	6050 1950 6100 1950
Wire Wire Line
	6050 2050 6100 2050
Wire Wire Line
	6050 2150 6100 2150
Wire Wire Line
	6050 2250 6100 2250
Wire Wire Line
	6050 2350 6100 2350
Wire Wire Line
	6050 2450 6100 2450
Entry Wire Line
	6100 950  6200 1050
Entry Wire Line
	6100 1050 6200 1150
Entry Wire Line
	6100 1150 6200 1250
Entry Wire Line
	6100 1250 6200 1350
Entry Wire Line
	6100 1350 6200 1450
Entry Wire Line
	6100 1450 6200 1550
Entry Wire Line
	6100 1550 6200 1650
Entry Wire Line
	6100 1650 6200 1750
Entry Wire Line
	6100 1750 6200 1850
Entry Wire Line
	6200 1950 6100 1850
Entry Wire Line
	6100 1950 6200 2050
Entry Wire Line
	6100 2050 6200 2150
Entry Wire Line
	6100 2150 6200 2250
Entry Wire Line
	6100 2250 6200 2350
Entry Wire Line
	6100 2350 6200 2450
Entry Wire Line
	6100 2450 6200 2550
Entry Bus Bus
	6200 1700 6300 1800
Text Label 6350 1800 0    50   ~ 0
FIFO_DATA_BUS
Wire Bus Line
	6300 1800 6950 1800
Connection ~ 1200 3650
Wire Wire Line
	1200 3650 1200 3700
Wire Wire Line
	1200 3550 1200 3650
$Comp
L DBLS_USB:USB_C_Receptacle J?
U 1 1 5E839228
P 1200 1950
AR Path="/5E839228" Ref="J?"  Part="1" 
AR Path="/5E81C490/5E839228" Ref="J?"  Part="1" 
F 0 "J?" H 1600 3100 50  0000 C CNN
F 1 "USB_C_Receptacle" H 1150 3100 50  0000 C CNN
F 2 "" H 1350 1950 50  0001 C CNN
F 3 "https://www.usb.org/sites/default/files/documents/usb_type-c.zip" H 1350 1950 50  0001 C CNN
	1    1200 1950
	1    0    0    -1  
$EndComp
Wire Wire Line
	950  3650 900  3650
Wire Wire Line
	1150 3650 1200 3650
$Comp
L DBLS_Resistor:SMD-RES-0-0603 R?
U 1 1 5E8391B3
P 1050 3650
AR Path="/5E8391B3" Ref="R?"  Part="1" 
AR Path="/5E81C490/5E8391B3" Ref="R?"  Part="1" 
F 0 "R?" H 1050 3600 45  0000 C CNN
F 1 "SMD-RES-0-0603" H 700 4350 50  0001 L BNN
F 2 "Resistors_SMD:R_0603" H 1050 3850 50  0001 C CNN
F 3 "N/A" H 1050 3850 50  0001 C CNN
F 4 "YES" H 950 3700 20  0001 C CNN "place"
F 5 "CRCW06030000Z0EAHP" H 1050 4150 50  0001 C CNN "mfg_pn"
F 6 "Vishay Dale" H 1050 4250 50  0001 C CNN "mfg"
F 7 "Digikey" H 1050 4050 50  0001 C CNN "vendor"
F 8 "0" H 1050 3700 40  0000 C CNN "resistance"
F 9 "541-0.0SBCT-ND" H 1050 3950 50  0001 C CNN "vendor_pn"
	1    1050 3650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E839110
P 1200 3700
AR Path="/5E839110" Ref="#PWR?"  Part="1" 
AR Path="/5E81C490/5E839110" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 1200 3450 50  0001 C CNN
F 1 "GND" H 1205 3527 50  0000 C CNN
F 2 "" H 1200 3700 50  0001 C CNN
F 3 "" H 1200 3700 50  0001 C CNN
	1    1200 3700
	1    0    0    -1  
$EndComp
Wire Bus Line
	6200 1050 6200 2550
$EndSCHEMATC
