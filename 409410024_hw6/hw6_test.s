.set AngelSWI, 0x123456

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
filename:
	.ascii "result.txt\000"
resultarr:
	.ascii "%d,\000" /*印出數字的格式*/
buffer:
	.space 40,0 /*sprintf's buffer*/	
space:
	.space 400,0 /*預留空白位子(第一次strcat要用)

/*================================*/
/*       TEXT section             */
/*================================*/
	.section .text
	.global main
	.type main,%function
.string:
	.word resultarr

.matrix:	/* linker把abc的位置存放過來(知道3個的開始位置) */
	.word arr	/* 原本的array */

.open_file:
	.word filename	/* The address of file name (path) */
	.word 0x4	/* Argument (Write)	*/
	.word 0x8	/* Length of file name	*/

.write_file:
	.space 4   /* file descriptor */
	.space 4   /* address of the string */
	.space 4   /* length of the string */

.close_file:
	.space 4

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


	/* open a file */
	mov r0,	#0x1	/* #SWI_Open*/
	adr r1, .open_file
	swi AngelSWI
	mov r4, r0	/* 把file descriptor存到r4 */

	/* write the result to a file */
	adr r5, .write_file	/* r5存Write a file時r1要存的東東(詳見3-5ppt) */
	str r4, [r5, #0]	/* store file descriptor */
	ldr r7,=space	/* 為等等把sprintf完的字串接起來(strcat)做準備 */
	mov r8,#0
change:
	cmp r8,#9	/* 9是array size */
	bge printarr
	/*sprintf(buffer,"%d ",num);  中buffer的位址*/
	ldr r0,=buffer 	/* butter要存進的地方 */
	ldr r1, .string /* 印出格式 */
	ldr r2,[r11,r8,LSL #2] 	/* 讀取arr中的值 */
	bl sprintf 	/* 呼叫sprintf */
	
	mov r0,r7 	/* r7=之前做好的字串 */
	ldr r1,=buffer	/* 這次產生的字串 */
	bl strcat 	/* 將前次字串跟此次的接在一起 */
	mov r7,r0 	/* 把接起來的字串給r7 */
	add r8,r8,#1
	b change
printarr:
	str r7, [r5,#4] /* 把接好的字串存去[r5,#4] */
	mov r0,r7	/* r0:=r7 */
	bl strlen 	/* 呼叫strlen(計算string長度) */
	sub r0,r0,#1 	/* 把最後一個","拿掉 */
	mov r3, r0 	/* r0:=the length of the string */
	str r3, [r5, #8]  /* 把string長度存進[r5,#8] */

	/* Write a file */
	adr r1, .write_file	/*r1 be the thing to write into file*/	
	mov r0, #0x5	/* SWI_Write */
	swi AngelSWI 	/* call AngelSWI */

	/* close a file */
	adr r1, .close_file
	str r4, [r1, #0] /* r4存file descriptor */
	
	mov r0, #0x2	/* SWI_Close */
	swi AngelSWI

	nop
	LDMEA fp, {fp,sp,pc}
	.end
