; char chr (int n);
; -----------------
; This function returns the character corresponding to an ASCII code.
; Only the lower 8 bits of the parameter are considered, thus the
; parameter should be a number between 0 and 255.


              section .code
              global  _chr

_chr          push   rbp
              mov    rbp, rsp
              mov    ax, di                   ; 1st parameter
              and    rax, 0xff
              pop    rbp
              ret
