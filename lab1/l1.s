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
answer:
	dq 1

section .text
global _start
_start:
	mov eax, [a]
	mul dword [c]
	div word [b]
	mov ecx, eax

	movzx eax, word [d]
	mul word [b]
	div dword [e]
	mov esi, eax

	mov eax, [c]
	mul dword [c]
	mov edi, eax
	mov eax, [a]
	mul word [d]
	mov ebx, eax
	mov eax, edi
	div ebx
	mov ebx, esi
	sub ebx, eax
	add ebx, ecx
	mov [answer], ebx

	jmp exit
exit:
	mov eax, 1
	int 0x80
