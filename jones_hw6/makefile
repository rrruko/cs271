SHELL = /bin/sh

jones_hw6 : jones_hw6.o
	ld -s -o jones_hw6 jones_hw6.o

jones_hw6.o : jones_hw6.asm
	nasm -f elf jones_hw6.asm

clean :
	rm jones_hw6 jones_hw6.o
