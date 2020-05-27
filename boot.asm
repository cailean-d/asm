; boot sector

  ; int 0x10 		- screen-related interrupts
  ; ah <- 0x0e  	- bios scrolling teletype routine   
  ; al <- ascii char	- char to display
  
  [org 0x7c00]

  mov ah, 0x0e		; enable teletype mode

  ; secret guess
  mov al, [secret]
  int 0x10

  jmp $			; $ - current address, endless loop

  secret:
    db "X"

  times 510-($-$$) db 0	 ; padding, fill 510 zeros
  dw 0xaa55		 ; boot sector signature 

