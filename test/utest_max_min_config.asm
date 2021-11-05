#testing the maximum position of sliders in the tool (duration and volume completely right)
#check wether they are still in range (not bigger 3000, 127 and 112 -> not smaller than 0)
#code from "utest_saved_max_config.asm" is generated with the save function of the virtual piano (melody deleted because not relevant for this test)
.text
#test if maximum value of duration slider is still in range
jal utest_max
jal test_duration
jal utest_min
jal test_duration
j utest_exit
test_duration:
	li t0, 0
	blt a1, t0, utest_failed
	li t0, 3000
	blt t0, a1, utest_failed
	li a1, 1
	j test_instrument
	
#test if last instrument in instrument menu is still in range
test_instrument:
	li t0, 0
	blt a2, t0, utest_failed
	li t0, 127
	blt t0, a2, utest_failed
	li a2, 1
	j test_volume
	
#test if maximum value of volume slider is still in range
test_volume:
	li t0, 0
	blt a3, t0, utest_failed
	li t0, 127
	blt t0, a3, utest_failed
	li a3, 1
	ret
	
#testing the minimum position of sliders in the tool (duration and volume completely left)
#check wether they are still in range (not bigger 3000, 127 and 112 -> not smaller than 0) 
#code from "utest_saved_min_config.asm" is generated with the save function of the virtual piano (melody deleted because not relevant for this test
jal utest_min
	
#fails if at least a0, a1, a2 or a3 not store 1
utest_failed:
	li a7, 10
	ecall

#success if a0, a1, a2, a3 store 1
utest_exit:
	li a7, 10
	ecall

.include "utest_saved_max_config.asm"
.include "utest_saved_min_config.asm"
	

