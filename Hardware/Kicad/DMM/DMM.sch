EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
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
U 1 1 5E6F9169
P 5250 750
F 0 "U?" H 5400 865 50  0000 C CNN
F 1 "FT600Q" H 5400 774 50  0000 C CNN
F 2 "" H 8450 -50 50  0001 C CNN
F 3 "" H 8450 -50 50  0001 C CNN
	1    5250 750 
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E7FFBEC
P 1100 3650
F 0 "#PWR?" H 1100 3400 50  0001 C CNN
F 1 "GND" H 1105 3477 50  0000 C CNN
F 2 "" H 1100 3650 50  0001 C CNN
F 3 "" H 1100 3650 50  0001 C CNN
	1    1100 3650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E807BDC
P 4750 4400
F 0 "#PWR?" H 4750 4150 50  0001 C CNN
F 1 "GND" H 4755 4227 50  0000 C CNN
F 2 "" H 4750 4400 50  0001 C CNN
F 3 "" H 4750 4400 50  0001 C CNN
	1    4750 4400
	1    0    0    -1  
$EndComp
Wire Wire Line
	4850 4100 4750 4100
Wire Wire Line
	4750 4100 4750 4200
Wire Wire Line
	4850 4200 4750 4200
Connection ~ 4750 4200
Wire Wire Line
	4750 4200 4750 4400
$Comp
L power:GND #PWR?
U 1 1 5E808A74
P 6000 4400
F 0 "#PWR?" H 6000 4150 50  0001 C CNN
F 1 "GND" H 6005 4227 50  0000 C CNN
F 2 "" H 6000 4400 50  0001 C CNN
F 3 "" H 6000 4400 50  0001 C CNN
	1    6000 4400
	1    0    0    -1  
$EndComp
Wire Wire Line
	6000 4200 5950 4200
Wire Wire Line
	6000 4200 6000 4400
$Comp
L power:GND #PWR?
U 1 1 5E830061
P 2550 2750
F 0 "#PWR?" H 2550 2500 50  0001 C CNN
F 1 "GND" H 2650 2750 50  0000 C CNN
F 2 "" H 2550 2750 50  0001 C CNN
F 3 "" H 2550 2750 50  0001 C CNN
	1    2550 2750
	1    0    0    -1  
$EndComp
$Comp
L DBLS_Diode:ESD122 U?
U 1 1 5E83180D
P 2000 2800
F 0 "U?" H 2300 2700 50  0000 L CNN
F 1 "ESD122" H 2050 2900 50  0000 L CNN
F 2 "" H 2150 2950 50  0001 C CNN
F 3 "" H 2150 3000 50  0001 C CNN
F 4 "Texas Instruments" H 2110 3420 50  0001 C CNN "mfg"
F 5 "ESD122DMXR" H 2100 3310 50  0001 C CNN "mfg_pn"
F 6 "Digikey" H 2090 3220 50  0001 C CNN "vendor"
F 7 "296-48543-1-ND" H 2110 3130 50  0001 C CNN "vendor_pn"
	1    2000 2800
	1    0    0    -1  
$EndComp
$Comp
L DBLS_Diode:ESD122 U?
U 1 1 5E833A31
P 2000 2500
F 0 "U?" H 2300 2400 50  0000 L CNN
F 1 "ESD122" H 2050 2600 50  0000 L CNN
F 2 "" H 2150 2650 50  0001 C CNN
F 3 "" H 2150 2700 50  0001 C CNN
F 4 "Texas Instruments" H 2110 3120 50  0001 C CNN "mfg"
F 5 "ESD122DMXR" H 2100 3010 50  0001 C CNN "mfg_pn"
F 6 "Digikey" H 2090 2920 50  0001 C CNN "vendor"
F 7 "296-48543-1-ND" H 2110 2830 50  0001 C CNN "vendor_pn"
	1    2000 2500
	1    0    0    -1  
