bits 64
global rotate_image_asm 
section .data
	image dq 0
	result_w dd 0
	result_h dd 0
	result_ch dd 0
	result_offset dd 0
	result_data dq 0
	w dd 0
	h dd 0
	channels dd 0
	angle dd 0
	
	radians dq 0.0

	pi dq 3.14159
	pi_degrees dq 180.0

	img_size dd 0
	new_img_size dd 0

	temp_x dq 0.0
	temp_y dq 0.0
	new_x dd 0
	new_y dd 0
cos_res:
	db "cos: %.10lf", 10, 0
const_zero:
	dq 0.0
const_neg:
	dq -1.0
section .text

	extern printf
	extern cos
	extern sin
rotate_image_asm:
	push rbp
	mov rbp, rsp
	sub rsp, 16

	;!!! cos messes rdi, rsi, rdx, rcx !!! 
	;movsd xmm0, [pi]
	;mov rax, 1
	;call cos
	
	;!!! printf messes r8, r9 !!! 
	;mov rdi, cos_res
	;mov rax, 1
	;movsd xmm1, [const_zero]
	;movsd xmm2, [const_zero]
	;movsd xmm3, [const_zero]
	;movsd xmm4, [const_zero]
	;call printf

	mov [image], rdi

	mov r10, [rsi]
	mov [result_w], r10

	mov r10, [rsi+4]
	mov [result_h], r10

	mov r10, [rsi+8]
	mov [result_ch], r10

	mov r10, [rsi+12]
	mov [result_offset], r10

	mov r10, [rsi+16]
	mov [result_data], r10

	mov [w], rdx
	mov [h], rcx
	mov [channels], r8
	mov [angle], r9
	movsx r9, dword [angle]

	;calculating angle in radians
	;movsd xmm0, [angle]
	cvtsi2sd xmm0, r9
	movsd xmm1, [pi]
	mulsd xmm0, xmm1
	movsd xmm1, [pi_degrees]
	divsd xmm0, xmm1
	movsd [radians], xmm0

	;calculating original image size
	mov eax, [w]
	mov r11d, [h]
	mul r11d
	mov r11d, [channels]
	mul r11d
	mov [img_size], eax

	;calculating new image size
	mov eax, [result_w]
	mov r11d, [result_h]
	mul r11d
	mov r11d, [result_ch]
	mul r11d
	mov [new_img_size], eax

	mov rdi, [image]
	mov r15, [image]
	add r15, [img_size]
	call turning
	

	mov rax, 60
	mov rdi, 0
	syscall

turning:
	mov r15, [image]
	add r15, [img_size]
	cmp rdi, r15
	jge finish
	
	;calcing x - r14
	mov rax, rdi
	sub rax, [image]
	xor rdx, rdx
	div dword [channels]
	div dword [w]
	mov rax, rdx
	xor rdx, rdx
	mov r14, rax

	;calcing y - r13
	mov rax, rdi
	sub rax, [image]
	xor rdx, rdx
	div dword [channels]
	div dword [w]
	xor rdx, rdx
	mov r13, rax
	
	;calcing new_x
	movsd xmm0, [radians]
	mov rax, 1
	call cos
	cvtsi2sd xmm1, r14
	mulsd xmm1, xmm0
	movsd [temp_x], xmm1
	movsd xmm0, [radians]
	mov rax, 1
	call sin
	movsd xmm1, [temp_x]
	cvtsi2sd xmm2, r13
	mulsd xmm2, xmm0
	subsd xmm1, xmm2
	cvtsd2si r12, xmm1
	mov [new_x], r12

	;calcing new_y
	movsd xmm0, [radians]
	mov rax, 1
	call sin
	cvtsi2sd xmm1, r14
	mulsd xmm1, xmm0
	movsd [temp_y], xmm1
	movsd xmm0, [radians]
	mov rax, 1
	call cos
	movsd xmm1, [temp_y]
	cvtsi2sd xmm2, r13
	mulsd xmm2, xmm0
	addsd xmm1, xmm2
	cvtsd2si r11, xmm1
	mov [new_y], r11

	;checking angle by 180 and 90
	mov rax, [angle]
	mov rsi, 180
	xor rdx, rdx
	div rsi
	cmp rdx, 0
	je transport
	mov rax, [angle]
	mov rsi, 90
	xor rdx, rdx
	div rsi
	cmp rdx, 0
	je transport
	jmp size_check
transport:
	movsx rax, dword [new_x]
	cmp rax, 0
	jl inv_x
	jmp check_y
inv_x:
	add rax, [result_w]
	mov [new_x], rax
check_y:
	movsx rax, dword [new_y]
	cmp rax, 0
	jl inv_y
	jmp size_check
inv_y:
	add rax, [result_h]
	mov [new_y], rax
size_check:
	mov rax, [result_w]
	mov rsi, [new_y]
	mul rsi
	mov rsi, [channels]
	mul rsi
	push rax
	mov rax, [new_x]
	mov rsi, [channels]
	mul rsi
	pop rsi
	add rax, rsi
	add rax, 2
	add rax, [result_offset]
	cmp rax, [new_img_size]
	jge iter
	
	;the actual pixel change
	push rax
	mov rax, [w]
	mov rdi, [channels]
	mul rdi
	mul r13
	push rax
	mov rax, [channels]
	mul r14
	pop rdi
	add rax, rdi
	add rax, 2
	mov rsi, [rax]
	pop rax
	mov [rax], rsi

	dec rax

	push rax
	mov rax, [w]
	mov rdi, [channels]
	mul rdi
	mul r13
	push rax
	mov rax, [channels]
	mul r14
	pop rdi
	add rax, rdi
	add rax, 1
	mov rsi, [rax]
	pop rax
	mov [rax], rsi

	dec rax

	push rax
	mov rax, [w]
	mov rdi, [channels]
	mul rdi
	mul r13
	push rax
	mov rax, [channels]
	mul r14
	pop rdi
	add rax, rdi
	mov rsi, [rax]
	pop rax
	mov [rax], rsi
iter:
	add rdi, [channels]
	jmp turning
finish:
	ret
















