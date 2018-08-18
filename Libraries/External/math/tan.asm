; double tan (double d);
; ----------------------
; This function returns the tangent of a real number.

; KNOWN BUGS !!!
; 1. Does not handle exceptions.
; 2. Ignores the abnormal case that 1.0 was not pushed.

            section .code
            global _tan

_tan        push    rbp
            mov     rbp, rsp
            fld     tword [rbp+16]
            fptan
            ffree   st0                 ; pop the 1.0 that is
            fincstp                     ; pushed by fptan
            pop     rbp
            ret
