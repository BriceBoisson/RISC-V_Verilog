# t0 = 0
li      t0, 0
li      t2, 10
loop_head:
bge     t0, t2, loop_end
# Repeated code goes here
addi    t0, t0, 1
j		loop_head
loop_end: