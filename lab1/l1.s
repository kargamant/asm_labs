section .data

a:
	dd 3
b:
	dw 6
c:
	dd 4
d:
	dw 5
e:
	dd 15
first:
	dw 1
second:
	dw 1
third:
	dw 1
answer:
	dw 1

section .text
global _start
_start:
	mov rax, [a]
	mul dword [c]
	div word [b]
	mov [first], rax

	mov rax, [d]
	mul word [b]
	div dword [e]
	mov [second], rax

	mov rax, [c]
	mul dword [c]
	mov [third], rax
	mov rax, [a]
	mul word [d]
	mov rbx, rax
	mov rax, [third]
	div ebx
	mov rbx, [second]
	sub rbx, rax
	add rbx, [first]

	jmp exit
exit:
	mov rax, 1
	int 0x80
