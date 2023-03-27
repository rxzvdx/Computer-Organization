.data 
 
A: .word 832040 1346269 2178309 3524578 5702887 9227465 14930352 24157817 39088169 63245986 102334155 165580141 267914296 433494437 701408733 1134903170 1836311903 2971215073
i: 		.word 4 						# start index in A 
g: 		.word 6 						# how many words to collect from A counting from i  #then change g to 12 
k: 		.word 17 						# how many words total in A 
msg1: 	.asciiz "the result is:"

.text 
.globl main 
 
main: 
 
# load registers for array A 
	la 		$s0, A  			# load address of A 
	lw 		$s1, i  			# load word i into s1 
	lw 		$s2, g  			# load word g into s2  
	lw 		$s3, k  			# load word k into s3 
  
	sll 	$s6, $s1, 2 		# initialize address of A[i] 
	sll 	$s5, $s2, 2			# initialize address of A[g]
	add 	$s6, $s6, $s0		# address of A[i]
	add		$s5, $s5, $s0		# address of A[g]
	add 	$t2, $s2, $zero		# counter
 # initialize a register where you will compute the sum of the elements 
	add 	$s4, $zero, $zero	# answer register
Loop: 
# check index bounds, have you reached the end of A 
	slt 	$t0, $s1, $s3 		# a < k, a needs to be less than total in a
	beq		$t0, $zero, end		# if t0 == 0, end
	beq 	$t2, $zero, end		# if counter == 0, end
# check index bounds, have you collected g words 
# if any of these TRUE, then jump out 
	add 	$t1, $s6, $s5		# i + g = i
	addi 	$s6, $s6, -4 		# i + g - 1 = j 
	lw 		$t1, 0($s6)			# load A[i+g-1] or A[j]
	addu 	$s7, $t1, $t1		# A[j] + A[j]
	
# in the loop iteratively grab successive elements of A and add to the sum 
# add the loaded word content to the sum (USE addu for addition) 
	
 # update the index  (you need it for the entrance checks) 
 # update the address of A[i] 
	addi 	$t2, $t2, -1 		# decrement counter

 # loop again 
 j Loop 
 
end:
#print result: move the sum register into a0 for that 
	addu 	$a0, $s7, $zero
	jal print_result
	ori 	$v0, $zero, 10
	syscall						# then exit 
	
	
print_result:
	li 		$v0, 4
	la 		$a0, msg1     		# argument: string
	syscall      				# print the string
	jr $ra
 