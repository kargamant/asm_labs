section .data
buffin:
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
buffout:
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
shift:
	dq 0
file_name:
	db 'hello.txt'
param:
	db 0

section .text
global _start

_start:
	call env_params_search
	jmp exit 
	;TO REMOVE!!!!!!!!!!!!!!!!!!
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

env_params_search:	
	mov rcx, 64
print_params:
	mov r13, [rsp+rcx*8]
	mov rax, 1
	mov rdi, 1
	mov rsi, r13
	mov rdx, 100
	push rcx
	syscall
	pop rcx

	loop print_params
	ret

print_nline:
	mov rax, 1
	mov rdi, 1
	mov rsi, 10
	mov rdx, 1
	syscall
	ret

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
	cmp r8b, 65
	jl continue
	cmp r8b, 90
	jg is_small_letter
	
	add r8b, sil
	mov rax, r8
	mov r10, 65
	xor rdx, rdx
	div r10
	mov r10, 26
	mov rax, rdx
	xor rdx, rdx
	div r10
	mov r8b, dl
	add r8b, 65
	jmp continue

is_small_letter:
	cmp r8b, 97
	jl continue
	
	add r8b, sil
	mov rax, r8
	mov r10, 97
	xor rdx, rdx
	div r10
	mov r10, 26
	mov rax, rdx
	xor rdx, rdx
	div r10
	mov r8b, dl
	add r8b, 97
continue:
	mov [buffout+rcx], r8b
	dec rcx
	cmp rcx, -1
	je process_end
	jmp cipher
	
process_end:
	;mov [buffout], r8b
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
