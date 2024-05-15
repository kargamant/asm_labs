all:
	gcc -g -c main.c -o main.o
	gcc -g -c -O3 image_rotation.c -o image_rotation.o
	nasm -g -f elf64 image_rotation_asm.s -o image_rotation_asm.o
	ld -static -z noexecstack -L /usr/lib/gcc/x86_64-linux-gnu/13 -L /lib /usr/lib/x86_64-linux-gnu/crt1.o /usr/lib/x86_64-linux-gnu/crti.o main.o image_rotation.o image_rotation_asm.o /usr/lib/x86_64-linux-gnu/crtn.o -\( -lgcc -lgcc_eh -lc -lm -\) -o main
c:
	gcc main.c stb_image_sources/stb/stb_image.h stb_image_sources/stb/stb_image_write.h image_rotation.c -o main -lm
timing:
	gcc -c main.c -o main.o
	gcc -c -O3 image_rotation.c -o image_rotation.o
	nasm -O3 -f elf64 image_rotation_asm.s -o image_rotation_asm.o
	ld -static -z noexecstack -L /usr/lib/gcc/x86_64-linux-gnu/13 -L /lib /usr/lib/x86_64-linux-gnu/crt1.o /usr/lib/x86_64-linux-gnu/crti.o main.o image_rotation.o image_rotation_asm.o /usr/lib/x86_64-linux-gnu/crtn.o -\( -lgcc -lgcc_eh -lc -lm -\) -o main

