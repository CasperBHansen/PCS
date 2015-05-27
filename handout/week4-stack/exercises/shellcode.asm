;
;   Proactive Computer Security
;   Assignment 2, Assembly
;
;   Author: Casper B. Hansen, fvx507@alumni.ku.dk
;
;   Description:
;   Prints the string 'hello, world\n' and calls 'execve(filename, argv, envp)'
;   with the arguments filename='/usr/bin/id' and argv={'-u'}. Redelegates the
;   return code of execve, if any.
;

[bits 32]

; zero registers
xor eax, eax
xor ecx, ecx
xor edx, edx

; call execve(const char *filename, char *const argv[], char *const envp[])
push dword eax          ; push NULL onto the stack
push dword 0x64692F2F   ; push 'di//' onto the stack, note NULL-byte workaround
push dword 0x6E69622F   ; push 'nib/' onto the stack
push dword 0x7273752F   ; push 'rsu/' onto the stack
mov ebx, esp            ; filename argument, stack pointer

push dword eax          ; push NULL onto the stack
push word 0x752D        ; push 'u-' onto the stack
mov esi, esp            ; store array address in source register ($esi)

push dword eax          ; push NULL onto the stack
push dword esi          ; push array address onto the stack
push dword ebx          ; push the filename argument address to the stack
mov ecx, esp            ; argv argument, stack pointer

push byte 11            ; push 11 (SYSCALL_execve) onto the stack
pop eax                 ; syscall argument, pop 11 (SYSCALL_execve) off of the stack into eax
int 0x80                ; call SYSCALL_execve (argument method used to show different ways)

; exit($ebx)
mov ebx, eax            ; copy the return code of execve
xor eax, eax            ; zero eax register
mov al, 1               ; syscall argument
int 0x80                ; call SYSCALL_exit