$EndComp
$Comp
L DBLS_Diode:ESD122 U?
U 1 1 5E83424D
P 2000 2200
F 0 "U?" H 2300 2100 50  0000 L CNN
F 1 "ESD122" H 2000 2300 50  0000 L CNN
F 2 "" H 2150 2350 50  0001 C CNN
F 3 "" H 2150 2400 50  0001 C CNN
F 4 "Texas Instruments" H 2110 2820 50  0001 C CNN "mfg"
F 5 "ESD122DMXR" H 2100 2710 50  0001 C CNN "mfg_pn"
F 6 "Digikey" H 2090 2620 50  0001 C CNN "vendor"
F 7 "296-48543-1-ND" H 2110 2530 50  0001 C CNN "vendor_pn"
	1    2000 2200
	1    0    0    -1  
$EndComp
$Comp
L DBLS_Diode:ESD122 U?
U 1 1 5E82A2A3
P 2000 3100
F 0 "U?" H 2350 3000 50  0000 C CNN
F 1 "ESD122" H 2200 3200 50  0000 C CNN
F 2 "" H 2150 3250 50  0001 C CNN
F 3 "" H 2150 3300 50  0001 C CNN
F 4 "Texas Instruments" H 2110 3720 50  0001 C CNN "mfg"
F 5 "ESD122DMXR" H 2100 3610 50  0001 C CNN "mfg_pn"
F 6 "Digikey" H 2090 3520 50  0001 C CNN "vendor"
F 7 "296-48543-1-ND" H 2110 3430 50  0001 C CNN "vendor_pn"
	1    2000 3100
	1    0    0    -1  
$EndComp
$Comp
L DBLS_Diode:TPD4E05U06 U?
U 1 1 5E81AFCB
P 2200 1750
F 0 "U?" H 2300 1900 50  0000 L CNN
F 1 "TPD4E05U06" H 2300 1500 50  0000 L CNN
F 2 "" H 1950 2100 50  0001 C CNN
F 3 "" H 2270 1940 50  0001 C CNN
F 4 "Texas Instruments" H 2110 2490 50  0001 C CNN "mfg"
F 5 "TPD4E05U06DQAR" H 2120 2390 50  0001 C CNN "mfg_pn"
F 6 "Digikey" H 2100 2310 50  0001 C CNN "vendor"
F 7 "296-35765-1-ND" H 2100 2220 50  0001 C CNN "vendor_pn"
	1    2200 1750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E821B97
P 2400 1850
F 0 "#PWR?" H 2400 1600 50  0001 C CNN
F 1 "GND" H 2500 1850 50  0000 C CNN
F 2 "" H 2400 1850 50  0001 C CNN
F 3 "" H 2400 1850 50  0001 C CNN
	1    2400 1850
	1    0    0    -1  
$EndComp
Wire Wire Line
	2250 1700 2300 1700
Wire Wire Line
	2300 1700 2300 1800
Wire Wire Line
	2300 1900 2250 1900
Connection ~ 2300 1800
Wire Wire Line
	2300 1800 2300 1900
$Comp
L DBLS_Diode:TPD4E05U06 U?
U 1 1 5E835CD7
P 2500 1250
F 0 "U?" H 2450 1500 50  0000 L CNN
F 1 "TPD4E05U06" H 2600 1000 50  0000 L CNN
F 2 "" H 2250 1600 50  0001 C CNN
F 3 "" H 2570 1440 50  0001 C CNN
F 4 "Texas Instruments" H 2410 1990 50  0001 C CNN "mfg"
F 5 "TPD4E05U06DQAR" H 2420 1890 50  0001 C CNN "mfg_pn"
F 6 "Digikey" H 2400 1810 50  0001 C CNN "vendor"
F 7 "296-35765-1-ND" H 2400 1720 50  0001 C CNN "vendor_pn"
	1    2500 1250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E838245
P 2650 1300
F 0 "#PWR?" H 2650 1050 50  0001 C CNN
F 1 "GND" H 2655 1127 50  0000 C CNN
F 2 "" H 2650 1300 50  0001 C CNN
F 3 "" H 2650 1300 50  0001 C CNN
	1    2650 1300
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2550 1200 2600 1200
Wire Wire Line
	2600 1200 2600 1300
Wire Wire Line
	2600 1400 2550 1400
Wire Wire Line
	2600 1300 2650 1300
Connection ~ 2600 1300
Wire Wire Line
	2600 1300 2600 1400
Wire Wire Line
	1950 1600 1700 1600
