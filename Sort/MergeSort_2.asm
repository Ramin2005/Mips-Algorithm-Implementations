
# $a0 -> Array start address
# $a1 -> Array end address

MergeSort:
    slt		$t0, $a1, $a0		# $t0 = ($a1 < $a0) ? 1 : 0
    beq		$t0, $zero, end     # If end address < start address, return (invalid case)
    beq     $a0, $a1, end       # If start address == end address, return (base case)

    addi    $sp, $sp, -12       # Allocate space on stack for 3 words (start, end, return address)
    sw		$a0, 0($sp)		    # Store start address
    sw		$a1, 4($sp)		    # Store end address
    sw		$ra, 8($sp)		    # Store return address

    # Declare temp array to hold merged results
    sub		$t0, $a1, $a0		# $t0 = $a1 - $a0
    addi	$t0, $t0, 4		    # $t0 = $t0 + 4 (to include the last element)
    move 	$a0, $t0		    # $a0 = $t0
    li      $v0, 9
    syscall
    move    $a0, $v0            # $s0 = Temp array address

    move    $t2, $a0            # $t2 = Temp array start address
    add     $a2, $a0, $t0       # $a2 = Temp array end address
    lw      $t0, 0($sp)		    # Load start address
    lw      $t1, 4($sp)		    # Load end address

    # Get copy of the array elements into temp array
    loop:
        lw		$t4, 0($t0)		# Load element from left
        sw		$t1, 0($t4)		# Store element in temp array
        addi	$t0, $t0, 4		# Move to next element in left array
        addi	$t2, $t2, 4		# Move to next position in temp array
        bne     $t0, $t1, loop  # If start address != end address jump to loop

    add     $a1, $a0, $a2       # $a1 = Temp array end address + Temp array start address
    srl		$a1, $a1, 1			# $a1 = $a1/2 (midpoint of the array)
    addi    $a1, $a1, -4        # Adjust midpoint to point to the last element of the left half

    # store start, mid, end on stack for recursive calls
    addi   $sp, $sp, -12        # Allocate space on stack for 2 words (start, mid, end)
    sw     $a0, 0($sp)          # Store start address
    sw     $a1, 4($sp)          # Store midpoint
    sw     $a2, 8($sp)          # Store end address
    
    # Recursively sort left half
    call    MergeSort           # Recursively sort left half

    # Recursively sort right half
    lw      $a0, 4($sp)         # Load midpoint
    addi    $a0, $a0, 4         # Load start address of right half
    lw      $a1, 8($sp)         # Load end address
    call    MergeSort           # Recursively sort right half

    lw     $t0, 0($sp)          # Load start address
    lw     $t1, 4($sp)          # Load midpoint
    lw     $t2, 8($sp)          # Load end address
    addi   $sp, $sp, 12         # Deallocate stack space for start, mid, end

    lw     $t3, 0($sp)          # Load temp array start address
    lw     $t4, 4($sp)          # Load temp array end address
    addi   $sp, $sp, 8          # Deallocate stack space for temp array addresses

    # Call Merge function to merge the two sorted halves
    move   $a0, $t0             # $a0 = temp start address
    move   $a1, $t2             # $a1 = temp end address
    move   $a2, $t3             # $a2 = original start address
    move   $a3, $t4             # $a3 = original end address
    call   Merge                # Merge the two sorted halves

    lw     $ra, 0($sp)          # Restore return address
    addi   $sp, $sp, 4          # Deallocate stack space

    end:
        jr $ra                          # jump to return address


Merge:
    move   $t0, $a2             # $t0 = original start address
    move   $t1, $a3             # $t1 = original end address
    move   $t2, $a0             # $t2 = temp start address
    move   $t4, $a1             # $t4 = temp end address

    add     $t3, $t2, $t4       # $t3 = temp start address + temp end address
    srl		$t3, $t3, 1			# $t3 = midpoint of temp array

    loop:
    
        lw      $t3, 0($t0)         # Load element from left half
        lw      $t4, 0($t1)         # Load element from right half
