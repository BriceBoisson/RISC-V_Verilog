module memory (input         clock, reset,
               input         we,
               input  [31:0] address,
               input  [31:0] data_in,
               output [31:0] data_out);
    
    reg [63:0] memory [31:0];

    always @(posedge clock, posedge reset) begin
        if (reset == 1)
            memory[0] <= 32'b0;
        else if (we == 1)
            memory[address] <= data_in;
    end

    assign data_out = memory[address];

endmodule
