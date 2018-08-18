; double fabs (double d);
; -----------------------
; This function returns the absolute value of a real number.


        section .code
        global _fabs
        

_fabs       push    rbp
            mov     rbp, rsp
            fld     tword [rbp+16]
            fabs
            pop     rbp
            ret
