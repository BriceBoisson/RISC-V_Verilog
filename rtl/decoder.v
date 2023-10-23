module decoder (input [31:0] instruction,
                output reg [31:0] imm,
                output reg reg_we,
                output reg [1:0] reg_sel_data_in,
                output reg [4:0] reg_sel_out_a, reg_sel_out_b, reg_sel_in,
                output reg alu_src,
                output reg [3:0] alu_func,
                output reg mem_we,
                output reg [1:0] jmp_pc,
                output reg b_pc, alu_not);

`include "op_code.vh"

function [3:0] get_alu_func(input [2:0] op_code, input arithmetic);
    begin
        case (op_code)
            3'b000 : get_alu_func = arithmetic ? 4'b0001 : 4'b0000;
            3'b001 : get_alu_func = 4'b0010;
            3'b010 : get_alu_func = 4'b0011;
            3'b011 : get_alu_func = 4'b0011;
            3'b100 : get_alu_func = 4'b0100;
            3'b101 : get_alu_func = arithmetic ? 4'b0111 : 4'b0101;
            3'b110 : get_alu_func = 4'b1000;
            3'b111 : get_alu_func = 4'b1010;
            3'b111 : get_alu_func = 4'b1011;
            default : get_alu_func= 4'b0000;
        endcase
    end
endfunction

function [3:0] get_alu_func_imm(input [2:0] op_code, input arithmetic);
    begin
        case (op_code)
            3'b000 : get_alu_func_imm = 4'b0000;
            3'b001 : get_alu_func_imm = 4'b0010;
            3'b010 : get_alu_func_imm = 4'b0011;
            3'b011 : get_alu_func_imm = 4'b0100;
            3'b100 : get_alu_func_imm = 4'b0101;
            3'b101 : get_alu_func_imm = arithmetic ? 4'b1000 : 4'b0111;
            3'b110 : get_alu_func_imm = 4'b1001;
            3'b111 : get_alu_func_imm = 4'b1010;
            3'b111 : get_alu_func_imm = 4'b1011;
            default : get_alu_func_imm = 4'b0000;
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
            OP : begin // OP - Add, ...
                imm = 0;
                reg_we = 1;
                reg_sel_data_in = 2'b00;
                reg_sel_out_a = instruction[19:15];
                reg_sel_out_b = instruction[24:20];
                reg_sel_in = instruction[11:7];
                alu_src = 0;
                alu_func = get_alu_func(instruction[14:12], instruction[30]);
                mem_we = 0;
                jmp_pc = 2'b00;
                b_pc = 0;
                alu_not = 0;
            end
            OP_IMM : begin // OP-IMM - Addi, ...
                imm[11:0] = instruction[31:20];
                imm[31:12] = (instruction[14:12] == 3'b011 || instruction[31] == 0) ? 12'b00000000000000000000 : 12'b11111111111111111111;
                reg_we = 1;
                reg_sel_data_in = 2'b00;
                reg_sel_out_a = instruction[19:15];
                reg_sel_out_b = 5'b00000;
                reg_sel_in = instruction[11:7];
                alu_src = 1;
                alu_func = get_alu_func_imm(instruction[14:12], instruction[30]);
                mem_we = 0;
                jmp_pc = 2'b00;
                b_pc = 0;
                alu_not = 0;
            end
            LOAD : begin // LOAD - Lw, ...
                imm[11:0] = instruction[31:20];
                imm[31:12] = (instruction[14:12] == 3'b100 || instruction[14:12] == 3'b101 || instruction[31] == 0) ? 12'b00000000000000000000 : 12'b11111111111111111111;
                reg_we = 1;
                reg_sel_data_in = 2'b01;
                reg_sel_out_a = instruction[19:15];
                reg_sel_out_b = 5'b00000;
                reg_sel_in = instruction[11:7];
                alu_src = 1;
                alu_func = 3'b000;
                mem_we = 0;
                jmp_pc = 2'b00;
                b_pc = 0;
                alu_not = 0;
            end
            STORE : begin // STORE - Sw, ...
                imm[11:0] = {instruction[31:25], instruction[11:7]};
                imm[31:12] = (instruction[31] == 0) ? 12'b00000000000000000000 : 12'b11111111111111111111;
                reg_we = 0;
                reg_sel_data_in = 2'b00;
                reg_sel_out_a = instruction[19:15];
                reg_sel_out_b = instruction[24:20];
                reg_sel_in = 5'b00000;
                alu_src = 1;
                alu_func = 3'b000;
                mem_we = 1;
                jmp_pc = 2'b00;
                b_pc = 0;
                alu_not = 0;
            end
            BRANCH : begin // BRANCH - Beq, ...
                imm[11:0] = {instruction[31:25], instruction[11:7]};
                imm[31:12] = (instruction[14:12] == 3'b110 || instruction[14:12] == 3'b111 || instruction[31] == 0) ? 12'b00000000000000000000 : 12'b11111111111111111111;
                reg_we = 0;
                reg_sel_data_in = 2'b00;
                reg_sel_out_a = instruction[19:15];
                reg_sel_out_b = instruction[24:20];
                reg_sel_in = 5'b00000;
                alu_src = 0;
                alu_func = branch_op_code(instruction[14:12]);
                mem_we = 0;
                jmp_pc = 2'b00;
                b_pc = 1;
                alu_not = branch_not(instruction[14:12]);
            end
            JAL : begin // JUMP - Jal
                imm[19:0] = instruction[31:12];
                imm[31:20] = (instruction[31] == 0) ? 12'b000000000000 : 12'b111111111111;
                reg_we = 1;
                reg_sel_data_in = 2'b10;
                reg_sel_out_a = 5'b00000;
                reg_sel_out_b = 5'b00000;
                reg_sel_in = instruction[11:7];
                alu_src = 0;
                alu_func = 3'b000;
                mem_we = 0;
                jmp_pc = 2'b01;
                b_pc = 0;
                alu_not = 0;
            end
            JALR : begin // JUMP REG - Jalr
                imm[11:0] = instruction[31:20];
                imm[31:12] = (instruction[31] == 0) ? 12'b00000000000000000000 : 12'b11111111111111111111;
                reg_we = 1;
                reg_sel_data_in = 2'b10;
                reg_sel_out_a = instruction[19:15];
                reg_sel_out_b = 5'b00000;
                reg_sel_in = instruction[11:7];
                alu_src = 0;
                alu_func = 3'b000;
                mem_we = 0;
                jmp_pc = 2'b10;
                b_pc = 0;
                alu_not = 0;
            end
            LUI : begin // LUI - lui
                imm = {instruction[31:12] << 12, 12'b000000000000};
                reg_we = 1;
                reg_sel_data_in = 2'b00;
                reg_sel_out_a = 5'b00000;
                reg_sel_out_b = 5'b00000;
                reg_sel_in = instruction[11:7];
                alu_src = 1;
                alu_func = 3'b000;
                mem_we = 0;
                jmp_pc = 2'b00;
                b_pc = 0;
                alu_not = 0;
            end
            AUIPC : begin // AUIPC - auipc
                imm = {instruction[31:12] << 12, 12'b000000000000};
                reg_we = 1;
                reg_sel_data_in = 2'b11;
                reg_sel_out_a = 5'b00000;
                reg_sel_out_b = 5'b00000;
                reg_sel_in = instruction[11:7];
                alu_src = 1;
                alu_func = 3'b000;
                mem_we = 0;
                jmp_pc = 2'b00;
                b_pc = 0;
                alu_not = 0;
            end
            default : begin // NOP
                imm = 32'b0;
                reg_we = 0;
                reg_sel_data_in = 2'b00;
                reg_sel_out_a = 5'b00000;
                reg_sel_out_b = 5'b00000;
                reg_sel_in = 5'b00000;
                alu_src = 0;
                alu_func = 3'b000;
                mem_we = 0;
                jmp_pc = 2'b00;
                b_pc = 0;
                alu_not = 0;
            end
        endcase
    end

endmodule
