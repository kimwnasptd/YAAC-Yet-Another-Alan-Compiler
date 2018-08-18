; [polymorphic in T]
; T * _new (int size);
; --------------------
; This function allocates 'size' bytes of memory space in the heap
; and returns a pointer to it.  It returns the 'nil' pointer if no
; memory can be allocated.

; KNOWN BUGS !!!
; 1. Does not attempt to reuse disposed memory.


            section .code
            global  __new
            extern  sbrk
            extern  brk

__new       push    rbp
            mov     rbp, rsp
            push    rdi
            mov     edi, 0
            call    sbrk                      ; will put current heap break in rax
            pop     rdi
            push    rax                       ; store current heap break to return to user
            and     rdi, 0xffff
            add     rdi, rax                  ; determine new location for heap break
            call    brk
            or      rax, rax                  ; check if the allocation was successful
            je      success                     
            pop     rax                       ; if not, return 0x0 (NULL)
            xor     rax, rax
            jmp     final
success     pop     rax                       ; otherwise return old heap break
final       pop     rbp
            ret
