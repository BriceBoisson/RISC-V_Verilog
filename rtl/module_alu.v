module module_alu (input             src, 
                   input  [3:0]  func,
                   input  [31:0] reg_in_a, reg_in_b, imm,
                   output [31:0] out);
    
    wire [31:0] in_b;

    mux2_1 mux2_in_b (
        .in_1(reg_in_b),
        .in_2(imm),
        .sel(src),
        .out(in_b)
    );

    alu alu (
        .in_a(reg_in_a),
        .in_b(in_b),
        .func(func),
        .out(out)
    );

endmodule