Wire Wire Line
	1700 1700 1950 1700
Wire Wire Line
	1950 1900 1700 1900
Wire Wire Line
	1700 2000 1950 2000
Wire Wire Line
	1700 1500 2250 1500
Wire Wire Line
	2250 1400 1700 1400
Wire Wire Line
	1700 1200 2250 1200
Wire Wire Line
	2250 1100 1700 1100
Text Label 1750 1400 0    50   ~ 0
D-
Text Label 1750 1500 0    50   ~ 0
D-
Text Label 1750 1600 0    50   ~ 0
D+
Text Label 1750 1700 0    50   ~ 0
D+
Wire Wire Line
	2350 2250 2450 2250
Wire Wire Line
	2450 2250 2450 2550
Wire Wire Line
	2450 3150 2350 3150
Wire Wire Line
	2350 2850 2450 2850
Connection ~ 2450 2850
Wire Wire Line
	2450 2850 2450 3150
Wire Wire Line
	2350 2550 2450 2550
Connection ~ 2450 2550
Wire Wire Line
	2450 2550 2450 2700
Connection ~ 2450 2700
Wire Wire Line
	2450 2700 2450 2850
Wire Wire Line
	1950 2500 1700 2500
Wire Wire Line
	1950 2600 1700 2600
Wire Wire Line
	1950 2800 1700 2800
Wire Wire Line
	1950 2900 1700 2900
Wire Wire Line
	1700 3100 1950 3100
Wire Wire Line
	1950 3200 1700 3200
Wire Wire Line
	1950 2300 1700 2300
Wire Wire Line
	1700 2200 1950 2200
Text Label 1750 1100 0    50   ~ 0
CC1
Text Label 1750 1200 0    50   ~ 0
CC2
Text Label 1750 1900 0    50   ~ 0
SBU1
Text Label 1750 2000 0    50   ~ 0
SBU2
Text Label 1750 2200 0    50   ~ 0
RX-
Text Label 1750 2300 0    50   ~ 0
RX+
Text Label 1750 2500 0    50   ~ 0
TX-
Text Label 1750 2600 0    50   ~ 0
TX+
Text Label 1750 2800 0    50   ~ 0
RX-
Text Label 1750 2900 0    50   ~ 0
RX+
Text Label 1750 3100 0    50   ~ 0
TX-
Text Label 1750 3200 0    50   ~ 0
TX+
$Comp
L DBLS_Resistor:SMD-RES-0-0603 R?
U 1 1 5E8833DA
P 950 3600
F 0 "R?" H 950 3550 45  0000 C CNN
F 1 "SMD-RES-0-0603" H 600 4300 50  0001 L BNN
F 2 "Resistors_SMD:R_0603" H 950 3800 50  0001 C CNN
F 3 "N/A" H 950 3800 50  0001 C CNN
F 4 "YES" H 850 3650 20  0001 C CNN "place"
F 5 "CRCW06030000Z0EAHP" H 950 4100 50  0001 C CNN "mfg_pn"
F 6 "Vishay Dale" H 950 4200 50  0001 C CNN "mfg"
F 7 "Digikey" H 950 4000 50  0001 C CNN "vendor"
F 8 "0" H 950 3650 40  0000 C CNN "resistance"
F 9 "541-0.0SBCT-ND" H 950 3900 50  0001 C CNN "vendor_pn"
	1    950  3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	1100 3500 1100 3600
Wire Wire Line
	1050 3600 1100 3600
Connection ~ 1100 3600
Wire Wire Line
	1100 3600 1100 3650
Wire Wire Line
	850  3600 800  3600
Wire Wire Line
	800  3500 800  3600
Text Label 4650 2700 0    50   ~ 0
D+
Text Label 4650 2800 0    50   ~ 0
D-
Wire Wire Line
	4650 2700 4850 2700
Wire Wire Line
	4650 2800 4850 2800
