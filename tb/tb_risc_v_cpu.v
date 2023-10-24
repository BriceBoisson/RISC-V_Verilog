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
        risc_v_cpu.uut_instruction.memory[0] = 32'b00000000000100000000001100010000;

        /* ADDi $0, R[0], R[7] - R[7] = 0 */
        /* "000000000000_00000_000_00111_0010000" */
        risc_v_cpu.uut_instruction.memory[4] = 32'b00000000000000000000001110010000;

        /* ADDi $0, R[6],  R[8] - R[8] = R[6] */
        /* "000000000000_00110_000_01000_0010000" */
        risc_v_cpu.uut_instruction.memory[8] = 32'b00000000000000110000010000010000;

        /* ADD R[7], R[6], R[6] - R[6] = R[7] + R[6] */
        /* "0000000_00111_00110_000_00110_0110000" */
        risc_v_cpu.uut_instruction.memory[12] = 32'b00000000011100110000001100110000;

        /* ADDi $0, R[8], R[7] - R[7] = R[8] */
        /* "000000000000_01000_000_00111_0010000" */
        risc_v_cpu.uut_instruction.memory[16] = 32'b00000000000001000000001110010000;

        /* JUMP - 12 */
        /* 11111111111111111101_00111_1101100 */
        risc_v_cpu.uut_instruction.memory[20] = 32'b11111111111111110100001011101100;

        `next_cycle
        `assert_no_wait("FIBO INIT: ADDi $1, R[0], R[6] - R[6] = 1", risc_v_cpu.registers_bank.registers[6], 1)
        `next_cycle
        `assert_no_wait("FIBO INIT: ADDi $0, R[0], R[7] - R[7] = 0", risc_v_cpu.registers_bank.registers[7], 0)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 1: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.registers_bank.registers[8], 1)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 1: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.registers_bank.registers[6], 1)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 1: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.registers_bank.registers[7], 1)
        `next_cycle
        `assert_no_wait("FIBO VALUE 1: 1", risc_v_cpu.registers_bank.registers[7], 1)
        `assert_no_wait("FIBO CYCLE 1: JUMP - 12", risc_v_cpu.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 2: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.registers_bank.registers[8], 1)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 2: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.registers_bank.registers[6], 2)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 2: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.registers_bank.registers[7], 1)
        `next_cycle
        `assert_no_wait("FIBO VALUE 2: 1", risc_v_cpu.registers_bank.registers[7], 1)
        `assert_no_wait("FIBO CYCLE 2: JUMP - 12", risc_v_cpu.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 3: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.registers_bank.registers[8], 2)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 3: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.registers_bank.registers[6], 3)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 3: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.registers_bank.registers[7], 2)
        `next_cycle
        `assert_no_wait("FIBO VALUE 3: 2", risc_v_cpu.registers_bank.registers[7], 2)
        `assert_no_wait("FIBO CYCLE 3: JUMP - 12", risc_v_cpu.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 4: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.registers_bank.registers[8], 3)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 4: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.registers_bank.registers[6], 5)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 4: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.registers_bank.registers[7], 3)
        `next_cycle
        `assert_no_wait("FIBO VALUE 4: 3", risc_v_cpu.registers_bank.registers[7], 3)
        `assert_no_wait("FIBO CYCLE 4: JUMP - 12", risc_v_cpu.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 5: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.registers_bank.registers[8], 5)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 5: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.registers_bank.registers[6], 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 5: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.registers_bank.registers[7], 5)
        `next_cycle
        `assert_no_wait("FIBO VALUE 5: 5", risc_v_cpu.registers_bank.registers[7], 5)
        `assert_no_wait("FIBO CYCLE 5: JUMP - 12", risc_v_cpu.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 6: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.registers_bank.registers[8], 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 6: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.registers_bank.registers[6], 13)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 6: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.registers_bank.registers[7], 8)
        `next_cycle
        `assert_no_wait("FIBO VALUE 6: 8", risc_v_cpu.registers_bank.registers[7], 8)
        `assert_no_wait("FIBO CYCLE 6: JUMP - 12", risc_v_cpu.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 7: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.registers_bank.registers[8], 13)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 7: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.registers_bank.registers[6], 21)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 7: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.registers_bank.registers[7], 13)
        `next_cycle
        `assert_no_wait("FIBO VALUE 7: 13", risc_v_cpu.registers_bank.registers[7], 13)
        `assert_no_wait("FIBO CYCLE 7: JUMP - 12", risc_v_cpu.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 8: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.registers_bank.registers[8], 21)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 8: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.registers_bank.registers[6], 34)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 8: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.registers_bank.registers[7], 21)
        `next_cycle
        `assert_no_wait("FIBO VALUE 8: 21", risc_v_cpu.registers_bank.registers[7], 21)
        `assert_no_wait("FIBO CYCLE 8: JUMP - 12", risc_v_cpu.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 9: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.registers_bank.registers[8], 34)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 9: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.registers_bank.registers[6], 55)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 9: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.registers_bank.registers[7], 34)
        `next_cycle
        `assert_no_wait("FIBO VALUE 9: 34", risc_v_cpu.registers_bank.registers[7], 34)
        `assert_no_wait("FIBO CYCLE 9: JUMP - 12", risc_v_cpu.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 10: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.registers_bank.registers[8], 55)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 10: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.registers_bank.registers[6], 89)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 10: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.registers_bank.registers[7], 55)
        `next_cycle
        `assert_no_wait("FIBO VALUE 10: 55", risc_v_cpu.registers_bank.registers[7], 55)
        `assert_no_wait("FIBO CYCLE 10: JUMP - 12", risc_v_cpu.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 11: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.registers_bank.registers[8], 89)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 11: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.registers_bank.registers[6], 144)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 11: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.registers_bank.registers[7], 89)
        `next_cycle
        `assert_no_wait("FIBO VALUE 11: 89", risc_v_cpu.registers_bank.registers[7], 89)
        `assert_no_wait("FIBO CYCLE 11: JUMP - 12", risc_v_cpu.program_counter.pc_addr, 8)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 12: ADDi $0, R[6],  R[8] - R[8] = R[6]", risc_v_cpu.registers_bank.registers[8], 144)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 12: ADD R[7], R[6], R[6] - R[6] = R[7] + R[6]", risc_v_cpu.registers_bank.registers[6], 233)
        `next_cycle
        `assert_no_wait("FIBO CYCLE 12: ADDi $0, R[8], R[7] - R[7] = R[8]", risc_v_cpu.registers_bank.registers[7], 144)
        `next_cycle
        `assert_no_wait("FIBO VALUE 12: 144", risc_v_cpu.registers_bank.registers[7], 144)
        `assert_no_wait("FIBO CYCLE 12: JUMP - 12", risc_v_cpu.program_counter.pc_addr, 8)

        `end_message
    end

endmodule : tb_risc_v_cpu
