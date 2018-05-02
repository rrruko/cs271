global _start

READ_SIZE     equ 20
WRITE_SIZE    equ 20

section .bss
    read_buf  resb READ_SIZE
    READ_BUF_END equ $
    write_buf resb WRITE_SIZE
    WRITE_BUF_END equ $

section .data
    read_ptr   dd 0
    write_ptr  dd 0
    times_seen db 0
    last_seen  db 0

section .text
  _start:
    call .read
    call .encode

  .read:
    mov eax, 3
    mov ebx, 0
    mov ecx, read_buf
    mov edx, READ_SIZE
    int 80h
    ret

  .encode:
    mov [read_ptr], dword read_buf
    mov [write_ptr], dword write_buf
    .encode_loop:
      mov eax, [read_ptr]              ; Deref the pointer and put it in bl.
      mov bl, [eax]                    ; bl now contains the next character
                                       ;   from the read buffer.
      push ebx                         ; Push ebx here so we can get it later.
      cmp bl, [last_seen]              ; Is this the same char as the last one?
      je .repeated_char                ; If so, jump. Otherwise...
        mov bl, [last_seen]            ; We've completed a run. Write the char.
        mov eax, [write_ptr]
        mov [eax], bl
        call .inc_write_ptr            ; We just wrote, so step forward.
        mov bl, [times_seen]           ; Now get the number of times we saw it.
        add bl, '0'                    ; (n + '0' = the char for n)
        mov eax, [write_ptr]           ; Get the new value of write_ptr.
        mov [eax], bl                  ; Write the count char.
        call .inc_write_ptr            ; Step again cuz we wrote again.
        mov al, 1                      ; Set times_seen to 1.
        mov [times_seen], al
        jmp .branch_end
      .repeated_char:                  ; Jump here if it's the same character.
        mov eax, [times_seen]          ; We just want to increment this.
        inc eax
        mov [times_seen], eax
      .branch_end:                     ; We jumped to here earlier.

      pop ebx                          ; Pop the bl we pushed earlier, and
      mov [last_seen], bl              ; make it the new previous char.

      mov eax, [read_ptr]              ; Increment read ptr.
      inc eax
      mov [read_ptr], eax

      cmp [write_ptr], dword WRITE_BUF_END
      je .print_encoded
      jmp .encode_loop

  .inc_write_ptr:
    ; increment write_ptr
    mov eax, [write_ptr]
    inc eax
    mov [write_ptr], eax
    ret

  .print_encoded:
    mov eax, 4
    mov ebx, 1
    mov ecx, write_buf
    mov edx, WRITE_SIZE
    int 80h

    mov eax, 1
    mov ebx, 0
    int 80h
