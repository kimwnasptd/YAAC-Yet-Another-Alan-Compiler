; bool readBoolean ();
; --------------------
; This function reads a boolean from the standard input.
; A whole line (of up to MAXSTRING characters) is actually
; read by a call to readString.  The result is true if the
; first character of the line is a 't', ignoring case.
; Leading spaces are also ignored.



                section .code

                MAXSTRING   equ 256
                global  _readBoolean
                extern  _readString

_readBoolean    push    rbp
                mov     rbp, rsp
                push    rsi
                mov     rdi, MAXSTRING
                lea     rsi, [inpstr]
                call    _readString
                xor     rax, rax                    ; value = false
loop1:
                mov     cl, byte [rsi]              ; Skip leading blanks
                inc     rsi
                cmp     cl, 0x20
                jz      loop1
                cmp     cl, 0x09
                jz      loop1
                or      cl, 0x20                    ; Convert to lower case
                cmp     cl, 't'                     ; Check for 't'
                jnz     store
                mov     rax, 1                      ; value = true
store:
                pop     rsi
                pop     rbp
                ret

                section .bss

inpstr      resb   MAXSTRING
