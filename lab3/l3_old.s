section .data
buff:
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
len:
	dd 0
str:
	db 0

section .text
global _start

_start:
	mov r9, 1
reading:
	dec r9

	mov rax, 0
	mov rdi, 0
	mov rsi, buff
	mov rdx, 10
	syscall
	mov rcx, rax
	dec rcx
	mov [len], rcx
	push rax
form_str:
	mov r8, [buff+rcx]
	mov [str+rcx+r9], r8
	dec rcx
	cmp rcx, -1
	je new_begin
	jmp form_str
new_begin:
	pop r9
	cmp r9, 10
	je reading
	jmp writing
writing:
	mov ecx, [len]
	mov [str+rcx], byte 10
	inc ecx
	mov [len], ecx

	mov rax, 1
	mov rdi, 1
	mov rsi, str
	mov edx, [len]
	syscall

	mov rax, 60
	mov rdi, 0
	syscall
