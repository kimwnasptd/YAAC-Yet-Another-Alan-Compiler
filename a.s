	.text
	.file	"<string>"
	.globl	convertInput            # -- Begin function convertInput
	.p2align	4, 0x90
	.type	convertInput,@function
convertInput:                           # @convertInput
	.cfi_startproc
# %bb.0:                                # %entry1
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
	subq	$48, %rsp
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rdi, -72(%rbp)
	movq	%rsi, -64(%rbp)
	movl	%edx, -48(%rbp)
	movq	%rcx, -56(%rbp)
	movl	$0, -40(%rbp)
	movl	$0, -44(%rbp)
	movb	$0, -33(%rbp)
	movq	%rbp, 8(%rcx)
	movl	$0, -40(%rbp)
	movl	$0, -44(%rbp)
	movb	$32, -33(%rbp)
	cmpl	$0, -48(%rbp)
	jle	.LBB0_12
# %bb.1:                                # %entry1
	movq	%rsi, %rbx
	cmpb	$10, (%rsi)
	je	.LBB0_12
# %bb.2:                                # %while.loop.preheader
	movq	%rdi, %r14
	.p2align	4, 0x90
.LBB0_3:                                # %while.loop
                                        # =>This Inner Loop Header: Depth=1
	cmpb	$32, -33(%rbp)
	je	.LBB0_6
# %bb.4:                                # %if.then
                                        #   in Loop: Header=BB0_3 Depth=1
	movslq	-40(%rbp), %rax
	cmpb	$32, (%rbx,%rax)
	je	.LBB0_9
# %bb.5:                                # %if.then1
                                        #   in Loop: Header=BB0_3 Depth=1
	movl	-44(%rbp), %eax
	decl	%eax
	movslq	%eax, %r15
	movl	(%r14,%r15,4), %eax
	leal	(%rax,%rax,4), %r12d
	movslq	-40(%rbp), %rax
	movzbl	(%rbx,%rax), %edi
	callq	extend@PLT
                                        # kill: def $eax killed $eax def $rax
	leal	-48(%rax,%r12,2), %eax
	movl	%eax, (%r14,%r15,4)
	jmp	.LBB0_10
	.p2align	4, 0x90
.LBB0_6:                                # %if.else
                                        #   in Loop: Header=BB0_3 Depth=1
	movslq	-40(%rbp), %rax
	cmpb	$32, (%rbx,%rax)
	je	.LBB0_9
# %bb.7:                                # %if.then2
                                        #   in Loop: Header=BB0_3 Depth=1
	movslq	-44(%rbp), %r15
	movslq	-40(%rbp), %rax
	movzbl	(%rbx,%rax), %edi
	callq	extend@PLT
	addl	$-48, %eax
	movl	%eax, (%r14,%r15,4)
	incl	-44(%rbp)
	movslq	-40(%rbp), %rax
	movzbl	(%rbx,%rax), %eax
	movb	%al, -33(%rbp)
	jmp	.LBB0_10
	.p2align	4, 0x90
.LBB0_9:                                # %if.else2
                                        #   in Loop: Header=BB0_3 Depth=1
	movb	$32, -33(%rbp)
.LBB0_10:                               # %if.exit
                                        #   in Loop: Header=BB0_3 Depth=1
	movslq	-40(%rbp), %rax
	leal	1(%rax), %ecx
	movl	%ecx, -40(%rbp)
	cmpl	-48(%rbp), %ecx
	jge	.LBB0_12
# %bb.11:                               # %if.exit
                                        #   in Loop: Header=BB0_3 Depth=1
	cmpb	$10, 1(%rbx,%rax)
	jne	.LBB0_3
.LBB0_12:                               # %while.exit
	addq	$48, %rsp
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end0:
	.size	convertInput, .Lfunc_end0-convertInput
	.cfi_endproc
                                        # -- End function
	.globl	delFromList             # -- Begin function delFromList
	.p2align	4, 0x90
	.type	delFromList,@function
delFromList:                            # @delFromList
	.cfi_startproc
# %bb.0:                                # %entry2
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	%rdi, -40(%rbp)
	movl	%esi, -8(%rbp)
	movq	%rdx, -32(%rbp)
	movq	%rcx, -24(%rbp)
	movq	%r8, -16(%rbp)
	movl	$0, -4(%rbp)
	movq	%rbp, 8(%r8)
	movslq	-8(%rbp), %rax
	movl	$0, (%rdi,%rax,4)
	decl	(%rdx)
	movl	-8(%rbp), %eax
	jmp	.LBB1_2
	.p2align	4, 0x90
