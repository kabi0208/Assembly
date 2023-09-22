程式碼：
hw4_test.s:
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

numsort.s:
	.section .text
	.global NumSort
	.type NumSort,%function

NumSort:
	/* function start */
	STMFD sp!,{r0-r9,fp,ip,lr}	/* 把原來狀態存起來 */
	
	/* --- begin your function --- */
	/* Get array size from r9 */
	/* Get array address from r10 */
	ldr r2, =#0
	mov r12, r11	/* 記住r11現在的位置(存在r12) */
	b copy

	/* 把陣列內值存到新陣列(r11存新array的address) */
copy:	
	add r2, r2, #1	/* r2=r2+1(紀錄目前做到第幾個) */
	ldr r7, [r10],#4	/* 把陣列內值load到r7並更新base位置 */
	str r7, [r11],#4	/* 把值store進新陣列並更新base位置 */

	/* 若目前做過個數比array size小則遞迴做copy */
	cmp r2, r9	
	blt copy

	ldr r2, =#0
	mov r11, r12	/* 讓r11重新指到array第一個值的位置 */
	b sort
	
	/* DO NumSort */
sort:	
	add r2, r2, #1	/* r2=r2+1(紀錄目前做了幾次(sort)) */
	mov r3, r2
	mov r4, r11
	b compare

	/* 讓陣列未排序值中最大的變到陣列未排序的最右邊位置 */
compare:
	add r3, r3, #1	/* r3=r3+1(紀錄目前做了幾次(compare)) */ 

	/* 把目前r4指到的值與他的下一個值比較，若當前值比較大則兩者位置互換 */
	ldr r7,[r4]
	ldr r8,[r4,#4]
	cmp r7, r8
	strgt r7,[r4,#4]
	strgt r8,[r4]

	add r4, r4, #4	/* 讓r4指到下一個位置 */	
	
	/* 不停compare直到做的次數等於陣列未排序大小-1 */
	cmp r3, r9	
	blt compare

	/* 一直做直到做的次數等於陣列大小-1 */ 
	cmp r2, r9
	ble sort

	/* put result array's address into r10*/
	mov r10, r12
	/* --- end of your function ---*/
	/* function exit */
	LDMFD sp!, {r0-r9,fp,ip,pc}	/* 把原來狀態restore回來 */
	.end


程式內容：
hw4_test.s:
	我先在data section分配好array跟新的array的位置，
	在text section再決定要在array裡面放入的值及array size
	讓r9存array size，r10存原本的array address，r11存新的array address
	然後跳過去執行NumSort並在最後測試sort的結果(因為我覺得在register檢查會更方便一點)
numsort.s:
	我先把array內的內容copy到新的array裡面，再對新的array做bubble sort
	每次讓陣列中未排序的最大值移到未排序值的最右邊，做array size-1次
	使陣列中的值由小到大排列。
	最後再讓r10存到新的array address


關於編譯執行等的部分：
首先打開wsl
在cd到適當位置後輸入 ./bin/arm-none-eabi-gcc -g hw4_test.s numsort.s -o hw4.exe 產生exe執行檔
去點XLaunch讓Xserver 常駐run在當前windows環境
再回到wsl頁面輸入 ./bin/arm-none-eabi-insight 執行insight debugger
視窗出現後點左上角 File -> Open 打開執行檔
再打開 View -> Registers (方便觀察)
點左上角 File -> Target Selection 把Target改成Simulator然後按ok
按下Run後透過單步執行(Next)邊執行邊觀察Registers視窗看值的變化
(在程式執行到bl NumSort那行的時候，改按step(s)就可以跳到numsort.s那個檔案
看numsort是怎麼執行的)
