section .data

a:
	dd -1
b:
	dw 6
c:
	dd 4
d:
	dw -5
e:
	dd 15
answer:
	dq 1

section .text
global _start
_start:
	;first term
	movsx rax, dword [a]
	imul word [c]
	idiv word [b]
	movsx rcx, ax

	;second term
	movsx rax, word [d]
	imul word [b]
	idiv word [e]
	movsx rsi, eax

	;third term
	movsx rax, dword [c]
	imul dword [c]
	movsx rdi, eax
	movsx rax, dword [a]
	imul word [d]
	movsx rbx, ax
	movsx rax, edi
	idiv rbx

	;adding up all terms
	movsx rbx, esi
	sub rbx, rax
	add rbx, rcx
	mov [answer], rbx

	jmp exit
exit:
	mov eax, 1
	int 0x80
