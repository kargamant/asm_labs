all:
	nasm -g -f elf64 l4.s
	ld -static -z noexecstack -L /usr/lib/gcc/x86_64-linux-gnu/13 -L /lib /usr/lib/x86_64-linux-gnu/crt1.o /usr/lib/x86_64-linux-gnu/crti.o l4.o /usr/lib/x86_64-linux-gnu/crtn.o -\( -lgcc -lgcc_eh -lc -lm -\) -o l4
