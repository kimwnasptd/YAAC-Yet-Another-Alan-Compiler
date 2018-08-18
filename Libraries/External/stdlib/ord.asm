; int ord (char c);
; -----------------
; This function returns the ASCII code of a character.


              section .code
              global _ord

_ord          push  rbp
              mov   rbp, rsp
              mov   al, dil
              xor   ah, ah
              and   rax, 0xff
              pop   rbp
              ret
