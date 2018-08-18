; double sin (double d);
; ----------------------
; This function returns the sine of a real number.

; KNOWN BUGS !!!
; 1. Does not handle exceptions.


              section   .code
              global    _sin

_sin          push      rbp
              mov       rbp, rsp
              fld       tword [rbp+16]
              fsin                            ; sin(x)
              pop       rbp
              ret
