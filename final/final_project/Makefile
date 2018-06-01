OBJS = main.o factorial.o atoi.o itoa.o count_digits.o
NASM = nasm -f elf -g -F stabs
EXES = main

all: $(EXES)

clean: 
	rm $(OBJS) $(EXES)

main: $(OBJS)
	ld -o main $(OBJS) 

main.o: main.asm
	$(NASM) main.asm

factorial.o: factorial.asm
	$(NASM) factorial.asm

atoi.o: atoi.asm
	$(NASM) atoi.asm

itoa.o: itoa.asm
	$(NASM) itoa.asm

count_digits.o: count_digits.asm
	$(NASM) count_digits.asm

