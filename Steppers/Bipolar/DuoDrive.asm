;To run a bipolar stepper motor CW/CCW ALTERNATIVELY with L298(DUO BOARD)
;Tested on Minebea-PM42L-048(6E/phase)
;11/08/2007
;CHECKED AND TESTED WITH AT89C51
;PROGRAM RUN ------------- SUCCESS.





ORG 0000H
SJMP 0030H
ORG 0030H



START:  MOV R0,#0AH
	
CWISE:	MOV R1,#0CH
ROTCW:	MOV P3,#11H; coil A +   ---------------- +0.0 DEG
	ACALL DELAY
	MOV P3,#44H; coil B +   ---------------- +7.5 DEG
	ACALL DELAY
	MOV P3,#22H; coil A -   ---------------- +7.5 DEG
	ACALL DELAY
	MOV P3,#88H; coil b -   ---------------- +7.5 DEG
	ACALL DELAY
	DJNZ R1,ROTCW
	DJNZ R0,CWISE



	MOV R0,#0AH
CCWISE:	MOV R1,#0CH
ROTCCW:	MOV P3,#88H; coil A +   ---------------- +0.0 DEG
	ACALL DELAY
	MOV P3,#22H; coil B +   ---------------- +7.5 DEG
	ACALL DELAY
	MOV P3,#44H; coil A -   ---------------- +7.5 DEG
	ACALL DELAY
	MOV P3,#11H; coil b -   ---------------- +7.5 DEG
	ACALL DELAY
	DJNZ R1,ROTCCW
	DJNZ R0,CCWISE


	SJMP START


DELAY:  MOV R7,#02H
WAITC:	MOV R6,#3FH
WAITB:	MOV R5,#5FH
WAITA:	DJNZ R5,WAITA
	DJNZ R6,WAITB
	DJNZ R7,WAITC
	RET



NOP
NOP
NOP
NOP
END