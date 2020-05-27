; boot sector

  ; int 0x10 		- screen-related interrupts
  ; ah <- 0x0e  	- bios scrolling teletype routine   
  ; al <- ascii char	- char to display

  mov ah, 0x0e		; enable teletype mode

  mov al, 'h'
  int 0x10
  mov al, 'e'
  int 0x10
  mov al, 'l'
  int 0x10
  mov al, 'l'
  int 0x10
  mov al, 'o'
  int 0x10
  mov al, ' '
  int 0x10
  mov al, 't'
  int 0x10
  mov al, ' '
  int 0x10

  jmp $			; $ - current address, endless loop

  times 510-($-$$) db 0	 ; padding, fill 510 zeros
  dw 0xaa55		 ; boot sector signature 

