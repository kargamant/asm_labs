section .data
buffin:
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
buffout:
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
shift:
	dq 0
file:
	db 'hello.txt'
param:
	db 0
ceasar_shift:
	db 'ceasar_shift='
file_name:
	db 'file_name='
shift:
	db 0

section .text
global _start

_start:
	;call env_params_search
	;jmp exit 
	;TO REMOVE!!!!!!!!!!!!!!!!!!

	call read
	add r14, r9		
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

env_params:
	mov rcx, [rsp]
find:
	push rcx
	mov rdi, [rsp+rcx*8+16]	
	mov rsi, ceasar_shift
	mov rcx, 13
	repe cmpsb
	je parse
	pop rcx
	inc rcx	
parse:
	pop rcx
	lea rsi, [rsp+rcx*8+16]
	;use movsb		
	
	;rsp+(args+2)*8

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
	;movs stos	
process_end:
	;mov [buffout], r8b
	ret


write:
		
	;opening file
	mov rax, 2
	mov rdi, file
	mov rsi, 1
	syscall
	mov r15, rax

	mov rax, 8
	mov rdi, r15
	mov rsi, r14
	mov rdx, 1
	syscall

	mov rax, 1
	mov rdi, r15
	mov rsi, buffout
	mov rdx, r9
	;inc rdx
	syscall

	mov rax, 3
	mov rdi, r15
	syscall

	ret
