module alu (input [31:0] input_a, input_b,
            input [2:0] op_code,
            output reg [31:0] out);
    
    always@ (*) begin
        case (op_code)
            3'b000 : out <= input_a + input_b;
            3'b001 : out <= input_a << input_b;
            3'b010 : out <= (input_a < input_b) ? 1 : 0;
            3'b011 : out <= input_a ^ input_b;
            3'b100 : out <= input_a >> input_b;
            3'b101 : out <= input_a >>> input_b;
            3'b110 : out <= input_a | input_b;
            3'b111 : out <= input_a & input_b;
            default : out <= 32'b0;
        endcase
    end

endmodule
