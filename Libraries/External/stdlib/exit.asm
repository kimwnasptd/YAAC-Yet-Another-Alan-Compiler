; void exit (int code);
; ---------------------
; This function aborts execution of the program by returning
; the given exit code to the operating system.  It never returns.
; Only the 8 lower bits of the exit code are considered, thus
; the exit code should be a number between 0 and 255.


            section .code
            global  _exit

_exit       push    rbp
            mov     rbp, rsp
            mov     rax, 60
            and     rdi, 0xffff
            syscall
