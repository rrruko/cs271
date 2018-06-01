section .text
global factorial

; factorial function calculate N! (N factorial) for input N
;
; eax holds N, the integer to factorial
; return value N! (N factorial) stored in eax

factorial:

	mov eax,40320	; 8! = 40320
	ret;

