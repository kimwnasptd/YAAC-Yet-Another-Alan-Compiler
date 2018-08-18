; function formatReal (var buffer : array of char; r : real;
;                      width, precision, flags, base : byte) : byte
; -----------------------------------------------------------------
; This procedure formats a real number for printing.

            section .code
            global _formatReal
            extern _formatInteger

POINT_CHAR  equ  '.'
CHAR_MINUS  equ  '-'
CHAR_EXP    equ  'e'         


_formatReal:
            push    rbp
            mov     rbp, rsp
            push    rdi
            push    rsi
            sub     rsp, 40
            movupd  [rbp - 32], xmm0
            movupd  [rbp - 16], xmm0
            fld     tword [rbp - 16]
            fxam
            fstsw   ax
            and     ax, 0x4700
            test    ax, 0x4000
            js      .empty
            test    ax, 0x0200
            jz      .chck
            mov     byte [rdi], CHAR_MINUS
            inc     rdi
            mov     word [rbp - 40], -1
            fimul   word [rbp - 40]
            fstp    tword [rbp - 16]
            fld     tword [rbp - 16]
            movupd  xmm0, [rbp - 16]
.chck:
            cmp     ax, 0x0100              ; + NaN
            je      .nan
            cmp     ax, 0x0300              ; - NaN
            je      .nan
            cmp     ax, 0x0500              ; +inf
            je      .inf
            cmp     ax, 0x0700              ; -inf
            je      .inf
            call    .putIntegerIntoMemory
            mov     r9, r8
            and     r9, 0x00ff0000
            shr     r9, 16                  ; r9b contains desired precision
            cmp     r9, 0
            je      .restoreAndFinish
            mov     byte [rdi], POINT_CHAR
            inc     rdi
            mov     word [rbp - 40], 10
            fstp    tword [rbp - 16]
.prep:
            fstcw   [rbp - 38]
            mov     ax, word [rbp - 38]
            push    rax
            and     ax, 0xf3ff
            or      ax, 0x0c00
            mov     word [rbp - 38], ax
            fldcw   [rbp - 38]              ; set to truncate
            mov     word [rbp - 38], 0
.fractDigit:
            fld     tword [rbp - 16]
            fisub   word [rbp - 38]
            fimul   word [rbp - 40]
            fstp    tword [rbp - 16]
            fld     tword [rbp - 16]
            frndint
            fistp   word [rbp - 38]
            mov     al, byte [rbp - 38]
            call    near .writeSingle
            dec     r9b
            jnz     .fractDigit
            jmp     .lastDigit
.empty:
            mov     byte [rdi], 0x65
            inc     rdi
            mov     byte [rdi], 0x6d
            inc     rdi
            mov     byte [rdi], 0x70
            inc     rdi
            mov     byte [rdi], 0x74
            inc     rdi
            mov     byte [rdi], 0x79
            inc     rdi
            jmp     .restoreAndFinish
.nan:
            mov     byte [rdi], 0x6e
            inc     rdi
            mov     byte [rdi], 0x61
            inc     rdi
            mov     byte [rdi], 0x6e
            inc     rdi
            jmp     .restoreAndFinish
.inf:            
            mov     byte [rdi], 0x69
            inc     rdi
            mov     byte [rdi], 0x6e
            inc     rdi
            mov     byte [rdi], 0x66
            inc     rdi
            jmp     .restoreAndFinish
.lastDigit:
            cmp     byte [printAsExp], 1
            jne     .writeNull
            mov     byte [rdi], CHAR_EXP
            inc     rdi
            mov     si, word [expPart]
            call    _formatInteger
            and     rax, 0xffff
            add     rdi, rax
            mov     byte [rdi], 0x0
            sub     rdi, rax
            dec     rdi                       ; point at 'e' char so that finalization works properly
            jmp     .afterNull
.writeNull:
            mov     byte [rdi], 0x0
.afterNull:
            fld     tword [rbp - 16]
            fisub   word [rbp - 38]
            fimul   word [rbp - 40]
            frndint
            fistp   word [rbp - 38]
            mov     r9w, word [rbp - 38]
.restore:
            pop     rax
            mov     word [rbp - 38], ax
            fldcw   word [rbp - 38]
