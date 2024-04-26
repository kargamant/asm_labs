bits 64

section .data
msg_x:
	db "Enter x: ", 10, 0
inp_x:
	db "%lf", 0
msg_acc:
	db "Enter accuracy: ", 10, 0
inp_acc:
	db "%lf", 0
out_series:
	db "Series result: %.10f", 10, 0
out_arctg:
	db "Arctg value for x: %.10f", 10, 0
echo_test:
	db "You have entered: %.10lf", 10, 0
const:
	dq 1.0
const_neg:
	dq -1.0
const_two:
	dq 2.0
const_zero:
	dq 0.0

section .text
;stored on stack
x equ 8
acc equ x+8


extern printf
extern scanf
extern exit
extern atan

;xmm7 - to_compare, xmm6 - multiplier, xmm5 - result, xmm4 - slagaemoe, xmm3 - coeff, xmm2 - accuracy, xmm1 - x
inv:
	mulsd xmm4, [const_neg]
	movsd xmm7, [const]
	ret

arctg:
	movsd xmm3, [const]
	movsd xmm4, xmm1
calc:
	addsd xmm5, xmm4
	movsd xmm6, [const]
	mulsd xmm6, [const_neg] 
	mulsd xmm4, xmm6
	mulsd xmm4, xmm1
	mulsd xmm4, xmm1
	mulsd xmm4, xmm3
	addsd xmm3, [const_two]
	divsd xmm4, xmm3
	movsd xmm7, xmm4
	ucomisd xmm4, [const_zero]
	jb invert
	jmp acc_compare
invert:
	mulsd xmm7, [const_neg]
acc_compare:
	ucomisd xmm7, xmm2
	ja calc
	ret

global main
main:
	;stack frame
	push rbp
	mov rbp, rsp
	sub rsp, acc

	;stack shifting
	;and rsp, -16

	mov rdi, msg_acc
	xor rax, rax
	call printf

	mov rdi, inp_acc
	lea rsi, [rbp-acc]
	xor rax, rax
	call scanf

	mov rdi, msg_x
	xor rax, rax
	call printf

	mov rdi, inp_x
	lea rsi, [rbp-x]
	xor rax, rax
	call scanf
	
	movsd xmm1, [rbp-x]
	movsd xmm2, [rbp-acc]
	call arctg

	mov rdi, out_series
	movsd xmm0, xmm5
	movsd xmm1, [const_zero]
	movsd xmm2, [const_zero]
	movsd xmm3, [const_zero]
	movsd xmm4, [const_zero]
	mov rax, 1
	call printf

	mov rdi, 0
	push rdi
	call exit
