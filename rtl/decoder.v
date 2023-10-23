module decoder (input [31:0] instruction,
                output reg [31:0] immediate,
                output reg we_reg, adder_pc,
                output reg [1:0] input_reg,
                output reg [4:0] select_a, select_b, select_d,
                output reg source_alu,
                output reg [3:0] op_code_alu,
                output reg mem_we,
                output reg [1:0] jmp_pc,
                output reg b_pc, alu_not);

function [3:0] get_op_code_alu(input [2:0] op_code, input arithmetic);
    begin
        case (op_code)
            3'b000 : get_op_code_alu = arithmetic ? 4'b0001 : 4'b0000;
            3'b001 : get_op_code_alu = 4'b0010;
            3'b010 : get_op_code_alu = 4'b0011;
            3'b011 : get_op_code_alu = 4'b0011;
            3'b100 : get_op_code_alu = 4'b0100;
            3'b101 : get_op_code_alu = arithmetic ? 4'b0111 : 4'b0101;
            3'b110 : get_op_code_alu = 4'b1000;
            3'b111 : get_op_code_alu = 4'b1010;
            3'b111 : get_op_code_alu = 4'b1011;
            default : get_op_code_alu= 4'b0000;
        endcase
    end
endfunction

function [3:0] get_op_code_alu_imm(input [2:0] op_code, input arithmetic);
    begin
        case (op_code)
            3'b000 : get_op_code_alu_imm = 4'b0000;
            3'b001 : get_op_code_alu_imm = 4'b0010;
            3'b010 : get_op_code_alu_imm = 4'b0011;
            3'b011 : get_op_code_alu_imm = 4'b0100;
            3'b100 : get_op_code_alu_imm = 4'b0101;
            3'b101 : get_op_code_alu_imm = arithmetic ? 4'b1000 : 4'b0111;
            3'b110 : get_op_code_alu_imm = 4'b1001;
            3'b111 : get_op_code_alu_imm = 4'b1010;
            3'b111 : get_op_code_alu_imm = 4'b1011;
            default : get_op_code_alu_imm = 4'b0000;
        endcase
    end
endfunction

function [3:0] branch_op_code(input [2:0] op_code);
    begin
        case (op_code)
            3'b000 : branch_op_code = 4'b0001;
            3'b001 : branch_op_code = 4'b0001;
            3'b010 : branch_op_code = 4'b0011;
            3'b011 : branch_op_code = 4'b0011;
            3'b100 : branch_op_code = 4'b0011;
            3'b101 : branch_op_code = 4'b0011;
            default : branch_op_code = 4'b0000;
        endcase
    end
endfunction

function branch_not(input [2:0] op_code);
    begin
        case (op_code)
            3'b000 : branch_not = 1;
            3'b001 : branch_not = 0;
            3'b010 : branch_not = 0;
            3'b011 : branch_not = 1;
            3'b100 : branch_not = 0;
            3'b101 : branch_not = 1;
            default : branch_not = 0;
        endcase
    end
