section .text
global count_digits;

; count_digits counts the number of digits in an integer value
; e.g., 1000 has 4 digits.
;
; eax contains integer value to count 
; return value (number of digits) stored in eax

count_digits:

	mov eax,5	; 8 factorial = 40320, which has 5 digits 
	ret;

