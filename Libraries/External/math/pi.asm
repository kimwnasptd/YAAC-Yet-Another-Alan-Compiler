; double pi ();
; -------------
; This function returns the real number pi (3.1415926535...).


             section .code
             global _pi

_pi          push      rbp
             mov       rbp, rsp
             fldpi
             pop       rbp
             ret
