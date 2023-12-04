module module_registers_bank (input         clock, reset, we,
                              input  [1:0]  sel_data_in,
                              input  [4:0]  sel_in, sel_out_a, sel_out_b,
                              input  [31:0] alu_out, mem_out, pc_addr,
                              output [31:0] data_out_a, data_out_b);
    
    wire [31:0] data_in;

    mux4_1 mux4_reg_sel_data_in (
        .in_1(alu_out),
        .in_2(mem_out),
        .in_3(pc_addr + 4),
        .in_4(pc_addr + alu_out),
        .sel(sel_data_in),
        .out(data_in)
    );

    registers_bank registers_bank (
        .clock(clock),
        .reset(reset),
        .we(we),
        .sel_in(sel_in),
        .sel_out_a(sel_out_a),
        .sel_out_b(sel_out_b),
        .data_in(data_in),
        .data_out_a(data_out_a),
        .data_out_b(data_out_b)
    );

endmodule
