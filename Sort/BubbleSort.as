# $t0 -> first loop counter
# $t1 -> second loop counter (pointer - address)
# $t2 -> first loop condition
# $t3 -> second loop condition
# $t4 -> temp variable 1
# $t5 -> temp variable 2
# $t6 -> flag
# $t7 -> sorted-flag

BubbleSort:

    slti $t6, $a1, 2
    bne  $t6, $zero, done # if array has one element goto done

    addi	$t0, $zero, 0			# $t0 = 0

    addi	$t2, $a1, -1            # $t2 = ArrayLength - 1

    sll 	$t3, $a1, 2	            # $t3 = 4 * ArrayLength
    add    $t3, $t3, $a0            # $t3 = 4 * ArrayLength + ArrayStartAddress
    addi    $t3, $t3, -4            # $t3 = 4 * ArrayLength + ArrayStartAddress - 4


    loop_1:
        beq		$t0, $t2, done	    # if $t0 == $t2 then goto done
        addi	$t0, $t0, 1			# $t0 = $t0 + 1
        addi	$t1, $a0, 0			# ArrayStartAddress
        addi	$t7, $zero, 0		# $t7 = 0
    
        loop_2:
            lw		$t4, 0($t1)		# load element i
            lw		$t5, 4($t1)		# load element i + 1

            slt		$t6, $t5, $t4		            # $t6 = ($t5 < $t4) ? 1 : 0
            beq		$t6, $zero, loop_2_end_part	    # if $t6 == 0 then goto loop_2_end_part
        
            sw		$t5, 0($t1)		# store $5 into memory with address $t1
            sw		$t4, 4($t1)		# store $4 into memory with address $t1 + 4
            addi	$t7, $t7, 1		# $t7 = 1
            

            loop_2_end_part:
                addi	$t1, $t1, 4			# $t1 = $t1 + 4
                bne		$t1, $t3, loop_2	# if $t1 != $t3 then goto loop_2

        addi     $t3, $t3, -4          # $t3 = $t3 - 4
        beq		 $t7, $zero, done	   # if array sorted then goto done
        j loop_1 # goto loop_1

    done:
        jr $ra # goto reverse address