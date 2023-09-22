我的程式內容如下：
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

我是分四次做要matrix c中的四個值。r1-r4存的是當前計算需要用到的matrix A的值，r5-r8存的是當前計算需要用到的matrix B的值(按順序)。
每次計算完後就先存好算出來的值，再把r1-r8更新成下一次計算要用到的值，然後做下一次運算。
其中運算的部分其實4次都是一樣的，所以我寫了一個副函式calculate並用bl來運作。最後再讓r1指到c的起始位置，並檢查是否有放對
(雖然透過看memory好像也可以檢查但我還是想再做一次)

關於編譯執行等的部分：
首先打開wsl
在cd到適當位置後輸入 ./bin/arm-none-eabi-gcc -g -O0 hw3.s -o hw3.exe 產生exe執行檔
去點XLaunch讓Xserver 常駐run在當前windows環境
再回到wsl頁面輸入 ./bin/arm-none-eabi-insight 執行insight debugger
視窗出現後點左上角 File -> Open 打開執行檔
再打開 View -> Registers (方便觀察)
點左上角 File -> Target Selection 把Target改成Simulator然後按ok
按下Run後透過單步執行(Next)邊執行邊觀察Registers視窗看值的變化