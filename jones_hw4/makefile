SHELL = /bin/sh

jones_hw4 : jones_hw4.o
	ld -s -o jones_hw4 jones_hw4.o

jones_hw4.o : jones_hw4.asm
	nasm -f elf jones_hw4.asm

clean :
	rm jones_hw4 jones_hw4.o
