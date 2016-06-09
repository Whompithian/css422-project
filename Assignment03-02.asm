# Sweeney, Brendan
# CSS 422
# Assignment 03-02 / Implementation
# 4/20/2012
############################################
# The data segment -- declare variables here
############################################
.data

# Create some null terminated strings to use
strPromptFirst:    .asciiz "Please enter 10 numbers on separate lines:\n"
strResultAscend:   .asciiz "Ascending order:\n"
strResultDescend:  .asciiz "Descending order:\n"
strDone:           .asciiz "DONE\n"
strCR:             .asciiz "\n"

# Set aside space for an array to contain 10 items
array1:            .word 10

##########################################
# The text segment -- instructions go here
##########################################
.text
        .globl main
main:
        # STEP 1 -- get the integer list
        # Print a prompt asking user for input
        addi $v0, $zero, 4          # syscall 4 prints string addressed in $a0
        la   $a0, strPromptFirst    # load address of the string
        syscall                     # actually print the string

        # Setup the array
        la   $s0, array1            # get address of array ready
        add  $a0, $s0,   $zero      # prepare to pass array
        addi $a1, $zero, 36         # prepare to pass array size
        jal fill                    # call procedure to fill array
        
        # Print an extra carriage return
        addi $v0, $zero, 4          # syscall for print string
        la   $a0, strCR             # address of string with a carriage return
        syscall                     # actually print the string
        
        # STEP 2 -- sort the array of integers
        # Sort the contents of the array
        add  $a0, $s0,   $zero      # prepare to pass array
        addi $a1, $zero, 10         # prepare to pass array size
        jal  sort                   # call precedure to sort array

        # SETP 3 -- print the sorted array
        # Print in ascending order
        add  $a0, $s0,   $zero      # prepare to pass array
        addi $a1, $zero, 36         # prepare to pass array size
        jal  ascPrint               # call procedure to print array

        # Print in descending order
        add  $a0, $s0,   $zero      # prepare to pass array
        addi $a1, $zero, 36         # prepare to pass array size
        jal  descPrint              # call procedure to print array
        j    progDone               # go to program end

        # Procedure to read and store the integer list
fill:
        # No stack manipulation necessary in this procedure
        add  $t0, $zero, $zero      # initialize index to 0
fillBody:
        addi $v0, $zero, 5          # syscall number 5 will read an int
        syscall                     # actually read the int
        add  $t1, $t0,   $a0        # set $t1 to current array element
        sw   $v0, 0($t1)            # store int in array
        beq  $t0, $a1,   fillExit   # exit loop
        addi $t0, $t0,   4          # increment index
        j    fillBody               # iterate through loop again
fillExit:
        jr   $ra

        # Procedure to sort an array of integers
sort:
        # Adjust the stack and save needed registers
        addi $sp, $sp,   -20        # make room on stack for 5 registers
        sw   $ra, 16($sp)           # save $ra on stack
        sw   $s3, 12($sp)           # save $s3 on stack
        sw   $s2, 8($sp)            # save $s2 on stack
        sw   $s1, 4($sp)            # save $s1 on stack
        sw   $s0, 0($sp)            # save $s0 on stack
        # Save $a registers to use for other calls
        add  $s2, $a0,   $zero      # save the array start
        add  $s3, $a1,   $zero      # save the array size
        add  $s0, $zero, $zero      # initialize index to 0
for1tst:
        slt  $t0, $s0,   $s3        # is index still within array?
        beq  $t0, $zero, exit1      # if not, exit
        addi $s1, $s0,   -1         # otherwise, set index for inner loop
for2tst:
        slt  $t0, $s1,   $zero      # is inner index within array?
        bne  $t0, $zero, exit2      # if not, exit
        sll  $t1, $s1,   2          # otherwise, multiply by 4 to get offset
        add  $t2, $s2,   $t1        # set $t2 to current array element
        lw   $t3, 0($t2)            # get value at current element
        lw   $t4, 4($t2)            # get value at next element
        slt  $t0, $t4,   $t3        # is lower value less than next value?
        beq  $t0, $zero, exit2      # if so, they are in order, exit
        add  $a0, $s2,   $zero      # otherwise, prepare to pass size
        add  $a1, $s1,   $zero      # prepare to pass array start
        jal  swap                   # swap the two values
        addi $s1, $s1,   -1         # decrement inner index
        j    for2tst                # iterate through loop again
