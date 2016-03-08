;REAL TIME DIGITAL CLOCK ON MULTIPLEXED 7SEGMENT LED COMMON ANODE DISPLAY
;ASTER
;09/11/2008			::::: 		23:32

;PORT SPECIFICATION :::::::: 	P0 ---- DATA					::::: INPUT FOR ULN2003
;								P2.6 - C , P2.7 - B , P2.8 - A  ::::: INPUT FOR 74LS138

;TIME FORMAT :::::::: 			HH : MM : SS  

ORG 0000H
SJMP 0030H

ORG 000BH
LJMP 0500

ORG 0030H


START:		NOP
			NOP

INIT:		MOV R0,#30H
			LCALL CLEARRAM
			MOV R0,#40H
			LCALL CLEARRAM

			MOV 50H,#23H
			MOV 51H,#35H
			MOV 52H,#59H

			MOV IE,#82H
			MOV IP,#02H
			MOV TMOD,#01H
			MOV TH0,#00H
			MOV TL0,#00H

			CLR 21H
			MOV SP,#60H

			CLR A
			MOV R2,A
			MOV R3,A
			MOV R4,A
			MOV R5,A

			MOV P0,A
			MOV P2,A
			MOV P3,#0FFH

			LCALL CONVRT
			LCALL CPY7
			LCALL UPDTT

			MOV R0,#30H
			MOV R1,#40H

			SETB TR0

;MAIN BEGINS HERE
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
MAIN:		NOP
DISP7:		JNB 21H,DISPC
			CLR 21H
			LCALL CONVRT
			NOP
			LCALL CPY7
			NOP

DISPC:		MOV P0,#00H			;HIGH DOMINANCE PRE-MASKING BYTE
			LCALL NXMOD
			MOV A,@R1
			MOV P0,A
			INC R1
			INC R3
			CJNE R1,#46H,DISP7
			MOV R1,#40H
			MOV R3,#00H
			NOP
			;SETB 21H			;DEBUGGING ONLY
			SJMP DISP7
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
;MAIN ENDS HERE


;SUBROUTINES
;-------------------------------------------------------------------------------
;COPIES 7SEGMENT CODES TO DISPLAY RAM AREA

CPY7:		MOV P0,#00H
			MOV DPTR,#NOS
			MOV R0,#30H
			MOV R1,#40H
			MOV R2,#06H
			CLR A
CMPLT:		MOV A,@R0
			MOVC A,@A+DPTR
			MOV @R1,A
			INC R0
			INC R1
			DJNZ R2,CMPLT
			NOP
			RET

;-------------------------------------------------------------------------------
;UPDATES TIME BY INCREMENTING COUNTERS ON EVERY CALL

UPDTT:		CLR A
SEC:		MOV A,52H
			ADD A,#01H
			DA A
			MOV 52H,A
			CJNE A,#60H,EXITU
			MOV 52H,#00H
MIN:		MOV A,51H
			ADD A,#01H
			DA A
			MOV 51H,A
			CJNE A,#60H,EXITU
			MOV 51H,#00H
HR:			MOV A,50H
			ADD A,#01H
			DA A
			MOV 50H,A
			CJNE A,#24H,EXITU
			MOV 50H,#00H
EXITU:		NOP
			SETB 21H
			RET
			
;---------------------------------------------------------------------------------
;CONVERT DECIMAL TIME TO SPLIT DECIMAL DIGITS

CONVRT:		MOV P0,#00H
			PUSH 00H
			PUSH 01H
			PUSH 02H
			MOV R0,#50H
			MOV R1,#30H
			MOV R2,#03H
			
FINI:		MOV A,@R0
			ANL A,#0F0H
			SWAP A
			MOV @R1,A
			INC R1
			MOV A,@R0
			ANL A,#0FH
			MOV @R1,A
			INC R1
			INC R0
			DJNZ R2,FINI

			POP 02H
			POP 01H
			POP 00H
			RET
			
;---------------------------------------------------------------------------------									
;CLEARS RAM DATA

CLEARRAM:	MOV R2,#06H
CLEARALL:	MOV @R0,#00H
			INC R0
			DJNZ R2,CLEARALL
			RET

;---------------------------------------------------------------------------------
;ENABLES THE REQUIRED 7SEG MODULE, PASS MODULE NO IN R3

NXMOD:		MOV A,R3		 
			MOV C,ACC.0		 ; XYZ 0 0 ZYX
			MOV ACC.7,C
			MOV C,ACC.1
			MOV ACC.6,C
			MOV C,ACC.2
			MOV ACC.5,C
			MOV P2,A
			RET
				
;----------------------------------------------------------------------------------
;INTERRUPT ROUTINE
ORG 0500H
INTRTN:		CLR TR0
			MOV P0,#00H
			MOV TH0,#00H
			MOV TL0,#00H
			CLR TF0
			INC R4
			CJNE R4,#10H,EXITT
			MOV R4,#00H
			LCALL UPDTT
EXITT:		SETB TR0
			RETI

;-----------------------------------------------------------------------------------
;DATA BYTES

NOS: DB 77H,11H,6BH,3BH,1DH,3EH,7EH,13H,7FH,3FH,0
END
