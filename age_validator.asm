section .data
    prompt_msg db "Type your age: " ; The string to display
    prompt_len equ $ - prompt_msg   ; Calculate length automatically

section .bss
    age_buffer resb 3               ; Reserve 3 bytes: 2 for digits + 1 for newline (\n)

section .text
    global _start

_start:
    ; --- Step 1: Display the Prompt ---
    ; sys_write(stdout=1, buffer=prompt_msg, length=prompt_len)
    mov rax, 1           ; syscall number for sys_write
    mov rdi, 1           ; file descriptor 1 is stdout
    mov rsi, prompt_msg  ; pointer to our message
    mov rdx, prompt_len  ; number of bytes to write
    syscall

    ; --- Step 2: Read User Input ---
    ; sys_read(stdin=0, buffer=age_buffer, length=3)
    mov rax, 0           ; syscall number for sys_read
    mov rdi, 0           ; file descriptor 0 is stdin
    mov rsi, age_buffer  ; where to store the typed characters
    mov rdx, 3           ; read up to 3 bytes (e.g., '1', '8', '\n')
    syscall

validate_age:
    ; --- Step 3: Compare Input to "18" ---
    ; Note: x86 is Little-Endian. 
    ; The string "18" is stored as 0x31 ('1') then 0x38 ('8').
    ; When loaded into the 16-bit AX register, it becomes 0x3831.
    
    mov ax, [age_buffer] ; Load the first two bytes into the AX register
    cmp ax, 0x3831       ; Compare against "18" in Little-Endian hex
    
    jl access_denied     ; If the input is "less than" 18 (e.g., "17"), jump to exit
    ; If the input is 18 or greater, code continues here...

access_denied:
    ; --- Step 4: Exit Program ---
    ; sys_exit(return_code=0)
    mov rax, 60          ; syscall number for sys_exit
    xor rdi, rdi         ; set rdi to 0 (successful exit)
    syscall
