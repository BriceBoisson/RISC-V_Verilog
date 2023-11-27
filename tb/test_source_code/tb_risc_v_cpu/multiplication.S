/*
 *  0:zero, 1:ra, 2:sp, 3:gp, 4:tp, 5:t0-2, 8:s0/fp
 *  9:s1, 10:a0-7, 18:s2-11, 28:t3-6
 */

j test

mult:
li a0, 0
li a2, 1
mult_loop_start:
blt t1, a2, mult_loop_end
and a1, t1, 1
beq a1, zero, mult_even_compute
add a0, a0, t2
mult_even_compute:
add t2, t2, t2
srl t1, t1, 1
j mult_loop_start
mult_loop_end:
jalr ra, t0, 0

test:
li t1, 0
li t2, 0
jal t0, mult
nop # R[10]=0
li t1, 0
li t2, 1
jal t0, mult
nop # R[10]=0
li t1, 1
li t2, 0
jal t0, mult
nop # R[10]=0
li t1, 1
li t2, 1
jal t0, mult
nop # R[10]=1
li t1, 2
li t2, 1
jal t0, mult
nop # R[10]=2
li t1, 1
li t2, 3
jal t0, mult
nop # R[10]=3
li t1, 2
li t2, 2
jal t0, mult
nop # R[10]=4
li t1, 2
li t2, 3
jal t0, mult
nop # R[10]=6
li t1, 5
li t2, 3
jal t0, mult
nop # R[10]=15
li t1, 5
li t2, 25
jal t0, mult
nop # R[10]=125
