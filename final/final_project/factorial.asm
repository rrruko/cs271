section .text
global factorial

; factorial function calculate N! (N factorial) for input N
;
; eax holds N, the integer to factorial
; return value N! (N factorial) stored in eax

factorial:
        mov ebx, eax
        mov eax, 1
        .loop:
        mul ebx
        dec ebx
        jnz .loop
        ret

