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
	imul dword [c]
	idiv dword [b]
	movsx rcx, eax

	;second term
	movsx rax, word [d]
	imul word [b]
	idiv word [e]
	movsx rsi, eax

	;third term
	movsx rax, dword [c]
	imul word [c]
	movsx rdi, eax
	movsx rax, dword [a]
	imul word [d]
	movsx rbx, eax
	movsx rax, edi
	idiv bx

	;adding up all terms
	movsx rbx, esi
	sub ebx, eax
	js incorrect_sub
	jmp adding
adding:
	add ebx, ecx
	mov [answer], rbx

	jmp exit
incorrect_sub:
	movsx rdi, ebx
	mov rbx, rdi
	jmp adding
exit:
	mov eax, 1
	int 0x80
