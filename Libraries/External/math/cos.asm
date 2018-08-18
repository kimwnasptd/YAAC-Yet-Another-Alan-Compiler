; double cos (double d);
; ----------------------
; This function returns the cosine of a real number.

; KNOWN BUGS !!!
; 1. Does not handle exceptions.

              section .code
              global _cos

_cos    push    rbp
        mov     rbp, rsp
        fld     tword [rbp+16]
        fcos                            ; cos(x)
        pop     rbp
        ret
