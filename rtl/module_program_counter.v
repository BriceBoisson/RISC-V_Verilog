module module_program_counter (input         clock, reset,
                               input         is_jmp, alu_not,
                               input  [1:0]  is_branch,
                               input  [31:0] alu_out, imm,
                               output [31:0] addr);
    
    wire [1:0] sel_in;
    wire [31:0] pc_addr, new_addr;

    mux2_1 #(2) mux2_pc_sel_branch (
        .in_1(is_branch),
        .in_2({1'b0, (alu_not ? (alu_out == 32'b0 ? 1'b1 : 1'b0) : (alu_out != 32'b0 ? 1'b1 : 1'b0))}),
        .sel(is_jmp),
        .out(sel_in)
    );

    mux4_1 mux4_pc_sel_in (
        .in_1(pc_addr + 4),
        .in_2(pc_addr + imm),
        .in_3(alu_out),
        .in_4(0),
        .sel(sel_in),
        .out(new_addr)
    );

    program_counter program_counter (
        .clock(clock),
        .reset(reset),
        .new_addr(new_addr),
        .pc_addr(pc_addr)
    );

    assign addr = pc_addr;

endmodule
