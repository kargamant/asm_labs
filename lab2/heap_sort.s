section .data
n:
	dd 10
mas:
	dd 255, -7, 33, -9, 5, 25, 0, -9, 1, 3
	;255, -7, 33, -9, 5, 25, 0, -9, 1, 3
	;5, -9, 0
section .text
global _start

_start:
	mov eax, [n]
	mov ebx, mas
	cmp eax, 2
	je two_elements
	cmp eax, 1
	je end
	mov ebp, 2
	div ebp
	mov ecx, eax
	dec ecx
	mov r10d, [n]
	mov eax, [n]
	cmp eax, 3
	je inct
	jmp building_heap
inct:
	inc ecx
	jmp building_heap
two_elements:
	mov edi, [rbx]
	cmp edi, [rbx+4]
	jg change
	jmp end
change:
	xchg edi, [rbx+4]
	mov [rbx], edi
	jmp end

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
	cmp eax, r10d
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
	cmp eax, r10d
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
	mov edx, [rbx+rcx*4]
	mov [rbx], edx
	mov [rbx+rcx*4], ebp
	mov edi, 0
	mov r10d, ecx
	jmp heapify
sort_iter:
	loop sorting
end:
	mov eax, 60
	mov edi, 0
	syscall
