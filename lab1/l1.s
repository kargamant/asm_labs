section .data

a:
	dd -2
b:
	dw 6
c:
	dd 327
d:
	dw 115
e:
	dd -15
answer:
	dq 1

section .text
global _start
_start:
	;first term
	movsx rax, dword [a]
	movsx rsi, dword [c]
	movsx rdi, word [b]
	imul rsi
	cqo
	idiv rdi
	push rax

	;second term
	movsx rax, word [d]
	movsx rsi, word [b]
	movsx rdi, dword [e]
	imul rsi
	cqo
	idiv rdi
	push rax

	;third term
	movsx rax, dword [c]
	imul rax
	movsx rsi, dword [a]
	movsx rdi, word [d]
	cqo
	idiv rsi
	cqo
	idiv rdi

	;adding up all terms
	pop rbx
	sub rbx, rax
	pop rax
	add rbx, rax
	mov [answer], rbx

	jmp exit
exit:
	mov eax, 1
	int 0x80
