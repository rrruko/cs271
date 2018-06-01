section .data
	input:  db "          "		; blank input buffer
	SIZE: equ $-input			; MAX size of input
	num_read: dd 0x00			; number of characters read from stdin
	total: dd 0x00				; result from factorial call
	total_len: db 0x00			; number of digits in result
	output: db "          ",10	; output buffer for write call
	output_len: equ $-output	; size of output buffer for write call

section .text

;include macros to read from stdin, write to stdout
%include "read_write.mac"

;functions you must define
extern factorial, atoi, itoa, count_digits;

global _start
_start:

	; use macro to read in number from standard input 
	read_input input, SIZE, num_read;

	; convert number from ASCII to integer
	mov eax,input;
	mov ebx,dword [num_read];

	; eax holds return value (integer)
	call atoi;

	; call factorial on converted number
	; integer already in eax
	call factorial;

	; store factorial result in [total]
	mov [total],eax;

	; count the number of digits in total
	; eax has factorial result
	call count_digits;

	; store number of digits (return value from count_digits)
	mov [total_len],eax;

	; convert total from integer to ASCII (for printing)
	mov eax,dword [total]		; integer value to convert
	mov ebx,dword [total_len]	; number of digits in integer value
	mov ecx,output				; output buffer to fill 
	call itoa					; make integer to ASCII conversion

	;call macro to write output buffer to standard output
	write_output output,output_len;
	
	; clean exit
	mov eax,1;
	mov ebx,0;
	int 0x80;

