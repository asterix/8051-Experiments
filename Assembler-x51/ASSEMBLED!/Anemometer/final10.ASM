;COUNT AND DISPLAY + ANALOG METER + SERIAL TRANSMISSION AT 9600 BPS
;ANEMOMETER COUNT PROCESSOR 
;29/02/2008	:::::::::::::::::::::::::::::: LAST UPDATED: 28/07/2008 ::
;ASTER

;CONNECTIONS::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::    			;  	LCD DATA:  PORT 2

												;	LCD CONTROL: RS-P1.1 , R/W-P1.2 , EN-P1.3

												;	SERIAL:	RXD-P3.0 , TXD-P3.1

												;	TIMER0:	PULSE COUNTER - P3.4 RISING EDGES ONLY

												;	TIMER1:	1 SECOND TIMER

												;	TIMER2: BAUD GENERATOR -9600 BPS	
												






$NOMOD51
$INCLUDE (89C52.MCU)




ORG 0000H
SJMP 0030H
ORG 0030H
;---------------------------------------------------------------------------------------------------------------
;MICROCOMPUTER INITIALIZATIONS

INI_DIS:	CLR A		;INITIALIZATION FOR THE PORTS
		MOV P1,A
		MOV P2,A

		MOV A,#38H	;INITIALIZATION FOR LCD/LCM
		LCALL COMMAND
		MOV A,#0CH
		LCALL COMMAND
		MOV A,#06H
		LCALL COMMAND
		MOV A,#01H	
		LCALL COMMAND

		MOV DPTR,#MSG3
NXINI:		CLR A
		MOVC A,@A+DPTR
		CJNE A,#0FFH,PRCD
		SJMP OUTR
PRCD:		LCALL DISPLAY
		INC DPTR
		SJMP NXINI

OUTR:		NOP
;		MOV A,#0C0H		;SET DDRAM ADDRESS TO 40H = LINE 2 OF LCD
;		LCALL COMMAND		;STAND BY ROUTINE
;
;		MOV DPTR,#MSG5
;NXINI0:	CLR A
;		MOVC A,@A+DPTR
;		CJNE A,#0FFH,PRCD0
;		SJMP START
;PRCD0:		LCALL DISPLAY
;		INC DPTR
;		SJMP NXINI0		


START: 		MOV TMOD,#15H		; INITIALIZATION FOR TIMERS AND BAUD GENERATORS	
		
		MOV IE,#98H	
		MOV IP,#08H	
		
		MOV TH1,#3CH	
		MOV TL1,#0B0H	
		SETB TR1	
		SETB TR0	

		CLR A		;INITIALIZATION
		MOV P1,A
		MOV P2,A	
		MOV R0,#00H
		MOV R2,#00H	
		MOV R4,#00H	
		MOV 32H,#30H	;ASCII ZEROS
		MOV 31H,#30H
		MOV 30H,#30H
		SETB P3.4	;CONFIGURE AS INPUT PIN


		MOV 3BH,#07H
		MOV 3CH,#02H
		MOV 3DH,#01H
		MOV 3EH,#01H
		MOV 3FH,#01H

	
		MOV SCON,#40H		;SERIAL INITIALIZATION 
		ANL PCON,#7FH
		MOV T2CON,#30H
		MOV RCAP2H,#0FFH	;9600 BPS
		MOV RCAP2L,#0D9H
		
		

DELAY_INI:	MOV R7,#32H	; 4 SECONDS APPROX.
		MOV R6,#0FFH
		MOV R5,#0FFH
		DJNZ R5,$
		DJNZ R6,$-2
		DJNZ R7,$-3


		;SETB TR2
		MOV 55H,#32H
		MOV 56H,#00H		;INITIALIZE TRACE BYTE
		;LCALL XMIT		;START SERIAL COMM.


;INITIALIZATIONS END HERE
;-----------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------
;THE PROGRAM MAIN BEGINS
;MAIN


MAIN_T:		MOV 33H,R2	
		MOV R0,33H	

LCD_BGN:	MOV A,#38H
		LCALL COMMAND
		MOV A,#0CH
		LCALL COMMAND
		MOV A,#06H
		LCALL COMMAND
		MOV A,#01H	
		LCALL COMMAND


		
BCD_ASC:	MOV A,R0	; BINARY TO BCD TO ASCII
		MOV B,#64H	
		DIV AB		
		ADD A,#30H	
		MOV 32H,A	
		MOV A,B		
		MOV B,#0AH	
		DIV AB		
		ADD A,#30H
		MOV 31H,A	
		MOV A,B		
		ADD A,#30H		
		MOV 30H,A	; COUNT PLACED IN 32H:31H:30H AS ASCII VALUES OF THE THREE DIGITS

;---------------------------------------------------------------------------------------------------------
;RESTART SERIAL TRANSMISSION FOR THE PRESENT PASS		
;STILL IN MAIN 

