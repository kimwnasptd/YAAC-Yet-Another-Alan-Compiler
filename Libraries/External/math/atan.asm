; double atan (double d);
; -----------------------
; This function returns the arc tangent of a real number.

; KNOWN BUGS !!!
; 1. Does not handle exceptions.


        section .code

        global _atan

_atan   push         rbp
        mov          rbp, rsp
        fld          tword [rbp+16]
        fld1
        fpatan
        pop          rbp
        ret
