; void writeChar (char c);
; ------------------------
; This function prints a character to the standard output.


            section .code
            global  _writeChar

_writeChar  push  rbp
            mov   rbp, rsp
            or    dil, dil
            jz    ok
normal:
            sub     rsp, 2
            mov     byte [rsp], dil
            mov     byte [rsp+1], 0x0A
            mov     rax, 1                 ; write syscall
            mov     rdi, 1                 ; to stdout
            lea     rsi, [rsp]             ; location of character to print in mem
            mov     rdx, 1                 ; print 1 character
            syscall
            add     rsp,2
ok:
            pop   rbp
            ret