RESTR_SER:	SETB TR2
		LCALL XMIT		;RESTART SERIAL COMM.



;---------------------------------------------------------------------------------------------------------
;ANALOG LEVEL METER 
;LEVEL STORER
;RAM 3AH:39H:38H:37H::8'S:4'S:2'S:1'S
;INTEGRATED-14/03/2008
;STILL IN MAIN

LEVL8:		MOV A,33H
		MOV B,#08H
		DIV AB
		MOV 3AH,A
		MOV A,B
		MOV B,#04H
		DIV AB
		MOV 39H,A
		MOV A,B
		MOV B,#02H
		DIV AB
		MOV 38H,A
		MOV 37H,B

FINISHED:	NOP

;---------------------------------------------------------------------------------------------------------
;LCD DISPLAY ROUTINES
;STILL IN MAIN
 
LCD_RTN0:	MOV DPTR,#MSG1
RPT0:		CLR A
		MOVC A,@A+DPTR
		CJNE A,#0FFH,NEXT0
		SJMP OVER0
NEXT0:		LCALL DISPLAY
		INC DPTR
		SJMP RPT0
OVER0:		NOP


LCD_RTN1:	MOV A,32H	
		LCALL DISPLAY
		MOV A,31H
		LCALL DISPLAY
		MOV A,30H
		LCALL DISPLAY	
OVER1:		NOP


LCD_RTN2:	MOV DPTR,#MSG2
RPT2:		CLR A
		MOVC A,@A+DPTR
		CJNE A,#0FFH,NEXT2
		SJMP OVER2
NEXT2:		LCALL DISPLAY
		INC DPTR
		SJMP RPT2
OVER2:		NOP

;------------------------------------------------------------------------------------------------------------
;ANALOG LEVEL METER
;INTEGRATED-14/03/2008
;STILL IN MAIN

AL_MTR:	MOV A,#40H
	MOV R7,A
	LCALL COMMAND
	
	LCALL CG_CLR

	MOV A,#40H
	MOV R7,A
	LCALL COMMAND
	
	LCALL CG_LOAD
	
	MOV A,#0C0H		;SET DDRAM ADDRESS TO 40H = LINE 2 OF LCD
	LCALL COMMAND
	
	MOV A,#00H
BACK:	LCALL DISPLAY
	INC A
	CJNE A,#08H,BACK
	
	MOV A,#02H
	LCALL COMMAND
	
;------------------------------------------------------------------------------------------------------------
;STILL IN MAIN
		;INC R2         TEST INSTRUCTION
DELAY_VISUAL:	MOV R7,#0CH	; 0.9 SECONDS APPROX.
		MOV R6,#0FFH
		MOV R5,#0FFH
		DJNZ R5,$
		DJNZ R6,$-2
		DJNZ R7,$-4		

STAY_END:	LJMP MAIN_T






;////////////////////////////////////////////////////////////////////////////////////////////////////////////
;MAIN ENDS HERE : : : : : : : : : : : : : : : : : : :: : : : : : : : : : : : : : : : :: : : : : : : : : : : :
;////////////////////////////////////////////////////////////////////////////////////////////////////////////


;------------------------------------------------------------------------------------------------------------
;FUNCTION 1
;CLEAR CGRAM DATA

CG_CLR:	MOV R6,#40H
RPTC:	MOV A,#00H
	LCALL DISPLAY
	DJNZ R6,RPTC
	RET

;------------------------------------------------------------------------------------------------------------
;FUNCTION 2
;LOAD THE CHARACTER PATTERNS IN CGRAM

CG_LOAD:MOV R3,#00H

DIS_8:	MOV R5,3AH
	CJNE R5,#00H,NXT80
	SJMP OVR0
NXT80:	MOV R6,3CH
NXT801:	MOV R1,3BH
NXT8:	MOV A,#1FH
	INC R3
	LCALL DISPLAY
	DJNZ R1,NXT8
	MOV A,#00H
	INC R3
	LCALL DISPLAY

	DJNZ R6,NXT801
	DJNZ R5,NXT80
OVR0:	NOP

	CJNE R3,#40H,FRR0
FRRG0:	LJMP OVER	
FRR0:	JNC FRRG0


DIS_4:	MOV R5,39H
	CJNE R5,#00H,NXT40
	SJMP OVR1
NXT40:	MOV R6,3DH
NXT401:	MOV R1,3BH
NXT4:	MOV A,#1FH
	INC R3
	LCALL DISPLAY
	DJNZ R1,NXT4
	MOV A,#00H
	INC R3
	LCALL DISPLAY
	DJNZ R6,NXT401
OVR1:	NOP

	CJNE R3,#40H,FRR1
FRRG1:	LJMP OVER	
FRR1:	JNC FRRG1
	
