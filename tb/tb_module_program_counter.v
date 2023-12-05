`timescale 1ns / 1ps
`include "tb_tools.vh"

module tb_module_program_counter ();
    reg         clk;
    reg         reset;
    reg         is_jmp;
    reg         alu_not;
    reg  [1:0]  is_branch;
    reg  [31:0] alu_out;
    reg  [31:0] imm;
    wire [31:0] addr;

    integer i;

    module_program_counter module_program_counter (
        .clock(clk),
        .reset(reset),
        .is_jmp(is_jmp),
        .alu_not(alu_not),
        .is_branch(is_branch),
        .alu_out(alu_out),
        .imm(imm),
        .addr(addr)
    );

    initial begin
        clk = 1'b0;
        for (i = 0; i < 100; i = i + 1) begin
            #1 clk = ~clk;
        end
    end

    initial begin

        reset = 1'b1;
        is_jmp = 1'b0;
        alu_not = 1'b0;
        is_branch = 2'b00;
        alu_out = 32'b0;
        imm = 32'b0;
        #10
        reset = 1'b0;
        `assert_no_wait("module_program_counter is_jmp: 0, is_branch: 0, alu_not: 0, alu_out: 0, imm: 0", addr, 0)

        `end_message
    end



endmodule : tb_module_program_counter
