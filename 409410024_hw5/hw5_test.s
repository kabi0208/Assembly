/*================================*/
/*       DATA section             */
/*================================*/
	.data

/* arr : 100 elements array */

/* --- variable arr --- */
	.type arr, %object
arr:
	.space 400, 0	/* 400個bytes = 100個word (打100個 .word 0也是同等效果) */
/* --- print用的 --- */
	.align 4
a:
	.ascii "Input array: "
b:
	.ascii "Result array: "
c:
	.asciz "%d\n"
d:
	.ascii "%d, \0"

/*================================*/
/*       TEXT section             */
/*================================*/
	.section .text
	.global main
	.type main,%function
	.extern printf

.matrix:	/* linker把abc的位置存放過來(知道3個的開始位置) */
	.word arr	/* 原本的array */

.string:
	.word a
	.word b
	.word c
	.word d
main:
	MOV ip, sp
	STMFD sp!, {fp,ip,lr,pc}
	SUB fp, ip, #4

	/* prepare input array */
	adr r0, .matrix
	ldr r0, .matrix		/* 讓r0指到陣列的第一個位置 */

	/* 把值依序存入 */
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

	/* put array size into r0 */
	ldr r0, =#9

	/* put array address into r1 */
	ldr r1, .matrix

	bl NumSort	/* return r0 存放排序好的新陣列的位置 */
	mov r11, r0	/* 把新陣列位置存到r11 */
	/* ---end of your function--- */
	ldmia r0, {r2-r10} 	/* 測試sort是否有做好 */

	/* print "Input array: " */
	mov r3, #13	/* 要print的總長度 */
	ldr r1, .string	/* r1存要印出的第一個位置 */
	b inputarray
inputarray:
	mov r0, #0x3	/* #define AngelSWI_Reason_WriteC 0x03 */
	cmp r3, #0	/* 剩餘長度等於零則代表印完了 */
	swigt 0x123456
	addgt r1, r1, #1	/* 印完這個就把位置移到下一個做準備 */
	subgt r3, r3, #1	/* 每印一個把長度-1 */
	bgt inputarray		/* 如果剩餘長度大於零則繼續印 */

	/* print num */
	mov r4, #9	/* 要print的數字個數(array size) */
	ldr r0, .string+12	/* r0存要印出的樣子 */
	ldr r7, .matrix		/* 把要印陣列的第一個位置存在r7 */
	b printarr
	
printarr:
	cmp r4, #0	/* 剩餘長度等於零則代表印完了 */
	subgt r4, r4, #1	/* 每印一個把長度-1 */
	ldrgt r1, [r7], #4	/* 把當前要印數字load到r1 */
	bl printf	/* 呼叫printf */

	/* 如果是該陣列最後一個數字則要印出%d\n */
	/* 因為printf會使r0-r3值發生改變所以要重新存r0的值 */
	cmp r4, #1	
	ldrle r0, .string+8
	ldrgt r0, .string+12
	cmp r4, #0
	bgt printarr	/* 如果剩餘長度大於零則繼續印 */

/* print Result array*/
	mov r3, #14
	mov r0, #0x3
	ldr r1, .string+4
	b resultarray
resultarray:
	mov r0, #0x3	/* #define AngelSWI_Reason_WriteC 0x03 */
	cmp r3, #0	/* 剩餘長度等於零則代表印完了 */
	swigt 0x123456
	addgt r1, r1, #1	/* 印完這個就把位置移到下一個做準備 */
	subgt r3, r3, #1	/* 每印一個把長度-1 */
	bgt resultarray		/* 如果剩餘長度大於零則繼續印 */

	/* print num */
	mov r4, #9	/* 要print的數字個數(array size) */
	ldr r0, .string+12	/* r0存要印出的樣子 */
	mov r7, r11	/* 把要印陣列的第一個位置存在r7 */
	b printarrnew
	
printarrnew:
	cmp r4, #0	/* 剩餘長度等於零則代表印完了 */
	subgt r4, r4, #1	/* 每印一個把長度-1 */
	ldrgt r1, [r7], #4	/* 把當前要印數字load到r1 */
	bl printf	/* 呼叫printf */

	/* 如果是該陣列最後一個數字則要印出%d\n */
	/* 因為printf會使r0-r3值發生改變所以要重新存r0的值 */
	cmp r4, #1	
	ldrle r0, .string+8
	ldrgt r0, .string+12
	cmp r4, #0
	bgt printarrnew	/* 如果剩餘長度大於零則繼續印 */

	nop
	LDMEA fp, {fp,sp,pc}
	.end
