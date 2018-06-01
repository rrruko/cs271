section .data
        digit_count dd 0

section .text
global count_digits;

; count_digits counts the number of digits in an integer value
; e.g., 1000 has 4 digits.
;
; eax contains integer value to count 
; return value (number of digits) stored in eax

count_digits:
        cmp eax, 0
        je .special_zero_case
        mov ebx, 10
        .loop:
        xor edx, edx
        div ebx                        ; Quotient: eax, remainder: edx
        add [digit_count], dword 1           
        test eax, eax                  ; Is eax 0?
        jnz .loop
        mov eax, [digit_count]
        ret 

.special_zero_case:
        mov eax, 1
        ret
