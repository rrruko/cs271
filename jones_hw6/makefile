SHELL = /bin/sh

encoder decoder : encoder.o decoder.o
	ld -s -o encoder encoder.o && ld -s -o decoder decoder.o

encoder.o decoder.o : encoder.asm decoder.asm
	nasm -f elf encoder.asm && nasm -f elf decoder.asm

clean :
	rm encoder encoder.o decoder decoder.o
