module registers_bank (input clock, reset, we,
                       input [4:0] sel_in, sel_out_a, sel_out_b,
                       input [31:0] data_in,
                       output [31:0] data_out_a, data_out_b);
    
    reg [31:0] registers[31:0];

    assign registers[0] = 32'b0;
    
    always @(posedge clock, posedge reset) begin
        if (reset == 1)
            registers[0] <= 32'b0;
        else if (we == 1 && sel_in != 5'b00000)
            registers[sel_in] <= data_in;
    end

    assign data_out_a = registers[sel_out_a];
    assign data_out_b = registers[sel_out_b];

endmodule
