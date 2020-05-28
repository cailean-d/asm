; boot sector

  ; int 0x10 		      - screen-related interrupts
  ; ah <- 0x0e      	- bios scrolling teletype routine   
  ; al <- ascii char	- char to display
  
  [org 0x7c00]

  ; clear screen
  mov ax, 0x0700
  mov bh, 0x07
  mov dx, 0x184f
  int 0x10

  ; reset cursor
  mov ah, 0x2
  mov bh, 0x0
  mov dx, 0x0000
  int 0x10

  mov bp, 0x8000
  mov sp, bp

  mov dx, 17              ; print_address uses dx as source  
  call print_address
  call print_ln

  jmp $			              ; $ - current address, endless loop

  print_address:
    mov cl, 15            ; shift counter, 1000 -> 3 = 0001 
   
    ; print '0b' before binary numbers  
    mov al, '0'
    call print_char
    mov al, 'b'
    call print_char

   .loop:
    mov ax, dx            ; temp var to get higher  bit
    shr ax, cl
    and ax, 1
    call print_num
    sub cl, 1
    cmp cl, 0
    jge .loop
    ret

  print_num:
    mov ah, 0x0e
    add al, 48             ; offset, convert num to char
    int 0x10
    ret

  print_char:
    mov ah, 0x0e
    int 0x10
    ret
  
  print_ln:
    mov ah, 0x0e
    mov al, 0xd
    int 0x10
    mov al, 0xa
    int 0x10
    ret  
  

  times 510-($-$$) db 0	   ; padding, fill 510 zeros
  dw 0xaa55		             ; boot sector signature 

