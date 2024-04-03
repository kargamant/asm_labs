section .data
buffin:
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
buffout:
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

section .text
global _start

_start:
	call read
	mov r9, rax
	cmp rax, 0
	je exit
	dec rax
	mov rdi, rax ;read length
	mov rsi, 3 ;shift
	call process
	call write
	jmp _start

exit:
	mov rax, 60
	mov rdi, 0
	syscall


read:
	mov rax, 0
	mov rdi, 0
	mov rsi, buffin
	mov rdx, 10
	syscall
	ret


process:	
	mov rcx, rdi
cipher:
	mov r8b, byte [buffin+rcx]
	cmp r8b, 32
	je continue
	cmp r8b, 10
	je continue
	add r8b, sil ;shifting
continue:
	mov [buffout+rcx], r8b
	loop cipher
	mov r8b, byte [buffin]
	cmp r8b, 32
	je process_end
	cmp r8b, 10
	je process_end
	add r8b, sil
	
process_end:
	mov [buffout], r8b
	ret


write:
	;mov byte [buffout+r9], 10
	mov rax, 1
	mov rdi, 1
	mov rsi, buffout
	mov rdx, r9
	;inc rdx
	syscall
	ret
