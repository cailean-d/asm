; boot sector

 ;[org 0x7c00]
  [bits 16]

  ; prepare stack frame
  mov bp, 0x7c00    ; 30kb memory available down to 0x500
  mov sp, bp

  mov bx, 0x7c0
  mov ds, bx        ; set data segment 

  ; save boot drive
  mov [BOOT_DRIVE], dl

  %include "clear_screen.asm"
  %include "reset_cursor.asm"
  %include "reset_drive.asm"
  %include "read_second_sector.asm"  

  mov bx, disk_error_msg
  call print_string
  call print_ln

  ; jump to 2nd sector if no error
  jnc disk_success

  disk_error:
    mov al, [disk_error_msg]
    call print_char
    jmp end
  
  disk_success:
    ; jump to 2nd sector, absolute address 
    jmp 0x7e00:0x00

  end:

    jmp $			              ; endless loop    

  disk_error_msg: db 'Cannot read disk sector', 0
  BOOT_DRIVE: db 0

  %include "sum_func.asm"
  %include "print_hex_address.asm"
  %include "print_bin_address.asm"
  %include "print_dec_address.asm"
  %include "print_hex_num.asm"
  %include "print_dec_num.asm"
  %include "print_char.asm"
  %include "print_string.asm"
  %include "print_ln.asm"
  
  times 510-($-$$) db 0	   ; padding, fill zeros
  dw 0xaa55		             ; boot sector signature 
  
  mov ah, 0x0e
  mov al, 'G'
  int 0x10
  jmp $

  times 512 db 'V'
  times 512 db 'M'

