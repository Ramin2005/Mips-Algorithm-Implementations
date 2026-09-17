# Memory Complexity: O(n)
# Time Complexity: O(n log n)

# $a0 -> Array start address
# $a1 -> Array last element address
Sort:
    slt		$t0, $a1, $a0		# $t0 = ($a1 < $a0) ? 1 : 0
    bne		$t0, $zero, SortEnd # If last element address < start address, return (invalid case)
    beq     $a0, $a1, SortEnd   # If start address == last element address, return (base case)

    addi    $sp, $sp, -12       # Allocate space on stack for 3 words (start, end, return address)
    sw		$a0, 0($sp)		    # Store start address
    sw		$a1, 4($sp)		    # Store last element address
    sw		$ra, 8($sp)		    # Store return address

    sub     $t7, $a1, $a0       # $t7 = $a1 - $a0 (size of the array)
    addi    $t7, $t7, 4         # $t7 = $t7 + 4 (to include the last element)

    # Declare temp array to hold merged results
    move 	$a0, $t7		    # $a0 = $t7
    li      $v0, 9
    syscall
    move    $a2, $v0            # $a2 = Temp array address

    # load start and end addresses from stack
    lw      $a0, 0($sp)         # Load start address
    lw      $a1, 4($sp)         # Load last element address
    addi    $sp, $sp, 8         # Deallocate stack space for start, end, return address
    
    # temp array last element address
    add     $a3, $a2, $t7       # $a3 = Temp array last element address
    addi	$a3, $a3, -4	    # $a3 = Temp array last element address (subtract 4 to get the last element address)

    jal     MergeSort           # Call MergeSort to sort the array

    lw      $ra, 0($sp)         # Load return address
    addi    $sp, $sp, 4         # Deallocate stack space for return address

    SortEnd:
        jr  $ra                     # jump to return address

MergeSort:
    slt		$t0, $a1, $a0		# $t0 = ($a1 < $a0) ? 1 : 0
    bne		$t0, $zero, end     # If last element address < start address, return (invalid case)
    beq     $a0, $a1, end       # If start address == last element address, return (base case)

    sub     $t0, $a1, $a0       # $t0 = $a1 - $a0 (size of the array)
    addi    $t0, $t0, 4         # $t0 = $t0 + 4 (to include the last element)
    srl     $t0, $t0, 1         # $t0 = size of the array / 2
    andi	$t0, $t0, 0xFFFFFFFC# $t0 = $t1 & 0xFFFFFFFC (align to word boundary)
    add     $t1, $a0, $t0       # $t1 = start address + midpoint
    add     $t2, $a2, $t0       # $t2 = temp start address + midpoint
    
    addi    $sp, $sp, -28       # Allocate space on stack for 7 words (start, mid, end, temp start, temp mid, temp end, return address)
    sw		$a0, 0($sp)		    # Store start address
    sw		$t1, 4($sp)		    # Store mid address
    sw		$a1, 8($sp)		    # Store last element address
    sw		$a2, 12($sp)		# Store temp array start address
    sw      $t2, 16($sp)        # Store temp mid address
    sw      $a3, 20($sp)        # Store temp array last element address
    sw		$ra, 24($sp)		# Store return address
 
    # Recursively sort left half
    move    $a1, $t1            # Load last element address of left half
    addi    $a1, $a1, -4        # Load last element address of left half
    move    $a3, $t2            # Load temp last element address of left half
    addi    $a3, $a3, -4        # Load temp last element address of left half
    jal     MergeSort           # Recursively sort left half

    # Recursively sort right half
    lw      $a0, 4($sp)         # Load start address of right half (midpoint)
    lw      $a1, 8($sp)         # Load last element address of right half
    lw      $a2, 16($sp)        # Load temp start address of right half (midpoint)
    lw      $a3, 20($sp)        # Load temp last element address of right half
    jal     MergeSort           # Recursively sort right half

    end:
        jr  $ra                     # jump to return address

Merge:
    