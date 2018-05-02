SHELL = /bin/sh

jones_hw5 : jones_hw5.o
	ld -s -o jones_hw5 jones_hw5.o

jones_hw5.o : jones_hw5.asm
	nasm -f elf jones_hw5.asm

clean :
	rm jones_hw5 jones_hw5.o
