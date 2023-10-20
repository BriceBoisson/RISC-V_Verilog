module registers_bank (input clock, reset, we,
                       input [4:0] select_d, select_a, select_b,
                       input [31:0] input_d,
                       output [31:0] output_a, output_b);
    
    reg [31:0] registers[31:0];
    
    always @(posedge clock, reset) begin
        if (reset == 1)
            registers[0] <= 32'b0;
        else if (we == 1)
            registers[select_d] <= input_d;
    end

    assign output_a = registers[select_a];
    assign output_b = registers[select_b];

endmodule
