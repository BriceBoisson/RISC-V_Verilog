/*
 *  0:zero, 1:ra, 2:sp, 3:gp, 4:tp, 5:t0-2, 8:s0/fp
 *  9:s1, 10:a0-7, 18:s2-11, 28:t3-6
 *  beq, bne, blt, ble, bltu, bleu
 *  bgt, bge, beqz, bnez, blez, bgez, bltz, bgtz
 */

addi a0, zero, 0 # R[10]=0
start:
beq a0, zero, first
addi a0, a0, 1 # R[10]=3
first:
bne a0, zero, second
addi a0, a0, 2 # R[10]=2
j start
second:
addi a1, zero, 4 # R[11]=4
blt a0, a1, third
addi a0, a0, 3 # R[10]=10
third:
addi a1, zero, 7 # R[11]=7
ble a1, a0, forth
add a0, a0, 4 # R[10]=7
j second
forth:
addi a1, zero, 4294967295 # R[11]=4294967295, R[11]=-1
bltu a0, a1, fifth
addi a0, a0, 5
fifth:
addi a1, zero, 16 # R[11]=16
bleu a1, a0, sixth
add a0, a0, 6 # R[10]=16
j forth
sixth:
blt a0, a1, end
addi a0, a0, 7 # R[10]=23
end:

# R[10]=23
