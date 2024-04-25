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


section .text
x:
	dq 1.0
acc:
	dq 1.0

extern printf
extern scanf
extern exit
extern atan
global main
main:
	mov rdi, msg_x
	push msg_x
	call printf
	mov rdi, inp_x
	mov rsi, x
	push rdi
	push rsi
	call scanf


	mov rdi, 0
	push rdi
	call exit
