global _start
section .data
    x: db 0
    y: db 0
    z: db 0
    a: db 0

section .text
    _start:
    ; Step 1
    mov [x], byte 2                    ; Write 2 to x.

    ; Step 2
    mov al, [x]                        ; Get x so we can do math to it.
    add al, 4                          ; al = x + 4
    mov [y], al                        ; Write al to y.

    ; Step 3
    mov al, [y]                        ; Get y so we can do math to it.
    mov bl, [x]                        ; Get x so we can do math to it.
    add bl, 1                          ; Increment bl to get x + 1.
    sub al, bl                         ; Subtract bl from al to get y - (x+1)
    mov [z], al                        ; Write the result to z.

    ; Step 4
    mov al, [y]                        ; Get y so we can do math to it.
    mov bl, 2                          ; Get 2 in a register so we can div.
    div bl                             ; Divide the contents of al by 2.
    mov bl, al                         ; Put al in bl so we can use al more.
    mov al, [x]                        ; Get x so we can do math to it.
    add al, [z]                        ; Now al = x + z
    mul bl                             ; Now al = (x + z) * (y / 2)
    mov bl, al                         ; Put al in bl so we can use al more.
    mov al, [z]                        ; Get z so we can square it.
    mul byte [z]                       ; Square it.
    add al, bl                         ; Add z^2 to our result from earlier.
    mov [a], al                        ; All done.

    ; Step 5
    mov al, [a]                        ; Get a.
    add al, [z]                        ; Add z.
    mov [x], al                        ; Write to x.

    ; Finish
    mov al, [x]
    mov bl, [y]
    mov cl, [z]
    mov dl, [a]

    ; exit()
    mov eax, 1
    mov ebx, 0
    int 80h
