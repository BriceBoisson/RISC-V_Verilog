/*
 *  0:zero, 1:ra, 2:sp, 3:gp, 4:tp, 5:t0-2, 8:s0/fp
 *  9:s1, 10:a0-7, 18:s2-11, 28:t3-6
 */

/* addi dest, reg1, imm */
addi a0, zero, 10 # R[10]=10
addi a1, zero, 1 # R[11]=1
/* addi dest, reg1, reg2 */
add a2, a0, a1 # R[12]=11
/* sub dest, reg1, reg2 - reg1 - reg2 */
sub a1, a2, a0 # R[11]=1
/* add dest, reg1, reg2 - reg1 & reg2 */
and a2, zero, a1 # R[12]=0
/* or dest, reg1, reg2 - reg1 | reg2 */
or a2, a0, a1 # R[12]=11
/* xor dest, reg1, reg2 - reg1 ^ reg2 */
xor a0, a2, a1 # R[10]=10
/* li dest, imm */
li a0, -10 # R[10]=-10
/* mv dest, reg1 */
mv a1, a0 # R[11]=-10
/* neg dest, reg1 */
neg a1, a2 # R[11]=-11

# R[0]=0
