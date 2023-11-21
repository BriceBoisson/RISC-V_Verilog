# t0 = 0
li      t0, 0
li      t2, 10 # R[2]=10, MEM[1]=6
loop_head:
bge     t0, t2, loop_end
# Repeated code goes here
addi    t0, t0, 1 # PC=16
j		loop_head
loop_end:

# R[0]=0
