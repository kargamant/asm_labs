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
	mov r11d, [n]
	mov eax, [m]
	mov ebx, matr
matr_iteration:
	dec r11
	mov r12, matr
	add r12, r11
	add r12, r11
	add r12, r11
	add r12, r11
	mov ebx, r12d
	cmp r11, 0
	jne heap_sort
	jmp end
heap_sort:
	cmp eax, 2
	je two_elements
	cmp eax, 1
	je matr_iteration
	mov ebp, 2
	div ebp
	mov ecx, eax
	dec ecx
	mov r10d, [n]
	mov r13d, [m]
	mov eax, [m]
	cmp eax, 3
	je inct
	jmp building_heap
inct:
	inc ecx
	jmp building_heap
two_elements:
	mov edi, [rbx]
	cmp edi, [rbx+4*rax]
	jg change
	jmp matr_iteration
change:
	xchg edi, [rbx+4*rax]
	mov [rbx], edi
	jmp matr_iteration

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
	cmp eax, r13d
	mov eax, [m]
	mov ebx, r12d
	jg next

	;counitng index
	pop rax
	mul r10
	mov ebp, [rbx+4*rax] ;left neighbour
	push rax
	mov rax, rsi
	mul r10
	cmp ebp, [rbx+4*rax]
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
	cmp eax, r13d
	mov eax, [m]
	mov ebx, r12d
	jg check_largest_change

	;counting index
	pop rax
	mul r10
	mov ebp, [rbx+4*rax] ;right neighbour
	push rax
	mov rax, rsi
	mul r10
	cmp ebp, [rbx+4*rax]
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
	mov rax, rsi
	mul r10
	mov ebp, [rbx+4*rax]
	mov rax, rdi
	mul r10
	mov edx, [rbx+4*rax]
	mov rax, rsi
	mul r10
	mov [rbx+4*rax], edx
	mov rax, rdi
	mul r10
	mov [rbx+4*rax], ebp

	mov edi, esi
	jmp heapify
	

building_heap:
	mov edi, ecx
	jmp heapify
next:
	cmp r8, 1
	je sort_iter
	cmp r9, 1
	je end_loop
	loop building_heap
	mov r9, 1
	jmp building_heap
end_loop:	
	mov ecx, eax
	dec ecx
sorting:
	mov r8, 1
	;swap 0 and i
	mov ebp, [rbx]
	mov rax, rcx
	mul r10
	mov edx, [rbx+4*rax]
	mov [rbx], edx
	mov [rbx+4*rax], ebp
	mov edi, 0
	mov r13d, ecx
	jmp heapify
sort_iter:
	loop sorting
end:
	mov eax, 60
	mov edi, 0
	syscall
