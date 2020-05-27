; boot sector

  ; int 0x10 		- screen-related interrupts
  ; ah <- 0x0e  	- bios scrolling teletype routine   
  ; al <- ascii char	- char to display
  
  [org 0x7c00]

  mov ah, 0x0e		; enable teletype mode

  ; simple stack

  mov bp, 0x8000
  mov sp, bp

  push 'A'
  push 'B'
  push 'C'

  ; print C
  pop bx
  mov al, bl
  int 0x10

  ; print B
  pop bx
  mov al, bl
  int 0x10

  ; print A
  pop bx
  mov al, bl
  int 0x10

  jmp $			; $ - current address, endless loop

  secret:
    db "My awesome OS!", 0

  times 510-($-$$) db 0	 ; padding, fill 510 zeros
  dw 0xaa55		 ; boot sector signature 

