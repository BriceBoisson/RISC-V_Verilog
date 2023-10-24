module instruction (input  [31:0] address,
                    output [31:0] instruction);
    
    reg [7:0] memory [63:0];

    assign instruction = {memory[address + 3], memory[address + 2], memory[address + 1], memory[address]};

endmodule
