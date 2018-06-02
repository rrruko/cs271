section .data
        atoi_ptr dd 0
        atoi_pow dd 1
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
        mov ecx, ebx                   ; Repeat the following ebx times:
        .loop:                         ; loop
        sub [atoi_ptr], dword 1        ;  Move to next (previous?) ASCII byte
        xor ebx, ebx                   ; Zero ebx so it's the same as bl later
        mov eax, [atoi_ptr]            ; Prepare to dereference pointer
        mov bl, [eax]                  ; Put current string byte in bl
        sub bl, '0'                    ; Compute the value of the digit
        jc .loopback                   ; See [note]
        mov eax, ebx                   ; Put that value in al
        mul dword [atoi_pow]           ; Multiply by the current power of ten
        add [atoi_res], eax            ; Update the current sum with new digit
        call .mul_pow_by_ten           ; Next time multiply by next power of 10
        .loopback:
	loop .loop                     ; loop loop
        mov eax, [atoi_res]            ; Return the sum in eax
	ret

; [note]
;   All whitespace characters are less than ascii '0'.
;   This means subtracting ascii '0' has a negative result,
;   setting the carry flag. In that case, we want to skip the rest of the
;   loop body, which would add the whitespace character's value to the sum.
;
;   This isn't a perfect solution.
;   For one thing, it's too permissive:
;     - "  1  0 " parses as 10.
;     - ':', ';', and '<' parse as 10, 11, and 12 respectively,
;       because of their position in ascii.
;   ...but it works well enough.
; 
;   This program is usually invoked in such a way that this procedure gets
;   handed a number with a trailing newline, so it's necessary to handle it.

; atoi_pow keeps track of the power of ten corresponding to the decimal
; place of the current digit. We parse from right to left so that keeping track
; simply entails multiplying by ten each time.
.mul_pow_by_ten:
        mov eax, [atoi_pow]
        mov ebx, 10
        mul ebx
        mov [atoi_pow], eax
        ret
