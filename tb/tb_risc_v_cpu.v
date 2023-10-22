`timescale 1ns / 1ps

module tb_risc_v_cpu ();
integer i;

// Clock and reset signals
reg clk;
reg reset;

// Design Inputs and outputs
wire [31:0] out;

// DUT instantiation
risc_v_cpu risc_v_cpu (
    .clock(clk),
    .reset(reset),
    .out(out)
);

// Generate the reset
initial begin
    reset = 1'b1;
    #10
    reset = 1'b0;
end


// generate the clock
initial begin
    clk = 1'b0;
    for (i = 0; i < 100; i = i + 1) begin
        #1 clk = ~clk;
    end
end

endmodule : tb_risc_v_cpu
