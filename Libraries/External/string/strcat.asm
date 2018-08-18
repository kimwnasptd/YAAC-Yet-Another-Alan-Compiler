; void strcat (char * trg, char * src);
; -------------------------------------
; This function concatenates the null terminated strings
; trg and src. The result is stored in trg. Pointers to
; both strings are passed. String src is left untouched.
; It is assumed that trg has enough space to hold the
; result of the concatenation.


            section .code
            global  _strcat

_strcat     push    rbp
            mov     rbp, rsp
            push    rdi
            push    rsi
loop1:
            mov     dl, byte [rdi]        ; Find the end of trg
            or      dl, dl
            jz      loop2
            inc     rdi
            jmp     short loop1
loop2:
            mov     dl, byte [rsi]        ; Until the end of src
            or      dl, dl
            jz      ok
            mov     byte [rdi], dl        ; Append characters
            inc     rsi
            inc     rdi
            jmp     short loop2
ok:
            xor     dl, dl                   ; Append final 0
            mov     byte [rdi], dl
            pop     rsi
            pop     rdi
            pop     rbp
            ret
