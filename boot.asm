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

  %include "bios_helpers/clear_screen.asm"
  %include "bios_helpers/reset_cursor.asm"
  %include "bios_helpers/reset_drive.asm"
  %include "bios_helpers/read_second_sector.asm"  

  ; jump to 2nd sector if no error
  jnc disk_success

  disk_error:
    mov bx, disk_error_msg
    call print_string
    jmp end
  
  disk_success:
    ; jump to 2nd sector, absolute address 
    jmp 0x7e00:0x00

  end:

    jmp $			              ; endless loop    

  disk_error_msg: db 'Cannot read disk sector', 0
  BOOT_DRIVE: db 0

  %include "sum_func.asm"
  %include "bios_helpers/print_hex_address.asm"
  %include "bios_helpers/print_bin_address.asm"
  %include "bios_helpers/print_dec_address.asm"
  %include "bios_helpers/print_hex_num.asm"
  %include "bios_helpers/print_dec_num.asm"
  %include "bios_helpers/print_char.asm"
  %include "bios_helpers/print_string.asm"
  %include "bios_helpers/print_ln.asm"
  
  times 510-($-$$) db 0	   ; padding, fill zeros
  dw 0xaa55		             ; boot sector signature 
  
  [bits 32]  

  VIDEO_MEMORY equ 0xb8000
  WHITE_ON_BLACK equ 0x0f

  mov al, 'X'
  mov ah, WHITE_ON_BLACK
  mov [0xb8000], ax

 ; mov ebx, hello_msg
  ;call print_string
  
  jmp $

  ; ebx - pointer to string
  print_string_x:
    pusha
    mov edx, VIDEO_MEMORY
    .loop:
      mov al, [ebx]  
      mov ah, WHITE_ON_BLACK
      cmp al, 0
      je .done
      mov [edx], ax
      add ebx, 1
      add edx, 2
      jmp .loop
    .done:
      popa
      ret


  hello_msg: db 'Hello there'

  times 512 db 'V'
  times 512 db 'M'

