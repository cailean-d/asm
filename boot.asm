; boot sector

  [org 0x7c00]
  [bits 16]

  ; prepare stack frame
  mov bp, 0x7c00    ; 30kb memory available down to 0x500 (0x500-0x7c00)
  mov sp, bp

  ; mov bx, 0x7c0
  ; mov ds, bx        ; set data segment 

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
    jmp 0x00:0x7e00

  end:

    jmp $			              ; endless loop    

  disk_error_msg: db 'Cannot read disk sector', 0
  BOOT_DRIVE: db 0

  ; %include "sum_func.asm"
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
  
  ; ----------------------
  ; SECTOR 2 - 0x7e00
  ; ----------------------

  jmp SWITCH_TO_PROTECTION_MODE

  GDT_START:
    GDT_NULL:   ; null descriptor (8 bytes)
    dq 0x0
  ; offset 0x8
  GDT_CODE:     ; code segment descriptor | cs
    dw 0xffff   ; segment limit (bits 0-15)
    dw 0x0      ; base (bits 0-15)
    db 0x0      ; base (bits 16-23)
    ; flags: 1(present), 00(privilege), 1(descriptor type) -> 1001
    ; type flags: 1(code), 0(conforming), 1(readable), 0(accessed) -> 1010
    db 10011010b
    ; flags
    ; 1(granularity), 1(32-bit default), 0(64-bit seg), 0(AVL) -> 1100
    db 11001111b
    db 0x0      ; base (bits 24-31)
  ; offset 0x10
  GDT_DATA:     ; data segment descriptor | ds, ss, es, fs, gs
    dw 0xffff   ; segment limit (0-15)
    dw 0x0      ; base (0-15)
    db 0x0      ; base (16-23)
    ; type flags: 0(code), 0(expand down), 1(writable), 0(accessed) -> 0010
    db 10010010b
    db 11001111b
    db 0x0
  GDT_END:

  GDT_DESCRIPTOR:
    dw GDT_END - GDT_START - 1
    dd GDT_START

  ; some useful constant for segment registers
  ; when we set DS = 0x10, thats mean offset from GDT
  CODE_SEG equ GDT_CODE - GDT_START
  DATA_SEG equ GDT_DATA - GDT_START

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

    ; code segment
    ; mov ax, CODE_SEG
    ; mov cs, ax

    ; update stack
    mov ebp, 0x90000
    mov esp, ebp

    ; sti   ; enable interrupts

    mov ebx, hello_msg
    call print_string_prot
    jmp $

 
  %include "protection_mode/print_string_prot.asm"

  hello_msg: db 'Hello from protection mode', 0

  times 512 db 'V'
  times 512 db 'M'

