org 0000h
sjmp 30h
org 0030h
START:  mov r0,#88h
	mov a,r0
	rlc a
	mov p0,a
	acall DELAY
	ajmp START
 	nop
	nop
	nop

DELAY:  nop
	mov r7,#10h
HOLD:	mov r6,#0ffh
WAIT:	djnz r6,WAIT 
	djnz r7,HOLD
	ret	




org 00aah
text1:db 'vaibhav'
END

	