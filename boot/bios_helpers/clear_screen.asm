bios_clear_screen:
  mov ax, 0x0700
  mov bh, 0x07
  mov dx, 0x184f
  int 0x10
  ret
