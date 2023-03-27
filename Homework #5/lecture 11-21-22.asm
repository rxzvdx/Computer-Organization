.data 


.text
.globl main

main:

	la $s0, A						#load address A into $s0
	lw $s1, i						#load word i into $s1
	lw $s2, g						#load word g into $s2
	lw $s3, k						#load word k into $s3

#initialize address of A[i]
	sll $s6, $s1, 2
	add $s6, $s6, $s0

#initialize a register where you will compute the sum of the elements
	add $s4, $zero, $zero
	lw $t0, 0($s6) 					#use address to load next word
	addu $s4, $s4, $t0 				#add next word to $s4 or sum, and call overflow
	jal ifOverflow
	bne $v0, $zero, end
	addi $s6, $s6, 4
	lw $t0, 0($s6)
	addu $s4, $s4, $t0
	jal ifOverflow
	bne $vo, $zero, end
	 
#add $s2, $s2, $s1
#add $s3, $s3, $s1

end: 
	addu $a0, $s4, $zero
	ori $v0, $zero, 1 				#exit
	syscall
	ori $v0, $zero, 10 				#exit
	syscall

ifOverflow:
	addu $t0, $a0, $a1				# t0 <= sum of $a0 and $a1
	nor $t3, $a0, $zero				# t3 = NOT $a0
	sltu $t3, $t3, $a1				# t3 = 1 if $t3 < $a1
									# overflow if $a0 + $a1 > (2^32 - 1) 
									# $t3 = 1 overflow
	bne $t3, $zero, Overflow
	
	add $v0, $zero, $zero
	jr $ra
	
	Overflow:
	addi $v0, $zero, 1
	jr $ra