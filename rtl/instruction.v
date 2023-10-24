module instruction (input  [31:0] address,
                    output [31:0] instruction);
    
    reg [31:0] memory [63:0];

    assign instruction = memory[address];

endmodule
