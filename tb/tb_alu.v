`timescale 1ns / 1ps
`include "tb_tools.vh"

module tb_alu ();
    `include "../rtl/alu_func.vh"

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
        // ALU - Add 
        in_a = 32'b0;
        in_b = 32'b0;
        op_code = ADD;
        `assert("alu : 0 + 0", out, 0)
        in_a = 32'b1;
        `assert("alu : 1 + 0", out, 1)
        in_b = 32'b1;
        `assert("alu : 1 + 1", out, 2)
        op_code = 4'b0001;
        `assert("alu : 1 - 1", out, 0)

        // ALU - left shift
        in_a = 32'b1;
        in_b = 32'b1;
        op_code = SLL;
        `assert("alu : 1 << 1", out, 2)
        in_b = 32'b10;
        `assert("alu : 1 << 2", out, 4)
        in_a = 32'b11;
        `assert("alu : 3 << 2", out, 12)
        in_b = 32'b11110;
        `assert("alu : 3 << 30", out, 32'b11000000000000000000000000000000)
        in_b = 32'b11111;
        `assert("alu : 3 << 31", out, 32'b10000000000000000000000000000000)
        in_b = 32'b100000;
        `assert("alu : 3 << 31", out, 32'b00000000000000000000000000000000)

        // ALU - less than
        in_a = 32'b0;
        in_b = 32'b0;
        op_code = SLT;
        `assert("alu : 0 < 0", out, 0)
        in_b = 32'b10;
        `assert("alu : 0 << 2", out, 1)
        in_a = 32'b11;
        `assert("alu : 3 < 2", out, 0)
        in_b = 32'b11111111111111111111111111111111;
        in_a = 32'b11111111111111111111111111111111;
        `assert("alu : -1 < -1", out, 0)
        in_b = 32'b0;
        `assert("alu : -1 < 0", out, 1)
        in_a = 32'b10000000000000000000000000000000;
        in_b = 32'b10000000000000000000000000000001;
        `assert("alu : MIN_INT << MIN_INT + 1", out, 1)

        // ALU - xor
        in_a = 32'b0;
        in_b = 32'b0;
        op_code = XOR;
        `assert("alu : 0 ^ 0", out, 32'b00000000000000000000000000000000)
        in_a = 32'b1;
        `assert("alu : 1 ^ 0", out, 32'b00000000000000000000000000000001)
        in_a = 32'b0;
        in_b = 32'b1;
        `assert("alu : 0 ^ 1", out, 32'b00000000000000000000000000000001)
        in_a = 32'b11111111111111111111111111111111;
        in_b = 32'b11111111111111111111111111111111;
        `assert("alu : MAX_INT ^ MAX_INT", out, 32'b00000000000000000000000000000000)
        in_a = 32'b00000000000000000000000000000000;
        in_b = 32'b11111111111111111111111111111111;
        `assert("alu : 0 ^ MAX_INT", out, 32'b11111111111111111111111111111111)
        in_a = 32'b00000011001000010001000011000000;
        in_b = 32'b10101111001011101110111111111011;
        `assert("alu : 00000011001000010001000011000000 ^ 10101111001011101110111111111011", out, 32'b10101100000011111111111100111011)

        // ALU - right shift
        in_a = 32'b1;
        in_b = 32'b1;
        op_code = SRL;
        `assert("alu : 1 >> 1", out, 0)
        in_a = 32'b10;
        `assert("alu : 2 >> 1", out, 1)
        in_a = 32'b11;
        `assert("alu : 3 >> 2", out, 1)
        in_a = 32'b11110;
        in_b = 32'b1;
        `assert("alu : 30 >> 1", out, 32'b1111)
        in_a = 32'b10000000000000000000000000000000;
        in_b = 32'b11111;
        `assert("alu : 1000...000 >> 31", out, 32'b00000000000000000000000000000001)
        in_a = 32'b10000000111100000000000111111111;
        in_b = 32'b11111;
        `assert("alu : 1000..111 >> 31", out, 32'b00000000000000000000000000000001)

        // // ALU - logical right shift
        // in_a = 32'b1;
        // in_b = 32'b1;
        // op_code = 4'b0110;
        // `assert("alu : 1 >> 1", out, 0)
        // in_a = 32'b10;
        // `assert("alu : 2 >> 1", out, 1)
        // in_a = 32'b11;
        // `assert("alu : 3 >> 2", out, 1)
        // in_a = 32'b11110;
        // in_b = 32'b1;
        // `assert("alu : 30 >> 1", out, 32'b1111)
        // in_a = 32'b10000000000000000000000000000000;
        // in_b = 32'b11111;
        // `assert("alu : 1000...000 >> 31", out, 32'b00000000000000000000000000000001)
        // in_a = 32'b10000000111100000000000111111111;
        // in_b = 32'b11111;
        // `assert("alu : 1000..111 >> 31", out, 32'b00000000000000000000000000000001)

        `end_message
    end

endmodule : tb_alu
