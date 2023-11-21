`timescale 1ns / 1ps
`include "tb_tools.vh"

module tb_risc_v_cpu ();
    reg         clk;
    reg         reset;
    integer     i;
    wire [31:0] out;

    /* File management variable */
    integer    bin_file_inputs;
    integer    code_file_inputs;
    reg [8:0]  read_instruction_1;
    reg [8:0]  read_instruction_2;
    reg [8:0]  read_instruction_3;
    reg [8:0]  read_instruction_4;

    reg [113:0]  test [0:100];
    integer      instruction_addr;
    reg [5:0]    reg_number;
    reg [31:0]   reg_test_value;
    integer curent_addr;
    integer res;
    reg [8:0] dump;

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
            $display("bin file handle was NULL");
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
                risc_v_cpu.uut_instruction.memory[i]   = read_instruction_1[7:0];
                risc_v_cpu.uut_instruction.memory[i+1] = read_instruction_2[7:0];
                risc_v_cpu.uut_instruction.memory[i+2] = read_instruction_3[7:0];
                risc_v_cpu.uut_instruction.memory[i+3] = read_instruction_4[7:0];
                i = i + 4;
            end
        end

        $fclose(bin_file_inputs);

        /* Extract Value to Test From File */
        code_file_inputs = $fopen("./../tb/test_source_code/tb_riscv_cpu/test.tmp", "r");
        if (code_file_inputs == 0) begin
            $display("source code file handle was NULL");
            $finish;
        end

        i = 0;
        for (i = 0; i < 100; i = i + 1) begin   // Fill test data structure of 1,
            test[i] = {114{1'b1}};              // to represent the empty state
        end
        
        while (!$feof(code_file_inputs))
        begin
            res = $fscanf(code_file_inputs, "%d:%d=%d\n", instruction_addr, reg_number, reg_test_value);
            if (res != 3) begin     // If fscanf failed, the test file structure is wrong, then exit
                $display("Parsing test file failed");
                $finish;
            end

            if (test[instruction_addr][5:0] == 6'b111111) begin
                test[instruction_addr][5:0] = reg_number;
                test[instruction_addr][37:6] = reg_test_value;
            end else if (test[instruction_addr][43:38] == 6'b111111) begin
                $display ("1");
                test[instruction_addr][43:38] = reg_number;
                test[instruction_addr][75:44] = reg_test_value;
            end else if (test[instruction_addr][81:76] == 6'b111111) begin
                test[instruction_addr][81:76] = reg_number;
                test[instruction_addr][113:83] = reg_test_value;
            end
        end

        $fclose(code_file_inputs);

        /* Run The Program */

        for (i = 0; i < 100; i = i + 1) begin
            if (test[risc_v_cpu.program_counter.pc_addr][5:0] != 6'b111111) begin
                curent_addr = risc_v_cpu.program_counter.pc_addr;
                `next_cycle
                if (test[curent_addr][5:0] != 6'b111111) begin
                    if (test[curent_addr][5:0] < 6'b100000) begin
                        `assert_no_wait("TEST - REG", risc_v_cpu.registers_bank.registers[test[curent_addr][4:0]], test[curent_addr][37:6])
                    end else if (test[curent_addr][5:0] == 6'b100000) begin
                        `assert_no_wait("TEST - PC", risc_v_cpu.program_counter.pc_addr, test[curent_addr][37:6])
                    end else if (test[curent_addr][5:0] > 6'b100000) begin
                        `assert_no_wait("TEST - MEM", risc_v_cpu.memory.memory[test[curent_addr][5:0]], test[curent_addr][37:6])
                    end
                end
                if (test[curent_addr][43:38] != 6'b111111) begin
                    if (test[curent_addr][43:38] < 6'b100000) begin
                        `assert_no_wait("TEST - REG", risc_v_cpu.registers_bank.registers[test[curent_addr][42:38]], test[curent_addr][75:44])
                    end else if (test[curent_addr][43:38] == 6'b100000) begin
                        `assert_no_wait("TEST - PC", risc_v_cpu.program_counter.pc_addr, test[curent_addr][75:44])
                    end else if (test[curent_addr][43:38] > 6'b100000) begin
                        `assert_no_wait("TEST - MEM", risc_v_cpu.memory.memory[test[curent_addr][43:38]], test[curent_addr][75:44])
                    end
                end
                if (test[curent_addr][81:76] != 6'b111111) begin
                    if (test[curent_addr][81:76] < 6'b100000) begin
                        `assert_no_wait("TEST - REG", risc_v_cpu.registers_bank.registers[test[curent_addr][80:76]], test[curent_addr][81:76])
                    end else if (test[curent_addr][81:76] == 6'b100000) begin
                        `assert_no_wait("TEST - PC", risc_v_cpu.program_counter.pc_addr, test[curent_addr][113:83])
                    end else if (test[curent_addr][81:76] > 6'b100000) begin
                        `assert_no_wait("TEST - MEM", risc_v_cpu.memory.memory[test[curent_addr][81:76]], test[curent_addr][81:76])
                    end
                end
            end
            else
                `next_cycle
        end

        /* Test State After Execution */
        code_file_inputs = $fopen("./../tb/test_source_code/tb_riscv_cpu/test.final.tmp", "r");
        if (code_file_inputs == 0) begin
            $display("source code file handle was NULL");
            $finish;
        end

        while (!$feof(code_file_inputs))
        begin
            res = $fscanf(code_file_inputs, "%d=%d\n", reg_number, reg_test_value);
            if (res != 2) begin     // If fscanf failed, the test file structure is wrong, then exit
                $display("Parsing test file failed");
                $finish;
            end

            if (reg_number < 6'b100000) begin
                `assert_no_wait("FINAL TEST - REG", risc_v_cpu.registers_bank.registers[reg_number[4:0]], reg_test_value)
            end else if (reg_number == 6'b100000) begin
                `assert_no_wait("FINAL TEST- PC", risc_v_cpu.program_counter.pc_addr, reg_test_value)
            end else if (reg_number > 6'b100000) begin
                `assert_no_wait("FINAL TEST - MEM", risc_v_cpu.memory.memory[test[curent_addr][5:0]], reg_test_value)
            end
        end
        
        `end_message
    end

endmodule : tb_risc_v_cpu
