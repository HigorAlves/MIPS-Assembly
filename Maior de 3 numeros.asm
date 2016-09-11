.data
	mensagem: .asciiz "O maior número é:"
	insira: .asciiz "\nInsira um número:"
	insira2: .asciiz "\nInsira um outro numero:"
	insira3: .asciiz "\nInsira mais um:"
.text
	main:
		#printf insira um numero
		li $v0, 4
		la $a0, insira
		syscall
		li $v0, 5
		syscall
		move $t0, $v0
		
		#Insira outro numero
		li $v0, 4
		la $a0, insira2
		syscall
		la $v0, 5
		syscall
		move $t1, $v0
		
		#insira mais outro numero
		li $v0, 4
		la $a0, insira3
		syscall
		la $v0, 5
		syscall
		move $t2, $v0
		
		slt $s0, $t1, $t0
		bne $s0, $zero, swap
		
		li $v0, 1
		move $a0, $t3
		syscall
		
		#return 0
		li $v0, 10
		syscall
		
	swap:
		move $t3, $t0
		jr $ra