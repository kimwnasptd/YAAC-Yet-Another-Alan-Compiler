	.text
	.file	"<string>"
	.globl	hello                   # -- Begin function hello
	.p2align	4, 0x90
	.type	hello,@function
hello:                                  # @hello
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movabsq	$8022916924116329800, %rax # imm = 0x6F57206F6C6C6548
	movq	%rax, 11(%rsp)
	movb	$0, 23(%rsp)
	movl	$560229490, 19(%rsp)    # imm = 0x21646C72
	leaq	11(%rsp), %rdi
	callq	writeString
	addq	$24, %rsp
	retq
.Lfunc_end0:
	.size	hello, .Lfunc_end0-hello
	.cfi_endproc
                                        # -- End function

	.section	".note.GNU-stack","",@progbits
