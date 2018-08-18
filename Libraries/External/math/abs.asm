; int abs (int n);
; ----------------
; This function returns the absolute value of an integer.

        section .code

        global _abs

_abs    push    rbp
        mov     rbp, rsp
        mov     ax, di              ; 1st parameter
        or      ax, ax              ; If it is negative
        jge     ok
        neg     ax                  ; i = -i
ok:
        and     rax, 0xffff
        pop     rbp
        ret
