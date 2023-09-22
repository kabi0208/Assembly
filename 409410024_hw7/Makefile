COMPILE = gcc
option = -msse4
option2 = -lrt

hw7: hw7.c 
	$(COMPILE) hw7.c $(option2) 

hw7simd: hw7simd.c
	$(COMPILE) $(option) hw7simd.c $(option2)

clean:
	rm -f *.ex