;ASTER 01/03/2009 1545
;TO BE ASSEMBLED USING KEIL MICROVISION V3.60
;ARTIFICIAL INTELLIGENCE
;MICROCOMPUTER A

;16-BIT HEXADECIMAL TO ASCII CONVERTER 

;-----------------------------------------------------------------------------------------------------------
;SET THE ASSEMBLER FOR AT89S52
$NOMOD51
$INCLUDE (AT89X52.h)

;DEFINITIONS

;SBIT WR=P3^6  							;ALREADY DEFINED IN THE HEADER, SO MAKE FREE USE OF IT
;SBIT RD=P3^7
SBIT INTR=P3^2
SBIT RS=P0^7
SBIT RW=P0^6
SBIT EN=P0^5
SBIT SWA=P0^4
SBIT SWB=P0^3
SBIT SWC=P0^2
SBIT SWD=P0^1
;-----------------------------------------------------------------------------------------------------------

ORG 0000H

RESET:		SJMP 0030H 

ORG 0030H

START:		NOP
			MOV SP,#10H					;RELOCATE STACK OVER 10H

;--------------------------------------------------------------------------------------------------
;**************************************************************************************************
;PROGRAM MAIN
;MAIN BEGINS HERE
MAIN:		MOV A,#0FFH
			MOV B,#0FFH
			LCALL XTOD16
HERE:		SJMP HERE


;PROGRAM MAIN ENDS HERE
;******************************************************************************************

;------------------------------------------------------------------------------------------
;16 BIT HEX TO ASCII CONVERTER 
;INPUT- [B-A]   OUTPUT- [65H,66H,67H,68H,69H]
XTOD16:		MOV 65H,#30H
			MOV 66H,#30H
			MOV 67H,#30H
			MOV 68H,#30H
			MOV 69H,#30H
			CLR C
			MOV 6CH,A
			MOV 6DH,B
R10K:		MOV A,6CH
			SUBB A,#10H
			MOV 6CH,A
			MOV A,6DH
			SUBB A,#27H
			MOV 6DH,A
			INC 69H
			JNC R10K
			DEC 69H
			CLR C
			MOV A,6CH
			ADD A,#10H
			MOV 6CH,A
			MOV A,6DH
			ADDC A,#27H
			MOV 6DH,A
			CLR C
R1K:		MOV A,6CH
			SUBB A,#0E8H
			MOV 6CH,A
			MOV A,6DH
			SUBB A,#03H
			MOV 6DH,A
			INC 68H
			JNC R1K
			DEC 68H
			CLR C
			MOV A,6CH
			ADD A,#0E8H
			MOV 6CH,A
			MOV A,6DH
			ADDC A,#03H
			MOV 6DH,A
			CLR C
HUND:		MOV A,6CH
			SUBB A,#64H
			MOV 6CH,A
			MOV A,6DH
			SUBB A,#00H
			MOV 6DH,A
			INC 67H
			JNC HUND
			DEC 67H
			CLR C
			MOV A,6CH
			ADD A,#64H
			MOV 6CH,A
			CLR C
TENS:		MOV A,6CH
			MOV B,#10
			DIV AB
			ORL 66H,A
			MOV A,B
ONES:		ORL 65H,A
			RET

;------------------------------------------------------------------------------------------

END
