; void writeString (char * s);
; ----------------------------
; This function prints a null terminated string to the standard output.


            section .code
            global _writeString

_writeString:
            push    rbp
            mov     rbp, rsp
            push    rdi
            push    rsi
            mov     rsi, rdi
            xor     rax, rax
calcLen:
            cmp     byte [rsi], 0x0
            jz      doPrint
            inc     rax
            inc     rsi
            jmp     calcLen
doPrint:
            mov     rsi, rdi
            mov     rdi, 1
            mov     rdx, rax
            mov     rax, 1
            syscall
ok:
            pop     rsi
            pop     rdi
            pop     rbp
            ret
