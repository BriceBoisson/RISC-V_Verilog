module registers_bank (input clock, reset, we,
                       input [4:0] select_d, select_a, select_b,
                       input [31:0] input_d,
                       output [31:0] output_a, output_b);
    
    reg [31:0] registers[31:0];

    assign registers[0] = 32'b0;
    assign registers[1] = 32'b0;
    assign registers[2] = 32'b0;
    assign registers[3] = 32'b0;
    assign registers[4] = 32'b0;
    assign registers[5] = 32'b0;
    assign registers[6] = 32'b0;
    assign registers[7] = 32'b0;
    assign registers[8] = 32'b0;
    assign registers[9] = 32'b0;
    assign registers[10] = 32'b0;
    assign registers[11] = 32'b0;
    assign registers[12] = 32'b0;
    assign registers[13] = 32'b0;
    assign registers[14] = 32'b0;
    assign registers[15] = 32'b0;
    assign registers[16] = 32'b0;
    assign registers[17] = 32'b0;
    assign registers[18] = 32'b0;
    assign registers[19] = 32'b0;
    assign registers[20] = 32'b0;
    assign registers[21] = 32'b0;
    
    always @(posedge clock, posedge reset) begin
        if (reset == 1)
            registers[0] <= 32'b0;
        else if (we == 1)
            registers[select_d] <= input_d;
    end

    assign output_a = registers[select_a];
    assign output_b = registers[select_b];

endmodule
