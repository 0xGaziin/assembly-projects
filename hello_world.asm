section .data
    message db "Hello, world!", 10      ; '10' is the ASCII for New Line (\n)
    message_length equ $ - message      ; Constant to calculate the size of the string (we need to rdx)

section .text
    global _start

_start:
    MOV rax, 1
    MOV rdi, 1
    MOV rsi, message
    MOV rdx, message_length
    SYSCALL

exit:
    MOV rax, 60
    XOR rdi, rdi                        ; Return code 0 (success). 'xor' is faster than 'mov rdi, 0'
    SYSCALL
