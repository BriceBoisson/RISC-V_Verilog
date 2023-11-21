# t0 = 0
li      t0, 0  # R[5]=0
li      t2, 10 # R[7]=10
loop_head:
bge     t0, t2, loop_end
# Repeated code goes here
addi    t0, t0, 1 # PC=16
j		loop_head
loop_end:
# R[0]=0
