module decoder (input [31:0] instruction,
                output immediate,
                output we_reg, adder_pc,
                output [1:0] input_reg,
                output [4:0] select_a, select_b, select_d,
                output source_alu,
                output [2:0] op_code_alu,
                output mem_we,
                output [31:0] mem_address
                output jmp_pc, b_pc);

    always @(*) begin
        if (reset == 1)
            registers[0] <= 32'b0;
        else if (we == 1)
            registers[select_d] <= input_d;
    end

endmodule
