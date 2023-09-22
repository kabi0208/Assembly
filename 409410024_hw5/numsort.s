	.section .text
	.global NumSort
	.type NumSort,%function
	.extern malloc

NumSort:
	/* function start */
	STMFD sp!,{r1-r10,fp,ip,lr}	/* 把原來狀態存起來 */
	
	/* --- begin your function --- */
	/* Get array size from r0 */
	mov r9, r0
	/* Get array address from r1 */
	mov r10, r1
	/* malloc一個100個整數(100*4=400)的空間 */
	mov r0, #400	
	bl malloc
	and r11,r0,r0	/* 讓r11存新陣列的位置 */
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

	/* put result array's address into r0*/
	mov r0, r12
	/* --- end of your function ---*/
	/* function exit */
	LDMFD sp!, {r1-r10,fp,ip,pc}	/* 把原來狀態restore回來 */
	.end
