; boot sector

  [org 0x7c00]

  %include "clear_screen.asm"
  %include "reset_cursor.asm"

  ; prepare stack frame
  mov bp, 0x8000    ; stack 1024 bytes
  mov sp, bp

  mov ax, 123 
  call print_dec_address

  jmp $			              ; $ - current address, endless loop    

  %include "sum_func.asm"
  %include "print_hex_address.asm"
  %include "print_bin_address.asm"
  %include "print_dec_address.asm"
  %include "print_hex_num.asm"
  %include "print_dec_num.asm"
  %include "print_char.asm"
  %include "print_ln.asm"
  
  times 510-($-$$) db 0	   ; padding, fill zeros
  dw 0xaa55		             ; boot sector signature 

