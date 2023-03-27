"]	slt 	$t1, $s5, $s2			# if counter < g, end
]
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
	ori 	$v0, $zero, 4         	# print overflow 
	syscall 
 
e
nd:								
	add 	$a0, $a1, $zero			# add answer to $a0
	ori 	$v0, $zero, 4
	syscall							# print the string	
	
	ori 	$v0, $zero, 10			# exit
	syscall
	
ifOverflow:
	addu 	$t0, $a0, $a1			# t0 <= sum of $a0 and $a1
	nor 	$t3, $a0, $zero			# t3 = NOT $a0
	sltu 	$t3, $t3, $a1			# t3 = 1 if $t3 < $a1
									# overflow if $a0 + $a1 > (2^32 - 1)								
	bne 	$t3, $zero, Overflow	# $t3 = 1 overflow
	
	add 	$v0, $zero, $zero
	jr $ra
	
	Overflow:
	addi 	$v0, $zero, 1
	jr $ra
 