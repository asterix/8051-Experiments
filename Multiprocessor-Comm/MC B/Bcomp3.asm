;ASTER 02/03/2009 2135
;TO BE ASSEMBLED IN KEIL MICROVISION V3.60
;ARTIFICIAL INTELLIGENCE
;MICROCOMPUTER B

;REV 0 LAST UPDATED 04/03/2009 1610

;-----------------------------------------------------------------------------------------------------------
;SET THE ASSEMBLER FOR AT89S52
$NOMOD51
$INCLUDE (AT89X52.h)

;-----------------------------------------------------------------------------------------------------------

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

			LCALL DELAYIN

			MOV R0,#20H					;CLEAR RAM FROM 20H TO 7FH
			CLR A
CLRALL:		MOV @R0,A
			INC R0
			CJNE R0,#7FH,CLRALL

			
			MOV T2CON,#30H				;SET UP THE UART 9600BPS
			MOV RCAP2H,#0FFH
			MOV RCAP2L,#0DCH
			
			ANL PCON,#7FH
			
			MOV IE,#90H					;ENABLE INTERRUPTS: SERIAL
			MOV IP,#10H
			
			MOV SCON,#58H
			SETB TR2					;START BAUD GEN TIMER



;----------------------------------------------------------------------------------------------------------
;**********************************************************************************************************
;THE PROGRAM MAIN
;PASS DIRECTION IN R2,BANK0 : 00H->FORWARD, 01H->BACKWARD
MAIN:							   		

			


MAIN_END:	LJMP MAIN





;MAIN ENDS HERE
;**********************************************************************************************************
;----------------------------------------------------------------------------------------------------------
;INTERRUPT SERVICE ROUTINES
ORG 0023H
			LJMP 1000H
ORG 1000H

SERCON:		CLR TR2
			JNB RI,TXI
			CLR RI
			MOV A,SBUF
			JB 20H,SKIPC
			CJNE A,#0CEH,EXITC
			MOV SBUF,#9EH
			SETB 20H
			SJMP EXITC
SKIPC:		CJNE A,#0BEH,SKIPC2
			MOV SBUF,#0BEH
			CLR 20H
			SJMP EXITC
SKIPC2:		SETB 21H
			MOV SBUF,#9EH
			SJMP EXITC
TXI:		CLR TI
EXITC:		SETB TR2
			RETI

;----------------------------------------------------------------------------------------------------------
;MOTOR DRIVING ROUTINES

;MOTOR 1: BASE RIGHT MOTOR :: MOTOR CODE: 01H
BSERGT:		NOP
			CJNE R2,#00H,BACK1
			SETB P2.0
			CLR P2.1
			MOV 34H,#00H
			SJMP DONE1	
BACK1:		CJNE R2,#01H,RSTP1
			CLR P2.0
			SETB P2.1
			MOV 34H,#01H
			SJMP DONE1
RSTP1:		CJNE R2,#02H,HSTP1
			CLR P2.0
			CLR P2.1
			MOV 34H,#04H
			SJMP DONE1
HSTP1:		MOV R3,34H
			CJNE R3,#00H,RREV1
RFOR1:		CLR P2.0
			CLR P2.1
			LCALL DELAYHS
			SETB P2.1
			LCALL DELAYHS
			CLR P2.1
			MOV 34H,#04H
			SJMP DONE1
RREV1:		CJNE R3,#01H,DONE1
			CLR P2.0
			CLR P2.1
			LCALL DELAYHS
			SETB P2.0
			LCALL DELAYHS
			CLR P2.0
			MOV 34H,#04H
DONE1:		NOP
			RET

;MOTOR 2: BASE LEFT MOTOR :: MOTOR CODE: 02H
BSELFT:		NOP
			CJNE R2,#00H,BACK2
			SETB P2.2
			CLR P2.3
			MOV 38H,#00H
			SJMP DONE2	
BACK2:		CJNE R2,#01H,RSTP2
			CLR P2.2
			SETB P2.3
			MOV 38H,#01H
			SJMP DONE2
RSTP2:		CJNE R2,#02H,HSTP2
			CLR P2.2
			CLR P2.3
			MOV 38H,#04H
			SJMP DONE2
HSTP2:		MOV R3,38H
			CJNE R3,#00H,RREV2
RFOR2:		CLR P2.2
			CLR P2.3
			LCALL DELAYHS
			SETB P2.3
			LCALL DELAYHS
			CLR P2.3
			MOV 38H,#04H
			SJMP DONE2
RREV2:		CJNE R3,#01H,DONE2
			CLR P2.2
			CLR P2.3
			LCALL DELAYHS
			SETB P2.2
			LCALL DELAYHS
			CLR P2.2
			MOV 38H,#04H
DONE2:		NOP
			RET

;MOTOR 3: SHOULDER RIGHT MOTOR :: MOTOR CODE: 03H
SHLRGT:		NOP
			CJNE R2,#00H,BACK3
			SETB P2.4
			CLR P2.5
			MOV 3CH,#00H
			SJMP DONE1	
