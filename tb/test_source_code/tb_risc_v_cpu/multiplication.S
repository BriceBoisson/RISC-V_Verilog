/*
 *  0:zero, 1:ra, 2:sp, 3:gp, 4:tp, 5:t0-2, 8:s0/fp
 *  9:s1, 10:a0-7, 18:s2-11, 28:t3-6
 */

li sp, 0
j test

mult:
sw ra, 4(sp)
sw a1, 8(sp)
sw a2, 12(sp)
sw s0, 16(sp)
sw s1, 20(sp)
sw s2, 24(sp)
sw s3, 28(sp)
addi sp, sp, 28
add s1, a1, zero
add s2, a2, zero
li s0, 0
li s3, 1
mult_loop_start:
blt s1, s3, mult_loop_end
and t0, s1, 1
beq t0, zero, mult_even_compute
add s0, s0, s2
mult_even_compute:
add s2, s2, s2
srl s1, s1, 1
j mult_loop_start
mult_loop_end:
add a0, s0, zero
lw s3, 0(sp)
lw s2, -4(sp)
lw s1, -8(sp)
lw s0, -12(sp)
lw a2, -16(sp)
lw a1, -20(sp)
lw ra, -24(sp)
addi sp, sp, -28
jalr ra, ra, 0

test:
li a1, 0
li a2, 0
jal ra, mult
nop # R[10]=0, R[11]=0, R[12]=0
li a1, 0
li a2, 1
jal ra, mult
nop # R[10]=0, R[11]=0, R[12]=1
li a1, 1
li a2, 0
jal ra, mult
nop # R[10]=0, R[11]=1, R[12]=0
li a1, 1
li a2, 1
jal ra, mult
nop # R[10]=1, R[11]=1, R[12]=1
li a1, 2
li a2, 1
jal ra, mult
nop # R[10]=2, R[11]=2, R[12]=1
li a1, 1
li a2, 3
jal ra, mult
nop # R[10]=3, R[11]=1, R[12]=3
li a1, 2
li a2, 2
jal ra, mult
nop # R[10]=4, R[11]=2, R[12]=2
li a1, 2
li a2, 3
jal ra, mult
nop # R[10]=6, R[11]=2, R[12]=3
li a1, 5
li a2, 3
jal ra, mult
nop # R[10]=15, R[11]=5, R[12]=3
li a1, 5
li a2, 25
jal ra, mult
nop # R[10]=125, R[11]=5, R[12]=25
