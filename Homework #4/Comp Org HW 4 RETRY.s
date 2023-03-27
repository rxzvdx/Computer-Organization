.data
# problem 1
test: .word 5
n: .word 0 						# n argument for int n

.text
.globl main

main:

	lw 		$a0, n 				#load 0 into $a0, will be used to check validity
	lw 		$a1, test			#test number
# move the result into v0
	addi 	$t0, $zero, 0 		#load 0 into $t0, this is zero VALUE
	addi 	$t1, $zero, 1		#load 1 into $t1, this is one VALUE
	move 	$v0, $a0
	#addi $s0, $a0, -1 			# stores n-1
Loop:
	sgt		$a2, $a1, $a0
	beq		$a2, $zero, Exit
	add 	$t2, $t0, $t1
	add		$s0, $t2, $zero	
	add 	$t0, $t1, $zero 	
	add 	$t1, $t2, $zero
	addi 	$a0, $s0, 1			#increment n
	
	#blt 	$s0, $zero, Exit 	#if n-2 < 0 exits
	#add 	$t3, $t0, $t1		# t0 + t1 + t3
	#add 	$v0, $t3, $zero		#answer
	#add 	$t0, $t1, $zero 	
	#add 	$t1, $t3, $zero
		j Loop
		
Exit:
	add		$v0, $t0, $zero		#move t0, to v0

