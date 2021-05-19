# NGHI NGUYEN 
# weLCOME TO MY FIBONACCI SEQUENCE GENERATOR
# Enter the first and second number of the sequence and the number of numbers in the sequence and it will generate the whole sequences based on these information.
.data

messg:	.asciiz "Welcome to my Fibs calculator \n"
messg1: .asciiz "Please enter the first number: "
messg2: .asciiz "Please enter the second number: "
messg3: .asciiz "Please enter the number of elements of the sequence: "
godown: .asciiz "\n"
space: .asciiz "   "
.text
main:	
# INPUT RECEIVE AND INTRO
	la	$a0, messg		#Set up my message as an argument
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall 			#make the system call
	
	
	la  	$a0, messg1 		#Set up message1 as an argument
	addi 	$v0, $zero, 4		#Specify system call 4 to print String
	syscall				#make the system call
	
	addi 	$v0, $zero, 5		#Specify system call to read integer
	syscall				#System call
	add 	$t0, $v0, $zero		#Store input of 1st
	
	la 	$a0, godown		#GO DOWN ONE LINE
	addi 	$v0, $zero, 4
	syscall
	
	la  	$a0, messg2 		#Set up message2 as an argument
	addi 	$v0, $zero, 4		#Specify system call 4 to print String
	syscall				#make the system call
	
	addi 	$v0, $zero, 5		#Store second input
	syscall
	add 	$t1, $v0, $zero	
	
	la 	$a0, godown		#GO DOWN ONE LINE
	addi 	$v0, $zero, 4
	syscall
	
	la  	$a0, messg3 		#Set up message3 as an argument
	addi 	$v0, $zero, 4		#Specify system call 4 to print String
	syscall				#make the system call
	
	addi 	$v0, $zero, 5		#Store the number of numbers in the sequence (k)
	syscall
	addi 	$t2, $v0, 1		# this one: t2 = v0 + 1 is because we want to loop using branch equal so I want to add 1 more so it will loop properly
	
	la 	$a0, godown		#GO DOWN
	addi 	$v0, $zero, 4
	syscall
	
	addi 	$t4, $zero, 1		#a variable starts from 1 and ends when reaches k (Use t4 as i to loop n times to list everything)
# Call function to generate
#We're going to create a function to generate the fibonacci number f(i,j,k) and then loop for k times to list everything out.
Loop:	beq 	$t2, $t4, End			# When the variable reaches k, then stops looping 
	add 	$t5, $zero, $zero		# t5 = NUMBER OF ONES (starting from 0)
	add 	$t8, $zero, $zero		# Rolling through 32 bits, this is the parameter going from 0 - 32
	add 	$a0, $zero, $t0			# Set the arguments to be i,j,k respectively so you can put into function f
	add 	$a1, $zero, $t1
	add 	$a2, $zero, $t4
	jal 	fib			# Call the fib function to get the fib result
	add 	$t3, $zero, $v0		#Get RESULT of function f IN T3
	add 	$t7, $zero, $v0		#Get result of function f in T7 to calculate number of 1s
	
#####################################################
# COUNTING NUMBER OF 1s ####################
count:	and 	$t6, $t7, 1		# t6 will be 0 if t7 = 0 and t6 = 1 if t7 = 1
	beq 	$t6, $zero, exit	# if t6 = 0 then we won't increment into t5 ( the number of ones)
	addi 	$t5, $t5, 1		# if t6 = 1 then we will just increment like normal
exit:	srl 	$t7, $t7, 1		# shift right so we can check the next bit of t7
	addi 	$t8, $t8, 1		# this one will increment every time, it's just counting the number of times we're shifting right. Once it reaches 32, it will stop looping back into Label count
	blt 	$t8,32, count


	addi 	$t4, $t4, 1 		#increment the variable so we can loop normally
#OUTPUT AND DISPLAY
	add 	$a0, $t3, $zero		#OUTPUT the Result of the fibonacci function
	addi	$v0, $zero, 1		#Use system call 1 to print integer
	syscall
	
	la  	$a0, space 		#Set up space as an argument
	addi 	$v0, $zero, 4		#Specify system call 4 to print String
	syscall				#make the system call
	
	add 	$a0, $t3, $zero		# Output the result of the fibonacci function in Hex form
	addi 	$v0, $zero, 34		# System call 34 to hex display
	syscall
	
	la  	$a0, space 		#Set up space as an argument
	addi 	$v0, $zero, 4		#Specify system call 4 to print String
	syscall				#make the system call
	
	add 	$a0, $t5, $zero		#Output the number of 1s 
	addi 	$v0, $zero, 1		# System call 1 to print integer
	syscall
	
	la  	$a0, godown 		#Set up godown as an argument
	addi 	$v0, $zero, 4		#Specify system call 4 to print String
	syscall				#make the system call

	j Loop				#Jump back to Loop the next number in the sequence
End:
#END PROGRAM
	addi	$v0, $zero, 10		#Specify system call 10 to exit
	syscall 			#make the system call

###########################################################################################################################################################
# GENERATE THE FIB FUNCTION TO GENERATE THE SEQUENCE    f(i,j,k) (With i = first number, j = second number, k = number of numbers) = f(i,j,k-1) + f(i,j,k-2)
fib:	beq 	$a2, 1, first		#2 base cases : k = 1  and k = 2
	beq	$a2, 2, second			
	
	addi 	$sp, $sp, -4		#STORING RETURN ADDRESS1  (WHEN CALLING fib(i,j,k-1))
	sw	$ra, 0($sp)
	
	addi	$a2, $a2, -1		# We're going to call function f(i,j,k-1)
	jal 	fib
	addi 	$a2, $a2, 1		# Add it back to normal so we can do f(i,j,k-2) later
	
	
	lw 	$ra, 0($sp)		#restoring return adddress #1
	addi	$sp, $sp, 4
	
	
	addi 	$sp, $sp, -4		# Push on stack return value
	sw	$v0, 0($sp)
	addi 	$sp, $sp, -4		#Store on stack return address 2
	sw 	$ra, 0($sp)
	
	
	addi 	$a2, $a2, -2		# Call function f(k-2)
	jal 	fib
	addi 	$a2, $a2, 2
	
	
	lw	$ra, 0($sp)		#Restoring and POP return value and address 2
	addi	$sp, $sp, 4
	lw	$s0, 0($sp)
	addi	$sp, $sp, 4
	
	
	add 	$v0, $v0, $s0		#f(i,j,k) =  f(i,j,k-1) + f(i,j,k-2)
	jr 	$ra


first:	add 	$v0, $a0, $zero 	#FIRST BASE CASE: f(i,j,k) = i   when   k = 1
	jr 	$ra

second: add 	$v0, $a1, $zero		#Second base case: f(i,j,k) = j   when k = 2
	jr 	$ra



