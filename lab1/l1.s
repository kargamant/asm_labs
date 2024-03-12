section .data

a:
	dd 691
b:
	dw -321
c:
	dd 621
d:
	dw 946
e:
	dd -654
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
	jo overflow
	cmp rdi, 0
	je zero_division
	cqo
	idiv rdi
	push rax

	;second term
	movsx rax, word [d]
	movsx rsi, word [b]
	movsx rdi, dword [e]
	imul rsi
	jo overflow
	cmp rdi, 0
	je zero_division
	cqo
	idiv rdi
	push rax

	;third term
	movsx rax, dword [c]
	imul rax
	jo overflow
	movsx rsi, dword [a]
	movsx rdi, word [d]
	cmp rsi, 0
	je zero_division
	cqo
	idiv rsi
	cmp rdi, 0
	je zero_division
	cqo
	idiv rdi

	;adding up all terms
	pop rbx
	sub rbx, rax
	jo overflow
	pop rax
	add rbx, rax
	jo overflow
	mov [answer], rbx

	jmp exit
zero_division:
	mov rbx, 1
	mov rax, 1
	int 0x80
overflow:
	mov rbx, 2
	mov rax, 1
	int 0x80
exit:
	mov rax, 1
	int 0x80

