; boot sector

  [org 0x7c00]
  [bits 16]

  jmp START

  KERNEL_OFFSET equ 0x1000
  LOAD_SECTORS equ 15

  disk_error_msg: db 'Cannot read disk sector', 0
  real_mode_msg: db 'Started in 16-bit Real Mode', 0
  prot_mode_msg: db 'Successfully landed in 32-bit Protected Mode', 0
  load_kernel_msg: db 'Loading kernel into memory', 0
  BOOT_DRIVE: db 0

  %include "bios_helpers/print_string.asm"
  %include "bios_helpers/print_char.asm"
  %include "bios_helpers/print_ln.asm"
  %include "protection_mode/gdt_table.asm"

  ; some useful constant for segment registers
  ; when we set DS = 0x10, thats mean offset from GDT
  CODE_SEG equ GDT_CODE - GDT_START
  DATA_SEG equ GDT_DATA - GDT_START

  START:

  ; prepare stack frame
  mov bp, 0x7c00    ; 30kb memory available down to 0x500 (0x500-0x7c00)
  mov sp, bp

  ; save boot drive
  mov [BOOT_DRIVE], dl

  ; clear screen
  %include "bios_helpers/clear_screen.asm"
  %include "bios_helpers/reset_cursor.asm"

  mov bx, real_mode_msg
  call print_string
  call print_ln

  %include "bios_helpers/reset_drive.asm"
  %include "bios_helpers/load_kernel.asm"  

  ; if no disk errors
  jnc SWITCH_TO_PROTECTION_MODE

  disk_error:
    mov bx, disk_error_msg
    call print_string
    jmp $

  
  SWITCH_TO_PROTECTION_MODE:
    cli   ; disable interrupts
    lgdt [GDT_DESCRIPTOR]   ; load gdt table

    ; set 1st bit of cr0 to switch mode
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    
    jmp CODE_SEG:INIT_PROTECTION_MODE

  
  [bits 32]

  INIT_PROTECTION_MODE:
    ; update segment registers
    ; data segments
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; update stack
    mov ebp, 0x90000
    mov esp, ebp

    ; call kernel written in C
    call KERNEL_OFFSET

    jmp $

  times 510-($-$$) db 0	   ; padding, fill zeros
  dw 0xaa55		             ; boot sector signature 
 