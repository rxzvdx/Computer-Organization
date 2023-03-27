.data 
 
A: .word 0 1 2 3 4 5 6 7 8 9 
i: .word 0 # start index in A 
g: .word 4 # how many indices in A  
 
.text 
.globl main 
 
main: 
 
# load registers for array A 
la 		$s0, A  					# load address of A 
la 		$s1, msgresults 			# load address of msgresults 
lw 		$s2, i  					# load word i into s2 
lw 		$s3, g  					# load word g into s3 
 
# initialize address of A[i] 
sll 	$s4, $s2, 2 				#offset of i word, i * 4
add 	$s4, $s4, $s0 				#addr of A[i]

# initialize address of msgresults[2i] 
sll 	$s5, $s2, 2					# offset of 2 X I
add 	$s5, $s5, $s5 				# 2 X I
add		$s5, $s5, $s1				#msgresults[2i] in s5
 
# iteratively grab successive elements of A 
Loop: 
slt 	$a1, $s2, $s3				# if s2 < s3, set a1 = 1
beq 	$a1, $zero, end				# loop through A, check index bounds  
lw 		$a0, 0($s4)					# load A[i] 
	jal fact 						# now call the fact function with the argument = A[i] 
lb 		$t1, 0($s5)
addi 	$t1, $v0, 48				# store v0+48 into msgresults[2i]  
sb 		$t1, 0($s5)
#store character into msg[2i]

addi 	$s2, $s2, 1 				# update the index i = i + 1
add 	$s4, $s4, 4 				# update the address of A[i] 
add 	$s5, $s5, 4					# update the address of msgresults[2i] 
	j Loop 
 
end: 
ori 	$v0, $zero, 10         		#exit 
	syscall 
 
fact: 
#The first time fact is called, sw saves an address in the program that called it 
 addi 	$sp, $sp, -8 	# adjust stack for 2 items 
 sw 	$ra, 4($sp) 	# save the return address 
 sw 	$a0, 0($sp) 	# save the argument n 
 slti 	$t0,$a0,1 		# test for n < 1 
 beq 	$t0,$zero,L1 	# if n >= 1, go to L1 
# n LESS THAN 1  ------> every n will reach this point 
 addi 	$v0,$zero,1 	# return 1 
 addi 	$sp,$sp,8 		# pop 2 items off stack 
	jr $ra 				# return to caller 
 
L1:  
addi 	$a0, $a0, -1 	# n >= 1: argument gets (n – 1) 
	jal fact 			# call fact with (n –1) 
 lw 	$a0, 0($sp) 	# return from jal: restore argument n 
 lw 	$ra, 4($sp) 	# restore the return address 
 addi 	$sp, $sp, 8 	# adjust stack pointer to pop 2 items 
# We assume a multiply instruction is available, even though it is not covered until Ch 3 
 mul 	$v0,$a0,$v0 # return n * fact (n – 1) 
#fact jumps again to the return address: 
	jr $ra # return to the caller 
 
#Bonus: Adding v0+48 allows for the printing but it is not generalizable for g>4. Why?   
#This is because when g>4, the program is over. The max index of the loop is 4, which is G.
#If there is no program (because g>4 will shut it down) there will be no applicable print statement.                                               
 