global _start

READ_SIZE     equ 20
WRITE_SIZE    equ 20

section .bss
    read_buf  resb READ_SIZE
    READ_BUF_END equ $
    write_buf resb WRITE_SIZE
    WRITE_BUF_END equ $

section .data
    read_ptr  dd 0
    write_ptr dd 0
    amp       db '@'

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
      ;mov ebx, [read_ptr]
      ;mov eax, [ebx]
      ; eax now contains the next character from the read buffer

      mov bl, [amp]
      mov eax, [write_ptr]
      mov [eax], bl
      
      ; increment read_ptr
      ;mov eax, [read_ptr]
      ;inc eax
      ;mov [read_ptr], eax

      ; increment write_ptr
      mov eax, [write_ptr]
      inc eax
      mov [write_ptr], eax

      cmp [write_ptr], dword WRITE_BUF_END
      je .oof
      jmp .encode_loop

  .oof:
    mov eax, 4
    mov ebx, 1
    mov ecx, write_buf
    mov edx, WRITE_SIZE
    int 80h

    mov eax, 1
    mov ebx, 0
    int 80h
