global _start

READ_BUF_SIZE  equ 1000
WRITE_BUF_SIZE equ 1000

section .bss
    read_buf  resb READ_BUF_SIZE
    READ_BUF_END equ $
    write_buf resb WRITE_BUF_SIZE
    WRITE_BUF_END equ $

section .data
    read_ptr   dd 0
    write_ptr  dd 0
    write_size dd 0
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
    mov edx, READ_BUF_SIZE
    int 80h
    ret

  .encode:
    mov [read_ptr], dword read_buf
    mov [write_ptr], dword write_buf
    mov eax, [read_ptr]
    mov bl, [eax]
    mov [last_seen], bl
    .encode_loop:
      mov eax, [read_ptr]              ; Deref the pointer and put it in bl.
      mov bl, [eax]                    ; bl now contains the next character
                                       ;   from the read buffer.
      push ebx                         ; Push ebx here so we can get it later.
      mov al, 0
      cmp bl, al                       ; Is this char \0? (i.e. end user input)
      je .null_byte                    ; If so, jump. Otherwise...
      cmp bl, [last_seen]              ; Is this the same char as the last one?
      je .repeated_char                ; If so, jump. Otherwise...
        mov bl, [last_seen]            ; We've completed a run. Write the char.
        mov eax, [write_ptr]
        mov [eax], bl
        call .inc_write_ptr            ; We just wrote, so step forward.
        mov bl, [times_seen]           ; Now get the number of times we saw it.
        cmp bl, 0                      ; Hey wait! Special case for first char.
        je .repeated_char              ; Hmm... Why does jumping here work?
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
        jmp .branch_end
      .null_byte:
        mov bl, 10                     ; Write a newline at the end and bail.
        mov eax, [write_ptr]
        mov [eax], bl
        call .inc_write_ptr
        jmp .print_encoded             ; ! Break out here.
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
    mov eax, [write_ptr]               ; Increment write pointer
    inc eax
    mov [write_ptr], eax
    mov eax, [write_size]              ; Increment write size
    inc eax
    mov [write_size], eax
    ret

  .print_encoded:
    ; write() syscall to print `write_buf`
    mov eax, 4
    mov ebx, 1
    mov ecx, write_buf
    mov edx, [write_size]
    int 80h

    ; exit() syscall
    mov eax, 1
    mov ebx, 0
    int 80h
