`timescale 1ns / 1ps
`include "tb_tools.vh"

module tb_risc_v_cpu ();
    reg         clk;
    reg         reset;
    integer     i;
    wire [31:0] out;

    /* File management variable */
    integer    bin_file_inputs;
    reg [8:0]  read_instruction_1;
    reg [8:0]  read_instruction_2;
    reg [8:0]  read_instruction_3;
    reg [8:0]  read_instruction_4;

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

        /* Loading Test From File */

        /* Loading Binary File */
        bin_file_inputs = $fopen("./../tb/test_source_code/tb_riscv_cpu/test.bin", "r");
        if (bin_file_inputs == 0) begin
            $display("data_file handle was NULL");
            $finish;
        end

        i = 0;
        while (!$feof(bin_file_inputs))
        begin
            read_instruction_1 = $fgetc(bin_file_inputs);
            read_instruction_2 = $fgetc(bin_file_inputs);
            read_instruction_3 = $fgetc(bin_file_inputs);
            read_instruction_4 = $fgetc(bin_file_inputs);
            $display("read_instruction_1: %b", read_instruction_1);

            if (
                read_instruction_1[8] != 1'b1 &&
                read_instruction_2[8] != 1'b1 &&
                read_instruction_3[8] != 1'b1 &&
                read_instruction_4[8] != 1'b1
            ) begin
                risc_v_cpu.uut_instruction.memory[i]   = read_instruction_1[7:0];
                risc_v_cpu.uut_instruction.memory[i+1] = read_instruction_2[7:0];
                risc_v_cpu.uut_instruction.memory[i+2] = read_instruction_3[7:0];
                risc_v_cpu.uut_instruction.memory[i+3] = read_instruction_4[7:0];
                i = i + 4;
            end
        end

        for (i = 0; i < 100; i = i + 1) begin
            `next_cycle
            // run
        end

        // final test
        `assert_no_wait("FOR LOOP - REG[5]: 1", risc_v_cpu.registers_bank.registers[5], 32'b1010)
        
        `end_message
    end

endmodule : tb_risc_v_cpu