$Comp
L DBLS_Capacitor:SMD-CAP-100NF-0402 C?
U 1 1 5E8950FA
P 4600 3200
F 0 "C?" V 4550 3300 40  0000 C CNN
F 1 "SMD-CAP-100NF-0402" H 4400 3775 20  0001 L CNN
F 2 "DBLS_Capacitor:C_0402_1005Metric" H 4600 3525 20  0001 C CNN
F 3 "N/A" H 4600 3425 20  0001 C CNN
F 4 "311-1345-1-ND" H 4600 3575 20  0001 C CNN "vendor_pn"
F 5 "Digikey" H 4600 3625 20  0001 C CNN "vendor"
F 6 "CC0402KRX7R6BB104" H 4600 3675 20  0001 C CNN "mfg_pn"
F 7 "Yageo" H 4600 3725 20  0001 C CNN "mfg"
F 8 "YES" H 4525 3275 20  0001 C CNN "place"
F 9 "0.1uF" V 4650 3350 30  0000 C CNN "capacitance"
	1    4600 3200
	0    1    1    0   
$EndComp
$Comp
L DBLS_Capacitor:SMD-CAP-100NF-0402 C?
U 1 1 5E896812
P 4400 3300
F 0 "C?" V 4350 3400 40  0000 C CNN
F 1 "SMD-CAP-100NF-0402" H 4200 3875 20  0001 L CNN
F 2 "DBLS_Capacitor:C_0402_1005Metric" H 4400 3625 20  0001 C CNN
F 3 "N/A" H 4400 3525 20  0001 C CNN
F 4 "311-1345-1-ND" H 4400 3675 20  0001 C CNN "vendor_pn"
F 5 "Digikey" H 4400 3725 20  0001 C CNN "vendor"
F 6 "CC0402KRX7R6BB104" H 4400 3775 20  0001 C CNN "mfg_pn"
F 7 "Yageo" H 4400 3825 20  0001 C CNN "mfg"
F 8 "YES" H 4325 3375 20  0001 C CNN "place"
F 9 "0.1uF" V 4450 3450 30  0000 C CNN "capacitance"
	1    4400 3300
	0    1    1    0   
$EndComp
Wire Wire Line
	4500 3300 4850 3300
Wire Wire Line
	4850 3200 4700 3200
Wire Wire Line
	4850 2950 4650 2950
Wire Wire Line
	4850 3050 4650 3050
Text Label 4200 3200 0    50   ~ 0
TX+
Text Label 4200 3300 0    50   ~ 0
TX-
Text Label 4650 3050 0    50   ~ 0
RX-
Text Label 4650 2950 0    50   ~ 0
RX+
Wire Wire Line
	4350 3300 4200 3300
Wire Wire Line
	4550 3200 4200 3200
$Comp
L DBLS_LDO:LP5912 U?
U 1 1 5E8AD309
P 3650 900
F 0 "U?" H 3750 1000 50  0000 C CNN
F 1 "LP5912" H 3650 600 50  0000 C CNN
F 2 "DBLS_SON:WSON-6-1EP_2x2mm_P0.65mm_EP1x1.6mm_ThermalVias" H 3650 1100 50  0001 C CNN
F 3 "" H 3650 1100 50  0001 C CNN
F 4 "Texas Instruments" H 3650 1500 50  0001 C CNN "mfg"
F 5 "LP5912-3.3DRVT" H 3650 1400 50  0001 C CNN "mfg_pn"
F 6 "Digikey" H 3650 1300 50  0001 C CNN "vendor"
F 7 "296-44153-1-ND" H 3650 1200 50  0001 C CNN "vendor_pn"
F 8 "YES" H 3850 650 25  0001 C CNN "place"
	1    3650 900 
	1    0    0    -1  
$EndComp
$Comp
L DBLS_Resistor:SMD-RES-0-0603 R?
U 1 1 5E8B08DB
P 3000 1000
F 0 "R?" H 3000 1050 45  0000 L CNN
F 1 "SMD-RES-0-0603" H 2650 1700 50  0001 L BNN
F 2 "DBLS_Resistor:R_0603_1608Metric_Pad1.05x0.95mm_HandSolder" H 3000 1200 50  0001 C CNN
F 3 "N/A" H 3000 1200 50  0001 C CNN
F 4 "0" H 3050 950 40  0000 L CNN "resistance"
F 5 "Vishay Dale" H 3000 1600 50  0001 C CNN "mfg"
F 6 "CRCW06030000Z0EAHP" H 3000 1500 50  0001 C CNN "mfg_pn"
F 7 "Digikey" H 3000 1400 50  0001 C CNN "vendor"
F 8 "541-0.0SBCT-ND" H 3000 1300 50  0001 C CNN "vendor_pn"
F 9 "YES" H 2900 1050 20  0001 C CNN "place"
	1    3000 1000
	1    0    0    -1  
