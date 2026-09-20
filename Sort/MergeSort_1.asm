# Memory Complexity: O(n log n)
# Time Complexity: O(n log n)

# $a0 -> Array start address / Heap allocation size / Temp array start address
# $a1 -> Array last element address / Midpoint address
# $a2 -> Temp array last element address
# $a3 -> Original array start address (passed to Merge)
# $v0 -> Syscall service 9 result (allocated memory address)
# $t0 -> Base case flag / Source pointer in copy loop / Midpoint offset
# $t1 -> Copy loop end address condition
# $t2 -> Destination pointer in copy loop
# $t3 -> Temp array start address (loaded from stack for Merge)
# $t4 -> Temp element value during copy / Temp array end address
# $t7 -> Array size in bytes
# $ra -> Return address
MergeSort:
    slt		$t0, $a1, $a0		# $t0 = ($a1 < $a0) ? 1 : 0
    bne		$t0, $zero, end     # If last element address < start address, return (invalid case)
    beq     $a0, $a1, end       # If start address == last element address, return (base case)

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
    move    $a0, $v0            # $a0 = Temp array address

    move    $t2, $a0            # $t2 = Temp array start address
    add     $a2, $a0, $t7       # $a2 = Temp array last element address
    addi	$a2, $a2, -4	    # $a2 = Temp array last element address (subtract 4 to get the last element address)
    lw      $t0, 0($sp)		    # Load start address
    lw      $t1, 4($sp)		    # Load last element address

    # Get copy of the array elements into temp array
    loop:
        lw		$t4, 0($t0)		# Load element from left
        sw		$t4, 0($t2)		# Store element in temp array
        beq     $t0, $t1, end_loop  # If start address == last element address jump to end_loop
        addi	$t0, $t0, 4		# Move to next element in left array
        addi	$t2, $t2, 4		# Move to next position in temp array
        j       loop

    end_loop:
    
    srl     $t0, $t7, 1         # $t0 = size of the array / 2
    andi	$t0, $t0, 0xFFFFFFFC# $t0 = $t1 & 0xFFFFFFFC (align to word boundary)
    add     $a1, $a0, $t0       # $a1 = start address + midpoint

    # store start, mid, end on stack for recursive calls
    addi    $sp, $sp, -12       # Allocate space on stack for 2 words (start, mid, end)
    sw      $a0, 0($sp)         # Store start address
    sw      $a1, 4($sp)         # Store midpoint
    sw      $a2, 8($sp)         # Store last element address
    
    # Recursively sort left half
    addi    $a1, $a1, -4        # Load last element address of left half
    jal     MergeSort           # Recursively sort left half

    # Recursively sort right half
    lw      $a0, 4($sp)         # Load start address of right half (midpoint)
    lw      $a1, 8($sp)         # Load last element address of right half
    jal     MergeSort           # Recursively sort right half

    lw      $t0, 0($sp)         # Load start address
    lw      $t1, 4($sp)         # Load midpoint
    lw      $t2, 8($sp)         # Load last element address
    addi    $sp, $sp, 12        # Deallocate stack space for start, mid, end

    lw      $t3, 0($sp)         # Load temp array start address
    lw      $t4, 4($sp)         # Load temp array last element address
    addi    $sp, $sp, 8         # Deallocate stack space for temp array addresses

    # Call Merge function to merge the two sorted halves
    move    $a0, $t0            # $a0 = temp start address
    move    $a1, $t1            # $a1 = temp midpoint address
    move    $a2, $t2            # $a2 = temp last element address
    move    $a3, $t3            # $a3 = original start address
    jal     Merge               # Merge the two sorted halves

    lw      $ra, 0($sp)         # Restore return address
    addi    $sp, $sp, 4         # Deallocate stack space

    end:
        jr  $ra                     # jump to return address



# $a0 -> Temp array start address (input)
# $a1 -> Temp array midpoint address (input)
# $a2 -> Temp array last element address (input)
# $a3 -> Original array start address (input)
# $s0 -> Temp midpoint address (left half end limit)
# $s1 -> Temp last element address + 4 (right half end limit)
# $t0 -> Original array write pointer
# $t1 -> Left half read pointer
# $t2 -> Right half read pointer
# $t4 -> Value loaded from left half / Temp storage
# $t5 -> Value loaded from right half
# $t6 -> Comparison result flag $t4 < $t5
# $ra -> Return address
Merge:
    addi    $sp, $sp, -8        # Allocate space on stack for 2 registers ($s0, $s1)
    sw      $s0, 0($sp)         # Store $s0 on stack
    sw      $s1, 4($sp)         # Store $s1 on stack

    move    $t1, $a0            # $t1 = temp start address
    move    $s0, $a1            # $s0 = temp midpoint address
    move    $t2, $a1            # $t2 = temp midpoint address
    move    $s1, $a2            # $s1 = temp last element address
    move    $t0, $a3            # $t0 = original start address

    addi    $s1, $s1, 4          # $s1 = temp last element address + 4 (right half end limit)

    loop_1:
        beq     $t1, $s0, loop_2    # If left half is exhausted, copy right half
        beq     $t2, $s1, loop_3    # If right half is exhausted, copy left half

        lw      $t4, 0($t1)         # Load element from left half
        lw      $t5, 0($t2)         # Load element from right half

        slt     $t6, $t4, $t5       # Compare elements left < right
        beq		$t6, $zero, CopyRight   # If left >= right, copy Right element
           
        CopyLeft:
            sw      $t4, 0($t0)		# Store element from left half into original array
            addi	$t1, $t1, 4		# Move to next element in left half
            addi	$t0, $t0, 4		# Move to next position in original array
            j		loop_1	        # jump to end_loop_1

        CopyRight:
            sw		$t5, 0($t0)		# Store element from right half into original array
            addi	$t2, $t2, 4		# Move to next element in right half
            addi	$t0, $t0, 4		# Move to next position in original array
            j		loop_1	        # jump to end_loop_1

    # Copy remaining elements from right half
    loop_2:
        lw      $t4, 0($t2)         # Load element from right half
        sw      $t4, 0($t0)         # Store element into original array
        addi    $t2, $t2, 4         # Move to next element in right half
        addi    $t0, $t0, 4         # Move to next position in original array
        beq     $t2, $s1, MergeEnd  # If temp midpoint != temp last element address jump to MergeEnd
        j       loop_2              # Jump back to loop_2

    # Copy remaining elements from left half
    loop_3:
        lw      $t4, 0($t1)         # Load element from left half
        sw      $t4, 0($t0)         # Store element into original array
        addi    $t1, $t1, 4         # Move to next element in left half
        addi    $t0, $t0, 4         # Move to next position in original array
        beq     $t1, $s0, MergeEnd  # If temp start != temp midpoint jump to MergeEnd
        j       loop_3              # Jump back to loop_3


    MergeEnd:
        lw      $s0, 0($sp)         # Restore $s0 from stack
        lw      $s1, 4($sp)         # Restore $s1 from stack
        addi    $sp, $sp, 8         # Deallocate stack space for $s0 and $s1
        jr      $ra                 # Return from Merge function