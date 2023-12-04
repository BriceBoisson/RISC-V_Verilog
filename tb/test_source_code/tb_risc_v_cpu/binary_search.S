/*
 *  0:zero, 1:ra, 2:sp, 3:gp, 4:tp, 5:t0-2, 8:s0/fp
 *  9:s1, 10:a0-7, 18:s2-11, 28:t3-6
 */

li sp, 0
j test

binary_search:
sw ra, 4(sp)
sw a1, 8(sp)
sw s0, 12(sp)
sw s1, 16(sp)
sw s2, 20(sp)
sw s3, 24(sp)
sw s4, 28(sp)
sw s5, 32(sp)
addi sp, sp, 32
add s1, a1, zero
add s2, a2, zero
add s3, a3, zero
li s4, 0
addi s5, s2, 0
li s0, -1
binary_search_loop_start:
add s0, s4, s5
srl s0, s0, 1
ble s5, s4, binary_search_loop_end
sll t0, s0, 2
add t0, t0, s1
lw t1, 0(t0)
blt t1, s3, binary_search_lower_compute
beq t1, s3, binary_search_loop_end
addi s5, s0, 0
j binary_search_loop_start
binary_search_lower_compute:
addi s4, s0, 1
j binary_search_loop_start
binary_search_loop_end:
add a0, s0, zero
lw s5, -0(sp)
lw s4, -4(sp)
lw s3, -8(sp)
lw s2, -12(sp)
lw s1, -16(sp)
lw s0, -20(sp)
lw a1, -24(sp)
lw ra, -28(sp)
addi sp, sp, -32
jalr ra, ra, 0

test:
li a1, 40
li a2, 1
sw a2, 0(a1)
li a2, 3
sw a2, 4(a1)
li a2, 4
sw a2, 8(a1)
li a2, 7
sw a2, 12(a1)
li a2, 10
sw a2, 16(a1)
li a2, 11
sw a2, 20(a1)
li a2, 16
sw a2, 24(a1)
li a2, 7
li a3, 0
jal ra, binary_search
nop # R[10]=0
li a3, 1
jal ra, binary_search
nop # R[10]=0
li a3, 2
jal ra, binary_search
nop # R[10]=1
li a3, 4
jal ra, binary_search
nop # R[10]=2
li a3, 10
jal ra, binary_search
nop # R[10]=4
li a3, 16
jal ra, binary_search
nop # R[10]=6
li a3, 25
jal ra, binary_search
nop # R[10]=7
li a2, 11
sw a2, 0(a1)
li a2, 32
sw a2, 4(a1)
li a2, 45
sw a2, 8(a1)
li a2, 74
sw a2, 12(a1)
li a2, 102
sw a2, 16(a1)
li a2, 112
sw a2, 20(a1)
li a2, 166
sw a2, 24(a1)
li a2, 356
sw a2, 28(a1) # MEM[17]=356
li a2, 8
li a3, 0
jal ra, binary_search
nop # R[10]=0
li a3, 11
jal ra, binary_search
nop # R[10]=0
li a3, 22
jal ra, binary_search
nop # R[10]=1
li a3, 45
jal ra, binary_search
nop # R[10]=2
li a3, 102
jal ra, binary_search
nop # R[10]=4
li a3, 166
jal ra, binary_search
nop # R[10]=6
li a3, 167
jal ra, binary_search
nop # R[10]=7
li a3, 500
jal ra, binary_search
nop # R[10]=8
