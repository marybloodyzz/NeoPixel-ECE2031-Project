; Simple test for the NeoPixel peripheral

ORG 0
 ; Set all the pixels dim white
Start:	
 Loadi 	0
 IN     Switches
 OUT    Coord_Converter
 ; Wait for the set-all to complete
 IN     Coord_Converter
 OUT    Hex0
 IN		Coord_Converter
 OUT    PXL_A
 Loadi	500
 ; Set red component of that pixel to 0
 OUT    PXL_RGB
 
  Jump	Start


DimWhite:  DW  &B0000100001000001

; IO address constants
Switches:  EQU 000
LEDs:      EQU 001
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
PXL_A:     EQU &H0B0
PXL_RGB:   EQU &H0B1
PXL_ALL:   EQU &H0B2
PXL_R:     EQU &H0B3
PXL_G:     EQU &H0B4
PXL_B:     EQU &H0B5
Coord_Converter:     EQU &H0B6