$EndComp
Wire Wire Line
	2900 1000 2900 900 
$Comp
L power:GND #PWR?
U 1 1 5E8C994C
P 3350 1150
F 0 "#PWR?" H 3350 900 50  0001 C CNN
F 1 "GND" H 3350 1000 50  0000 C CNN
F 2 "" H 3350 1150 50  0001 C CNN
F 3 "" H 3350 1150 50  0001 C CNN
	1    3350 1150
	1    0    0    -1  
$EndComp
Wire Wire Line
	3350 1150 3350 1100
Wire Wire Line
	3350 1100 3450 1100
$Comp
L power:GND #PWR?
U 1 1 5E8CB9BD
P 3950 1150
F 0 "#PWR?" H 3950 900 50  0001 C CNN
F 1 "GND" H 3950 1000 50  0000 C CNN
F 2 "" H 3950 1150 50  0001 C CNN
F 3 "" H 3950 1150 50  0001 C CNN
	1    3950 1150
	1    0    0    -1  
$EndComp
Wire Wire Line
	3950 1150 3950 1100
Wire Wire Line
	3950 1100 3850 1100
Text Label 3150 1000 0    50   ~ 0
LDO_EN
$Comp
L DBLS_Capacitor:SMD-CAP-1UF-0402 C?
U 1 1 5E8E4AC3
P 2800 1050
F 0 "C?" H 2700 1150 40  0000 L CNN
F 1 "SMD-CAP-1UF-0402" H 2350 1900 50  0001 L CNN
F 2 "DBLS_Capacitor:C_0402_1005Metric" H 2800 1400 50  0001 C CNN
F 3 "" H 2800 1275 20  0001 C CNN
F 4 "1uF" H 2700 1000 30  0000 L CNN "capacitance"
F 5 "Murata Electronics" H 2800 1800 50  0001 C CNN "mfg"
F 6 "GRM155R61E105KA12D" H 2800 1700 50  0001 C CNN "mfg_pn"
F 7 "Digikey" H 2800 1600 50  0001 C CNN "vendor"
F 8 "490-10017-1-ND" H 2800 1500 50  0001 C CNN "vendor_pn"
F 9 "YES" H 2725 1125 20  0001 C CNN "place"
	1    2800 1050
	1    0    0    -1  
$EndComp
Wire Wire Line
	2800 950  2800 900 
$Comp
L DBLS_Resistor:SMD-RES-10K-0603 R?
U 1 1 5E81B547
P 4300 1000
F 0 "R?" H 4300 1050 45  0000 C CNN
F 1 "SMD-RES-10K-0603" H 3950 1700 50  0001 L BNN
F 2 "DBLS_Resistor:R_0603_1608Metric_Pad1.05x0.95mm_HandSolder" H 4300 1200 50  0001 C CNN
F 3 "N/A" H 4300 1200 50  0001 C CNN
F 4 "10K" H 4200 950 40  0000 C CNN "resistance"
F 5 "Vishay Dale" H 4300 1600 50  0001 C CNN "mfg"
F 6 "CRCW060310K0JNEAHP" H 4300 1500 50  0001 C CNN "mfg_pn"
F 7 "Digikey" H 4300 1400 50  0001 C CNN "vendor"
F 8 "541-10KSACT-ND" H 4300 1300 50  0001 C CNN "vendor_pn"
F 9 "YES" H 4200 1050 20  0001 C CNN "place"
	1    4300 1000
	1    0    0    -1  
$EndComp
Text Label 3900 1000 0    50   ~ 0
LDO_PG
$Comp
L DBLS_USB:USB_C_Receptacle J?
U 1 1 5E81A9BD
P 1100 1900
F 0 "J?" H 1500 3050 50  0000 C CNN
F 1 "USB_C_Receptacle" H 1050 3050 50  0000 C CNN
F 2 "" H 1250 1900 50  0001 C CNN
F 3 "https://www.usb.org/sites/default/files/documents/usb_type-c.zip" H 1250 1900 50  0001 C CNN
	1    1100 1900
	1    0    0    -1  
