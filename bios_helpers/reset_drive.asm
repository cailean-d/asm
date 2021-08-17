  reset_disk:
    mov ah, 0x00
    mov dl, [BOOT_DRIVE]
    int 0x13
    jc reset_disk

