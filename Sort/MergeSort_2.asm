
# $a0 -> Array start address
# $a1 -> Array last element address

MergeSort:
    slt		$t0, $a1, $a0		# $t0 = ($a1 < $a0) ? 1 : 0
    bne		$t0, $zero, end     # If last element address < start address, return (invalid case)
    beq     $a0, $a1, end       # If start address == last element address, return (base case)

    addi    $sp, $sp, -12       # Allocate space on stack for 3 words (start, end, return address)
    sw		$a0, 0($sp)		    # Store start address
    sw		$a1, 4($sp)		    # Store last element address
    sw		$ra, 8($sp)		    # Store return address

    # Declare temp array to hold merged results
    sub		$t0, $a1, $a0		# $t0 = $a1 - $a0
    addi	$t0, $t0, 4		    # $t0 = $t0 + 4 (to include the last element)
    move 	$a0, $t0		    # $a0 = $t0
    li      $v0, 9
    syscall
    move    $a0, $v0            # $s0 = Temp array address

    move    $t2, $a0            # $t2 = Temp array start address
    add     $a2, $a0, $t0       # $a2 = Temp array last element address
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
    add     $a1, $a0, $a2       # $a1 = Temp array last element address + Temp array start address
    srl		$a1, $a1, 1			# $a1 = $a1/2 (midpoint of the array)
    andi	$a1, $a1, 0xFFFFFFFC# $a1 = $a1 & 0xFFFFFFFC (align to word boundary)

    # store start, mid, end on stack for recursive calls
    addi    $sp, $sp, -12       # Allocate space on stack for 2 words (start, mid, end)
    sw      $a0, 0($sp)         # Store start address
    sw      $a1, 4($sp)         # Store midpoint
    sw      $a2, 8($sp)         # Store last element address
    
    # Recursively sort left half
    jal     MergeSort           # Recursively sort left half

    # Recursively sort right half
    lw      $a0, 4($sp)         # Load midpoint
    addi    $a0, $a0, 4         # Load start address of right half
    lw      $a1, 8($sp)         # Load last element address
    jal     MergeSort           # Recursively sort right half

    lw      $t0, 0($sp)         # Load start address
    lw      $t1, 4($sp)         # Load midpoint
    lw      $t2, 8($sp)         # Load last element address
    addi    $sp, $sp, 12        # Deallocate stack space for start, mid, end

    lw      $t3, 0($sp)         # Load temp array start address
    lw      $t4, 4($sp)         # Load temp array last element address
    addi    $sp, $sp, 8         # Deallocate stack space for temp array addresses

    addi    $t1, $t1, 4         # $t1 = midpoint + 4 (start of right half)
    # Call Merge function to merge the two sorted halves
    move    $a0, $t0            # $a0 = temp start address
    move    $a1, $t1            # $a1 = temp midpoint address
    move    $a2, $t2            # $a2 = temp last element address
    move    $a3, $t3           `# $a3 = original start address
    jal     Merge               # Merge the two sorted halves

    lw      $ra, 0($sp)         # Restore return address
    addi    $sp, $sp, 4         # Deallocate stack space

    end:
        jr  $ra                     # jump to return address


Merge:
    addi    $sp, $sp, -8        # Allocate space on stack for 2 registers ($s0, $s1)
    sw      $s0, 0($sp)         # Store $s0 on stack
    sw      $s1, 4($sp)         # Store $s1 on stack

    move    $t1, $a0            # $t1 = temp start address
    move    $s0, $a1            # $s0 = temp midpoint address
    move   `$t2, $a1            # $t2 = temp midpoint address
    move    $s1, $a2            # $s1 = temp last element address
    move    $t0, $a3            # $t0 = original start address

    loop_1:
        lw      $t4, 0($t1)         # Load element from left half
        lw      $t5, 0($t2)         # Load element from right half

        slt     $t6, $t4, $t5       # $t6 = ($t4 < $t5) ? 1 : 0

        bne		$t6, $zero, left	# if $t6 != 0 then jump to left

        right:
            sw		$t5, 0($t0)		# Store element from right half into original array
            addi	$t2, $t2, 4		# Move to next element in right half
            j		end_loop_1	    # jump to end_loop_1
            
        left:
            sw      $t4, 0($t0)		# Store element from left half into original array
            addi	$t1, $t1, 4		# Move to next element in left half
        
        end_loop_1:   
            addi	$t0, $t0, 4		    # Move to next position in original array
            beq     $t1, $s0, loop_2    # If temp start == temp midpoint, jump to loop_2
            beq     $t2, $s1, loop_3    # If temp midpoint == temp last element address, jump to loop_3
            j       loop_1              # Jump back to loop_1

    loop_2:
        # Copy remaining elements from right half
        lw      $t4, 0($t2)         # Load element from right half
        sw      $t4, 0($t0)         # Store element into original array
        beq     $t2, $s1, merge_end # If temp midpoint != temp last element address jump to merge_end
        addi    $t2, $t2, 4         # Move to next element in right half
        addi    $t0, $t0, 4         # Move to next position in original array
        j       loop_2              # Jump back to loop_2
    
    j      merge_end            # jump to merge_end

    loop_3:
        # Copy remaining elements from left half
        lw      $t4, 0($t1)         # Load element from left half
        sw      $t4, 0($t0)         # Store element into original array
        beq     $t1, $s0, merge_end # If temp start != temp midpoint jump to merge_end
        addi    $t1, $t1, 4         # Move to next element in left half
        addi    $t0, $t0, 4         # Move to next position in original array
        j       loop_3              # Jump back to loop_3

    lw     $s0, 0($sp)         # Restore $s0 from stack
    lw     $s1, 4($sp)         # Restore $s1 from stack
    addi   $sp, $sp, 8         # Deallocate stack space for $s0 and $s1

    merge_end:
        jr      $ra                 # Return from Merge function    