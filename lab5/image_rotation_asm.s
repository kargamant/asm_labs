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
section .text

extern printf
extern cos
extern sin
rotate_image_asm:
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

	mov rax, 60
	mov rdi, 0
	syscall
