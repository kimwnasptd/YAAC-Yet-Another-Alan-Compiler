; void writeReal (double d);
; --------------------------
; This function prints a real number to the standard output.


            section .code
            global  _writeReal
            extern  _formatReal
            extern  _writeString

_writeReal:
            push    rbp
            mov     rbp, rsp
            push    rdi
            push    rsi
            movupd  xmm0, [rbp+16]

            mov     r8, 0x00050000
            lea     rdi, [buffer]
            call    _formatReal
            
            lea     rdi, [buffer]
            call    _writeString 
            pop     rsi
            pop     rdi
            pop     rbp
            ret


            section .bss

buffer  resb 32
