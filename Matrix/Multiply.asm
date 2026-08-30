# A and B are saved in memory with row-major approach
# Cx, z = Ax,y * By, z
# $a0 -> Matrix A start address
# $a1 -> Matrix B start address
# $a2 -> Matrix C start address
# 0($sp) -> z
# 4($sp) -> y
# 8($sp) -> x

# $t0 -> A row pointer and loop_1 condition
# $t1 -> B column pointer and loop_2 condition
# $t2 -> C elements pointer
# $t3 -> A address pointer
# $t4 -> B address Pointer
# $t5 -> loop_3 condition
# $t6 -> temp_1
# $t7 -> temp_2
# $t8 -> temp_3

# $s0 -> loop_1 condition
# $s1 -> loop_2 condition
# $s2 -> for address increment y*4
# $s3 -> for address increment z*4
# $s4 -> temp_4 (Ci,j)
# $S5 -> Matrix B start address


Multiply:
    lw      $t6, 0($sp)             # $t6 = (M[$sp] to M[$sp + 3]) -> z
    lw      $t7, 4($sp)             # $t7 = (M[$sp - 4] to M[$sp - 1]) -> y
    lw      $t8, 8($sp)             # $t8 = (M[$sp - 8] to M[$sp - 5]) -> x

    # save $s
    addi $sp, $sp, -24
    sw   $s0, 0($sp)
    sw   $s1, 4($sp)
    sw   $s2, 8($sp)
    sw   $s3, 12($sp)
    sw   $s4, 16($sp)
    sw   $s5, 20($sp)

    move    $t0, $a0    		    # $t0 = $a0
    move    $t2, $a2    		    # $t2 = $a2

    mul     $s0, $t7, $t8           # $s0 = x*y
    sll     $s0, $s0, 2             # $s0 = 4**xy
    add	    $s0, $s0, $a0   		# $s0 = $s0 + $a0

    move    $s1, $t6    		    # $s1 = $t6
    sll     $s1, $s1, 2             # $s1 = 4*z
    add	    $s1, $s1, $a1   		# $a1 = $s1 + $a1
    
    sll     $s2, $t7, 2             # $s2 = 4*y
    sll     $s3, $t6, 2             # $s3 = 4*z

    move    $s5, $a1    		    # $s5 = $a1
    

    loop_1:
        beq     $t0, $s0, end           # if $t1 == $s1 jump to end
        
        move    $t1, $s5    		    # $t1 = $s5

        loop_2:
            beq     $t1, $s1, loop_2_end    # if $t1 == $s1 jump to loop_2_end

            move    $s4, $zero              # $s4 = 0
            move    $t3, $t0                # $t3 = $t0
            move    $t4, $t1                # $t4 = $t1
            add     $t5, $t3, $s2           # $t5 = $t3 + $s2

            loop_3:
                beq	    $t3, $t5, loop_3_end    # if $t3 == $t5 jump to loop_3_end

                lw		$t6, 0($t3)             # $t6 = (M[$t3] to M[$t3 + 3])
                lw		$t7, 0($t4)             # $t7 = (M[$t4] to M[$t4 + 3])

                mul     $t8, $t7, $t6           # $t8 = $t7 * $t6
                add     $s4, $s4, $t8           # $s4 = $s4 + $t8

                addi    $t3, $t3, 4             # $t3 = $t3 + 4
                add     $t4, $t4, $s3           # $t4 = $t4 + 4*z
                j		loop_3				    # jump to loop_3
                
            loop_3_end:
                sw      $s4, 0($t2)             # store $s4 in memory at $t2
                addi    $t2, $t2, 4             # $t2 = $t2 + 4
                addi    $t1, $t1, 4             # $t1 = $t1 + 4
                j       loop_2                  # jump to loop_2

        loop_2_end:
            add     $t0, $t0, $s2           # $t0 = st0 + $s2
            j       loop_1				    # jump to loop_1

    end:
        # load $s
        lw   $s0, 0($sp)
        lw   $s1, 4($sp)
        lw   $s2, 8($sp)
        lw   $s3, 12($sp)
        lw   $s4, 16($sp)
        lw   $s5, 20($sp)
        addi $sp, $sp, 24

        jr $ra                          # jump to return address