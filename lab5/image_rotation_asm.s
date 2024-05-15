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
	new_x dq 0
	new_y dq 0
cos_res:
	db "cos: %.10lf", 10, 0
pointer_dbg:
	db "image_data: %p", 10, 0
const_zero:
	dq 0.0
const_neg:
	dq -1.0
const_half:
	dq 0.4
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

	mov r10d, [rsi]
	mov [result_w], r10d

	mov r10d, [rsi+4]
	mov [result_h], r10d

	mov r10d, [rsi+8]
	mov [result_ch], r10d

	mov r10d, [rsi+12]
	mov [result_offset], r10d
	
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

;	mov rdi, pointer_dbg
;	mov rsi, [image]
;	call printf

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
	
	leave
	;mov rax, 60
	;mov rdi, 0
	;syscall
turning:
	mov r15, [image]
	mov r10d, [img_size]
	add r15, r10
	cmp rdi, r15
	jge finish
	
	;calcing x - r14
	mov rax, rdi
	sub rax, [image]
	xor rdx, rdx
	div dword [channels]
	div dword [w]
	mov rax, rdx
	mov r14, rax

	;calcing y - r13
	mov rax, rdi
	sub rax, [image]
	xor rdx, rdx
	div dword [channels]
	div dword [w]
	mov r13, rax
	
	;calcing new_x
	movsd xmm0, [radians]
	mov rax, 1
	push rdi
	call cos
	pop rdi
	cvtsi2sd xmm1, r14
	mulsd xmm1, xmm0
	movsd [temp_x], xmm1
	movsd xmm0, [radians]
	mov rax, 1
	push rdi
	call sin
	pop rdi
	movsd xmm1, [temp_x]
	cvtsi2sd xmm2, r13
	mulsd xmm2, xmm0
	subsd xmm1, xmm2
	cvtsd2si r12, xmm1
	movsd xmm2, [const_half]
	addsd xmm1, xmm2
	cvtsd2si r10, xmm1
	cmp r12, r10
	je decr12
	jmp cont1
decr12:
	cmp r12, 0
	jle cont1
	dec r12
cont1:
	mov [new_x], r12
	movsd xmm1, [const_zero]
	movsd xmm2, [const_zero]
	

	;calcing new_y
	movsd xmm0, [radians]
	mov rax, 1
	push rdi
	call sin
	pop rdi
	cvtsi2sd xmm1, r14
	mulsd xmm1, xmm0
	movsd [temp_y], xmm1
	movsd xmm0, [radians]
	mov rax, 1
	push rdi
	call cos
	pop rdi
	movsd xmm1, [temp_y]
	cvtsi2sd xmm2, r13
	mulsd xmm2, xmm0
	addsd xmm1, xmm2
	cvtsd2si r11, xmm1
	movsd xmm2, [const_half]
	addsd xmm1, xmm2
	cvtsd2si r10, xmm1
	cmp r11, r10
	je decr11
	jmp cont2
decr11:
	cmp r11, 0
	jle cont2
	dec r11
cont2:
	mov [new_y], r11

	;checking angle by 180 and 90
	mov eax, [angle]
	cmp r9, 0
	jl inv_angle
	jmp cont5
inv_angle:
	mov rax, r9
	mov r10, -1
	imul r10
cont5:
	mov esi, 180
	xor rdx, rdx
	div esi
	cmp edx, 0
	je transport
	xor rdx, rdx
	mov eax, [angle]
	cmp r9, 0
	jl inv_angle2
	jmp cont6
inv_angle2:
	mov rax, r9
	mov r10, -1
	imul r10
cont6:
	mov esi, 90
	xor rdx, rdx
	div esi
	cmp edx, 0
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
	mov eax, [result_w]
	movsx rsi, dword [new_y]
	imul rsi
	mov esi, [channels]
	imul rsi
	push rax
	movsx rax, dword [new_x]
	mov esi, [channels]
	imul rsi
	pop rsi
	add rax, rsi
	add rax, 2

	xor rbx, rbx
	mov ebx, [result_offset]
	add rax, rbx
	cmp eax, dword [new_img_size]
	jge iter

cont3:
;	mov eax, [result_w]
;	movsx rsi, dword [new_y]
;	imul rsi
;	mov esi, [channels]
;	imul rsi
;	push rax
;	movsx rax, dword [new_x]
;	mov esi, [channels]
;	imul rsi
;	pop rsi
;	add rax, rsi
;	add rax, 2
;
;	;xor rbx, rbx
;	mov ebx, [result_offset]
;	add rax, rbx
;	cmp rax, [new_img_size]
;	jge iter
	
	sub rax, 2
	cmp rax, 0
	jl iter
	xor rbx, rbx
	mov rbx, [result_data]
	add rax, rbx

	;the actual pixel change
	push rax
	mov eax, [w]
	mov esi, [channels]
	mul esi
	mul r13d
	push rax
	mov eax, [channels]
	mul r14d
	pop rsi
	add rax, rsi
	add rax, [image]
	mov rsi, rax
	pop rax

	mov bl, [rsi+2]
	mov [rax+2], bl
	
	mov bl, [rsi+1]
	mov [rax+1], bl

	mov bl, [rsi]
	mov [rax], bl

;	push rax
;	mov rax, [w]
;	mov rdi, [channels]
;	mul rdi
;	mul r13
;	push rax
;	mov rax, [channels]
;	mul r14
;	pop rdi
;	add rax, rdi
;	add rax, [image]
;	mov sil, [rax+1]
;	pop rax
;	mov [rax+1], sil
;
;	push rax
;	mov rax, [w]
;	mov rdi, [channels]
;	mul rdi
;	mul r13
;	push rax
;	mov rax, [channels]
;	mul r14
;	pop rdi
;	add rax, rdi
;	add rax, [image]
;	mov sil, [rax]
;	pop rax
;	mov [rax], sil
iter:
;	mov rax, 0
;	mov rsi, 0
;	mov eax, [channels]
;	mov esi, 8
;	mul esi
	xor rax, rax
	mov eax, [channels]
	add rdi, rax
	jmp turning
finish:
	ret
















