/*
 *  0:zero, 1:ra, 2:sp, 3:gp, 4:tp, 5:t0-2, 8:s0/fp
 *  9:s1, 10:a0-7, 18:s2-11, 28:t3-6
 *  beq, bne, blt, ble, bltu, bgeu
 *  bgt, bge, beqz, bnez, blez, bgez, bltz, bgtz
 */

addi a0, zero, 0 # R[10]=0
start:
beq a0, zero, second
addi a0, a0, 1 # R[10]=3
second:
bne a0, zero, end
addi a0, a0, 2 # R[10]=2
j start
end:

# R[10]=3
