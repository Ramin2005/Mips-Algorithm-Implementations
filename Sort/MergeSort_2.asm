# Memory Complexity: O(n)
# Time Complexity: O(n log n)

# $a0 -> Array start address (and later used for Heap allocation size)
# $a1 -> Array last element address
# $a2 -> Temp array start address (Heap allocated)
# $a3 -> Temp array last element address
# $v0 -> Syscall 9 return value (Heap memory address)
# $t0 -> Base case / Invalid case condition flag
# $t7 -> Array size in bytes
# $ra -> Return address
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


# $a0 -> Original array start address (current partition)
# $a1 -> Original array last element address (current partition)
# $a2 -> Temp array start address (current partition)
# $a3 -> Temp array last element address (current partition)
# $t0 -> Base case flag / Partition size / Midpoint byte offset
# $t1 -> Original array midpoint address
# $t2 -> Temp array midpoint address
# $ra -> Return address
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
    sw		$a2, 12($sp)		# Store temp start address
    sw      $t2, 16($sp)        # Store temp mid address
    sw      $a3, 20($sp)        # Store temp last element address
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

    # Merge the two sorted halves
    lw      $a0, 0($sp)         # Load start address
    lw      $a1, 8($sp)         # Load last element address
    lw      $a2, 12($sp)        # Load temp start address
    lw      $a3, 20($sp)        # Load temp last element address
    jal     Merge               # Merge the two sorted halves

    lw      $ra, 24($sp)        # Load return address
    addi    $sp, $sp, 28        # Deallocate stack space for
    end:
        jr  $ra                     # jump to return address


# $a0 -> Original array start address (input)
# $a1 -> Original array last element address (input)
# $a2 -> Temp array start address (input)
# $a3 -> Temp array last element address (input)
# $s0 -> End limit for CopyLoop / Temp array midpoint address (left half end limit)
# $s1 -> Temp array last element address (right half end limit)
# $t0 -> Original array read pointer (in CopyLoop) / Midpoint offset / Original array write pointer (in Merge loops)
# $t1 -> Temp left half read pointer
# $t2 -> Temp array write pointer (in CopyLoop) / Temp right half read pointer (in Merge loops)
# $t4 -> Element loaded from original array / Element loaded from left half
# $t5 -> Element loaded from right half
# $t6 -> Comparison result flag (left element < right element)
# $ra -> Return address
Merge:
    addi    $sp, $sp, -8       # Allocate space on stack for 4 registers ($s0, $s1, $s2, $s3)
    sw      $s0, 0($sp)         # Store $s0 on stack
    sw      $s1, 4($sp)         # Store $s1 on stack

    # Condition registers to check the end of array
    move    $s0, $a1            # $s0 = last element address
    # Initialize pointers for copying
    move    $t0, $a0            # $t0 = start address
    move    $t2, $a2            # $t2 = temp start address
    # Copy elements from original array to temp array
    CopyLoop:
        lw      $t4, 0($t0)     # Load element from original array
        sw      $t4, 0($t2)     # Store element in temp array
        beq     $t0, $s0, CopyEnd   # If start address == last element address jump to copy_end
        addi    $t0, $t0, 4     # Move to next element in original array
        addi    $t2, $t2, 4     # Move to next position in temp array
        j       CopyLoop
    CopyEnd:
    
    # Calculate the midpoint of the arrays
    sub     $t0, $a1, $a0       # $t0 = $a1 - $a0 (size of the array)
    addi    $t0, $t0, 4         # $t0 = $t0 + 4 (to include the last element)
    srl     $t0, $t0, 1         # $t0 = size of the array / 2
    andi	$t0, $t0, 0xFFFFFFFC# $t0 = $t0 & 0xFFFFFFFC (align to word boundary)
    # Condition registers to check the end of the left and right halves
    add     $s0, $a2, $t0       # $s0 = temp start address + midpoint
    move    $s1, $a3            # $s1 = temp last element address
    addi    $s1, $s1, 4         # $s1 = temp last element address + 4 (right half end limit)
    # Initialize pointers for merging
    move    $t0, $a0            # $t0 = tart address
    move    $t1, $a2            # $t1 = temp left half start address
    move    $t2, $s0            # $t2 = temp right half start address
    # Start merging the two halves
    loop_1:
        beq     $t1, $s0, loop_2    # If left half is exhausted, copy right half
        beq     $t2, $s1, loop_3    # If right half is exhausted, copy left half

        lw      $t4, 0($t1)         # Load element from left half
        lw      $t5, 0($t2)         # Load element from right

        slt     $t6, $t5, $t4       # Compare elements right < left
        bne		$t6, $zero, CopyRight   # If right < left, copy right, ELSE copy left

        CopyLeft:
            sw      $t4, 0($t0)     # Store left element in original array
            addi    $t1, $t1, 4     # Move to next element in left half
            addi    $t0, $t0, 4     # Move to next position in original array
            j       loop_1          # Repeat loop

        CopyRight:
            sw      $t5, 0($t0)     # Store right element in original array
            addi    $t2, $t2, 4     # Move to next element in right half
            addi    $t0, $t0, 4     # Move to next position in original array
            j       loop_1          # Repeat loop

    # Copy remaining elements from right half
    loop_2:
        lw      $t5, 0($t2)         # Load element from right half
        sw      $t5, 0($t0)         # Store element in original array
        addi    $t2, $t2, 4         # Move to next element in right half
        addi    $t0, $t0, 4         # Move to next position in original array
        beq     $t2, $s1, MergeEnd  # If right half is exhausted, exit loop
        j       loop_2              # Repeat loop
    
    # Copy remaining elements from left half
    loop_3:
        lw      $t4, 0($t1)         # Load element from left half
        sw      $t4, 0($t0)         # Store element in original array
        addi    $t1, $t1, 4         # Move to next element in left half
        addi    $t0, $t0, 4         # Move to next position in original array
        beq     $t1, $s0, MergeEnd  # If left half is exhausted, exit loop
        j       loop_3              # Repeat loop

MergeEnd:
    lw      $s0, 0($sp)         # Restore $s0 from stack
    lw      $s1, 4($sp)         # Restore $s1 from stack
    addi    $sp, $sp, 8         # Deallocate stack space for 2 registers
    jr      $ra                 # Return from Merge