[bits 32]

section .bss
key_buffer resb 256
head       resb 1
tail       resb 1

section .text
global ps2_init
global ps2_handler
global ps2_getkey
global ps2_has_key

; -------------------------
; INIT
; -------------------------
ps2_init:
    ; enable keyboard
    mov al, 0xAE
    out 0x64, al
    ret

; -------------------------
; INTERRUPT HANDLER (IRQ1)
; -------------------------
ps2_handler:
    pusha

    in al, 0x60

    ; release (key up) kodlarını at (0x80 üstü)
    cmp al, 0x80
    jae .done

    ; buffer push (overflow koruma)
    mov bl, [head]
    mov bh, bl
    inc bl

    cmp bl, [tail]
    je .done          ; buffer dolu → drop

    mov [key_buffer + ebx], al
    mov [head], bl

.done:
    ; PIC EOI
    mov al, 0x20
    out 0x20, al

    popa
    iret

; -------------------------
; HAS KEY (non-blocking)
; AL = 1 varsa, 0 yoksa
; -------------------------
ps2_has_key:
    mov al, [head]
    cmp al, [tail]
    jne .yes
    xor al, al
    ret
.yes:
    mov al, 1
    ret

; -------------------------
; GET KEY (blocking)
; AL = scan code
; -------------------------
ps2_getkey:
.wait:
    call ps2_has_key
    cmp al, 1
    jne .wait

    mov bl, [tail]
    mov al, [key_buffer + ebx]

    inc bl
    mov [tail], bl

    ret