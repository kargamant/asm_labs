section .data
buff:
	dq 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

section .text
global _start

_start:
	;reading
	mov rax, 0
	mov rdi, 0
	mov rsi, buff
	mov rdx, 10
	syscall
	push rax

	;writing
	mov rax, 1
	mov rdi, 1
	mov rsi, buff
	pop rdx
	syscall

	mov rax, 60
	mov rdi, 0
	syscall
