; boot sector

  jmp $			; $ - current address, endless loop

  times 510-($-$$) db 0	 ; padding, fill 510 zeros
  dw 0xaa55		 ; boot sector signature 
  
