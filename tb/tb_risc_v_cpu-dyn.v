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
        bin_file_inputs = $fopen("/home/brice/Code/RISC-V_VERILOG/tb/test.bin", "r");
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

            if (
                read_instruction_1[8] != 1'b1 &&
                read_instruction_2[8] != 1'b1 &&
                read_instruction_3[8] != 1'b1 &&
                read_instruction_4[8] != 1'b1
            ) begin
                risc_v_cpu.uut_instruction.memory[i]   = read_instruction_4[7:0];
                risc_v_cpu.uut_instruction.memory[i+1] = read_instruction_3[7:0];
                risc_v_cpu.uut_instruction.memory[i+2] = read_instruction_2[7:0];
                risc_v_cpu.uut_instruction.memory[i+3] = read_instruction_1[7:0];
                i = i + 4;
            end
        end
        `assert_no_wait("BUBBLE SORT - MEM[0]: 1", risc_v_cpu.uut_instruction.memory[0], 8'b00000000)
        `assert_no_wait("BUBBLE SORT - MEM[0]: 1", risc_v_cpu.uut_instruction.memory[1], 8'b11000101)
        `assert_no_wait("BUBBLE SORT - MEM[0]: 1", risc_v_cpu.uut_instruction.memory[2], 8'b10000111)
        `assert_no_wait("BUBBLE SORT - MEM[0]: 1", risc_v_cpu.uut_instruction.memory[3], 8'b10110011)

        for (i = 0; i < 1; i = i + 1) begin
            `next_cycle
            // run
        end

        // final test
        `assert_no_wait("BUBBLE SORT - MEM[0]: 1", risc_v_cpu.memory.memory[0], 8'b00000000)
        
        `end_message
    end

endmodule : tb_risc_v_cpu
