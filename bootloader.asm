[bits 16]           ; 16-bit Real Mode (CPU default on startup)
[org 0x7c00]        ; BIOS loads the bootloader at this memory offset

_start:
    ; The BIOS does not guarantee the state of the Data Segment (DS).
    ; We zero it out to ensure all memory references are predictable.
    xor ax, ax      ; Efficient way to set AX to 0
    mov ds, ax      ; Set Data Segment to 0
    mov es, ax      ; Set Extra Segment to 0

    ; We need a safe place for the Stack. 0x7c00 is where we are,
    ; so setting the stack pointer here allows it to grow downwards safely.
    mov ss, ax
    mov sp, 0x7c00

    ; The "Halt" instruction (hlt) puts the CPU in a low-power state
    ; until the next external interrupt occurs. 
    ; The jump (jmp) ensures that even if an interrupt wakes the CPU, 
    ; it stays trapped here forever doing nothing.
idle:
    hlt             ; Sleep until next interrupt
    jmp idle        ; Repeat the sleep

; A boot sector must be exactly 512 bytes.
; '$' is the current address, '$$' is the start address.
times 510-($-$$) db 0 

; The BIOS checks for this specific "Magic Number" at the end of the 
; sector (bytes 511 and 512) to verify this is a valid boot disk.
dw 0xaa55
