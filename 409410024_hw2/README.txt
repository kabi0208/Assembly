我的程式內容如下：

	 .section .text
	.global main
	.type main,%function
main:
	ldr r1,=#10	/* r1:=10 */
	ldr r2,=#20	/* r2:=20 */
	ldr r3,=#12	/* r3:=12 */
	
	ldr r0,=#0	/* r0:=0 */
	add r0,r0,r1,lsl #1	/* r0:=r0+2*r1 */
	add r0,r0,r2,lsl #2	/* r0:=r0+4*r2 */
	add r0,r0,r3,lsl #3	/* r0:=r0+8*r3 */

	nop
	.end

先讓r0=2*r1
然後變成r0=(2*r1)+4*r2
最後就會變成r0=(2*r1+4*r2)+8*r3

關於編譯執行等的部分：
首先打開wsl
在cd到適當位置後輸入 ./bin/arm-none-eabi-gcc -g -O0 hw2.s -o hw2.exe 產生exe執行檔
去點XLaunch讓Xserver 常駐run在當前windows環境
再回到wsl頁面輸入 ./bin/arm-none-eabi-insight 執行insight debugger
視窗出現後點左上角 File -> Open 打開執行檔
再打開 View -> Registers (方便觀察)
點左上角 File -> Target Selection 把Target改成Simulator然後按ok
按下Run後透過單步執行(Next)邊執行邊觀察Registers視窗看值的變化
