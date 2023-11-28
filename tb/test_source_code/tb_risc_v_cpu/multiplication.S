/*
 *  0:zero, 1:ra, 2:sp, 3:gp, 4:tp, 5:t0-2, 8:s0/fp
 *  9:s1, 10:a0-7, 18:s2-11, 28:t3-6
 */

li sp, 0
j test

mult:
sw a1, 4(sp)
sw a2, 8(sp)
addi sp, sp, 8
li a0, 0
li t0, 1
mult_loop_start:
blt a1, t0, mult_loop_end
and t1, a1, 1
beq t1, zero, mult_even_compute
add a0, a0, a2
mult_even_compute:
add a2, a2, a2
srl a1, a1, 1
j mult_loop_start
mult_loop_end:
lw a2, 0(sp)
lw a1, -4(sp)
addi sp, sp, -8
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
