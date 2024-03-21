section .data
m:
	dd 5
n:
	dd 3
matr:
	dd 2, 6, 2
	dd 4, 7, 1
	dd 8, 1, 2
	dd 3, 7, 9
	dd 7, 4, 8

section .text
global _start

_start:
	mov ecx, [n]
	mov edi, [m]
	mov ebx, matr
	jmp sort
sort:
	dec ecx

heapify:
	
		
