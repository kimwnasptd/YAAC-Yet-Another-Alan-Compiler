; int trunc (double d);
; ---------------------
; This function converts a real number to an integer by truncating.
; 


            section .code
            global _trunc

_trunc      push    rbp
            mov     rbp, rsp
            sub     rsp, 32
            fstcw   [rbp-28]            ; get FPU control word
            fwait
            mov     ax, word [rbp-28]   ; store it
            push    rax
            and     ax, 0xf3ff
            or      ax, 0x0c00          ; set rounding mode to truncate
            mov     word [rbp-28], ax
            fldcw   [rbp-28]
            fwait
            fld     tword [rbp+16]
            frndint                     
            fistp   word [rbp-8]
            pop     rax                 ; restore control word
            mov     word [rbp-28], ax
            fldcw   [rbp-28]
            mov     ax, word [rbp-8]
            and     rax, 0xffff
            add     rsp, 32
            pop     rbp
            ret
