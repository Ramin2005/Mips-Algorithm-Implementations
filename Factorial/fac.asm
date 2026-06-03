factorial:
    addi $v0, $zero, 1      # initialize result to 1
    addi $t0, $zero, 1      # load constant 1
    slt  $t0, $t0, $a0      # t0 = 1 if n > 1, otherwise 0
    beq  $t0, $zero, done    # return 1 if n <= 1

    addi $t0, $zero, 1      # initialize loop counter

    loop:
        mul  $v0, $v0, $t0      # result *= counter
        beq  $t0, $a0, done      # stop when counter reaches n
        addi $t0, $t0, 1        # counter++
        j    loop               # repeat loop

    done:
        jr   $ra                # return to caller