bios_reset_drive:
  mov ah, 0x00
  mov dl, [BOOT_DRIVE]
  int 0x13
  jc bios_reset_drive
  ret

