; int round (double d);
; ---------------------
; This function converts a real number to an integer by rounding.

            section .code
            global _round

_round      push    rbp
            mov     rbp, rsp
            sub     rsp, 8
            fld     tword [rbp+16]      ; @Important: for our purposes, the size specifier should be 'tword'
            frndint
            fistp   word [rbp-8]
            mov     ax, word [rbp-8]
            and     rax, 0xffff
            add     rsp, 8
            pop     rbp
            ret
