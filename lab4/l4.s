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


section .text

;stored on stack
x equ 8
acc equ x+8

extern printf
extern scanf
extern exit
extern atan
global main
main:
	;stack frame
	push rbp
	mov rbp, rsp
	sub rsp, acc
	and rsp, -16

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

	mov rdi, echo_test
	movsd xmm0, [rbp-acc]
	mov rax, 1
	call printf

	mov rdi, echo_test
	movsd xmm0, [rbp-x]
	mov rax, 1
	call printf

	mov rdi, 0
	push rdi
	call exit