DIS_21:	MOV R5,38H
	CJNE R5,#00H,NXT20
	SJMP DIS_1

NXT20:	MOV R5,37H
	MOV R1,3BH
	CJNE R5,#00H,NXT210
NXT2:	MOV A,#1EH
	INC R3
	LCALL DISPLAY
	DJNZ R1,NXT2
	MOV A,#00H
	INC R3
	LCALL DISPLAY
	SJMP CLRR

NXT210:	MOV A,#1FH
	INC R3
	LCALL DISPLAY
	DJNZ R1,NXT210
	MOV A,#00H
	INC R3
	LCALL DISPLAY
	
	CJNE R3,#40H,FRR2
FRRG2:	LJMP OVER	
FRR2:	JNC FRRG2
	
	MOV R1,3BH
NXT2101:MOV A,#10H
	INC R3
	LCALL DISPLAY
	DJNZ R1,NXT2101
	MOV A,#00H
	INC R3	
	LCALL DISPLAY
	SJMP CLRR	


DIS_1:	MOV R1,3BH
	MOV R5,37H
	CJNE R5,#00H,REP1
	SJMP CLRR
REP1:	MOV A,#18H
	INC R3
	LCALL DISPLAY
	DJNZ R1,REP1
	MOV A,#00H
	INC R3
	LCALL DISPLAY

CLRR:	MOV A,#00H
	CJNE R3,#40H,REPR
	SJMP OVER
REPR:	JNC OVER
	INC R3
	LCALL DISPLAY
	SJMP CLRR

OVER:	NOP
	RET

;------------------------------------------------------------------------------------------------------------
;FUNCTIONS 3,4,5
;LCD FUNCTIONS

COMMAND:	LCALL READY
		CLR P1.2
		CLR P1.1
		MOV P2,A
		SETB P1.3
		NOP 
		CLR P1.3
		RET

DISPLAY:	LCALL READY
		CLR P1.2
		SETB P1.1
		MOV P2,A
		SETB P1.3
		NOP
		CLR P1.3
		RET


READY:		SETB P2.7
		CLR P1.1
		SETB P1.2
BUSY:		CLR P1.3
		SETB P1.3
		JB P2.7,BUSY
		NOP
		CLR P1.3
		RET

;-----------------------------------------------------------------------------------------------------------
;FUNCTION 6
;SERIAL TRANSMISSION CONTROL ROUTINE

XMIT:		PUSH ACC
		PUSH 00H

XMIT0:		CLR A
		MOV R0,55H
		CJNE R0,#2FH,CONTS
		MOV R0,#32H	
		MOV A,#0DH
		MOV 56H,#0A5H		;LEAVE A TRACE
		MOV SBUF,A
		SJMP TRIP

CONTS:		MOV A,@R0
		MOV SBUF,A
		DEC R0

TRIP:		MOV 55H,R0
		POP 00H
		POP ACC
		RET

;-----------------------------------------------------------------------------------------------------------
;FUNCTION 7
;INTERRUPT SERVICE ROUTINE FOR TIMER1 GEN-50MSx20


ORG 001BH
		LJMP 0800H	
ORG 0800H	
		CLR TR1		
		MOV TH1,#3CH	
		MOV TL1,#0BAH	
		INC R4		
		SETB TR1	
		CJNE R4,#14H,SKIP
		MOV R4,#00H	
		CLR TR0		
		CLR TR1		
		MOV R2,TL0	;ABSORB LOWER BYTE
		

		;INC R2		;TEST INSTRUCTION	
		MOV TH0,#00H	
		MOV TL0,#00H	
		MOV TH1,#3CH	
		MOV TL1,#0BAH	
		SETB TR0	
		SETB TR1	
SKIP:		RETI		


;-----------------------------------------------------------------------------------------------------------
;FUNCTION 8
;SERIAL INTERRUPT ROUTINE

ORG 0023H

		LJMP 0900H
ORG 0900H
		
SER_INT:	NOP
		CLR TI
		
		PUSH ACC
		MOV A,56H		;GET TRACE BYTE
		CJNE A,#0A5H,STPW
		CLR TR2			;STOP TIMER2
		MOV 56H,#00H		;ERASE TRACE
		SJMP TMPSTP	
		
STPW:		NOP
		LCALL XMIT
TMPSTP:		NOP
		POP ACC
		RETI



;-----------------------------------------------------------------------------------------------------------
;MESSAGES AND DISPLAY PATTERNS


ORG 0F00H

MSG1: DB 'SPEED = '

ORG  0F0FH

MSG2: DB ' RPS'

ORG 0F20H

MSG3:	DB'Initialising...' 

ORG 0F30H

MSG5: 	DB'Running comm chk'

END	

; SOFTWARE ENDS		
;////////////////////////////////////////////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////////////////////////////////////////////