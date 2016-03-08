;To run a bipolar stepper motor CW with L298 or L293D
;Tested on Minebea-PM42L-048(6E/phase)
;no frame vibrations,good torque,heats up drivers and powering circuits
;03/08/2007






ORG 0000H
SJMP 0030H
ORG 0030H



START:  MOV P2,#01H; coil A +
	ACALL DELAY
	MOV P2,#04H; coil B +
	ACALL DELAY
	MOV P2,#02H; coil A -
	ACALL DELAY
	MOV P2,#08H; coil b -
	ACALL DELAY
	SJMP START


DELAY:  MOV R7,#01H
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