module risc_v_cpu (input clock, reset, output [31:0] out);
    
    wire [31:0] in_b;
    wire [31:0] alu_out;

    wire [31:0] instruction;
    wire we_reg, adder_pc, data_out;
    wire [1:0] input_reg;
    wire [4:0] select_a, select_b, select_d;
    wire source_alu;
    wire [3:0] op_code_alu;
    wire mem_we;
    wire [1:0] jmp_pc;
    wire b_pc, alu_not;

    wire [31:0] input_d;
    wire [31:0] output_a, output_b;

    wire [31:0] immediate;

    wire [31:0] pc;
    wire [31:0] new_pc;

    wire [1:0] pc_in;

    wire [31:0] memory_out;

    wire [31:0] pc_store;

    decoder decoder (
        .instruction(instruction),
        .immediate(immediate),
        .we_reg(we_reg),
        .adder_pc(adder_pc),
        .data_out(data_out),
        .input_reg(input_reg),
        .select_a(select_a),
        .select_b(select_b),
        .select_d(select_d),
        .source_alu(source_alu),
        .op_code_alu(op_code_alu),
        .mem_we(mem_we),
        .jmp_pc(jmp_pc),
        .b_pc(b_pc),
        .alu_not(alu_not)
    );

    registers_bank registers_bank (
        .clock(clock),
        .reset(reset),
        .we(we_reg),
        .select_d(select_d),
        .select_a(select_a),
        .select_b(select_b),
        .input_d(input_d),
        .output_a(output_a),
        .output_b(output_b)
    );

    mux2_1 mux2_1_1 (
        .A(output_b),
        .B(immediate),
        .S(source_alu),
        .O(in_b)
    );

    alu alu (
        .input_a(output_a),
        .input_b(in_b),
        .op_code(op_code_alu),
        .out(alu_out)
    );

    mux2_1 #(2) mux2_1_2 (
        .A(jmp_pc),
        .B({alu_out[1], (alu_not ? ~alu_out[0] : alu_out[0])}),
        .S(b_pc),
        .O(pc_in)
    );

    mux4_1 mux4_1_1 (
        .A(pc + 4),
        .B(pc + immediate),
        .C(alu_out),
        .D(0),
        .S(pc_in),
        .O(new_pc)
    );

    program_counter program_counter (
        .clock(clock),
        .reset(reset),
        .new_pc(new_pc),
        .pc(pc)
    );

    instruction uut_instruction (
        .address(pc),
        .instruction(instruction)
    );

    memory memory (
        .clock(clock),
        .reset(reset),
        .we(mem_we),
        .address(alu_out),
        .data_in(output_b),
        .data_out(memory_out)
    );

    mux2_1 mux2_1_3 (
        .A(4),
        .B(alu_out),
        .S(adder_pc),
        .O(pc_store)
    );

    mux4_1 mux4_1_2 (
        .A(pc_store + pc),
        .B(alu_out),
        .C(memory_out),
        .D(0),
        .S(input_reg),
        .O(input_d)
    );

endmodule
