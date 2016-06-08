;ASTER 01/03/2009 1545
;TO BE ASSEMBLED IN KEIL MICROVISION V3.60
;ARTIFICIAL INTELLIGENCE
;MICROCOMPUTER A

;CODE BASE COMPLETED : 02/03/2009 2120

;REV 3 LAST UPDATED 08/03/2009 2230

;-----------------------------------------------------------------------------------------------------------
;SET THE ASSEMBLER FOR AT89S52
$NOMOD51
$INCLUDE (AT89X52.h)

;DEFINITIONS

;SBIT WR=P3^6  						;ALREADY DEFINED IN THE HEADER, SO MAKE FREE USE OF IT
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
								 
INIT:		MOV A,#38H					;INITIALIZATION OF HD44780
			LCALL COMMAND
			MOV A,#0CH
			LCALL COMMAND
			MOV A,#38H					;REINITIALIZATION OF HD44780 FOR CAPACITIVE CORRECTION
			LCALL COMMAND
			MOV A,#0CH
			LCALL COMMAND
			MOV A,#06H
			LCALL COMMAND
			MOV A,#01H	
			LCALL COMMAND

			
			CLR A					 	;PORTS'  INIT
			MOV A,#0FFH
			MOV P3,A
			SETB P0.0
			SETB P0.1
			SETB P0.2
			SETB P0.3
			SETB P0.4
			MOV P1,A

			MOV R0,#20H				 	;CLEAR RAM FROM 20H TO FFH
			CLR A
CLE:		MOV @R0,A
			INC R0
			CJNE R0,#0FFH,CLE

			
					
			MOV TCON,#01H
			MOV TMOD,#01H
			MOV IE,#93H				  	;INTERRUPTS ENABLE : INT0, SERIAL, TIMER0
			MOV IP,#10H
			
			
			MOV DPTR,#MSG2
			MOV R4,#96			  		;LOAD DISPLAY RAM WITH FORMAT
			MOV R0,#80H
DISPD:		CLR A
			MOVC A,@A+DPTR
			MOV @R0,A
			INC R0
			INC DPTR
			DJNZ R4,DISPD
EXITDD:   	NOP


			
			MOV TH0,#00H 				;LOAD COUNT 65536*42/1 = 3SECONDS
			MOV TL0,#00H
			MOV R4,#42					;R4 USED EXCLUSIVELY BY TIMER0 ISR
			MOV 31H,#80H				;31H HOLDS CURRENT POINTER

			
			
			MOV R0,31H
			LCALL LCDWRITE
			SETB TR0					;START TIMER0
			SETB P3.4

;--------------------------------------------------------------------------------------------------
;**************************************************************************************************
;PROGRAM MAIN
;MAIN BEGINS HERE

MAIN:		NOP


MAIN_END:	LJMP MAIN					;LOOP THE MAIN

;PROGRAM MAIN ENDS HERE
;******************************************************************************************
;------------------------------------------------------------------------------------------
;LCD ROUTINES

COMMAND:	LCALL READY
			CLR RW
			CLR RS
			MOV P2,A
			SETB EN
			NOP 
			CLR EN
			RET

DISPLAY:	LCALL READY
			CLR RW
			SETB RS
			MOV P2,A
			SETB EN
			NOP
			CLR EN
			RET

READY:		SETB P2.7
			CLR RS
			SETB RW
BUSY:		CLR EN
			SETB EN
			JB P2.7,BUSY
			NOP
			CLR EN
			RET



LCDWRITE:	MOV A,#02H
			LCALL COMMAND
			MOV R2,#10H					;UPDATE LCD UPPER LINE
DISPU:		MOV A,@R0
			LCALL DISPLAY
			INC R0
			DJNZ R2,DISPU
LCDWRITEL:	MOV A,#0C0H				  	;UPDATE LCD LOWER LINE
			LCALL COMMAND
			MOV R2,#10H
DISPL:		MOV A,@R0
			LCALL DISPLAY
			INC R0
			DJNZ R2,DISPL
			RET


;TIMER 0 INTERRUPT
;TIMER 0 USED TO GENERATE 3SECONDS SCREEN DISPLAY DELAY
ORG 000BH
			LJMP 1400H
ORG 1400H
TIME3:		CLR TR0
			CLR TF0
			MOV TH0,#00H
			MOV TL0,#00H
			DJNZ R4,MORE
			MOV R4,#42
			MOV A,31H
			ADD A,#32
			CJNE A,#0E0H,RESC
			MOV A,#80H
RESC:		MOV R0,A
			MOV 31H,A
			LCALL LCDWRITE
MORE:		SETB TR0
			RETI
					 
;-------------------------------------------------------------------------------------------
;OTHER SUBROUTINES

;DELAY INIT
DELAYS:		MOV R7,#06H
			MOV R6,#0FFH
			MOV R5,#0FFH
			DJNZ R5,$
			DJNZ R6,$-2
			DJNZ R7,$-4
			RET


;-------------------------------------------------------------------------------------------
;DISPLAY DATA

ORG 1F00H

MSG1:	DB 'INITIALIZING',00H
MSG2:	DB 'BATTERY A 00.00VBATTERY B 00.00V5AR  5BR  7AR   0.00 0.00 0.00V A-RES 0  B-OVR 0C-UDF 0  D-UDF 0',00H
;------------------------------------------------------------------------------------------- 
;-------------------------------------------------------------------------------------------
END
