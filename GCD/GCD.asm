# $t0 -> a
# $t1 -> b
# $t2 -> flag & temp

GCD:
    move 	$t0, $a0		    # $t0 = $a0
    move 	$t1, $a1		    # $t1 = $a1

    slt		$t2, $t0, $t1	    # $t2 = ($t0 < $t1) ? 1 : 0

    beq     $t2, $zero, check   # if $t2 == $zero jump to check
    move 	$t2, $t0		    # $t2 = $t0
    move 	$t0, $t1		    # $t0 = $t1
    move 	$t1, $t2		    # $t1 = $t2

    check:
        beq		$t1, $zero, end 	# if $t1 != 0 jump to end

    loop:
        div		$t0, $t1			# $t0 / $t1
        mfhi	$t2					# $t2 = $t0 % $t1
        move 	$t0, $t1		    # $t0 = $t1  
        move 	$t1, $t2		    # $t1 = $t2

        bne		$t1, $zero, loop	# if $t1 != 0 jump to loop

    end:
        move 	$v0, $t0		    # $v0 = $t0
        jr $ra                      # jump to return address