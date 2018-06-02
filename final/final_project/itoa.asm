section .data
        itoa_ctr dd 0

section .text
global itoa;

; eax is integer to be converted to ASCII
; ebx is number of digits in integer
; ecx is output buffer to fill with ASCII characters
; e.g., integer 40320 gets converted to ASCII '40320'

itoa:
        add ecx, ebx
        dec ecx
        mov [itoa_ctr], ebx
        mov ebx, 10
        .loop:
        xor edx, edx
        div ebx                        ; Quotient: eax, remainder: edx
        add dl, '0'                    ; Get corresponding ASCII digit for edx
        mov [ecx], dl                  ; Write byte
        dec ecx                        ; Move to next (previous) byte
        sub [itoa_ctr], dword 1
        jnz .loop
        ret