.LBB1_1:                                # %while.loop1
                                        #   in Loop: Header=BB1_2 Depth=1
	movslq	-4(%rbp), %rax
	movl	4(%rdi,%rax,4), %edx
	movl	%edx, (%rdi,%rax,4)
	movl	-4(%rbp), %eax
	incl	%eax
.LBB1_2:                                # %while.loop1
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, -4(%rbp)
	cmpl	(%rcx), %eax
	jl	.LBB1_1
# %bb.3:                                # %while.exit1
	movslq	(%rcx), %rax
	movl	$0, (%rdi,%rax,4)
	decl	(%rcx)
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end1:
	.size	delFromList, .Lfunc_end1-delFromList
	.cfi_endproc
                                        # -- End function
	.globl	addToList               # -- Begin function addToList
	.p2align	4, 0x90
	.type	addToList,@function
addToList:                              # @addToList
	.cfi_startproc
# %bb.0:                                # %entry3
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	%rdi, -48(%rbp)
	movq	%rsi, -40(%rbp)
	movq	%rdx, -32(%rbp)
	movq	%rcx, -24(%rbp)
	movq	%r8, -16(%rbp)
	movl	$0, -4(%rbp)
	movq	%rbp, 8(%r8)
	movslq	(%rsi), %rax
	cmpl	$0, (%rdi,%rax,4)
	je	.LBB2_1
# %bb.3:                                # %if.else3
	movl	(%rcx), %r8d
	incl	%r8d
	jmp	.LBB2_5
	.p2align	4, 0x90
.LBB2_4:                                # %while.loop2
                                        #   in Loop: Header=BB2_5 Depth=1
	movslq	-4(%rbp), %r8
	leal	-1(%r8), %eax
	cltq
	movl	(%rdi,%rax,4), %eax
	movl	%eax, (%rdi,%r8,4)
	movl	-4(%rbp), %r8d
	decl	%r8d
.LBB2_5:                                # %while.loop2
                                        # =>This Inner Loop Header: Depth=1
	movl	%r8d, -4(%rbp)
	movl	(%rsi), %eax
	incl	%eax
	cmpl	%eax, %r8d
	jge	.LBB2_4
# %bb.6:                                # %while.exit2
	movslq	(%rsi), %rax
	movl	4(%rsi), %esi
	movl	%esi, (%rdi,%rax,4)
	incl	(%rdx)
	incl	(%rcx)
	jmp	.LBB2_7
.LBB2_1:                                # %if.then3
	movslq	(%rsi), %r8
	movl	4(%rsi), %eax
	movl	%eax, (%rdi,%r8,4)
	incl	(%rdx)
	movl	(%rcx), %eax
	cmpl	4(%rsi), %eax
	jge	.LBB2_7
# %bb.2:                                # %if.then4
	movl	4(%rsi), %eax
	movl	%eax, (%rcx)
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.LBB2_7:                                # %if.exit3
	.cfi_def_cfa %rbp, 16
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end2:
	.size	addToList, .Lfunc_end2-addToList
	.cfi_endproc
                                        # -- End function
	.globl	searchList              # -- Begin function searchList
	.p2align	4, 0x90
	.type	searchList,@function
searchList:                             # @searchList
	.cfi_startproc
# %bb.0:                                # %entry4
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	%rdi, -32(%rbp)
	movl	%esi, -12(%rbp)
	movl	%edx, -8(%rbp)
	movq	%rcx, -24(%rbp)
	movl	$0, -4(%rbp)
	movq	%rbp, 8(%rcx)
	movl	$0, -4(%rbp)
	cmpl	$0, -8(%rbp)
	js	.LBB3_3
	.p2align	4, 0x90
.LBB3_1:                                # %while.loop3
                                        # =>This Inner Loop Header: Depth=1
	movslq	-4(%rbp), %rax
	movl	(%rdi,%rax,4), %eax
	cmpl	-12(%rbp), %eax
	je	.LBB3_4
# %bb.2:                                # %if.exit5
                                        #   in Loop: Header=BB3_1 Depth=1
	movl	-4(%rbp), %eax
	incl	%eax
	movl	%eax, -4(%rbp)
	cmpl	-8(%rbp), %eax
	jle	.LBB3_1
