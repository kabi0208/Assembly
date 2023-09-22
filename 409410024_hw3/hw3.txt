/*================================*/
/*       DATA section             */
/*================================*/
	.data

/* a : 2x4 matrix b : 4x2 matrix c : 2x2 matrix c = bxa */

/* --- variable a --- */
	.type a, %object
a:
	.word 1		/* A(1,1) := 1 */
	.word 2		/* A(1,2) := 2 */
	.word 3		/* A(1,3) := 3 */
	.word 4		/* A(1,4) := 4 */
	.word 5		/* A(2,1) := 5 */
	.word 6		/* A(2,2) := 6 */
	.word 7		/* A(2,3) := 7 */
	.word 8		/* A(2,4) := 8 */

/* --- variable b --- */
	.type b, %object
b:
	.word 1		/* B(1,1) := 1 */
	.word 2		/* B(1,2) := 2 */
	.word 3		/* B(1,3) := 3 */
	.word 4		/* B(1,4) := 4 */
	.word 5		/* B(2,1) := 5 */
	.word 6		/* B(2,2) := 6 */
	.word 7		/* B(2,3) := 7 */
	.word 8		/* B(2,4) := 8 */

/* --- variable c --- */
	.type c, %object
c:
	.space 16, 0	/* 16個bytes = 4個word (打4個 .word 0也是同等效果) */

/*================================*/
/*       TEXT section             */
/*================================*/
	.section .text
	.global main
	.type main,%function

.matrix:	/* linker把abc的位置存放過來(知道3個的開始位置) */
	.word a
	.word b
	.word c

calculate:
	ldr r10, =#0		/* r10 := 0 */
	mul r11, r1, r5		/* r11 := r1 * r5 */
	add r10, r10, r11	/* r10 := r10 + r11 */
	mul r11, r2, r6		/* r11 := r2 * r6 */
	add r10, r10, r11	/* r10 := r10 + r11 */
	mul r11, r3, r7		/* r11 := r3 * r7 */
	add r10, r10, r11	/* r10 := r10 + r11 */
	mul r11, r4, r8		/* r11 := r4 * r8 */
	add r10, r10, r11	/* r10 := r10 + r11 */

	str r10, [r9], #4	/* mem32[r9] := r10 (將結果存入第一個c的位置) (並把base+4移動到下一個位置) */
	mov pc,lr

main:
	adr r0, .matrix

	ldr r0, .matrix		/* 從.matrix的位置load一個word到r0暫存器(a的位置) */
	ldmia r0!, {r1-r4}	/* 把r0依序指到位置的值存入r1-r4(做完一個r0=r0+4然後再做下一個) */

	ldr r12, .matrix + 4	/* r12 := b的位置 */
	ldmia r12!, {r5-r8}	/* 把r12依序指到位置的值存入r5-r8(做完一個r12=r12+4然後再做下一個) */

	ldr r9, .matrix + 8	/* r9 := c的位置(為運算後存放做準備) */
	
	/* 算C(1,1)的值 */
	bl calculate
	
	/* 算C(1,2)的值 (要改r5-r8的值)*/
	ldmia r12!, {r5-r8}	/* r5 := B(2,1) r6:= B(2,2) 以此類推 */
	bl calculate

	/* 算C(2,1)的值 (r1-r8的值都要改)*/
	ldmia r0!, {r1-r4}	/* 把r0依序指到位置的值存入r1-r4(做完一個r0=r0+4然後再做下一個) */

	ldr r12, .matrix + 4	/* r12 := b的位置 */
	ldmia r12!, {r5-r8}	/* 把r12依序指到位置的值存入r5-r8(做完一個r12=r12+4然後再做下一個) */
	bl calculate	

	/* 算C(2,2)的值 (要改r5-r8的值)*/
	ldmia r12!, {r5-r8}	/* r5 := B(2,1) r6:= B(2,2) 以此類推 */
	bl calculate


	ldr r1, .matrix + 8	/* 讓r1指到c的起始位置 */
	ldmia r1, {r5-r8}	/* 檢查有沒有算對 */
	
	nop
	.end
