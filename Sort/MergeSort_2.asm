
# $a0 -> Array start address
# $a1 -> Array end address

MergeSort:
    beq $a0, $a1, end


    end:
        jr $ra                          # jump to return address


Merge:
