
# $a0 -> Array start address
# $a1 -> Array length

MergeSort:
    li		$t0, 1			# $t0 = 1
    beq     $a1, $t0, end	# if array has one element jump to end


    end:
        jr $ra                          # jump to return address


Merge:
