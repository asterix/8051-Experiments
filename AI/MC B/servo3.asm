;ASTER 06/03/2009 1245
;TO BE ASSEMBLED IN KEIL MICROVISION V3.60
;ARTIFICIAL INTELLIGENCE
;MICROCOMPUTER B   SERVO


;-----------------------------------------------------------------------------------------------------------
;SET THE ASSEMBLER FOR AT89S52
$NOMOD51
$INCLUDE (AT89X52.h)

;-----------------------------------------------------------------------------------------------------------

ORG 0000H

RESET:		SJMP 0030H 

ORG 0030H

START:		NOP
			MOV SP,#10H
			MOV TMOD,#10H
			CLR TF1
								;RELOCATE STACK OVER 10H

AGAIN:		CLR TR1
			MOV TH1,#0B7H
			MOV TL1,#0FFH
			CLR P3.0
			SETB TR1
WAITL:		JNB TF1,WAITL
			SETB P3.0
			CLR TR1
			CLR TF1
			MOV TH1,#0FAH
			MOV TL1,#9AH
			SETB TR1
WAITH:		JNB TF1,WAITH
			CLR TF1
			SJMP AGAIN
			
HERE:		SJMP HERE


DELAYL:		MOV R7,#72
			MOV R6,#0FFH
			DJNZ R6,$
			DJNZ R7,$-2
			RET

DELAYH:		MOV R7,#6
			MOV R6,#0FFH
			DJNZ R6,$
			DJNZ R7,$-2
			RET
			
			 
END