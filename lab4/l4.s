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
	db "You have entered: %.10f", 10, 0


section .text
x equ 1
acc equ 1

extern printf
extern scanf
extern exit
extern atan
global main
main:
	push rbp
	mov rbp, rsp
	sub rbp, 8

	mov rdi, msg_x
	xor rax, rax
	call printf

	mov rdi, inp_x
	lea rsi, [rbp-8]
	xor rax, rax
	call scanf

	mov rdi, echo_test
	mov rsi, [rbp-8]
	mov rax, 1
	call printf

	mov rdi, 0
	push rdi
	call exit
