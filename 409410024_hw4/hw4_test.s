/*================================*/
/*       DATA section             */
/*================================*/
	.data

/* arr : 100 elements array */

/* --- variable arr --- */
	.type arr, %object
arr:
	.space 400, 0	/* 400個bytes = 100個word (打100個 .word 0也是同等效果) */

	.type arrnew, %object
arrnew:
	.space 400, 0	/* 400個bytes = 100個word (打100個 .word 0也是同等效果) */


/*================================*/
/*       TEXT section             */
/*================================*/
	.section .text
	.global main
	.type main,%function

.matrix:	/* linker把abc的位置存放過來(知道3個的開始位置) */
	.word arr	/* 原本的array */
	.word arrnew	/* 新的array(要做sort的) */

main:
	MOV ip, sp
	STMFD sp!, {fp,ip,lr,pc}
	SUB fp, ip, #4

	/* prepare input array */
	adr r0, .matrix
	ldr r0, .matrix

	mov r1, #17
	str r1, [r0], #4	/* mem32[r0] := r1 (並把base+4移動到下一個位置) */
	mov r1, #5
	str r1, [r0], #4	/* mem32[r0] := r1 (並把base+4移動到下一個位置) */
	mov r1, #26
	str r1, [r0], #4	/* mem32[r0] := r1 (並把base+4移動到下一個位置) */
	mov r1, #92
	str r1, [r0], #4	/* mem32[r0] := r1 (並把base+4移動到下一個位置) */
	mov r1, #7
	str r1, [r0], #4	/* mem32[r0] := r1 (並把base+4移動到下一個位置) */
	mov r1, #12
	str r1, [r0], #4	/* mem32[r0] := r1 (並把base+4移動到下一個位置) */
	mov r1, #25
	str r1, [r0], #4	/* mem32[r0] := r1 (並把base+4移動到下一個位置) */
	mov r1, #73
	str r1, [r0], #4	/* mem32[r0] := r1 (並把base+4移動到下一個位置) */
	mov r1, #7
	str r1, [r0], #4	/* mem32[r0] := r1 (並把base+4移動到下一個位置) */

	/* put array size into r9 */
	ldr r9, =#9

	/* put array address into r10 */
	ldr r10, .matrix

	ldr r11, .matrix + 4	/* 讓r11存新陣列的address */
	bl NumSort

	/* ---end of your function--- */
	ldmia r10, {r1-r9} 	/* 測試sort是否有做好 */
	nop
	LDMEA fp, {fp,sp,pc}
	.end
