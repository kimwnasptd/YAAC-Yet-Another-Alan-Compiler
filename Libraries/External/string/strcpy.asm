; void strcpy (char * trg, char * src);
; -------------------------------------
; This function copies the null terminated string src to
; the string trg. Pointers to both strings are passed.
; The previous contents of trg are destroyed. The function
; assumes that trg has enough space to hold the contents
; of src.


            section .code
            global _strcpy

_strcpy     push    rbp
            mov     rbp, rsp
            push    rdi
            push    rsi
next:
            mov     dl, byte [rsi]        ; Load next character
            mov     byte [rdi], dl        ; and store it
            or      dl, dl
            jz      ok                    ; until it is 0
            inc     rsi
            inc     rdi
            jmp     short next
ok:
            pop     rsi
            pop     rdi
            pop     rbp
            ret
