module alu (input      [31:0] in_a, in_b,
            input      [3:0]  op_code,
            output reg [31:0] out);
    
    `include "alu_func.vh"

    reg signed [31:0] s_in_a;
    reg signed [31:0] s_in_b;
    
    always@ (*) begin
        s_in_a = in_a;
        s_in_b = in_b;
        case (op_code)
            ADD  : out <= in_a + in_b;
            SUB  : out <= in_a - in_b;
            SLL  : out <= in_a << in_b;
            SLT  : out <= (s_in_a < s_in_b) ? 1 : 0;
            SLTU : out <= (in_a < in_b) ? 1 : 0;
            XOR  : out <= in_a ^ in_b;
            SRL  : out <= in_a >> in_b;
            SRA  : out <= s_in_a >>> in_b;
            OR   : out <= in_a | in_b;
            AND  : out <= in_a & in_b;
            default : out <= 32'b0;
        endcase
    end

endmodule
