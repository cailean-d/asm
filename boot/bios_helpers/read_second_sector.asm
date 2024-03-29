bios_read_second_sector:
  xor ax, ax
  mov ds, ax
  cld
  mov ah, 0x02 ; bios read sector
  mov dl, [BOOT_DRIVE] ; 0x00, 0x01 - floppy; 0x80, 0x81 - hard disk
  mov ch, 0 ; cylinder
  mov dh, 0 ; head
  mov cl, 2 ; sector (1:_)
  mov al, 1 ; read n sectors

  ; set segment which we want to read to [ES:BX]
  mov bx, 0x0 ; segment - right after 1st boot sector
  mov es, bx
  mov bx, 0x7e00 ; offset

  int 0x13 ; interrupt for disk routines
  ret
