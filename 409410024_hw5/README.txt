程式內容：
hw4_test.s:
	我先在data section分配好array的位置，
	在text section再決定要在array裡面放入的值及array size
	讓r0存array size，r1存原本的array address
	然後跳過去執行NumSort(r0回傳新array的位置)並測試sort的結果(因為我覺得在register檢查會更方便一點)
	最後再呼叫printf function分別印出input array跟result array
numsort.s:
	先用malloc得到新array的空間跟位置並把位置存在r11
	把array內的內容copy到新的array裡面，再對新的array做bubble sort
	每次讓陣列中未排序的最大值移到未排序值的最右邊，做array size-1次
	使陣列中的值由小到大排列。
	最後再讓r0存到新的array address並return


關於編譯執行等的部分：
首先打開wsl
在cd到適當位置後輸入 ./bin/arm-none-eabi-gcc -g hw5_test.s numsort.s -o hw5.exe 產生exe執行檔
去點XLaunch讓Xserver 常駐run在當前windows環境
再回到wsl頁面輸入 ./bin/arm-none-eabi-insight 執行insight debugger
視窗出現後點左上角 File -> Open 打開執行檔
再打開 View -> Registers (方便觀察)
點左上角 File -> Target Selection 把Target改成Simulator然後按ok
按下Run後透過單步執行(Next)邊執行邊觀察Registers視窗看值的變化
(在程式執行到bl NumSort那行的時候，改按step(s)就可以跳到numsort.s那個檔案
看numsort是怎麼執行的)
打開 View -> Console (Console Window)觀測印出結果是否正確