$EndComp
Wire Wire Line
	3450 900  2900 900 
Connection ~ 2800 900 
Wire Wire Line
	2800 900  1700 900 
Connection ~ 2900 900 
Wire Wire Line
	2900 900  2800 900 
Wire Wire Line
	3100 1000 3450 1000
Wire Wire Line
	2800 1100 3350 1100
Connection ~ 3350 1100
Wire Wire Line
	3850 900  4450 900 
Wire Wire Line
	3850 1000 4200 1000
Wire Wire Line
	4400 1000 4450 1000
Wire Wire Line
	4450 1000 4450 900 
Connection ~ 4450 900 
Wire Wire Line
	4450 900  4550 900 
$Comp
L DBLS_Capacitor:SMD-CAP-1UF-0402 C?
U 1 1 5E836D9E
P 4550 1050
F 0 "C?" H 4550 1150 40  0000 L CNN
F 1 "SMD-CAP-1UF-0402" H 4100 1900 50  0001 L CNN
F 2 "DBLS_Capacitor:C_0402_1005Metric" H 4550 1400 50  0001 C CNN
F 3 "" H 4550 1275 20  0001 C CNN
F 4 "1uF" H 4600 1000 30  0000 L CNN "capacitance"
F 5 "Murata Electronics" H 4550 1800 50  0001 C CNN "mfg"
F 6 "GRM155R61E105KA12D" H 4550 1700 50  0001 C CNN "mfg_pn"
F 7 "Digikey" H 4550 1600 50  0001 C CNN "vendor"
F 8 "490-10017-1-ND" H 4550 1500 50  0001 C CNN "vendor_pn"
F 9 "YES" H 4475 1125 20  0001 C CNN "place"
	1    4550 1050
	1    0    0    -1  
$EndComp
Wire Wire Line
	4550 1100 3950 1100
Connection ~ 3950 1100
Wire Wire Line
	4550 950  4550 900 
Connection ~ 4550 900 
Wire Wire Line
	4550 900  4750 900 
Wire Wire Line
	4850 1050 4750 1050
Wire Wire Line
	4750 1050 4750 900 
Connection ~ 4750 900 
Wire Wire Line
	4750 900  4850 900 
Wire Wire Line
	4850 1150 4750 1150
Wire Wire Line
	4750 1150 4750 1050
Connection ~ 4750 1050
Wire Wire Line
	4850 1250 4750 1250
Wire Wire Line
	4750 1250 4750 1150
Connection ~ 4750 1150
Wire Wire Line
	4850 1400 4750 1400
Wire Wire Line
	4750 1400 4750 1250
Connection ~ 4750 1250
Wire Wire Line
	4850 1500 4750 1500
Wire Wire Line
	4750 1500 4750 1400
Connection ~ 4750 1400
Wire Wire Line
	4850 1600 4750 1600
Wire Wire Line
	4750 1600 4750 1500
Connection ~ 4750 1500
Wire Wire Line
	2550 2700 2550 2750
Wire Wire Line
	2450 2700 2550 2700
Wire Wire Line
	2400 1800 2400 1850
Wire Wire Line
	2300 1800 2400 1800
Wire Wire Line
	4850 1750 4750 1750
Wire Wire Line
	4750 1750 4750 1850
Wire Wire Line
	4750 2300 4850 2300
Wire Wire Line
	4850 2150 4750 2150
Connection ~ 4750 2150
Wire Wire Line
	4750 2150 4750 2300
Wire Wire Line
	4850 2050 4750 2050
Connection ~ 4750 2050
Wire Wire Line
	4750 2050 4750 2150
Wire Wire Line
	4850 1950 4750 1950
Connection ~ 4750 1950
Wire Wire Line
	4750 1950 4750 2050
Wire Wire Line
	4850 1850 4750 1850
Connection ~ 4750 1850
Wire Wire Line
	4750 1850 4750 1950
