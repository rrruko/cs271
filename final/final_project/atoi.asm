section .data
        atoi_ptr dd 0
        atoi_pow dd 0
	atoi_res dd 0

section .text
global atoi;

; atoi function: convert ASCII character string to integer number
;
; eax is pointer to ASCII buffer to convert
; ebx is length of buffer (number of digits)
;
; return value (integer dword) stored in eax
	
; Algorithm:
;   sum = 0
;   pow = 1
;   for each ascii byte, starting at the end:
;     sum += int_parse(byte) * pow
;     pow *= 10
;   return sum
atoi:
        add eax, ebx                   ; We're going to be traversing the
        mov [atoi_ptr], eax            ;   string backwards from the end.
        mov [atoi_pow], dword 1
        mov ecx, ebx                   ; Repeat the following ebx times:
        .loop:                         ; loop
        mov bl, [atoi_ptr]             ; Put current string byte in bl
        sub bl, '0'                    ; Compute the value of the digit
        xor eax, eax                   ; Zero eax
        mov al, bl                     ; Put that value in al
        mul dword [atoi_pow]           ; Multiply by the current power of ten
        mov ebx, [atoi_res]            ; Get the current sum
        add eax, ebx                   ; Update the current sum with new digit
        mov [atoi_res], eax            ; Write the current sum
        call .mul_pow_by_ten           ; Next time multiply by next power of 10
        mov eax, [atoi_ptr]            ; \
        dec eax                        ;  Move to next ASCII byte (notice dec)
        mov [atoi_ptr], eax            ; /
	loop .loop                     ; loop loop
        mov eax, [atoi_res]            ; Return the sum in eax
	ret 

; atoi_pow keeps track of the power of ten represented by this 
.mul_pow_by_ten:
        mov eax, [atoi_pow]
        mov ebx, 10
        mul ebx
        mov [atoi_pow], eax
        ret