; Simple test for the NeoPixel peripheral

ORG 0
	; Set all the pixels dim white
	LOAD   DimWhite
	OUT    PXL_ALL
	; Wait for the set-all to complete
	CALL   WaitSetAll
	; Set pixel address to 0
	LOADI  0
	OUT    PXL_A
	; Set red component of that pixel to 0
	OUT    PXL_R
	; Do similar for G and B on pixels 1 and 2
	LOADI  1      ; pixel 1
	OUT    PXL_A
	LOADI  0
	OUT    PXL_G
	LOADI  2      ; pixel 2
	OUT    PXL_A
	LOADI  0
	OUT    PXL_B
	
	; Take advantage of address auto-increment to
	; set slightly increasing blue colors over pixels 3-5
	LOADI  3
	OUT    PXL_A
	LOADI  1        ; Color will be dim blue
	OUT    PXL_RGB
	ADDI   3        ; Slightly more blue
	OUT    PXL_RGB
	ADDI   3        ; Slightly more blue
	OUT    PXL_RGB

MainLoop:
	OUT    Timer
LoopDelay:
	IN     Timer
	ADDI   -1
	JNEG   LoopDelay

	; A very simple color manipulation:
	; add 1 to each color's RGB, overflowing at
	; different amounts.
	LOADI  7
	OUT    PXL_A

ChangeRed:
	IN     PXL_R
	ADDI   1
	ADDI   -13       ; Check if >= 13
	JZERO  SetRed
	ADDI   13        ; Undo subtraction
SetRed:
	OUT    PXL_R

ChangeGreen:
	IN     PXL_G
	ADDI   1
	ADDI   -17       ; Check if >= 17
	JZERO  SetGreen
	ADDI   17        ; Undo subtraction
SetGreen:
	OUT    PXL_G

ChangeBlue:
	IN     PXL_B
	ADDI   1
	ADDI   -23       ; Check if >= 23
	JZERO  SetBlue
	ADDI   23        ; Undo subtraction
SetBlue:
	OUT    PXL_B

	JUMP   MainLoop
	
	
WaitSetAll:
	IN     PXL_ALL
	; Peripheral responds with 1 when busy
	JPOS   WaitSetAll
	RETURN

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
