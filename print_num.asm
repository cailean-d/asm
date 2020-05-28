  print_num:
    mov ah, 0x0e
    add al, 48             ; offset, convert num to char
    int 0x10
    ret
