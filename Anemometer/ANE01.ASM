;COUNT AND DISPLAY-----TEST A 
;29/02/2008
;ASTER


;HARDWARE DISABLED FOR TESTING----- INCREMENT AND DISPLAY AFTER 1SEC INTERRUPTION----- SUCCESS- AT89C51


;PORT DETAILS:  PORT2--- LCD DATA IN/OUT
;		PORT1--- LCD CONTROL-- P1.1-RS --- P1.2-R/W --- P1.3-EN -----
;		PORT3--- HARDWARE INPUT-- P3.4(T0) COUNTER INPUT --- HIGH TO LOW TRANSIT -----

;--------------------------------------------------------------------------------------------------------------------------------------------------

ORG 0000H
SJMP 0030H
ORG 0030H


START: 		MOV TMOD,#15H	
		
		MOV IE,#88H	
		MOV IP,#08H	
		
		MOV TH1,#3CH	
		MOV TL1,#0B0H	
		SETB TR1	
		SETB TR0	

		CLR A	
		MOV P1,A
		MOV P2,A	
		MOV R0,#00H
		MOV R2,#00H	
		MOV R4,#00H	
		MOV 32H,#33H
		MOV 31H,#33H
		MOV 30H,#33H



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


		
BCD_ASC:	MOV A,R0	
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
; LCD DISPLAY ROUTINES

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

		;INC R2         TEST INSTRUCTION
DELAY_VISUAL:	MOV R7,#05H	; 1.2 SECONDS APPROX.
		MOV R6,#0FFH
		MOV R5,#0FFH
		DJNZ R5,$
		DJNZ R6,$-2
		DJNZ R7,$-3		

STAY_END:	SJMP MAIN_T

;------------------------------------------------------------------------------------------------------------
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
;INTERRUPT SERVICE ROUTINE


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
		;MOV R2,TL0
		

		INC R2		;TEST INSTRUCTION	
		MOV TH0,#00H	
		MOV TL0,#00H	
		MOV TH1,#3CH	
		MOV TL1,#0BAH	
		SETB TR0	
		SETB TR1	
SKIP:		RETI		


;-----------------------------------------------------------------------------------------------------------

ORG 0F00H

MSG1: DB 'SPEED = '

ORG  0F0FH

MSG2: DB ' RPS'

END				
