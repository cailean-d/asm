; boot sector

  ; int 0x10 		      - screen-related interrupts
  ; ah <- 0x0e      	- bios scrolling teletype routine   
  ; al <- ascii char	- char to display
  
  ; print string

  [org 0x7c00]

  ; clear screen
  mov ax, 0x0700
  mov bh, 0x07
  mov dx, 0x184f
  int 0x10

  ; set cursor at start
  
  mov ah, 0x2
  mov bh, 0x0
  mov dx, 0x0000
  int 0x10

  mov bp, 0x8000
  mov sp, bp
  
  mov bx, hello_msg
  call print_string
  mov bx, bye_msg
  call print_string

  jmp $			          ; $ - current address, endless loop

  print_string:
    .start: 
    mov al, [bx]
    cmp al, 0
    je .done
    mov ah, 0x0e
    int 0x10
    add bx, 1
    jmp .start
    .done:
      ret

  hello_msg:
    db "hello there",0x0D,0xA,0

  bye_msg:
    db "bye my friend",0x0D,0xA,0

  times 510-($-$$) db 0	 ; padding, fill 510 zeros
  dw 0xaa55		 ; boot sector signature 

