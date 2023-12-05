`timescale 1ns / 1ps
`include "tb_tools.vh"

module tb_registers_bank ();
    reg         clk;
    reg         reset;
    reg         we;
    reg  [4:0]  sel_in;
    reg  [4:0]  sel_out_a;
    reg  [4:0]  sel_out_b;
    reg  [31:0] data_in;
    wire [31:0] data_out_a;
    wire [31:0] data_out_b;

    integer     i;

    registers_bank registers_bank (
        .clock(clk),
        .reset(reset),
        .we(we),
        .sel_in(sel_in),
        .sel_out_a(sel_out_a),
        .sel_out_b(sel_out_b),
        .data_in(data_in),
        .data_out_a(data_out_a),
        .data_out_b(data_out_b)
    );

    initial begin
        clk = 1'b0;
        for (i = 0; i < 100; i = i + 1) begin
            #1 clk = ~clk;
        end
    end

    initial begin

        reset = 1'b1;
        we = 1'b0;
        sel_in = 5'b00000;
        sel_out_a = 5'b00000;
        sel_out_b = 5'b00000;
        data_in = 32'b0;        
        #10
        reset = 1'b0;
        `assert("registers_bank we: 0, sel_in: 0, sel_out_a: 0, sel_out_b: 0, data_in: 0", data_out_a, 0)
        we = 1'b1;
        data_in = 32'b1;
        `assert("registers_bank we: 1, sel_in: 0, sel_out_a: 0, sel_out_b: 0, data_in: 1", data_out_a, 0)
        sel_in = 5'b00001;
        `assert("registers_bank we: 1, sel_in: 1, sel_out_a: 0, sel_out_b: 0, data_in: 1", data_out_a, 0)
        sel_out_a = 5'b00001;
        `assert("registers_bank we: 1, sel_in: 1, sel_out_a: 1, sel_out_b: 0, data_in: 1", data_out_a, 1)
        `assert("registers_bank we: 1, sel_in: 1, sel_out_a: 1, sel_out_b: 0, data_in: 1", data_out_b, 0)
        sel_out_b = 5'b00001;
        `assert("registers_bank we: 1, sel_in: 1, sel_out_a: 1, sel_out_b: 1, data_in: 1", data_out_b, 1)
        we = 1'b0;
        data_in = 32'b11;
        `assert("registers_bank we: 0, sel_in: 1, sel_out_a: 1, sel_out_b: 1, data_in: 3", data_out_a, 1)
        `assert("registers_bank we: 0, sel_in: 1, sel_out_a: 1, sel_out_b: 1, data_in: 3", data_out_b, 1)
        data_in = 32'b111;
        sel_in = 5'b11111;
        sel_out_a = 5'b11111;
        we = 1'b1;
        `assert("registers_bank we: 1, sel_in: 31, sel_out_a: 31, sel_out_b: 1, data_in: 7", data_out_a, 7)
        `assert("registers_bank we: 1, sel_in: 31, sel_out_a: 31, sel_out_b: 1, data_in: 7", data_out_b, 1)

        `end_message
    end



endmodule : tb_registers_bank
