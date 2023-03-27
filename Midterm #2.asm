.data 
 # objective: c = 2 x B[A[2i]]
A: 		 		.word 1 2 3 4 5 6 7 8 9 10
B: 				.word 11 12 13 14 15 16 17 18 19 20
i: 		 		.word 4 				# start index in A 
counter: 		.word 0 				# counter 
msg: 			.asciiz "Integer: "		# message
nLine:			.asciiz "\n"			# line break

.text 
.globl main 
 
main: 
 
# load registers for array A, B and index i 
	la 		$s0, A  				# load address of A 
	la 		$s1, B					# load address of B
	lw 		$s2, i  				# load word i into s2
	lw 		$t0, counter			# load counter

	sll 	$s6, $s2, 3				# 2 x i 				
	add 	$s6, $s6, $s0			# address of A[2i]
	lw 		$t0, 0($s6)				# this is an index into B, so x 4
	add 	$s5, $s5, $s1			# address of B[A[2i]]
	lw 		$t0, 0($s5)				# value of B[A[2i]]
	sll 	$s3, $t0, 1				# 2 x B[A[2i]]
	beq 	$t0, $zero, end			# if t0 == 0 (which it always does), jump to end
	
Process_msg: 
	la 		$a0, msg 		
	ori 	$v0, $zero, 4 			# print msg
	syscall         	
 
end:								
	add 	$a0, $s3, $zero			# add answer to $a0
	ori 	$v0, $zero, 1
	syscall							# print the word	
	
	la 		$a0, nLine
	ori 	$v0, $zero, 4   		# print line break
	syscall 

	ori 	$v0, $zero, 10			# exit
	syscall
	
 
