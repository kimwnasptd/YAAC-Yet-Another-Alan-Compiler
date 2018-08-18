; void writeBoolean (bool b);
; ---------------------------
; This function prints a boolean to the standard output.
; One of the strings 'true' and 'false' is printed.

str_true    db  'true',10
true_len    equ $-str_true
str_false   db  'false',10
false_len   equ $-str_false

            section .code
            global  _writeBoolean

_writeBoolean push  rbp
              mov   rbp, rsp
              push  rsi
              mov   rax, 1              ; write
              mov   r8b, dil
              mov   rdi, 1              ; to stdout
              or    r8b, r8b            ; check if arg is true or false
              jnz   par_true
              lea   rsi, [str_false]    ; and load appropriate string for printing
              mov   rdx, false_len
              jmp   short ok
par_true:
              lea   rsi, [str_true]
              mov   rdx, true_len
ok:
              syscall
              pop   rsi
              pop   rbp
              ret
