`timescale 1ns / 1ps
`include "tb_tools.vh"

module tb_mux2_1 ();

    reg         sel;
    reg  [31:0] in_1;
    reg  [31:0] in_2;
    wire [31:0] out;

    mux2_1 mux (
        .in_1(in_1),
        .in_2(in_2),
        .sel(sel),
        .out(out)
    );

    initial begin
        in_1 = 1'b0;
        in_2 = 1'b0;
        sel = 1'b0;
        `assert("mux in_1: 0, in_2: 0, sel: 0", out, 0)
        in_1 = 1'b1;
        `assert("mux in_1: 1, in_2: 0, sel: 0", out, 1)
        sel = 1'b1;
        `assert("mux in_1: 1, in_2: 0, sel: 1", out, 0)
        in_2 = 1'b1;
        `assert("mux in_1: 1, in_2: 1, sel: 1", out, 1)
        in_1 = 1'b0;
        `assert("mux in_1: 0, in_2: 1, sel: 1", out, 1)
        in_2 = 1'b0;
        `assert("mux in_1: 0, in_2: 0, sel: 1", out, 0)
        sel = 1'b0;
        `assert("mux in_1: 0, in_2: 0, sel: 0", out, 0)

        `end_message
    end

endmodule : tb_mux2_1
