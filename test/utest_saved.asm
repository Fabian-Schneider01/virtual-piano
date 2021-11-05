#automatically generated code by pressing save button
#values will be compared in utest_tool to check wether buttons create the correct pitch
#checked if values of duration, volume and instrument are in range
#!this is not the test itself! will be called by utest_tool.asm!
.data
melody:
.word 60 62 64 65 67 69 71 70 68 66 63 61 

.text
initialize:
li a7, 33
li a1, 161
li a2, 48
li a3, 119
la a4, melody
li t0, 0 
li t1, 44

ret

main:
bge t1, t0, playMelody
j exit 

playMelody:
lw a0, 0(a4)
addi t0, t0, 4
addi a4, a4, 4
ecall 
j main

exit:
addi zero, zero, 0
