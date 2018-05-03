SHELL = /bin/sh

encoder : encoder.o
	ld -s -o encoder encoder.o

encoder.o : encoder.asm
	nasm -f elf encoder.asm

clean :
	rm encoder encoder.o
