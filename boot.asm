; boot sector

  ; int 0x10 		      - screen-related interrupts
  ; ah <- 0x0e      	- bios scrolling teletype routine   
  ; al <- ascii char	- char to display
  
  ; simple function call

  mov bp, 0x8000
  mov sp, bp

  mov al, 'h'
  call print_func
  mov al, 'i'
  call print_func
  mov al, ' '
  call print_func

  jmp $			          ; $ - current address, endless loop

  print_func:
    mov ah, 0x0e
    int 0x10
    ret

  times 510-($-$$) db 0	 ; padding, fill 510 zeros
  dw 0xaa55		 ; boot sector signature 

