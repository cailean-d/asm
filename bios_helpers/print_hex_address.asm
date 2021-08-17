  print_hex_address:
    mov cl, 12            ; shift counter, 1000 -> 3 = 0001 
    ; print '0x' before binary numbers  
    mov al, '0'
    call print_char
    mov al, 'x'
    call print_char

   .loop:
    mov ax, dx            ; temp var to get higher  bit
    shr ax, cl
    and ax, 0xf
    call print_hex_num
    sub cl, 4
    cmp cl, 0
    jge .loop
    ret
