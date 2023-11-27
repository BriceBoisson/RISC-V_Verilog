/*
 *  0:zero, 1:ra, 2:sp, 3:gp, 4:tp, 5:t0-2, 8:s0/fp
 *  9:s1, 10:a0-7, 18:s2-11, 28:t3-6
 */

li      t0, 0  # R[5]=0
li      t1, 10 # R[6]=10
loop_pos_start:
bge     t0, t1, loop_pos_end
addi    t0, t0, 1
j		loop_pos_start
loop_pos_end:

li      a0, 10  # R[10]=10
loop_neg_start:
ble     a0, zero, loop_neg_end
addi    a0, a0, -1
j		loop_neg_start
loop_neg_end:

# R[5]=10
# R[10]=0
