section .text
global factorial

; factorial function calculate N! (N factorial) for input N
;
; eax holds N, the integer to factorial
; return value N! (N factorial) stored in eax

factorial:
        mov ebx, eax
        .loop:
        dec ebx
        mul ebx
        cmp ebx, 1
        jne .loop
        ret

