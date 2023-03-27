.data 
 # objective: 
 # f(n) = 0 if n = 0
 # f(n) = 1 if n = 1
 # f(n) = 2 x f(n-1) + f(n-2)
 
n: 				.word 0									# n arg for int n
msg: 			.asciiz "Fib sequence times 2: "		# message
nLine:			.asciiz "\n"							# line break
counter: 		.word 0 								# counter 

.text 
.globl main 
 
main: 
 
# load registers for array A, B and index i 
	lw 		$a0, n  				# load address of A 
	lw 		$t7, counter			# load counter
	add 	$t0, $zero, $zero		# t0 = 0
	addi 	$t1, $t0, 1				# t1 = t0 + 1
	add 	$t3, $a0, $zero			# for n = 0 and n = 1 the results = argument
	beq 	$a0, $t0, Exit			# if n = 0 jump over the loop
	beq 	$a0, $t1, Exit			# if n = 1 jump over the loop
	addi 	$s0, $a0, -2 			# counter: go through the loop n-2 times
	
Loop: 
	slt 	$t2, $s0, $zero 		# if we reached 0 by decrementing counter
	beq 	$t7, $zero, PrintMsg	# if t7 == 0 (which it always does), jump to printMsg
	bne 	$t2, $zero, Exit
	sll 	$t4, $t1, 1				
	add 	$t3, $t4, $t0			# f(i) = f(i-1) + f(i-2)
	add 	$t0, $t1, $zero			# update t0 (t0 <= t1)
	add 	$t1, $t3, $zero			# update t1 (t1 <= t3)
	addi 	$s0, $s0, -1			# decrement
	j loop
	
printMsg: 
	la 		$a0, msg 		
	ori 	$v0, $zero, 4 			# print msg
	syscall         	
 
Exit:								
	add 	$a0, $t3, $zero			# add answer to $a0
	ori 	$v0, $zero, 1
	syscall							# print the word	
	
	la 		$a0, nLine
	ori 	$v0, $zero, 4   		# print line break
	syscall 

	ori 	$v0, $zero, 10			# exit
	syscall
	
 
