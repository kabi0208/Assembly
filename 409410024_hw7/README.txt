程式內容：
	先生成亂數傳入data.txt，讀入data.txt後再按照要求進行計算，輸出到output.txt，並計算每一部份所花費的時間。
	
	
執行環境：
	CPU型號：i7-9750H CPU
	已安裝記憶體：24.0 GB
	作業系統：Windows 10 家用版

Non-SIMD version執行時間：
	read data：59966300
	computation：18258900
	write data：4200900
SIMD version執行時間：
	read data：51845800
	computation：7454100
	write data：3929200

如何編譯程式 (編譯時所下的參數)：
	hw7.c(nonsimd)：gcc hw7.c -lrt
	hw7simd.c(simd)：gcc -msse4 hw7simd.c -lrt
	(-lrt用於clock_gettime()中，-msse4用於編譯simd函式)

如何執行程式:
	./a.out

使用了哪些指令:
	_mm_mul_ps()
	_mm_add_ps()
	皆為SSE指令