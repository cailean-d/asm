bios_print_hex_num:
  cmp al, 10
  jge .ischar
  add al, '0'
  jmp .print  
  .ischar:
  add al, 87
  .print:
  call bios_print_char
  ret