$Comp
L power:GND #PWR?
U 1 1 5E861A7F
P 4400 2550
F 0 "#PWR?" H 4400 2300 50  0001 C CNN
F 1 "GND" H 4400 2400 50  0000 C CNN
F 2 "" H 4400 2550 50  0001 C CNN
F 3 "" H 4400 2550 50  0001 C CNN
	1    4400 2550
	1    0    0    -1  
$EndComp
Wire Notes Line
	1850 700  1850 1000
Wire Notes Line
	1850 1000 2400 1000
Wire Notes Line
	2400 1000 2400 700 
Wire Notes Line
	2400 700  1850 700 
Text Notes 1900 900  0    50   ~ 0
Ferrite may\nbe needed
Text Label 2450 900  0    50   ~ 0
VBUS
Wire Wire Line
	4650 2550 4850 2550
Text Label 4650 2550 0    50   ~ 0
VBUS
$Comp
L DBLS_Capacitor:SMD-CAP-4.7UF-0402 C?
U 1 1 5E87A038
P 4400 2450
F 0 "C?" H 4481 2505 40  0000 L CNN
F 1 "SMD-CAP-4.7UF-0402" H 3950 3300 50  0001 L CNN
F 2 "DBLS_Capacitor:C_0402_1005Metric" H 4400 2800 50  0001 C CNN
F 3 "" H 4400 2675 20  0001 C CNN
F 4 "4.7uF" H 4481 2437 30  0000 L CNN "capacitance"
F 5 "Murata Electronics" H 4400 3200 50  0001 C CNN "mfg"
F 6 "GRM155R61A475MEAAD" H 4400 3100 50  0001 C CNN "mfg_pn"
F 7 "Digikey" H 4400 3000 50  0001 C CNN "vendor"
F 8 "490-14306-1-ND" H 4400 2900 50  0001 C CNN "vendor_pn"
F 9 "YES" H 4325 2525 20  0001 C CNN "place"
	1    4400 2450
	1    0    0    -1  
$EndComp
Wire Wire Line
	4400 2500 4400 2550
Wire Wire Line
	4400 2350 4400 2300
Wire Wire Line
	4400 2300 4750 2300
Connection ~ 4750 2300
Wire Wire Line
	5950 900  6000 900 
Wire Wire Line
	5950 1000 6000 1000
Wire Wire Line
	5950 1100 6000 1100
Wire Wire Line
	5950 1200 6000 1200
Wire Wire Line
	5950 1300 6000 1300
Wire Wire Line
	5950 1400 6000 1400
Wire Wire Line
	5950 1500 6000 1500
Wire Wire Line
	5950 1600 6000 1600
Wire Wire Line
	5950 1700 6000 1700
Wire Wire Line
	5950 1800 6000 1800
Wire Wire Line
	5950 1900 6000 1900
Wire Wire Line
	5950 2000 6000 2000
Wire Wire Line
	5950 2100 6000 2100
Wire Wire Line
	5950 2200 6000 2200
Wire Wire Line
	5950 2300 6000 2300
Wire Wire Line
	5950 2400 6000 2400
Entry Wire Line
	6000 900  6100 1000
Entry Wire Line
	6000 1000 6100 1100
Entry Wire Line
	6000 1100 6100 1200
Entry Wire Line
	6000 1200 6100 1300
Entry Wire Line
	6000 1300 6100 1400
Entry Wire Line
	6000 1400 6100 1500
Entry Wire Line
	6000 1500 6100 1600
Entry Wire Line
	6000 1600 6100 1700
Entry Wire Line
	6000 1700 6100 1800
Entry Wire Line
	6100 1900 6000 1800
Entry Wire Line
	6000 1900 6100 2000
Entry Wire Line
	6000 2000 6100 2100
Entry Wire Line
	6000 2100 6100 2200
Entry Wire Line
	6000 2200 6100 2300
Entry Wire Line
	6000 2300 6100 2400
Entry Wire Line
	6000 2400 6100 2500
Entry Bus Bus
	6100 1650 6200 1750
Text Label 6250 1750 0    50   ~ 0
FIFO_DATA_BUS
Wire Bus Line
	6200 1750 6850 1750
Wire Bus Line
	6100 1000 6100 2500
$EndSCHEMATC
