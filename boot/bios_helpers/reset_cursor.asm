bios_reset_cursor:
  mov ah, 0x2
  mov bh, 0x0
  mov dx, 0x0000
  int 0x10
  ret