VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; ebx - pointer to string
print_string_prot:
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