BACK3:		CJNE R2,#01H,RSTP3
			CLR P2.4
			SETB P2.5
			MOV 3CH,#01H
			SJMP DONE3
RSTP3:		CJNE R2,#02H,HSTP3
			CLR P2.4
			CLR P2.5
			MOV 3CH,#04H
			SJMP DONE3
HSTP3:		MOV R3,3CH
			CJNE R3,#00H,RREV3
RFOR3:		CLR P2.4
			CLR P2.5
			LCALL DELAYHS
			SETB P2.5
			LCALL DELAYHS
			CLR P2.5
			MOV 3CH,#04H
			SJMP DONE3
RREV3:		CJNE R3,#01H,DONE3
			CLR P2.4
			CLR P2.5
			LCALL DELAYHS
			SETB P2.4
			LCALL DELAYHS
			CLR P2.4
			MOV 3CH,#04H
DONE3:		NOP
			RET

;MOTOR 4: SHOULDER LEFT MOTOR :: MOTOR CODE: 04H
SHLLFT:		NOP
			CJNE R2,#00H,BACK4
			SETB P2.6
			CLR P2.7
			MOV 40H,#00H
			SJMP DONE4	
BACK4:		CJNE R2,#01H,RSTP4
			CLR P2.6
			SETB P2.7
			MOV 40H,#01H
			SJMP DONE4
RSTP4:		CJNE R2,#02H,HSTP4
			CLR P2.6
			CLR P2.7
			MOV 40H,#04H
			SJMP DONE4
HSTP4:		MOV R3,40H
			CJNE R3,#00H,RREV4
RFOR4:		CLR P2.6
			CLR P2.7
			LCALL DELAYHS
			SETB P2.7
			LCALL DELAYHS
			CLR P2.7
			MOV 40H,#04H
			SJMP DONE4
RREV4:		CJNE R3,#01H,DONE4
			CLR P2.6
			CLR P2.7
			LCALL DELAYHS
			SETB P2.6
			LCALL DELAYHS
			CLR P2.6
			MOV 40H,#04H
DONE4:		NOP
			RET

;MOTOR 5: ARM ELBOW RIGHT MOTOR :: MOTOR CODE : 05H
ELRGT:		NOP
			CJNE R2,#00H,BACK5
			SETB P1.0
			CLR P1.1
			MOV 44H,#00H
			SJMP DONE5	
BACK5:		CJNE R2,#01H,RSTP5
			CLR P1.0
			SETB P1.1
			MOV 44H,#01H
			SJMP DONE5
RSTP5:		CJNE R2,#02H,HSTP5
			CLR P1.0
			CLR P1.1
			MOV 44H,#04H
			SJMP DONE5
HSTP5:		MOV R3,44H
			CJNE R3,#00H,RREV5
RFOR5:		CLR P1.0
			CLR P1.1
			LCALL DELAYHS
			SETB P1.1
			LCALL DELAYHS
			CLR P1.1
			MOV 44H,#04H
			SJMP DONE5
RREV5:		CJNE R3,#01H,DONE5
			CLR P1.0
			CLR P1.1
			LCALL DELAYHS
			SETB P1.0
			LCALL DELAYHS
			CLR P1.0
			MOV 44H,#04H
DONE5:		NOP
			RET

;MOTOR 6: ARM ELBOW RIGHT MOTOR :: MOTOR CODE : 06H
ELLFT:		NOP
			CJNE R2,#00H,BACK6
			SETB P1.2
			CLR P1.3
			MOV 48H,#00H
			SJMP DONE6	
BACK6:		CJNE R2,#01H,RSTP6
			CLR P1.2
			SETB P1.3
			MOV 48H,#01H
			SJMP DONE6
RSTP6:		CJNE R2,#02H,HSTP6
			CLR P1.2
			CLR P1.3
			MOV 48H,#04H
			SJMP DONE6
HSTP6:		MOV R3,48H
			CJNE R3,#00H,RREV6
RFOR6:		CLR P1.2
			CLR P1.3
			LCALL DELAYHS
			SETB P1.3
			LCALL DELAYHS
			CLR P1.3
			MOV 48H,#04H
			SJMP DONE6
RREV6:		CJNE R3,#01H,DONE6
			CLR P1.2
			CLR P1.3
			LCALL DELAYHS
			SETB P1.2
			LCALL DELAYHS
			CLR P1.2
			MOV 48H,#04H
DONE6:		NOP
			RET

;MOTOR 7: RIGHT CLASPER :: MOTOR CODE: 07H


;MOTOR 8: LEFT CLASPER :: MOTOR CODE : 08H

;-------------------------------------------------------------------------------------------------
;DELAY ROUTINES
;DELAY INIT

DELAYIN:	MOV R7,#07H
			MOV R6,#0FFH
			MOV R5,#0FFH
			DJNZ R5,$
			DJNZ R6,$-2
			DJNZ R7,$-4
			RET

DELAYHS:	MOV R7,#0A0H
			DJNZ R7,$
			RET

;--------------------------------------------------------------------------------------------------
END