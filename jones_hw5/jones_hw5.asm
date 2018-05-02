global _start

BUF_SIZE equ 1000

section .bss
    readbuf resb BUF_SIZE

section .data
    round_ctr  dd 0
    square_ctr dd 0
    curly_ctr  dd 0
    fail_msg   db "Some brackets don't match.",10
    FAIL_MSG_SIZE equ $ - fail_msg
    nest_msg   db "Some brackets aren't nested properly.",10
    NEST_MSG_SIZE equ $ - nest_msg
    curr_char  db 0
    loop_ctr   dd 0

section .text
  _start:
    jmp .main
 
  .do_read:
    mov eax, 3
    mov ebx, 0
    mov ecx, readbuf
    mov edx, BUF_SIZE
    int 80h
    ret

  .do_write:
    mov eax, 4
    mov ebx, 1
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
      mov [curr_char], al
      inc ecx
      mov [loop_ctr], ecx             ; Increment the counter

      cmp al, '('    ; Is it a `(` ?
      je .inc_rb 
      cmp al, ')'    ; Is it a `)` ?
      je .dec_rb

      cmp al, '['    ; Is it a `[` ? 
      je .inc_sb
      cmp al, ']'    ; Is it a `]` ?
      je .dec_sb

      cmp al, '{'   ; Is it a `{` ?
      je .inc_cb
      cmp al, '}'   ; Is it a `}` ?
      je .dec_cb

      cmp al, 0     ; Is this the end of the message?
      je .done

      jmp .bracket_loop

    .reached_end:
      jmp .bracket_loop
    .inc_rb:
      mov eax, [round_ctr]
      inc eax
      mov [round_ctr], eax
      jmp .bracket_loop
    .dec_rb:
      mov eax, [round_ctr]
      dec eax
      test eax, eax
      js .improper_nesting ; If the counter ever goes negative, fail
      mov [round_ctr], eax
      jmp .bracket_loop
    .inc_sb:
      mov eax, [square_ctr]
      inc eax
      mov [square_ctr], eax
      jmp .bracket_loop
    .dec_sb:
      mov eax, [square_ctr]
      dec eax
      test eax, eax
      js .improper_nesting ; If the counter ever goes negative, fail
      mov [square_ctr], eax
      jmp .bracket_loop
    .inc_cb:
      mov eax, [curly_ctr]
      inc eax
      mov [curly_ctr], eax
      jmp .bracket_loop
    .dec_cb:
      mov eax, [curly_ctr]
      dec eax
      test eax, eax
      js .improper_nesting ; If the counter ever goes negative, fail
      mov [curly_ctr], eax
      jmp .bracket_loop
     

  .main:
    call .do_read
    jmp .check_input

  .done:
    ; We've counted up all the brackets so now we need to check if they match.
    mov ecx, 0
    cmp ecx, [round_ctr]
    jne .fail
    cmp ecx, [square_ctr]
    jne .fail
    cmp ecx, [curly_ctr]
    jne .fail
    
    jmp .success

  .fail:
    mov eax, 4
    mov ebx, 1
    mov ecx, fail_msg
    mov edx, FAIL_MSG_SIZE
    int 80h
    jmp .exit

  .improper_nesting:
    mov eax, 4
    mov ebx, 1
    mov ecx, nest_msg
    mov edx, NEST_MSG_SIZE
    int 80h
    jmp .exit
   
  .success:
    mov eax, 4
    mov ebx, 1
    mov ecx, readbuf
    mov edx, BUF_SIZE
    int 80h
    jmp .exit

  .exit:
    mov eax, 1
    mov ebx, 0
    int 80h
