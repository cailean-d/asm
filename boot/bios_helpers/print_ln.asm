bios_print_ln:
  mov ah, 0x0e
  mov al, 0xd
  int 0x10
  mov al, 0xa
  int 0x10
  ret  
