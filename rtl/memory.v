module memory (input         clock, reset,
               input         we,
               input  [31:0] address,
               input  [31:0] data_in,
               output [31:0] data_out);
    
    reg [7:0] memory [63:0];

    always @(posedge clock, posedge reset) begin
        if (reset == 1)
            memory[0] <= 8'b0;
        else if (we == 1)
            memory[address]     <= data_in[7:0];
            memory[address + 1] <= data_in[15:8];
            memory[address + 2] <= data_in[23:16];
            memory[address + 3] <= data_in[31:24];
    end

    assign data_out = {memory[address + 3], memory[address + 2], memory[address + 1], memory[address]};

endmodule
