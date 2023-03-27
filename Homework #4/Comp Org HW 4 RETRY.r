.data
# problem 1

n: .word 0 						# n argument for int n

.text
.globl main

main:

	lw 		$a0, n 				#load 0 into $a0, will be used to check validity

# move the result into v0
	addi 	$t0, $zero, 0 		#load 0 into $t0, this is zero VALUE
	addi 	$t1, $zero, 1		#load 1 into $t1, this is one VALUE
	addi	$t2, $zero, 2		#load 2 into $t2, this is two VALUE
	move 	$v0, $a0
	addi $s0, $a0, -1 			# stores n-1
Loop:
	blt 	$s0, $zero, Exit 	#if n-2 < 0 exits
	add 	$t3, $t0, $t1		# t0 + t1 + t3
	add 	$v0, $t3, $zero		#answer
	add 	$t0, $t1, $zero 	
	add 	$t1, $t3, $zero
	addi 	$s0, $s0, -1			#decrement n
		j Loop
		
Exit:
	add		$v0, $t0, $zero		#move t0, to v0
exit
