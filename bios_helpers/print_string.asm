  ; bx - pointer to string
  print_string:
  push bx
  push ax
  .loop:
    cmp [bx], byte 0
    je .end
    mov al, byte [bx]
    call print_char
    add bx, 1
    jmp .loop
  .end:
  pop ax
  pop bx
    ret

