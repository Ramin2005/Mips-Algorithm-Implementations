# $t0 -> first loop counter (pointer - address)
# $t1 -> second loop counter (pointer - address)
# $t2 -> first loop condition - 4 * ArrayLength + ArrayStartAddress
# $t3 -> temp variable 1
# $t4 -> temp variable 2
# $t5 -> flag


InsertionSort:
    
    slti    $t5, $a1, 2
    bne     $t5, $zero, end         # if array has one element jump to end

    addi	$t0, $a0, 4     		# $t0 = ArrayStartAddress + 4

    sll 	$t2, $a1, 2	            # $t2 = 4 * ArrayLength
    add     $t2, $t2, $a0           # $t2 = 4 * ArrayLength + ArrayStartAddress


    loop_1:
        beq		$t0, $t2, end	        # if $t0 == $t2 then jump to end

        addi    $t1, $t0, 0             # $t1 = $t0
        lw		$t3, 0($t0)		        # $t3 = (M[$t0] to M[$t0 + 3])

        loop_2:
            beq		$t1, $a0, loop_end	        # if $t1 == $a0 then jump to loop_end 

            lw		$t4, -4($t1)		        # $t4 = (M[$t1] to M[$t1 + 3])

            slt		$t5, $t3, $t4		        # $t5 = ($t3 < $t4) ? 1 : 0
            beq		$t5, $zero, loop_end	    # if $t5 == 0 then jump to loop_end
            
            sw		$t4, 0($t1)		            # store $t4 in memory at $t1
            addi	$t1, $t1, -4			    # $t1= $t1 - 4

            j		loop_2				        # jump to loop_2

        loop_end:
            sw		$t3, 0($t1)		            # store $t3 in memory at $t1
            addi	$t0, $t0, 4			        # $t0 = $t0 + 4

            j       loop_1                      # jump to loop_1
            

    end:
        jr $ra                          # jump to reverse address