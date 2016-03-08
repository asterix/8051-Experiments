;REAL TIME DIGITAL CLOCK ON MULTIPLEXED 7SEGMENT LED COMMON ANODE DISPLAY
;ASTER
;10/11/2008			::::: 		16:37

;PORT SPECIFICATION :::::::: 	P0 ---- DATA					::::: INPUT FOR ULN2003
;								P2.6 - C , P2.7 - B , P2.8 - A  ::::: INPUT FOR 74LS138


;:::::::::::::::::::::::::::::::::::::::::::DIAGONOSTICS ONLY::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

;TIME FORMAT :::::::: 			HH : MM : SS  

ORG 0000H
SJMP 0030H
ORG 0030H


START:		MOV P0,#00H
			MOV P2,#00H
			MOV R3,#00H
			MOV R2,#02H
			MOV DPTR,#NOS

BACK:		CLR A
			MOVC A,@A+DPTR
			CJNE A,#00H,SKIPA
			MOV DPTR,#NOS
			SJMP NXTA

SKIPA:		INC DPTR
			MOV P0,A
			LCALL DELAYV
			SJMP BACK

NXTA:		LCALL NXMOD
			SJMP BACK



;----------------------------------------------------------------------------

NXMOD:		MOV A,R3		 ;NXMOD TAKES 17T STATES WITHOUT DELAYV LOOP
			INC A
			MOV R3,A
			CJNE A,#06H,SKIP
			CLR A		 
			MOV R3,A
SKIP:		MOV C,ACC.0		 ; XYZ 0 0 ZYX
			MOV ACC.7,C
			MOV C,ACC.1
			MOV ACC.6,C
			MOV C,ACC.2
			MOV ACC.5,C
			MOV P2,A
			RET
;-------------------------------------------------------------------------------

DELAYV:		MOV R7,#08H
WAITC:		MOV R6,#0FFH
WAITB:		MOV R5,#0FFH
WAITA:		DJNZ R5,WAITA
			DJNZ R6,WAITB
			DJNZ R7,WAITC
			RET



NOS: DB 77H,11H,6BH,3BH,1DH,3EH,7EH,13H,7FH,3FH,0

END
