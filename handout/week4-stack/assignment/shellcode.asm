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

; store the string 'hello, world' on the stack
push byte  0x0A         ; push '\0' onto the stack
push dword 0x646C726F   ; push 'dlro' onto the stack
push dword 0x77202C6F   ; push 'w ,o' onto the stack
push dword 0x6C6C6568   ; push 'lleh' onto the stack

; print 'hello, world'
add edx, 13     ; size argument
mov ecx, esp    ; address argument, stack pointer
add ebx, 1      ; file descriptor argument (stdout)
add eax, 4      ; syscall argument
int 0x80        ; call SYSCALL_write

nop
nop
nop
nop
nop
nop
nop
nop
nop
nop

