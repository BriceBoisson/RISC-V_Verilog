module risc_v_cpu (input         clock, reset,
                   output [31:0] out);

    wire [31:0] instruction;

    wire [31:0] imm;

    wire        reg_we;
    wire [1:0]  reg_sel_data_in;
    wire [4:0]  reg_sel_out_a, reg_sel_out_b, reg_sel_in;
    wire [31:0] reg_data_out_a, reg_data_out_b, reg_data_in;

    wire        alu_src, alu_not;
    wire [3:0]  alu_func;
    wire [31:0] alu_in_b, alu_out;

    wire        mem_we;
    wire [31:0] mem_out;

    wire        pc_is_jmp;
    wire [1:0]  pc_is_branch, pc_sel_in;
    wire [31:0] pc_addr, pc_new_addr;

    decoder decoder (
        .instruction(instruction),
        .imm(imm),
        .reg_we(reg_we),
        .reg_sel_data_in(reg_sel_data_in),
        .reg_sel_out_a(reg_sel_out_a),
        .reg_sel_out_b(reg_sel_out_b),
        .reg_sel_in(reg_sel_in),
        .alu_src(alu_src),
        .alu_func(alu_func),
        .mem_we(mem_we),
        .pc_is_branch(pc_is_branch),
        .pc_is_jmp(pc_is_jmp),
        .alu_not(alu_not)
    );

    registers_bank registers_bank (
        .clock(clock),
        .reset(reset),
        .we(reg_we),
        .sel_in(reg_sel_in),
        .sel_out_a(reg_sel_out_a),
        .sel_out_b(reg_sel_out_b),
        .data_in(reg_data_in),
        .data_out_a(reg_data_out_a),
        .data_out_b(reg_data_out_b)
    );

    mux2_1 mux2_alu_in_b (
        .in_1(reg_data_out_b),
        .in_2(imm),
        .sel(alu_src),
        .out(alu_in_b)
    );

    alu alu (
        .in_a(reg_data_out_a),
        .in_b(alu_in_b),
        .op_code(alu_func),
        .out(alu_out)
    );

    mux2_1 #(2) mux2_pc_sel_branch (
        .in_1(pc_is_branch),
        .in_2({alu_out[1], (alu_not ? ~alu_out[0] : alu_out[0])}),
        .sel(pc_is_jmp),
        .out(pc_sel_in)
    );

    mux4_1 mux4_pc_sel_in (
        .in_1(pc_addr + 4),
        .in_2(pc_addr + imm),
        .in_3(alu_out),
        .in_4(0),
        .sel(pc_sel_in),
        .out(pc_new_addr)
    );

    program_counter program_counter (
        .clock(clock),
        .reset(reset),
        .pc_new_addr(pc_new_addr),
        .pc_addr(pc_addr)
    );

    instruction uut_instruction (
        .address(pc_addr),
        .instruction(instruction)
    );

    memory memory (
        .clock(clock),
        .reset(reset),
        .we(mem_we),
        .address(alu_out),
        .data_in(reg_data_out_b),
        .data_out(mem_out)
    );

    mux4_1 mux4_reg_sel_data_in (
        .in_1(alu_out),
        .in_2(mem_out),
        .in_3(pc_addr + 4),
        .in_4(pc_addr + alu_out),
        .sel(reg_sel_data_in),
        .out(reg_data_in)
    );

endmodule
