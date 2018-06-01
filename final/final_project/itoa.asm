section .text
global itoa;

; eax is integer to be converted to ASCII
; ebx is number of digits in integer
; ecx is output buffer to fill with ASCII characters
; e.g., integer 40320 gets converted to ASCII '40320'

itoa:

	mov byte [ecx],'4';
	mov byte [ecx+1],'0';
	mov byte [ecx+2],'3';
	mov byte [ecx+3],'2';
	mov byte [ecx+4],'0';
	ret;

