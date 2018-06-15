TITLE Composite Numbers   (project4.asm)

; Author: Ken Hall
; Course / Project ID: CS 271 400         Date: 2/18/2018

; Description:  A program to calculate composite numbers. 
; First, the user is instructed to enter the number of
; composites to be displayed, and is prompted to enter an 
; integer in the range [1 .. 400]. The userenters a number, n, 
; and the program verifies that 1 ? n ? 400. If n is out of range, 
; the user is reprompted until s/he enters a value in the specified 
; range. The program then calculates and displays all of the 
; composite numbers up to and including the nth composite. 

INCLUDE Irvine32.inc

	LOWER_LIMIT = 1
	UPPER_LIMIT = 400

.data

	intro_1			BYTE		"Composite Numbers					By Ken Hall", 0
	userPrompt		BYTE		"Please enter the number of composite numbers you would like to see, between 1 and 400.", 0
	numTooLow		BYTE		"Input is too low. Please try again.", 0
	numTooHigh		BYTE		"Input is too high. Please try again.", 0
	outro_1			BYTE		"Thanks for playing! Goodbye!", 0


.code
main PROC
	call intro
	call getUserData
	call showComposites
	call outro

	exit	
main ENDP


;----------
;PROCEDURES
;----------

intro PROC
;---------
;;;DESCRIPTION: displays programmeer's name, program title
;;;RECEIVES: NONE
;;;RETURNS: NONE
;;;PRECONDITIONS: NONE
;---------
	push	edx
	mov		edx, OFFSET intro_1
	call	WriteString
	call	Crlf
	call	Crlf
	pop		edx
ret
intro ENDP


getUserData PROC
;---------------
;;;DESCRIPTION: accepts an integer from user input 1-400, calls validate to enforce acceptable
;;;input boundaries
;;;RECEIVES: NONE
;;;RETURNS: EAX = validated int
;;;PRECONDITIONS:
;---------------
	mov		edx, OFFSET userPrompt
	call	WriteString
	call	Crlf
	call	ReadInt
	call	validate
	ret
getUserData ENDP


validate PROC
;------------
;;;DESCRIPTION: verifies that user input is acceptable, calls getUserData if invalid
;;;RECEIVES: EAX = an int
;;;RETURNS: EAX = validated num; EBX = LOWER_LIMIT XOR UPPER_LIMIT
;;;PRECONDITIONS:  getUserData called immediately prior, defined constants UPPER_LIMIT, LOWER_LIMIT
;------------
	mov		ebx, LOWER_LIMIT
	cmp		eax, ebx
	jl		tooLow
	mov		ebx, UPPER_LIMIT
	cmp		eax, ebx
	jg		tooHigh
	ret

tooLow:
	mov		edx, OFFSET numTooLow
	call	WriteString
	call	Crlf
	call	getUserData
	ret

tooHigh:
	mov		edx, OFFSET numTooHigh
	call	WriteString
	call	Crlf
	call	getUserData
	ret
validate ENDP

 
showComposites PROC
;------------------
;;;DESCRIPTION: displays composite numbers
;;;RECEIVES: EAX = number of composite numbers to display
;;;RETURNS: NONE
;;;PRECONDITIONS: NONE
;------------------
	pushad
	mov		ecx, eax				;sets loop counter to number of comp num to display
	mov		eax, 2					;EAX is used to cycle through the composite num candidates
	
nextNum:							;target for cycling through dividends
	mov		ebx, 1					;EBX cycles through divisors. 2 is smallest possible divisor, EBX inc at start of keepChecking
	inc		eax

keepChecking:						;target for cycling through divisors
	inc		ebx
	push	eax						;save dividend from EAX
	mov		edx, 0					;set remainder to 0
	div		bx
	cmp		edx, 0
	pop		eax						;restore dividend to EAX
	je		printNum				;remainder 0, print the num
	push	eax						;save dividend from EDX
	mov		edx, 0					;set remainder to 0
	div		bx
	cmp		eax, 2
	pop		eax						;restore dividend to EAX
	jge		keepChecking			;if divisor/dividend > 2, keep checking; else start checking nextNum
	jmp		nextNum

printNum:							;target for printing eligible nums
	call	WriteInt
	call	Crlf

	loop	nextNum

	call	Crlf
	popad
	ret
showComposites ENDP


outro PROC
;---------
;;;DESCRIPTION: Writes farewell string to console
;;;RECEIVES: NONE
;;;RETURNS: NONE
;;;PRECONDITIONS: defined string outro_1
;---------
	push	edx
	mov		edx, OFFSET outro_1
	call	WriteString
	call	Crlf
	pop		edx
	ret
outro ENDP
END main
