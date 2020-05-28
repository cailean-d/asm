; boot sector

  [org 0x7c00]

  %include "clear_screen.asm"
  %include "reset_cursor.asm"

  mov bp, 0x8000    ; stack 1024 bytes
  mov sp, bp

  mov dx, 0x8000
  call print_hex_address
  
  jmp $			              ; $ - current address, endless loop
  
  %include "print_hex_address.asm"
  %include "print_hex_num.asm"
  %include "print_address.asm"
  %include "print_num.asm"
  %include "print_char.asm"
  %include "print_ln.asm"
  
  times 510-($-$$) db 0	   ; padding, fill 510 zeros
  dw 0xaa55		             ; boot sector signature 

