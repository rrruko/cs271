global _start

READ_SIZE     equ 1000
WRITE_SIZE    equ 1000

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
    call .decode

  .read:
    mov eax, 3
    mov ebx, 0
    mov ecx, read_buf
    mov edx, READ_SIZE
    int 80h
    ret

  .decode:
    mov [read_ptr], dword read_buf
    mov [write_ptr], dword write_buf
    .decode_loop:
      mov eax, [read_ptr]
      mov bl, [eax]                    ; Load the next two chars into bl and cl.
      mov cl, [eax+1]                  ; bl: output char, cl: number of times.
      cmp bl, 0
      je .done
      cmp cl, 0
      je .done
      sub cl, '0'                      ; Now cl is the actual correct number.
      .unpack:                         ; Write bl, cl times.
        mov eax, [write_ptr]           ; Get the write_ptr.
        mov [eax], bl                  ; Write the char.
        
        call .inc_write_ptr
        dec cl                         ; Decrement the loop counter.
        jnz .unpack                    ; Loop if non-zero.
      call .inc_read_ptr               ; Increment twice, since the loop reads
      call .inc_read_ptr               ; twice.
      jmp .decode_loop

  .done:
    mov bl, 10                         ; 10 is the ASCII code for newline (\n).
    mov eax, [write_ptr]               ; Write a newline at the end since
    mov [eax], bl                      ; we're done.
    call .print_decoded

  .inc_write_ptr:
    ; increment write_ptr
    mov eax, [write_ptr]
    inc eax
    mov [write_ptr], eax
    ret

  .inc_read_ptr:
    ; increment read_ptr
    mov eax, [read_ptr]
    inc eax
    mov [read_ptr], eax
    ret

  .print_decoded:
    ; write() syscall to print `write_buf`
    mov eax, 4
    mov ebx, 1
    mov ecx, write_buf
    mov edx, WRITE_SIZE
    int 80h

    ; exit() syscall
    mov eax, 1
    mov ebx, 0
    int 80h
