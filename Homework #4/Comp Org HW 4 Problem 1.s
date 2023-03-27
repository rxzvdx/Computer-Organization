.data
# problem 1
test: 	.word 7					#value to test
n: 		.word 0 				# n argument for int n

msgannounce:    .asciiz  " the results for  fibonnaci are: " 
msgresults:    	.asciiz  "                   "        # at least 20 spaces 
nLine:  		.asciiz "\n"   
.text
.globl main

main:

	lw 		$a0, n 				#load 0 into $a0, will be used to check validity
	lw 		$a1, test			#test number
# move the result into v0
	addi 	$t0, $zero, 0 		#load 0 into $t0, this is f(0)
	addi 	$t1, $zero, 1		#load 1 into $t1, this is f(1)
	move 	$v0, $a0

Loop:
	sgt		$a2, $a1, $a0		# if a1 > a0, then a2 = 1
	beq		$a2, $zero, end		# if a2 = 0, then exit
	
	add 	$t2, $t0, $t1		# f(n-1) + f(n-2) in t2
	add		$s0, $t2, $zero		# s0 holds answer
	add 	$t0, $t1, $zero 	# t1 = t0
	add 	$t1, $t2, $zero     # t2 = t1
	addi 	$a0, $a0, 1			#increment n
		j Loop
		
end:
	jal fib_print
	ori 	$v0, $zero, 10		#exit
	syscall

fib_print:  
 li 	$v0, 4 
 la 	$a0, msgannounce     		# argument: string 
	syscall         		 		# print the string 
 
 la 	$a0, nLine  		 		# argument: new line string 
	syscall         				# print the string 
 
 # Print the string with results 
 
 la 	$a0, msgresults     		# argument: string 
	syscall 
 
 la 	$a0, nLine  				# argument: new line string 
	syscall         				# print the string 
 
	jr $ra 