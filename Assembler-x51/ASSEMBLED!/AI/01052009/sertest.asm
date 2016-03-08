;ASTER 02/03/2009 2135
;TO BE ASSEMBLED IN KEIL MICROVISION V3.60
;ARTIFICIAL INTELLIGENCE
;MICROCOMPUTER B

;CODE BASE COMPLETED : 03/03/2009 2251

;REV 2 LAST UPDATED 19/04/2009 1610

;-----------------------------------------------------------------------------------------------------------
;SET THE ASSEMBLER FOR AT89S52
$NOMOD51
$INCLUDE (AT89X52.h)

;-----------------------------------------------------------------------------------------------------------
;MICROCOMPUTER INITIALIZATIONS
ORG 0000H

RESET:		SJMP 0030H 

ORG 0030H

START:		NOP
			MOV SP,#10H					;RELOCATE STACK OVER 10H
			 
			CLR A
			MOV P0,A
			MOV P1,A
			MOV P2,A
			MOV P3,#0FFH

;			LCALL DELAYIN

			MOV R0,#20H					;CLEAR RAM FROM 20H TO 7FH
			CLR A
CLRALL:		MOV @R0,A
			INC R0
			CJNE R0,#7FH,CLRALL

			
			MOV T2CON,#30H				;SET UP THE UART 9600BPS
			MOV RCAP2H,#0FFH
			MOV RCAP2L,#0DCH
			
			ANL PCON,#7FH
			
			SETB PSW.3 					;R0 OF BANK1 POINTS TO COMMAND SPACE(60-67H)
			MOV R0,#60H
			CLR PSW.3

			MOV IE,#90H					;ENABLE INTERRUPTS: SERIAL
			MOV IP,#10H
			
			MOV SCON,#58H
			SETB TR2					;START BAUD GEN TIMER
			MOV R0,#60H
			LCALL DELAYFOR
			MOV SBUF,#35H

;----------------------------------------------------------------------------------------------------------
;**********************************************************************************************************
;THE PROGRAM MAIN
;PASS DIRECTION IN R2,BANK0 : 00H->FORWARD, 01H->BACKWARD, 02H->ROLL AND STOP, 03H->HARD STOP
;CALL THE CORRESPONDING MOTOR FUNCTION AFTER LOADING R2 WITH THE FUNCTION CODES LISTED ABOVE

MAIN:		NOP
			NOP

			NOP
			NOP
			NOP
				
MAIN_END:	LJMP MAIN





;MAIN ENDS HERE
;**********************************************************************************************************
;----------------------------------------------------------------------------------------------------------
;INTERRUPT SERVICE ROUTINES
ORG 0023H
			LJMP 1400H
ORG 1400H

SERCON:		CLR TR2
			PUSH ACC
			JNB RI,TXI
			CLR RI
			MOV A,SBUF
			JB PSW.5,SKIPC
			CJNE A,#31H,EXITC			;PSW.5 SET IMPLIES CONNECTION ESTABLISHED
			MOV SBUF,#39H				;ACK
			SETB PSW.5
			SJMP EXITC
SKIPC:		CJNE A,#32H,SKIPC2		   	;SEND DISCONNECT AND DROP CONNECTION IF DISCONNECT IS RECEIVED
			MOV SBUF,#32H				;D-ACK
			CLR PSW.5
			SJMP EXITC
SKIPC2:		SETB PSW.3				  	;LOAD THE RECEIVED COMMAND IN THE COMMAND SPACE(60-67H)
			MOV @R0,A
			INC R0
			CJNE R0,#68H,INRANGE
			MOV R0,#60H
INRANGE:	MOV SBUF,#39H
			CLR PSW.3
			SJMP EXITC
TXI:		CLR TI
EXITC:		POP ACC
			SETB TR2
			NOP
			RETI

;----------------------------------------------------------------------------------------------------------
DELAYFOR:	MOV R7,#0FH
			MOV R6,#0FFH
			MOV R5,#0FFH
			DJNZ R5,$
			DJNZ R6,$-2
			DJNZ R7,$-4
			RET
END