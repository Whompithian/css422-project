# Yvonne V. Richardson
# CSS 422
# Assignment 03 : Assembler Activity
# 4/12/2012
############################################
# The data segment -- declare variables here
############################################		
.data

# If column 2 contains a dot, then the directive can be used by deleting the 
#    sharp sign (#)
#.byte
#.half
addone:		.word 0
addtwo:		.word 0
addthree:	.word 0
#.double
#.space
# strings are contained in double quotes
#.ascii
#.asciiz
##########################################
# The text segment -- instructions go here
##########################################	
.text
		.globl main
main:
		# STEP 1 -- Load 4 registers with the following numbers: 3, 5, 20, 16384
		li $t0, 3
		li $t1, 5
		li $t2, 20
		li $t3, 16384
 
		# STEP 2 -- Add 20 and 5 and store it in a 5th register
		add $t4, $t1, $t2
        # Store the results of each addition into a separate address in memory
		sw $t4,addone
		
        # STEP 3 -- Add 16384 to itself
		add $t3, $t3, $t3
		sw $t3,addtwo
		
		# STEP 4 -- Add the 5th register to the register that contains 16384
		add $t3,$t3,$t4
		sw $t4,addthree
	  	# STEP LAST -- exit
		li $v0, 10  # Syscall number 10 is to terminate the program
		syscall     # exit now

