module alu (input      [31:0] in_a, in_b,
            input      [3:0]  op_code,
            output reg [31:0] out);
    
    always@ (*) begin
        case (op_code)
            4'b0000 : out <= in_a + in_b;
            4'b0001 : out <= in_a - in_b;
            4'b0010 : out <= in_a << in_b;
            4'b0011 : out <= (in_a < in_b) ? 1 : 0;
            4'b0100 : out <= in_a ^ in_b;
            4'b0101 : out <= in_a >> in_b;
            4'b0111 : out <= in_a >>> in_b;
            4'b1000 : out <= in_a | in_b;
            4'b1001 : out <= in_a & in_b;
            default : out <= 32'b0;
        endcase
    end

endmodule
