`timescale 1ns / 1ps
`include "tb_tools.vh"

module tb_alu ();
    reg  [31:0] in_a;
    reg  [31:0] in_b;
    reg  [3:0]  op_code;
    wire [31:0] out;

    alu alu (
        .in_a(in_a),
        .in_b(in_b),
        .op_code(op_code),
        .out(out)
    );

    initial begin
        in_a = 32'b0;
        in_b = 32'b0;
        op_code = 4'b0000;
        `assert("alu : 0 + 0", out, 0)
        in_a = 32'b1;
        `assert("alu : 1 + 0", out, 1)
        in_b = 32'b1;
        `assert("alu : 1 + 1", out, 2)
        op_code = 4'b0001;
        `assert("alu : 1 - 1", out, 0)

        `end_message
    end

endmodule : tb_alu
