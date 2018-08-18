; double sqrt (double d);
; -----------------------
; This function returns the square root of a real number.

; KNOWN BUGS !!!
; 1. Does not check whether the number is non negative.
; 2. Does not handle exceptions.


            section .code
            global  _sqrt

_sqrt       push    rbp
            mov     rbp, rsp
            fld     tword [rbp+16]
            fsqrt
            pop     rbp
            ret
