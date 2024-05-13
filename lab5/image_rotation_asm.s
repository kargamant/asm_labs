bits 64
global rotate_image_asm 
section .data
	image dq 0
	result_w dd 0
	result_h dd 0
	result_ch dd 0
	result_data dq 0
	w dd 0
	h dd 0
	channels db 0
	angle dd 0
	
	radians dq 0.0

	pi dq 3.14159
	pi_degrees dq 180.0

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
	;mov r9, [angle]
	;cmp r9, 0
	;jl invert
	;jmp write_radians
;invert:
	;mulsd xmm0, [const_neg]	
;write_radians:
	;movsd [radians], xmm0

	mov rdi, cos_res
	mov rax, 1
	movsd xmm1, [const_zero]
	movsd xmm2, [const_zero]
	movsd xmm3, [const_zero]
	movsd xmm4, [const_zero]
	call printf

	mov rax, 60
	mov rdi, 0
	syscall


















