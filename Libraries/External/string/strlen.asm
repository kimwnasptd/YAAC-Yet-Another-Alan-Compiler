; int strlen (char * s);
; ----------------------
; This function returns the number of characters in the null
; terminated string s. A pointer to the string is passed.
; The last character (that is the null) is not counted.


            section .code
            global  _strlen

_strlen     push    rbp
            mov     rbp, rsp
            push    rdi
            xor     cx, cx                ; counter = 0
next:
            mov     dl, byte [rdi]        ; Load next character
            or      dl, dl
            jz      ok                    ; until it is 0
            inc     rdi
            inc     cx                    ; counter++
            jmp     short next
ok:
            mov     ax, cx
            and     rax, 0xffff
            pop     rdi
            pop     rbp
            ret
