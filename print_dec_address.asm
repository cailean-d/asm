print_dec_address:
  ; save used registers 
  push ax
  push dx
  push cx

  mov cx, 10   ; divider
  push 0       ; null, end of string

  .loop:
  mov dx, 0    ; clear dx
  div cx       ; divide ax by 10,  ax - quotient, dx - remainder
  push dx      ; save remainders on stack
  cmp ax, 0
  jne .loop

  .print:      ; print chars from stack in desc order
    pop ax
    cmp ax, 0  ; check for end of string
    je .end
    call print_dec_num
    jmp .print
  
  .end:
  ; restore used registers
  pop cx
  pop dx
  pop ax
  ret  
