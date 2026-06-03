fibonacci:
    addi $v0, $zero, 0
    addi $t2, $zero, 0

    slt $t2, $t2, $a0
    beq	$t2, $zero, done
    
    addi $t1, $zero, 0
    addi $t0, $zero, 0

    loop:
        add $v0, $t1, $t2
        addi $t1, $t2, 0
        addi $t2, $v0, 0
        addi $t0, $t0, 1
        bne $t0, $a0, loop

    done:
        add $v0, $t2, $zero
        jr $ra