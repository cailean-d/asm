; boot sector

[org 0x7c00]
[bits 16]

jmp START

%include "bios_helpers/print_string.asm"
%include "bios_helpers/print_char.asm"
%include "bios_helpers/print_ln.asm"
%include "bios_helpers/clear_screen.asm"
%include "bios_helpers/reset_cursor.asm"
%include "bios_helpers/reset_drive.asm"
%include "bios_helpers/load_kernel.asm"
%include "protection_mode/gdt_table.asm"

KERNEL_OFFSET equ 0x7e00    ; right after boot sector
LOAD_SECTORS  equ 50        ; 512*50 = ~25kb or kernel memory
STACK_16BIT   equ 0x7c00    ; 30kb memory available down to 0x500 (0x500-0x7c00)
STACK_32BIT   equ 0x9fc00
BOOT_DRIVE:   db  0

disk_error_msg:   db 'Cannot read disk sector', 0
real_mode_msg:    db 'Started in 16-bit Real Mode', 0
prot_mode_msg:    db 'Successfully landed in 32-bit Protected Mode', 0
load_kernel_msg:  db 'Loading kernel into memory', 0

; some useful constant for segment registers
; when we set DS = 0x10, thats mean offset from GDT
CODE_SEG equ GDT_CODE - GDT_START
DATA_SEG equ GDT_DATA - GDT_START

START:

; prepare stack frame
mov bp, STACK_16BIT
mov sp, bp

; save boot drive
mov [BOOT_DRIVE], dl

; clear screen
call bios_clear_screen
call bios_reset_cursor

mov bx, real_mode_msg
call bios_print_string
call bios_print_ln

call bios_reset_drive
call bios_load_kernel

; if no disk errors
jnc SWITCH_TO_PROTECTION_MODE

disk_error:
  mov bx, disk_error_msg
  call bios_print_string
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
  mov ebp, STACK_32BIT
  mov esp, ebp

  ; call kernel written in C
  call KERNEL_OFFSET

times 510-($-$$) db 0     ; padding, fill zeros
dw 0xaa55                 ; boot sector signature 
