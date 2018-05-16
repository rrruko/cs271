global _start

BUF_SIZE equ 1000

section .bss
    readbuf resb BUF_SIZE

section .data
    fail_msg   db "Some brackets don't match.",10
    FAIL_MSG_SIZE equ $ - fail_msg
    nest_msg   db "Some brackets aren't nested properly.",10
    NEST_MSG_SIZE equ $ - nest_msg
    loop_ctr dd 0
    initial_esp dd 0

section .text
  _start:
    mov [initial_esp], esp
    jmp .main
 
  .read:
    mov eax, 3
    mov ebx, 0
    mov ecx, readbuf
    mov edx, BUF_SIZE
    int 80h
    ret

  .check_input:
    mov eax, 0
    mov [loop_ctr], eax
    .bracket_loop:
      mov eax, [loop_ctr]
      cmp eax, BUF_SIZE                ; Are we done looping? 
      je .done

      mov ecx, [loop_ctr]
      mov eax, [readbuf+ecx]          ; Get the current character in the buffer
      inc ecx
      mov [loop_ctr], ecx             ; Increment the counter

      ; From here, we branch based on the current character.
      cmp al, '('
      je .open
      cmp al, '['
      je .open
      cmp al, '{'
      je .open
      jmp .not_open
      .open:
        push eax
      .not_open:
      cmp al, ')'
      je .close_round
      cmp al, ']'
      je .close_square
      cmp al, '}'
      je .close_curly
      .continue:

      cmp al, 0     ; Since the buffer was zeroed, reaching a zero means
                    ; we've probably reached the end of user input.
      je .done      ; So jump to the end.

      jmp .bracket_loop

    .reached_end:
      jmp .bracket_loop
    .close_round:
      pop eax                          ; This should be a '('
      cmp al, '(' 
      jne .fail
      jmp .continue
    .close_square:
      pop eax
      cmp al, '['
      jne .fail
      jmp .continue
    .close_curly:
      pop eax
      cmp al, '{'
      jne .fail
      jmp .continue
  .main:
    call .read
    jmp .check_input

  .done:
    cmp [initial_esp], esp
    je .success
    jmp .fail

  ; Print an error message saying the brackets were invalid.
  .fail:
    mov eax, 4
    mov ebx, 1
    mov ecx, fail_msg
    mov edx, FAIL_MSG_SIZE
    int 80h
    jmp .exit

  ; Print an error message about improper nesting.
  .improper_nesting:
    mov eax, 4
    mov ebx, 1
    mov ecx, nest_msg
    mov edx, NEST_MSG_SIZE
    int 80h
    jmp .exit
  
  ; On success, just print the buffer. 
  .success:
    mov eax, 4
    mov ebx, 1
    mov ecx, readbuf
    mov edx, BUF_SIZE
    int 80h
    jmp .exit

  ; exit() system call.
  .exit:
    mov eax, 1
    mov ebx, 0
    int 80h
