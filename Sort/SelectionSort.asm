# $t0 -> first loop counter (pointer - address)
# $t1 -> second loop counter (pointer - address)
# $t2 -> first loop condition - 4 * ArrayLength + ArrayStartAddress
# $t3 -> min value
# $t4 -> min pointer
# $t5 -> temp
# $t6 -> flag

SelectionSort:
    
    slti    $t6, $a1, 2
    bne     $t6, $zero, end         # if array has one element jump to end

    add 	$t0, $a0, $zero    		# $t0 = ArrayStartAddress

    sll 	$t2, $a1, 2	            # $t2 = 4 * ArrayLength
    add     $t2, $t2, $a0           # $t2 = 4 * ArrayLength + ArrayStartAddress

    loop_1:
        beq		$t0, $t2, end	        # if $t0 == $t2 then jump to end
        
        add 	$t1, $t0, $zero		    # $t1 = $t0
        add 	$t4, $t1, $zero		    # $t4 = $t1
        lw		$t3, 0($t4)		        # $t3 = (M[$t4] to M[$t4 + 3])

        loop_2:
            addi    $t1, $t1, 4             # $t1 = $t1 + 4
            beq		$t1, $t2, loop_end	    # if $t1 == $t2 then jump to loop_end

            lw      $t5, 0($t1)             # $t5 = (M[$t1] to M[$t1 + 3])

            slt     $t6, $t5, $t3           # $t6 = ($t5 < $t3)
            beq		$t6, $zero, loop_2      # if $t6 == 0 then jump to loop_2

            add		$t3, $t5, $zero		    # $t3 = $t5
            add 	$t4, $t1, $zero		    # $t4 = $t1

            j       loop_2                  # jump to loop_2

        loop_end:
            beq		$t0, $t4, jump	        # if $t0 == $t4 then jump to jump
            # swap:
            lw		$t5, 0($t0)		        # $t5 =  (M[$t0] to M[$t0 + 3])
            sw		$t5, 0($t4)		        # store $t5 in memory at $t4
            sw		$t3, 0($t0)		        # store $t3 in memory at $t0

            jump:
                addi    $t0, $t0, 4             # $t0 = $t0 + 4
                j		loop_1				    # jump to loop_1

    end:
        jr $ra                          # jump to reverse address