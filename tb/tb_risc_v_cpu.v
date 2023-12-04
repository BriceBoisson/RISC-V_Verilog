`timescale 1ns / 1ps
`include "tb_tools.vh"

module tb_risc_v_cpu ();
    reg         clk;
    reg         reset;
    integer     i;
    wire [31:0] out;

    risc_v_cpu risc_v_cpu (
        .clock(clk),
        .reset(reset),
        .out(out)
    );

    initial begin
        /* Reset */
        reset = 1'b1;
        #10
        reset = 1'b0;

        clk = 1'b0;

        /* Fibonacci */

        /* ADDi $1, R[0], R[6] - R[6] = 1 */
        /* "000000000001_00000_000_00110_0010000" */
        risc_v_cpu.uut_instruction.memory[0] = 8'b00010000;
        risc_v_cpu.uut_instruction.memory[1] = 8'b00000011;
        risc_v_cpu.uut_instruction.memory[2] = 8'b00010000;
        risc_v_cpu.uut_instruction.memory[3] = 8'b00000000;

        /* ADDi $0, R[0], R[7] - R[7] = 0 */
        /* "000000000000_00000_000_00111_0010000" */
        risc_v_cpu.uut_instruction.memory[4] = 8'b10010000;
        risc_v_cpu.uut_instruction.memory[5] = 8'b00000011;
        risc_v_cpu.uut_instruction.memory[6] = 8'b00000000;
        risc_v_cpu.uut_instruction.memory[7] = 8'b00000000;

        /* ADDi $0, R[6],  R[8] - R[8] = R[6] */
        /* "000000000000_00110_000_01000_0010000" */
        risc_v_cpu.uut_instruction.memory[8]  = 8'b00010000;
        risc_v_cpu.uut_instruction.memory[9]  = 8'b00000100;
        risc_v_cpu.uut_instruction.memory[10] = 8'b00000011;
        risc_v_cpu.uut_instruction.memory[11] = 8'b00000000;

        /* ADD R[7], R[6], R[6] - R[6] = R[7] + R[6] */
        /* "0000000_00111_00110_000_00110_0110000" */
        risc_v_cpu.uut_instruction.memory[12] = 8'b00110000;
        risc_v_cpu.uut_instruction.memory[13] = 8'b00000011;
        risc_v_cpu.uut_instruction.memory[14] = 8'b01110011;
        risc_v_cpu.uut_instruction.memory[15] = 8'b00000000;

        /* ADDi $0, R[8], R[7] - R[7] = R[8] */
        /* "000000000000_01000_000_00111_0010000" */
        risc_v_cpu.uut_instruction.memory[16] = 8'b10010000;
        risc_v_cpu.uut_instruction.memory[17] = 8'b00000011;
        risc_v_cpu.uut_instruction.memory[18] = 8'b00000100;
        risc_v_cpu.uut_instruction.memory[19] = 8'b00000000;

        /* JUMP - 12 */
        /* 11111111010111111111_00111_1101100 */
        risc_v_cpu.uut_instruction.memory[20] = 8'b11101100;
        risc_v_cpu.uut_instruction.memory[21] = 8'b11110010;
        risc_v_cpu.uut_instruction.memory[22] = 8'b01011111;
        risc_v_cpu.uut_instruction.memory[23] = 8'b11111111;

        `next_cycle
        `assert_no_wait("FIBO INIT: ADDi $1, R[0], R[6] - R[6] = 1", risc_v_cpu.module_registers_bank.registers_bank.registers[6], 1)
        `next_cycle
        `assert_no_wait("FIBO INIT: ADDi $0, R[0], R[7] - R[7] = 0", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 0)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 1: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[8], 1)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 1: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[6], 1)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 1: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 1)
        `next_cycle
        `assert_no_wait("FIBO VALUE 1: 1", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 1)
        `assert_no_wait("FIBO CYCLE 1: JUMP - 12", risc_v_cpu.module_program_counter.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 2: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[8], 1)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 2: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[6], 2)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 2: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 1)
        `next_cycle
        `assert_no_wait("FIBO VALUE 2: 1", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 1)
        `assert_no_wait("FIBO CYCLE 2: JUMP - 12", risc_v_cpu.module_program_counter.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 3: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[8], 2)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 3: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[6], 3)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 3: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 2)
        `next_cycle
        `assert_no_wait("FIBO VALUE 3: 2", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 2)
        `assert_no_wait("FIBO CYCLE 3: JUMP - 12", risc_v_cpu.module_program_counter.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 4: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[8], 3)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 4: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[6], 5)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 4: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 3)
        `next_cycle
        `assert_no_wait("FIBO VALUE 4: 3", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 3)
        `assert_no_wait("FIBO CYCLE 4: JUMP - 12", risc_v_cpu.module_program_counter.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 5: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[8], 5)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 5: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[6], 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 5: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 5)
        `next_cycle
        `assert_no_wait("FIBO VALUE 5: 5", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 5)
        `assert_no_wait("FIBO CYCLE 5: JUMP - 12", risc_v_cpu.module_program_counter.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 6: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[8], 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 6: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[6], 13)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 6: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 8)
        `next_cycle
        `assert_no_wait("FIBO VALUE 6: 8", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 8)
        `assert_no_wait("FIBO CYCLE 6: JUMP - 12", risc_v_cpu.module_program_counter.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 7: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[8], 13)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 7: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[6], 21)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 7: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 13)
        `next_cycle
        `assert_no_wait("FIBO VALUE 7: 13", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 13)
        `assert_no_wait("FIBO CYCLE 7: JUMP - 12", risc_v_cpu.module_program_counter.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 8: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[8], 21)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 8: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[6], 34)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 8: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 21)
        `next_cycle
        `assert_no_wait("FIBO VALUE 8: 21", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 21)
        `assert_no_wait("FIBO CYCLE 8: JUMP - 12", risc_v_cpu.module_program_counter.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 9: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[8], 34)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 9: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[6], 55)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 9: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 34)
        `next_cycle
        `assert_no_wait("FIBO VALUE 9: 34", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 34)
        `assert_no_wait("FIBO CYCLE 9: JUMP - 12", risc_v_cpu.module_program_counter.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 10: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[8], 55)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 10: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[6], 89)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 10: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 55)
        `next_cycle
        `assert_no_wait("FIBO VALUE 10: 55", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 55)
        `assert_no_wait("FIBO CYCLE 10: JUMP - 12", risc_v_cpu.module_program_counter.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 11: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[8], 89)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 11: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[6], 144)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 11: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 89)
        `next_cycle
        `assert_no_wait("FIBO VALUE 11: 89", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 89)
        `assert_no_wait("FIBO CYCLE 11: JUMP - 12", risc_v_cpu.module_program_counter.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 12: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[8], 144)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 12: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.module_registers_bank.registers_bank.registers[6], 233)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 12: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 144)
        `next_cycle
        `assert_no_wait("FIBO VALUE 12: 144", risc_v_cpu.module_registers_bank.registers_bank.registers[7], 144)
        `assert_no_wait("FIBO CYCLE 12: JUMP - 12", risc_v_cpu.module_program_counter.program_counter.pc_addr, 8)

        /* Reset */
        reset = 1'b1;
        #10
        reset = 1'b0;

        clk = 1'b0;

        /* BUBBLE SORT

           LOAD MEM[R[2] + 0] to R[3]
           LOAD MEM[R[2] + 1] to R[4]
           JUMP TO R[2]++ if R[4] >= R[3]
           STR R[4] to MEM[R[2] + 0]
           STR R[3] to MEM[R[2] + 1]
           R[2]++
           JUM to -12 if R[2] < R[1]
           R[1]--
           JMP if R[1] == 0 FIRST LINE
        */

        /* ADDi $9, R[0], R[1] - R[1] = 9 */
        /* "000000001010_00000_000_00001_0010000" */
        risc_v_cpu.uut_instruction.memory[0] = 8'b10010000;
        risc_v_cpu.uut_instruction.memory[1] = 8'b00000000;
        risc_v_cpu.uut_instruction.memory[2] = 8'b10010000;
        risc_v_cpu.uut_instruction.memory[3] = 8'b00000000;

        /* ADDi $10, R[0], R[2] - R[2] = 10 */
        /* "000000001010_00000_000_00010_0010000" */
        risc_v_cpu.uut_instruction.memory[4] = 8'b00010000;
        risc_v_cpu.uut_instruction.memory[5] = 8'b00000001;
        risc_v_cpu.uut_instruction.memory[6] = 8'b10100000;
        risc_v_cpu.uut_instruction.memory[7] = 8'b00000000;

        /* ADDi $0, R[0], R[3] - R[2] = 10 */
        /* "000000000000_00000_000_00011_0010000" */
        risc_v_cpu.uut_instruction.memory[8] = 8'b10010000;
        risc_v_cpu.uut_instruction.memory[9] = 8'b00000001;
        risc_v_cpu.uut_instruction.memory[10] = 8'b00000000;
        risc_v_cpu.uut_instruction.memory[11] = 8'b00000000;

        /* STR $0, R[0], R[2], MEM[0] = 10 */
        /* "0000000_00010_00000_000_00000_0100000" */
        risc_v_cpu.uut_instruction.memory[12] = 8'b00100000;
        risc_v_cpu.uut_instruction.memory[13] = 8'b00000000;
        risc_v_cpu.uut_instruction.memory[14] = 8'b00100000;
        risc_v_cpu.uut_instruction.memory[15] = 8'b00000000;

        /* ADDi $-1, R[2], R[2] - R[2] = R[2] - 1 */
        /* "111111111111_00010_000_00010_0010000" */
        risc_v_cpu.uut_instruction.memory[16] = 8'b00010000;
        risc_v_cpu.uut_instruction.memory[17] = 8'b00000001;
        risc_v_cpu.uut_instruction.memory[18] = 8'b11110001;
        risc_v_cpu.uut_instruction.memory[19] = 8'b11111111;

        /* ADDi $1, R[3], R[3] - R[3] = R[3] + 1 */
        /* "000000000001_00011_000_00011_0010000" */
        risc_v_cpu.uut_instruction.memory[20] = 8'b10010000;
        risc_v_cpu.uut_instruction.memory[21] = 8'b10000001;
        risc_v_cpu.uut_instruction.memory[22] = 8'b00010001;
        risc_v_cpu.uut_instruction.memory[23] = 8'b00000000;

        /* STR $0, R[3], R[2], MEM[R[3]] = 10 */
        /* "0000000_00010_00011_000_00000_0100000" */
        risc_v_cpu.uut_instruction.memory[24] = 8'b00100000;
        risc_v_cpu.uut_instruction.memory[25] = 8'b10000000;
        risc_v_cpu.uut_instruction.memory[26] = 8'b00100001;
        risc_v_cpu.uut_instruction.memory[27] = 8'b00000000;

        /* BNE -12, R[0], R[2] - PC = PC - 12 */
        /* "1111111_00010_00000_001_10101_1100000" */
        risc_v_cpu.uut_instruction.memory[28] = 8'b11100000;
        risc_v_cpu.uut_instruction.memory[29] = 8'b00011010;
        risc_v_cpu.uut_instruction.memory[30] = 8'b00100000;
        risc_v_cpu.uut_instruction.memory[31] = 8'b11111110;

        /* ADDi $0, R[0], R[2] - R[2] = 0 */
        /* "000000000000_00000_000_00010_0010000" */
        risc_v_cpu.uut_instruction.memory[32] = 8'b00010000;
        risc_v_cpu.uut_instruction.memory[33] = 8'b00000001;
        risc_v_cpu.uut_instruction.memory[34] = 8'b00000000;
        risc_v_cpu.uut_instruction.memory[35] = 8'b00000000;

        /* LOAD MEM[R[2] + 0], R[3] - R[3] = 10 */
        /* "000000000000_00010_000_00011_0000000" */
        risc_v_cpu.uut_instruction.memory[36] = 8'b10000000;
        risc_v_cpu.uut_instruction.memory[37] = 8'b00000001;
        risc_v_cpu.uut_instruction.memory[38] = 8'b00000001;
        risc_v_cpu.uut_instruction.memory[39] = 8'b00000000;

        /* LOAD MEM[R[2] + 1], R[4] - R[4] = 9 */
        /* "000000000001_00010_000_00100_0000000" */
        risc_v_cpu.uut_instruction.memory[40] = 8'b00000000;
        risc_v_cpu.uut_instruction.memory[41] = 8'b00000010;
        risc_v_cpu.uut_instruction.memory[42] = 8'b00010001;
        risc_v_cpu.uut_instruction.memory[43] = 8'b00000000;

        /* BNE 12, R[4], R[3] - PC = PC + 12 */
        /* "0000000_00100_00011_100_01101_1100000" */
        risc_v_cpu.uut_instruction.memory[44] = 8'b11100000;
        risc_v_cpu.uut_instruction.memory[45] = 8'b11000110;
        risc_v_cpu.uut_instruction.memory[46] = 8'b01000001;
        risc_v_cpu.uut_instruction.memory[47] = 8'b00000000;

        /* STR $0, R[2], R[4], MEM[R[2]] = 9 */
        /* "0000000_00100_00010_000_00000_0100000" */
        risc_v_cpu.uut_instruction.memory[48] = 8'b00100000;
        risc_v_cpu.uut_instruction.memory[49] = 8'b00000000;
        risc_v_cpu.uut_instruction.memory[50] = 8'b01000001;
        risc_v_cpu.uut_instruction.memory[51] = 8'b00000000;

        /* STR $1, R[2], R[3], MEM[R[2]] = 9 */
        /* "0000000_00011_00010_000_00001_0100000" */
        risc_v_cpu.uut_instruction.memory[52] = 8'b10100000;
        risc_v_cpu.uut_instruction.memory[53] = 8'b00000000;
        risc_v_cpu.uut_instruction.memory[54] = 8'b00110001;
        risc_v_cpu.uut_instruction.memory[55] = 8'b00000000;

        /* ADDi $1, R[2], R[2] - R[2] = R[2] + 1 */
        /* "000000000001_00010_000_00010_0010000" */
        risc_v_cpu.uut_instruction.memory[56] = 8'b00010000;
        risc_v_cpu.uut_instruction.memory[57] = 8'b00000001;
        risc_v_cpu.uut_instruction.memory[58] = 8'b00010001;
        risc_v_cpu.uut_instruction.memory[59] = 8'b00000000;

        /* BNE -xx, R[1], R[2] - PC = PC - 8 */
        /* "1111111_00010_00001_001_01001_1100000" */
        risc_v_cpu.uut_instruction.memory[60] = 8'b11100000;
        risc_v_cpu.uut_instruction.memory[61] = 8'b10010100;
        risc_v_cpu.uut_instruction.memory[62] = 8'b00100000;
        risc_v_cpu.uut_instruction.memory[63] = 8'b11111110;

        /* ADDi $-1, R[1], R[1] - R[1] = R[1] - 1 */
        /* "111111111111_00001_000_00001_0010000" */
        risc_v_cpu.uut_instruction.memory[64] = 8'b10010000;
        risc_v_cpu.uut_instruction.memory[65] = 8'b10000000;
        risc_v_cpu.uut_instruction.memory[66] = 8'b11110000;
        risc_v_cpu.uut_instruction.memory[67] = 8'b11111111;


        /* BNE -36, R[0], R[1] - PC = PC - 8 */
        /* "1111111_00001_00000_001_10001_1100000" */
        risc_v_cpu.uut_instruction.memory[68] = 8'b11100000;
        risc_v_cpu.uut_instruction.memory[69] = 8'b10011110;
        risc_v_cpu.uut_instruction.memory[70] = 8'b00000000;
        risc_v_cpu.uut_instruction.memory[71] = 8'b11111100;

        for (i = 0; i < 387; i = i + 1) begin
            `next_cycle
        end

        `assert_no_wait("BUBBLE SORT - MEM[0]: 1", risc_v_cpu.memory.memory[0], 1)
        `assert_no_wait("BUBBLE SORT - MEM[1]: 2", risc_v_cpu.memory.memory[1], 2)
        `assert_no_wait("BUBBLE SORT - MEM[2]: 3", risc_v_cpu.memory.memory[2], 3)
        `assert_no_wait("BUBBLE SORT - MEM[3]: 4", risc_v_cpu.memory.memory[3], 4)
        `assert_no_wait("BUBBLE SORT - MEM[4]: 5", risc_v_cpu.memory.memory[4], 5)
        `assert_no_wait("BUBBLE SORT - MEM[5]: 6", risc_v_cpu.memory.memory[5], 6)
        `assert_no_wait("BUBBLE SORT - MEM[6]: 7", risc_v_cpu.memory.memory[6], 7)
        `assert_no_wait("BUBBLE SORT - MEM[7]: 8", risc_v_cpu.memory.memory[7], 8)
        `assert_no_wait("BUBBLE SORT - MEM[8]: 9", risc_v_cpu.memory.memory[8], 9)
        `assert_no_wait("BUBBLE SORT - MEM[9]: 10", risc_v_cpu.memory.memory[9], 10)
        `assert_no_wait("BUBBLE SORT - PROGRAM EXITED - PC: 76", risc_v_cpu.module_program_counter.program_counter.pc_addr, 76)

        `end_message
    end

endmodule : tb_risc_v_cpu
