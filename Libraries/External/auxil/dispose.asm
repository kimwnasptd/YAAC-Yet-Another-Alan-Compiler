; [polymorphic in T]
; void _dispose (T * pointer);
; ----------------------------
; This function deallocates the memory that is pointed to by the
; given pointer.  Undefined behaviour if this memory has not been
; allocated by a call to _new.

; KNOWN BUGS !!!
; 1. Does not deallocate :-)


                
            section   .code
            global    __dispose

__dispose:
             ret                ; do nothing !!!
