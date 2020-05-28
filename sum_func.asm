  ; add(short a, short b) -> short

  sum_func:
    ; func prologue
    push bp
    mov bp, sp

    ; save used registers
    push ax

    ; do some work, adding 2 numbers
    mov ax, [bp+6]  ; take a param 
    add ax, [bp+8]  ; take b param
    mov [bp+4], ax  ; save it to return address
 
    ; restore used regisers
    pop ax    
    ; func epilogue
    pop bp
    ret
