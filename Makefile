fizzbuzz.out: fizzbuzz.o
	ld -o fizzbuzz fizzbuzz.o

fizzbuzz.o: fizzbuzz.asm
	nasm -f elf64 -l fizzbuzz.lst fizzbuzz.asm -o fizzbuzz.o

clean:
	rm fizzbuzz fizzbuzz.o fizzbuzz.lst
