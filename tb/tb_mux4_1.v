`timescale 1ns / 1ps
`include "tb_tools.vh"

module tb_mux4_1 ();

    reg  [1:0]  sel;
    reg  [31:0] in_1;
    reg  [31:0] in_2;
    reg  [31:0] in_3;
    reg  [31:0] in_4;
    wire [31:0] out;

    mux4_1 mux (
        .in_1(in_1),
        .in_2(in_2),
        .in_3(in_3),
        .in_4(in_4),
        .sel(sel),
        .out(out)
    );

    initial begin
        in_1 = 1'b0;
        in_2 = 1'b0;
        in_3 = 1'b0;
        in_4 = 1'b0;
        sel = 2'b00;
        `assert("mux in_1: 0, in_2: 0, in_3: 0, in_4: 0, sel: 0", out, 0)
        in_1 = 1'b1;
        `assert("mux in_1: 1, in_2: 0, in_3: 0, in_4: 0, sel: 0", out, 1)
        sel = 2'b01;
        `assert("mux in_1: 1, in_2: 0, in_3: 0, in_4: 0, sel: 1", out, 0)
        in_2 = 1'b1;
        `assert("mux in_1: 1, in_2: 1, in_3: 0, in_4: 0, sel: 1", out, 1)
        sel = 2'b10;
        `assert("mux in_1: 1, in_2: 0, in_3: 0, in_4: 0, sel: 2", out, 0)
        in_3 = 1'b1;
        `assert("mux in_1: 1, in_2: 1, in_3: 1, in_4: 0, sel: 2", out, 1)
        sel = 2'b11;
        `assert("mux in_1: 1, in_2: 0, in_3: 1, in_4: 0, sel: 3", out, 0)
        in_4 = 1'b1;
        `assert("mux in_1: 1, in_2: 1, in_3: 1, in_4: 1, sel: 3", out, 1)
        in_1 = 1'b0;
        `assert("mux in_1: 0, in_2: 1, in_3: 1, in_4: 1, sel: 1", out, 1)
        in_2 = 1'b0;
        `assert("mux in_1: 0, in_2: 0, in_3: 1, in_4: 1, sel: 1", out, 1)
        sel = 2'b00;
        `assert("mux in_1: 0, in_2: 0, in_3: 1, in_4: 1, sel: 0", out, 0)

        `end_message
    end

endmodule : tb_mux4_1
