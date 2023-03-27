.data 
 
A: 		 		.word 832040 1346269 2178309 3524578 5702887 9227465 14930352 24157817 39088169 63245986 102334155 165580141 267914296 433494437 701408733 1134903170 1836311903 
i: 		 		.word 4 				# start index in A 
g: 		 		.word 6					# how many words to collect from A counting from i  #then change g to 12 
k:		 		.word 17 				# how many words total in A 
counter: 		.word 0					# counter
msgoverflow: 	.asciiz "Overflow at: "	# message
nLine:			.asciiz "\n"			# line break

.text 
.globl main 
 
main: 
 
# load registers for array A 
	la 		$s0, A  				# load address of A 
	lw 		$s1, i  				# load word i into s1 
	lw 		$s2, g  				# load word g into s2 
	lw 		$s3, k  				# load word k into s3 
	lw 		$s5, counter  			# load counter into s5
# initialize address of A[i] 
	sll 	$s6, $s1, 2				
	add 	$s6, $s6, $s0			# address of A[i]
# initialize a register where you will compute the sum of the elements 
	add 	$a1, $zero, $zero		# answer register
 
Loop: 
# check index bounds, have you reached the end of A 
	slt 	$t0, $s1, $s3			# if i < k, end
	beq 	$t0, $zero, end  		# break for if i < k
# check index bounds, have you collected g words 
	slt 	$t1, $s5, $s2			# if counter < g, end
	beq 	$t1, $zero, end			# break for if counter < g
# if any of these TRUE, then jump out 
	lw 		$a0, 0($s6) 			# load A[i] 
# in the loop iteratively grab successive elements of A and add to the sum 
# add the loaded word content to the sum (USE addu for addition) 
	addu 	$a1, $a1, $a0			# add A[i] to sum
	jal ifOverflow
	bne  	$v0, $zero, end
 # update the address of A[i] 
 	addi 	$a1, $a1, 4				# addr A[i] += 4
	lw 		$a0, 0($s6)
	addu 	$a1, $a1, $a0
	jal ifOverflow
	bne  	$v0, $zero, end
	 # update the index  (you need it for the entrance checks) 
 	addi 	$s1, $s1, 1				# i += 1
	addi 	$s5, $s5, 1				# counter += 1
 # loop again 
	j Loop 
 
#print result: move the sum register into a0 for that 
	
#then exit 

Process_OF: 
	la 		$a0, msgoverflow 		
	ori 	$v0, $zero, 4 			# print overflow
	syscall         	
 
end:								
	add 	$a0, $a1, $zero			# add answer to $a0
	ori 	$v0, $zero, 1
	syscall							# print the string	
	
	la 		$a0, nLine
	ori 	$v0, $zero, 4   		# print line break
	syscall 

	ori 	$v0, $zero, 10			# exit
	syscall
	
ifOverflow:
	addu 	$t0, $a0, $a1			# t0 <= sum of $a0 and $a1
	nor 	$t3, $a0, $zero			# t3 = NOT $a0
	sltu 	$t3, $t3, $a1			# t3 = 1 if $t3 < $a1
									# overflow if $a0 + $a1 > (2^32 - 1)								
	bne 	$t3, $zero, Overflow	# $t3 = 1 overflow
	
	add 	$v0, $zero, $zero
	jal Process_OF

	Overflow:
	addi 	$v0, $zero, 1
	jr $ra
 