.shouldFinalize:
            dec     rdi
            add     rsp, 40
            pop     rsi
            pop     r11                     ; @IMPORTANT: $r11 now contains $rdi's original value
.finalize:
            mov     al, byte [rdi]
            cmp     al, POINT_CHAR
            je      .back
            cmp     r9w, 5
            jb      .finish
            inc     al
            cmp     al, 0x3a
            jne      .writeBack
            mov     byte [rdi], 0x30
.back:
            dec     rdi
            cmp     rdi, r11
            je      .finish
            jmp     .finalize
.writeBack:
            mov     byte [rdi], al
            mov     rdi, r11
            jmp     .finish
.restoreAndFinish:
            add     rsp, 40
            pop     rsi
            pop     rdi
.finish:
            pop     rbp
            ret

.writeSingle:
            push    rbp
            mov     rbp, rsp
            add     al, 0x30
            mov     byte [rdi], al
            inc     rdi
            pop     rbp
            ret

.putIntegerIntoMemory: 
            push    rbp 
            mov     rbp, rsp
            sub     rsp, 34
            movupd  [rbp - 34], xmm0
            fstcw   [rbp - 10]
            mov     ax, word [rbp - 10]
            push    rax
            and     ax, 0xf3ff
            or      ax, 0x0c00
            mov     word [rbp - 10], ax
            fldcw   [rbp - 10]                     ;set to truncate
            mov     r9w, 0
            mov     word [rbp - 8], 10
            fild    word [rbp - 8]
            fstp    dword [rbp - 8]
            mov     r11, 0x8000000000000000
.checkTrunc:
            frndint
            fistp   qword [rbp - 18]
            mov     rax, qword [rbp - 18]
            cmp     rax, r11
            jne     .iMMaybeDone
            mov     byte [printAsExp], 1
.singleDig:
            fld     tword [rbp - 34]
            fdiv    dword [rbp - 8]
            fstp    tword [rbp - 34]
            fld     tword [rbp - 34]
            inc     r9w
            fld     dword [rbp - 8]
            fcomp
            fstsw   [rbp - 10]
            mov     ax, word [rbp - 10]
            and     ax, 0x4500
            jz      .bigAdjust
            fstp    st0
            jmp     .singleDig
.iMMaybeDone:
            mov     r10, qword [rbp - 18]
            push    rbx
            push    r8
            call    .writeToMemory
            pop     r8
            pop     rbx
            cmp     r9w, 0
            je      .return
            fld     tword [rbp - 34]      ;number whose integer part we want gone is now on top of stack   
            fild    qword [rbp - 18]
            fsub    st1, st0
            fstp    st0
.fixAndTrunc:
            fimul   word [rbp - 8]
            dec     r9w
            cmp     r9w, 0
            je      .checkTrunc
            jmp     .fixAndTrunc
.bigAdjust:
            frndint
            fistp   qword [rbp - 18]
            mov     r10, qword [rbp - 18]
            push    rbx
            push    r8
            call    .writeToMemory
            pop     r8
            pop     rbx
            mov     word [expPart], r9w
.return:
            fld     tword [rbp - 34]
            fild    qword [rbp - 18]
            fsub    st1, st0
            fstp    st0
            pop     rax
            mov     word [rbp - 10], ax
            fldcw   [rbp - 10]
            add     rsp, 34
            pop     rbp
            ret
            

.writeToMemory:
            push    rbp
            mov     rbp, rsp
            push    rdx
            mov     rax, 0xde0b6b3a7640000
            mov     r8, 0
            mov     bx, 0
.digit:
            cmp     r10, rax
            jb      .mWriteDigit
            inc     bx
            sub     r10, rax
            jmp     .digit
.mWriteDigit:
            cmp     bx, 0
            jne     .writeDigit
            cmp     r8, 0
            je      .nextDigit
.writeDigit:
            add     bl, 0x30
            mov     r8, 1
            mov     byte [rdi], bl
            inc     rdi
            mov     bx, 0
.nextDigit:
            mov     rbx, 10
            mov     rdx, 0
            div     rbx
            cmp     rax, 0
            je      .finWrite
            mov     rbx, 0
            cmp     rax, 1
            jne     .digit
            mov     r8, 1
            jmp     .digit
.finWrite:  
            pop     rdx
            pop     rbp
            ret

            section .bss
printAsExp  resb    1
expPart     resb    2
