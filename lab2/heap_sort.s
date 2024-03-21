section .data
n:
	dd 10
mas:
	dd 8, 7, 1, 9, 5, 2, 6, 0, 4, 3

section .text
global _start

_start:
	mov eax, [n]
	mov ebx, mas
	mov ebp, 2
	div ebp
	mov ecx, eax
	dec ecx
	jmp building_heap
;ebx is an array, eax is n and edi is i
;esi - largest
heapify:
	mov esi, edi
check_left_ind:
	;checking index of left neighbour
	mov eax, edi
	mov ebx, 2
	mul ebx
	inc eax
	push rax
	inc eax
	cmp eax, [n]
	mov eax, [n]
	mov ebx, mas
	jg next

	mov ebp, [rbx+(rdi*2+1)*4] ;left neighbour
	cmp ebp, [rbx+rsi*4]
	jg left_update_largest
	jmp check_right_ind
left_update_largest:
	pop rbp
	mov esi, ebp

check_right_ind:
	;checking index of right neighbour
	mov eax, edi
	mov ebx, 2
	mul ebx
	add eax, 2
	push rax
	inc eax
	cmp eax, [n]
	mov eax, [n]
	mov ebx, mas
	jg check_largest_change

	mov ebp, [rbx+(rdi*2+2)*4] ;right neighbour
	cmp ebp, [rbx+rsi*4]
	jg right_update_largest
	jmp check_largest_change
right_update_largest:
	pop rbp
	mov esi, ebp

check_largest_change:
	cmp esi, edi
	jne step
	jmp next
step:
	;swap
	mov ebp, [rbx+rsi*4]
	mov edx, [rbx+rdi*4]
	mov [rbx+rsi*4], edx
	mov [rbx+rdi*4], ebp

	mov edi, esi
	jmp heapify
	

building_heap:
	mov edi, ecx
	jmp heapify
next:
	loop building_heap
