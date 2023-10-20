module instruction (input [31:0] address,
                       output [31:0] instruction);
    
    reg [63:0] memory [31:0];

    assign instruction = memory[address];

endmodule
