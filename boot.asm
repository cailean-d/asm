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

  ; secret guess
  mov al, secret
  int 0x10

  mov al, [secret]
  int 0x10

  mov bx, secret
  add bx, 0x7c00
  mov al, [bx]
  int 0x10 

  mov al, [0x7c1e]
  int 0x10

  jmp $			; $ - current address, endless loop

  secret:
    db "X"

  times 510-($-$$) db 0	 ; padding, fill 510 zeros
  dw 0xaa55		 ; boot sector signature 