endfunction

    // TODO - Manage ALU OP CODE and IMM Extension


    always @(*) begin
        case (instruction[6:2])
            5'b01100 : begin // OP - Add, ...
                immediate = 0;
                we_reg = 1;
                adder_pc = 0;
                input_reg = 2'b01;
                select_a = instruction[19:15];
                select_b = instruction[24:20];
                select_d = instruction[11:7];
                source_alu = 0;
                op_code_alu = get_op_code_alu(instruction[14:12], instruction[30]);
                mem_we = 0;
                jmp_pc = 2'b00;
                b_pc = 0;
                alu_not = 0;
            end
            5'b00100 : begin // OP-IMM - Addi, ...
                immediate[11:0] = instruction[31:20];
                immediate[31:12] = (instruction[14:12] == 3'b011 || instruction[31] == 0) ? 12'b00000000000000000000 : 12'b11111111111111111111;
                we_reg = 1;
                adder_pc = 0;
                input_reg = 2'b01;
                select_a = instruction[19:15];
                select_b = 5'b00000;
                select_d = instruction[11:7];
                source_alu = 1;
                op_code_alu = get_op_code_alu_imm(instruction[14:12], instruction[30]);
                mem_we = 0;
                jmp_pc = 2'b00;
                b_pc = 0;
                alu_not = 0;
            end
            5'b00000 : begin // LOAD - Lw, ...
                immediate[11:0] = instruction[31:20];
                immediate[31:12] = (instruction[14:12] == 3'b100 || instruction[14:12] == 3'b101 || instruction[31] == 0) ? 12'b00000000000000000000 : 12'b11111111111111111111;
                we_reg = 1;
                adder_pc = 0;
                input_reg = 2'b10;
                select_a = instruction[19:15];
                select_b = 5'b00000;
                select_d = instruction[11:7];
                source_alu = 1;
                op_code_alu = 3'b000;
                mem_we = 0;
                jmp_pc = 2'b00;
                b_pc = 0;
                alu_not = 0;
            end
            5'b01000 : begin // STORE - Sw, ...
                immediate[11:0] = {instruction[31:25], instruction[11:7]};
                immediate[31:12] = (instruction[31] == 0) ? 12'b00000000000000000000 : 12'b11111111111111111111;
                we_reg = 0;
                adder_pc = 0;
                input_reg = 2'b01;
                select_a = instruction[19:15];
                select_b = instruction[24:20];
                select_d = 5'b00000;
                source_alu = 1;
                op_code_alu = 3'b000;
                mem_we = 1;
                jmp_pc = 2'b00;
                b_pc = 0;
                alu_not = 0;
            end
            5'b11000 : begin // BRANCH - Beq, ...
                immediate[11:0] = {instruction[31:25], instruction[11:7]};
                immediate[31:12] = (instruction[14:12] == 3'b110 || instruction[14:12] == 3'b111 || instruction[31] == 0) ? 12'b00000000000000000000 : 12'b11111111111111111111;
                we_reg = 0;
                adder_pc = 0;
                input_reg = 2'b01;
                select_a = instruction[19:15];
                select_b = instruction[24:20];
                select_d = 5'b00000;
                source_alu = 0;
                op_code_alu = branch_op_code(instruction[14:12]);
                mem_we = 0;
                jmp_pc = 2'b00;
                b_pc = 1;
                alu_not = branch_not(instruction[14:12]);
            end
            5'b11011 : begin // JUMP - Jal
                immediate[19:0] = instruction[31:12];
                immediate[31:20] = (instruction[31] == 0) ? 12'b000000000000 : 12'b111111111111;
                we_reg = 1;
                adder_pc = 0;
                input_reg = 2'b00;
                select_a = 5'b00000;
                select_b = 5'b00000;
                select_d = instruction[11:7];
                source_alu = 0;
                op_code_alu = 3'b000;
                mem_we = 0;
                jmp_pc = 2'b01;
                b_pc = 0;
                alu_not = 0;
            end
            5'b11001 : begin // JUMP REG - Jalr
                immediate[19:0] = instruction[31:12];
                immediate[31:20] = (instruction[31] == 0) ? 12'b000000000000 : 12'b111111111111;
                we_reg = 1;
                adder_pc = 0;
                input_reg = 2'b00;
                select_a = instruction[19:15];
                select_b = 5'b00000;
                select_d = instruction[11:7];
                source_alu = 0;
                op_code_alu = 3'b000;
                mem_we = 0;
                jmp_pc = 2'b10;
                b_pc = 0;
                alu_not = 0;
            end
            5'b01101 : begin // LUI - lui
                immediate = {instruction[31:12] << 12, 12'b000000000000};
                we_reg = 1;
                adder_pc = 0;
                input_reg = 2'b01;
                select_a = 5'b00000;
                select_b = 5'b00000;
                select_d = instruction[11:7];
                source_alu = 1;
                op_code_alu = 3'b000;
                mem_we = 0;
                jmp_pc = 2'b00;
                b_pc = 0;
                alu_not = 0;
            end
            5'b00101 : begin // AUIPC - auipc
                immediate = {instruction[31:12] << 12, 12'b000000000000};
                we_reg = 1;
                adder_pc = 1;
                input_reg = 2'b00;
                select_a = 5'b00000;
                select_b = 5'b00000;
                select_d = instruction[11:7];
                source_alu = 1;
                op_code_alu = 3'b000;
                mem_we = 0;
                jmp_pc = 2'b00;
                b_pc = 0;
                alu_not = 0;
            end
            default : begin // NOP
                immediate = 32'b0;
                we_reg = 0;
                adder_pc = 0;
                input_reg = 2'b00;
                select_a = 5'b00000;
                select_b = 5'b00000;
                select_d = 5'b00000;
                source_alu = 0;
                op_code_alu = 3'b000;
                mem_we = 0;
                jmp_pc = 2'b00;
                b_pc = 0;
                alu_not = 0;
            end
        endcase
    end

endmodule
