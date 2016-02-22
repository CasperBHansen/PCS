;
; Proactive Computer Security
; Assignment 2, Shellcode
; Casper B. Hansen, fvx507
;

[bits 32]

; int3

; zero registers
xor eax, eax
xor ebx, ebx
xor edx, edx

; store string "Hello, World!" on the stack
push word 0x0A21        ; push '\0!' to the stack
push dword 0x646C726F   ; push 'dlro' to the stack
push dword 0x57202C6F   ; push 'W ,o' to the stack
push dword 0x6C6C6548   ; push 'lleH' to the stack

; print the "Hello, World!" string
add edx, 14     ; argument size
mov ecx, esp    ; address argument, stack-pointer
add ebx, 1      ; file descriptor argument (STDOUT)
add eax, 4      ; syscall argument
int 0x80        ; call SYSCALL_write

; zero registers
xor eax, eax
xor ebx, ebx
xor edx, edx


mov ebx, esp    ; address argument, stack-pointer

; exit
xor eax, eax    ; zero eax register
mov al, 1       ; syscall argument
int 0x80        ; call SYSCALL_exit
