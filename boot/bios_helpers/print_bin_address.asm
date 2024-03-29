bios_print_bin_address:
  mov cl, 15            ; shift counter, 1000 -> 3 = 0001 
  
  ; print '0b' before binary numbers  
  mov al, '0'
  call bios_print_char
  mov al, 'b'
  call bios_print_char

  .loop:
  mov ax, dx            ; temp var to get higher  bit
  shr ax, cl
  and ax, 1
  call bios_print_dec_num
  sub cl, 1
  cmp cl, 0
  jge .loop
  ret
