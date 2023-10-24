module alu (input      [31:0] in_a, in_b,
            input      [3:0]  op_code,
            output reg [31:0] out);
    
    `include "alu_func.vh"
    
    always@ (*) begin
        case (op_code)
            ADD  : out <= in_a + in_b;
            SUB  : out <= in_a - in_b;
            SLL  : out <= in_a << in_b;
            SLT  : out <= ((in_a[31] != in_b[31]) ? in_a[31] == 1'b1 : in_a < in_b) ? 1 : 0;
            SLTU : out <= (in_a < in_b) ? 1 : 0;
            XOR  : out <= in_a ^ in_b;
            SRL  : out <= in_a >> in_b;
            SRA  : out <= in_a >>> in_b;
            OR   : out <= in_a | in_b;
            AND  : out <= in_a & in_b;
            default : out <= 32'b0;
        endcase
    end

endmodule
