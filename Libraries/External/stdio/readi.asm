; int readInteger ();
; -------------------
; This function reads an integer from the standard input
; and returns it.  A whole line (of up to MAXSTRING characters)
; is actually read by a call to readString.  Leading spaces are
; ommited.  If the line does not contain a valid number, 0 is
; returned (same behaviour as 'atoi' in C).


MAXSTRING   equ 256
INTSIZE     equ 2

                section   .text
                global    _readInteger
                extern    _readChar
                extern    _readString
                extern    _parseInteger

_readInteger    push    rbp
                mov     rbp, rsp
                push    rsi
                mov     rdi, MAXSTRING
                lea     rsi, [inpstr]
                call    .ignoreMaybeNL
                call    _readString              ; Read a string
                
                dec     rsi
                mov     rdi, rsi                 ; buffer as first argument
                lea     rsi, [readint]           ; location of read integer in memory
                mov     r8, 10                   ; base = 10
                call    _parseInteger            ; result in rax

                xor     rax, rax
                mov     ax, word [rsi]
                pop     rsi
                pop     rbp
                ret

.ignoreMaybeNL:
                push    rbp
                mov     rbp, rsp
                push    rsi
                call    _readChar
                pop     rsi
                mov     byte [rsi], al
                inc     rsi
                pop     rbp
                ret

                section .bss

inpstr  resb  MAXSTRING
readint resb  INTSIZE
