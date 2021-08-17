  ; __cdecl  add(short a, short b) -> short
  ; __cdecl  add(short a, short b, short res) -> void
  ; arguments and return address on stack

  sum_func:
    ; func prologue
    push bp
    mov bp, sp

    ; save used registers
    push ax

    ; do some work, adding 2 numbers
    ; [bp+0] = old bp, start of caller stack frame
    ; [bp+2] = address to return by ret instruction

    mov ax, [bp+6]  ; take a param 
    add ax, [bp+8]  ; take b param
    mov [bp+4], ax  ; save it to return address
 
    ; restore used regisers
    pop ax    
    ; func epilogue
    pop bp
    ret
