module risc_v_cpu (input clock, reset, output [31:0] out);
    
    wire        alu_src, alu_not;
    wire [3:0]  alu_func;
    wire [31:0] alu_in_b, alu_out;

    wire        reg_we;
    wire [1:0]  reg_sel_data_in;
    wire [4:0]  reg_sel_out_a, reg_sel_out_b, reg_sel_in;
    wire [31:0] reg_data_out_a, reg_data_out_b, reg_data_in;

    wire [31:0] instruction;

    wire        mem_we;
    wire [31:0] mem_out;

    wire [1:0] jmp_pc;
    wire b_pc;

    wire [31:0] imm;

    wire [1:0]  pc_sel_in;
    wire [31:0] pc_addr;
    wire [31:0] pc_new_addr;


    wire [31:0] pc_store;

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
        .jmp_pc(jmp_pc),
        .b_pc(b_pc),
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

    mux2_1 mux2_1_1 (
        .A(reg_data_out_b),
        .B(imm),
        .S(alu_src),
        .O(alu_in_b)
    );

    alu alu (
        .input_a(reg_data_out_a),
        .input_b(alu_in_b),
        .op_code(alu_func),
        .out(alu_out)
    );

    mux2_1 #(2) mux2_1_2 (
        .A(jmp_pc),
        .B({alu_out[1], (alu_not ? ~alu_out[0] : alu_out[0])}),
        .S(b_pc),
        .O(pc_sel_in)
    );

    mux4_1 mux4_1_1 (
        .A(pc_addr + 4),
        .B(pc_addr + imm),
        .C(alu_out),
        .D(0),
        .S(pc_sel_in),
        .O(pc_new_addr)
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

    mux4_1 mux4_1_2 (
        .A(alu_out),
        .B(mem_out),
        .C(pc_addr + 4),
        .D(pc_addr + alu_out),
        .S(reg_sel_data_in),
        .O(reg_data_in)
    );

endmodule
