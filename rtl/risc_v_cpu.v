module risc_v_cpu (input         clock, reset,
                   output [31:0] out);

    wire [31:0] instruction;

    wire [31:0] imm;

    wire        reg_we;
    wire [1:0]  reg_sel_data_in;
    wire [4:0]  reg_sel_out_a, reg_sel_out_b, reg_sel_in;
    wire [31:0] reg_data_out_a, reg_data_out_b;

    wire        alu_src, alu_not;
    wire [3:0]  alu_func;
    wire [31:0] alu_out;

    wire        mem_we;
    wire [1:0]  mem_func_in;
    wire [2:0]  mem_func_out;
    wire [31:0] mem_out;

    wire        pc_is_jmp;
    wire [1:0]  pc_is_branch;
    wire [31:0] pc_addr;

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
        .mem_func_in(mem_func_in),
        .mem_func_out(mem_func_out),
        .pc_is_branch(pc_is_branch),
        .pc_is_jmp(pc_is_jmp),
        .alu_not(alu_not)
    );

    module_registers_bank module_registers_bank (
        .clock(clock),
        .reset(reset),
        .we(reg_we),
        .sel_data_in(reg_sel_data_in),
        .sel_in(reg_sel_in),
        .sel_out_a(reg_sel_out_a),
        .sel_out_b(reg_sel_out_b),
        .alu_out(alu_out),
        .mem_out(mem_out),
        .pc_addr(pc_addr),
        .data_out_a(reg_data_out_a),
        .data_out_b(reg_data_out_b)
    );

    module_alu module_alu (
        .src(alu_src),
        .func(alu_func),
        .reg_in_a(reg_data_out_a),
        .reg_in_b(reg_data_out_b),
        .imm(imm),
        .out(alu_out)
    );

    module_program_counter module_program_counter (
        .clock(clock),
        .reset(reset),
        .is_jmp(pc_is_jmp),
        .is_branch(pc_is_branch),
        .alu_not(alu_not),
        .alu_out(alu_out),
        .imm(imm),
        .addr(pc_addr)
    );

    instruction uut_instruction (
        .address(pc_addr),
        .instruction(instruction)
    );

    memory memory (
        .clock(clock),
        .reset(reset),
        .we(mem_we),
        .func_in(mem_func_in),
        .func_out(mem_func_out),
        .address(alu_out),
        .data_in(reg_data_out_b),
        .data_out(mem_out)
    );

endmodule
