  mov bx, load_kernel_msg
  call print_string
  call print_ln  

  xor ax, ax
  mov ds, ax
  cld
  mov ah, 0x02 ; bios read sector
  mov dl, [BOOT_DRIVE] ; 0x00, 0x01 - floppy; 0x80, 0x81 - hard disk
  mov ch, 0 ; cylinder
  mov dh, 0 ; head
  mov cl, 2 ; sector (1:_)
  mov al, LOAD_SECTORS ; read n sectors

  ; set segment which we want to read to [ES:BX]
  mov bx, 0x0 ; segment - from memory start
  mov es, bx
  mov bx, KERNEL_OFFSET ; offset
  int 0x13 ; interrupt for disk routines
