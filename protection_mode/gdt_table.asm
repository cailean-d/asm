
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