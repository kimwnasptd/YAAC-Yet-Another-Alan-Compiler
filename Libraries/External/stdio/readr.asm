; double readReal ();
; -------------------
; This function reads a real number from the standard input
; and returns it.  A whole line (of up to MAXSTRING characters)
; is actually read by a call to readString.  Leading spaces are
; ommited.  If the line does not contain a valid number, 0.0 is
; returned (same behaviour as 'atof' in C).


MAXSTRING     equ 256
REALSIZE      equ 10

            section   .text
            global    _readReal
            extern    _readString
            extern    _parseReal

_readReal   push    rbp
            mov     rbp, rsp
            push    rsi
            sub     rsp, 16
            mov     rdi, MAXSTRING
            lea     rsi, [inpstr]
            call    _readString


            mov     rdi, rsi            ; buffer as first argument
            mov     r8, 10              ; base 10
            call    _parseReal          ; result in xmm0
            movupd  [rbp-16], xmm0
            fld     tword [rbp-16]
            
            add     rsp, 16
            pop     rsi
            pop     rbp
            ret

                section .bss

inpstr  resb  MAXSTRING
