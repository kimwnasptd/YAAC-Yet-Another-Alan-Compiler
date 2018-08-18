; function parseReal (var buffer : array of char; p : ^real;
;                     base : byte) : byte
; ----------------------------------------------------------------
; This procedure parses a real number.  It ignores leading
; spaces and returns the number of characters read.
; 
;   KNOWN ISSUES
;   - overflow of the int/exponent causes a NaN to be returned

POINT_CHAR           equ  '.'
EXPONENT_LOWER_CHAR  equ  'e'
EXPONENT_UPPER_CHAR  equ  'E'
INTSIZE              equ  2

        section .code
        global _parseReal
        extern _parseInteger

_parseReal:
    	push	rbp
        push    rdi
        push    rsi
        mov	    rbp, rsp
        sub     rsp, 32
        lea     rsi, [intPart]
        mov     r8, 10
        call    _parseInteger
        cmp     rax, -1
        je      .overflow
        mov     r9, 1
        mov     r8, 0
.ignorenonfraction:
        cmp     byte [rdi], POINT_CHAR
        je      .fractioninit
        cmp     byte [rdi], 0x2d
        jne     .nonneg
        mov     byte [sign], 1
.nonneg:
        cmp     byte [rdi], 0x0
        je      .fractioninit
        inc     rdi
        jmp     .ignorenonfraction
.fractioninit:
        mov     rcx, 1
        xor     rdx, rdx
        mov     r9, 1
        mov     r10, 7
        mov     r11, 0xde0b6b3a7640000
.fraction:
        inc     rdi
        cmp     byte [rdi], 0x0
        je      .calculate
        cmp     byte [rdi], EXPONENT_LOWER_CHAR
        je      .readexp
        cmp     byte [rdi], EXPONENT_UPPER_CHAR
        je      .readexp
        cmp     rcx, r11
        je      .fraction
        xor     rax, rax
        mov     al, byte [rdi]
        sub     al, 0x30
        imul    rcx, 10
        imul    rdx, 10
        dec     r10
        add     rdx, rax
        jmp     .fraction
.readexp:
        inc     rdi
        lea     rsi, [expPart]
        mov     r8, 10
        push    r9
        call    _parseInteger
        pop     r9
        cmp     rax, -1
        je      .overflow
        xor     r8, r8
        mov     r8w, word [expPart]
        jmp     .calculate
        test    r8w, 0x8000
        jz      .pos_exp
.pos_exp:
        cmp     r8w, 0
        je      .calculatep
        imul    r9d, 10
        dec     r8w
        jz      .calculatep
        jmp     .pos_exp
.calculatep:
        cmp     r10, 0
        je      .calculate
        imul    rdx, 10
        imul    rcx, 10
        dec     r10
        jmp     .calculatep
.calculate:
        mov     qword [fraction], rdx
        fild    qword [fraction]
        mov     qword [divisor], rcx
        fild    qword [divisor]
        fdiv    st1, st0
        fstp    st0
        cmp     byte [sign], 1
        jne     .finalize
        fchs
.finalize:
        fiadd   word [intPart]
        mov     word [aux], 10
        cmp     r8w, 0
        je      .finishnormal
        jg      .exppos
.expneg:
        fidiv   word [aux]
        inc     r8w
        cmp     r8w, 0
        je      .finishnormal
        jmp     .expneg
.exppos:
        fimul   word [aux]
        dec     r8w
        cmp     r8w, 0
        je      .finishnormal
        jmp     .exppos
.finishnormal:
        fstp    tword [rbp-24]
        movupd  xmm0, [rbp-24]
        jmp     .finish
.overflow:
        fldz
        fldz
        fdiv    
        fstp    qword [rbp-24]
        movupd  xmm0, [rbp-24]
.finish:
        add     rsp, 32
        pop     rsi
        pop     rdi
        pop	    rbp
        ret

        section .bss

intPart     resb INTSIZE
expPart     resb INTSIZE
aux         resb 4
fraction    resb 8
divisor     resb 8
sign        resb 1
