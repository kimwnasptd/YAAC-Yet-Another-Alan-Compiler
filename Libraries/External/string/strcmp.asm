; int strcmp (char * s1, char * s2);
; ----------------------------------
; This function compares the null terminated strings s1
; and s2. Pointers to both strings are passed. The result
; is :
;
;   -1 : if s1 < s2
;    0 : if s1 = s2
;    1 : if s1 > s2


            section .code
            global  _strcmp

_strcmp     push    rbp
            mov     rbp, rsp
            push    rdi
            push    rsi
next:
            mov     al, byte [rdi]          ; Load next character of s1
            mov     ah, byte [rsi]          ; Load next character of s2
            cmp     al, ah                  ; Compare
            jnz     ok                      ; If different, ok
            or      al, al
            jz      ok                      ; If the end of both, ok
            inc     rsi
            inc     rdi
            jmp     short next
ok:
            jb      minus                   ; Flags contain the result
            ja      plus
            xor     rax, rax                ; result = 0
            jmp     short store
minus:
            mov     ax, -1                 ; result = -1
            jmp     short store
plus:
            mov     ax, 1                  ; result
store:
            pop     rsi
            pop     rdi
            pop     rbp
            ret