exit2:
        addi $s0, $s0,   1          # increment outer index
        j    for1tst                # iterate through loop again
exit1:
        # Restore registers and adjust the stack
        lw   $s0, 0($sp)            # restore $s0 from stack
        lw   $s1, 4($sp)            # restore $s1 from stack
        lw   $s2, 8($sp)            # restore $s2 from stack
        lw   $s3, 12($sp)           # restore $s3 from stack
        lw   $ra, 16($sp)           # restore $ra from stack
        addi $sp, $sp,   -20        # make room on stack for 5 registers
        jr   $ra                    # return to calling routine

        # Procedure to swap two values in an array
swap:
        # No stack manipulation necessary in this procedure
        sll  $t0, $a1,   2          # multiply offset by 4
        add  $t0, $t0,   $a0        # set $t0 to current array element
        lw   $t1, 0($t0)            # get value at current element
        lw   $t2, 4($t0)            # get value at next element
        sw   $t2, 0($t0)            # store old next value in current
        sw   $t1, 4($t0)            # sotre old current value in next
        jr   $ra                    # return to calling routine

        # Procedure to print sorted array in ascending order
ascPrint:
        # No stack manipulation necessary in this procedure
        add  $t0, $a0,   $zero      # copy array start into $t0
        addi $v0, $zero, 4          # syscall 4 prints string addressed at $a0
        la   $a0, strResultAscend   # load address of the string
        syscall                     # actually print the string
        add  $t1, $zero, $zero      # initialize index to 0
ascLoop:
        add  $t2, $t0,   $t1        # set $t2 to current element
        addi $v0, $zero, 1          # syscall 1 prints an int
        lw   $a0, 0($t2)            # prepare to print current element
        syscall                     # actually print the int
        addi $v0, $zero, 4          # syscall 4 prints string addressed at $a0
        la   $a0, strCR             # prepare to print a newline
        syscall                     # actually print the newline
        beq  $t1, $a1,   ascExit    # loop exit test
        addi $t1, $t1,   4          # increment index
        j    ascLoop                # iterate through loop again
ascExit:
        # Print an extra carriage return and exit
        addi $v0, $zero, 4          # syscall for print string
        la   $a0, strCR             # address of string with a carriage return
        syscall                     # actually print the string
        jr   $ra                    # return to calling routine

        # Procedure to print sorted array in descending order
descPrint:
        # No stack manipulation necessary in this procedure
        add  $t0, $a0,   $zero      # copy array start into $t0
        addi $v0, $zero, 4          # syscall 4 prints string addressed at $a0
        la   $a0, strResultDescend  # load address of the string
        syscall                     # actually print the string
        add  $t1, $a1,   $zero      # initialize index to last element
descLoop:
        add  $t2, $t0,   $t1        # set $t2 to current element
        addi $v0, $zero, 1          # syscall 1 prints an int
        lw   $a0, 0($t2)            # prepare to print current element
        syscall                     # actually print the int
        addi $v0, $zero, 4          # syscall 4 prints string addressed at $a0
        la   $a0, strCR             # prepare to print a newline
        syscall                     # actually print the newline
        beq  $t1, $zero, descExit   # loop exit test
        addi $t1, $t1,   -4         # increment index
        j descLoop                  # iterate through loop again
descExit:
        # Print an extra carriage return and exit
        addi $v0, $zero, 4          # syscall for print string
        la   $a0, strCR             # address of string with a carriage return
        syscall                     # actually print the string
        jr   $ra                    # return to calling routine

        # STEP 4 -- finish and exit program
progDone:
        # Print a message and exit
        addi $v0, $zero, 4          # syscall for print string
        la   $a0, strDone           # address of DONE string
        syscall                     # actually print the string
        addi $v0, $zero, 10         # Syscall number 10 terminates the program
        syscall                     # exit now