.LBB3_3:                                # %while.exit3
	xorl	%eax, %eax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.LBB3_4:                                # %if.then5
	.cfi_def_cfa %rbp, 16
	movl	-4(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end3:
	.size	searchList, .Lfunc_end3-searchList
	.cfi_endproc
                                        # -- End function
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$504, %rsp              # imm = 0x1F8
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
.set .Lmain$frame_escape_0, -48
.set .Lmain$frame_escape_1, -44
.set .Lmain$frame_escape_2, -68
.set .Lmain$frame_escape_3, -64
.set .Lmain$frame_escape_4, -104
.set .Lmain$frame_escape_5, -96
.set .Lmain$frame_escape_6, -88
.set .Lmain$frame_escape_7, -52
.set .Lmain$frame_escape_8, -60
.set .Lmain$frame_escape_9, -56
	movl	$0, -48(%rbp)
	movl	$0, -44(%rbp)
	movl	$0, -68(%rbp)
	movl	$0, -64(%rbp)
	movl	$0, -124(%rbp)
	movq	$0, -132(%rbp)
	movq	$0, -140(%rbp)
	movl	$0, -72(%rbp)
	movq	$0, -80(%rbp)
	movq	$0, -292(%rbp)
	movq	$0, -300(%rbp)
	movq	$0, -308(%rbp)
	movq	$0, -316(%rbp)
	movq	$0, -324(%rbp)
	movq	$0, -332(%rbp)
	movq	$0, -340(%rbp)
	movq	$0, -348(%rbp)
	movq	$0, -356(%rbp)
	movq	$0, -364(%rbp)
	movq	$0, -372(%rbp)
	movq	$0, -380(%rbp)
	movq	$0, -388(%rbp)
	movq	$0, -396(%rbp)
	movq	$0, -404(%rbp)
	movq	$0, -412(%rbp)
	movq	$0, -420(%rbp)
	movq	$0, -428(%rbp)
	movq	$0, -436(%rbp)
	movq	$0, -444(%rbp)
	movq	$0, -452(%rbp)
	movq	$0, -460(%rbp)
	movq	$0, -468(%rbp)
	movq	$0, -476(%rbp)
	movq	$0, -484(%rbp)
	movq	$0, -492(%rbp)
	movq	$0, -500(%rbp)
	movq	$0, -508(%rbp)
	movq	$0, -516(%rbp)
	movq	$0, -524(%rbp)
	movq	$0, -532(%rbp)
	movq	$0, -540(%rbp)
	movq	$0, -148(%rbp)
	movq	$0, -156(%rbp)
	movq	$0, -164(%rbp)
	movq	$0, -172(%rbp)
	movq	$0, -180(%rbp)
	movq	$0, -188(%rbp)
	movq	$0, -196(%rbp)
	movq	$0, -204(%rbp)
	movq	$0, -212(%rbp)
	movq	$0, -220(%rbp)
	movq	$0, -228(%rbp)
	movq	$0, -236(%rbp)
	movq	$0, -244(%rbp)
	movq	$0, -252(%rbp)
	movq	$0, -260(%rbp)
	movq	$0, -268(%rbp)
	movq	$0, -276(%rbp)
	movq	$0, -284(%rbp)
	movl	$0, -52(%rbp)
	movl	$0, -60(%rbp)
	movl	$0, -56(%rbp)
	movq	$0, -112(%rbp)
	movq	%rbp, -120(%rbp)
	leaq	-140(%rbp), %rax
	movq	%rax, -104(%rbp)
	leaq	-80(%rbp), %rax
	movq	%rax, -96(%rbp)
	leaq	-540(%rbp), %rax
	movq	%rax, -88(%rbp)
	leaq	.Lstr.entry.37(%rip), %rdi
	callq	writeString@PLT
	callq	readInteger@PLT
	movl	%eax, -48(%rbp)
	leaq	.Lstr.entry.42(%rip), %rdi
	callq	writeString@PLT
	movl	-48(%rbp), %edi
	callq	writeInteger@PLT
	movl	$0, -44(%rbp)
	movl	$0, -52(%rbp)
	movl	$0, -60(%rbp)
	cmpl	$0, -48(%rbp)
	jle	.LBB4_3
# %bb.1:                                # %while.loop4.preheader
	leaq	-140(%rbp), %rbx
	leaq	-80(%rbp), %r15
	leaq	-120(%rbp), %r12
	leaq	-60(%rbp), %r14
	leaq	-52(%rbp), %r13
	.p2align	4, 0x90
.LBB4_2:                                # %while.loop4
                                        # =>This Inner Loop Header: Depth=1
	movl	$20, %edi
	movq	%rbx, %rsi
	callq	readString@PLT
	leaq	.Lstr.while.loop4.57(%rip), %rdi
	callq	writeString@PLT
	movq	%rbx, %rdi
	callq	writeString@PLT
	movq	%rbx, %rdi
	callq	strlen@PLT
	movq	%r15, %rdi
	movq	%rbx, %rsi
	movl	%eax, %edx
	movq	%r12, %rcx
	callq	convertInput@PLT
	leaq	-540(%rbp), %rdi
	movq	%r15, %rsi
	movq	%r14, %rdx
	movq	%r13, %rcx
	movq	%r12, %r8
	callq	addToList@PLT
	movl	-44(%rbp), %eax
	incl	%eax
	movl	%eax, -44(%rbp)
	cmpl	-48(%rbp), %eax
	jl	.LBB4_2
.LBB4_3:                                # %while.exit4
	leaq	.Lstr.while.exit4.67(%rip), %rdi
	callq	writeString@PLT
	callq	readInteger@PLT
	movl	%eax, -48(%rbp)
	movl	$0, -44(%rbp)
	movl	$0, -56(%rbp)
	testl	%eax, %eax
	jle	.LBB4_6
# %bb.4:                                # %while.loop5.preheader
	leaq	-540(%rbp), %r14
	leaq	-120(%rbp), %rbx
	leaq	-60(%rbp), %r15
	leaq	-52(%rbp), %r12
	leaq	-80(%rbp), %r13
	.p2align	4, 0x90
.LBB4_5:                                # %while.loop5
                                        # =>This Inner Loop Header: Depth=1
	callq	readInteger@PLT
	movl	%eax, -64(%rbp)
	movl	-52(%rbp), %edx
	movq	%r14, %rdi
	movl	%eax, %esi
	movq	%rbx, %rcx
	callq	searchList@PLT
	movl	%eax, -68(%rbp)
	addl	%eax, -56(%rbp)
	movq	%r14, %rdi
	movl	%eax, %esi
	movq	%r15, %rdx
	movq	%r12, %rcx
	movq	%rbx, %r8
	callq	delFromList@PLT
	movl	$1, -80(%rbp)
	movl	-64(%rbp), %eax
	movl	%eax, -76(%rbp)
	movq	%r14, %rdi
	movq	%r13, %rsi
	movq	%r15, %rdx
	movq	%r12, %rcx
	movq	%rbx, %r8
	callq	addToList@PLT
	movl	-44(%rbp), %eax
	incl	%eax
	movl	%eax, -44(%rbp)
	cmpl	-48(%rbp), %eax
	jl	.LBB4_5
.LBB4_6:                                # %while.exit5
	movl	-56(%rbp), %edi
	callq	writeInteger@PLT
	movl	$10, %edi
	callq	writeChar@PLT
	addq	$504, %rsp              # imm = 0x1F8
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
	.cfi_endproc
                                        # -- End function
	.type	.Lstr.entry.37,@object  # @str.entry.37
	.section	.rodata.str1.16,"aMS",@progbits,1
	.p2align	4
.Lstr.entry.37:
	.asciz	"Give me the number of imports: "
	.size	.Lstr.entry.37, 32

	.type	.Lstr.entry.42,@object  # @str.entry.42
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr.entry.42:
	.asciz	"Int: "
	.size	.Lstr.entry.42, 6

	.type	.Lstr.while.loop4.57,@object # @str.while.loop4.57
.Lstr.while.loop4.57:
	.asciz	"Got: "
	.size	.Lstr.while.loop4.57, 6

	.type	.Lstr.while.exit4.67,@object # @str.while.exit4.67
	.section	.rodata.str1.16,"aMS",@progbits,1
	.p2align	4
.Lstr.while.exit4.67:
	.asciz	"Give me the number of searches : "
	.size	.Lstr.while.exit4.67, 34


	.section	".note.GNU-stack","",@progbits
