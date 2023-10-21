`timescale 1ns / 1ps

module tb_risc_v_cpu ();
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

// generate the clock
initial begin
    clk = 1'b0;
    forever #1 clk = ~clk;
end

// Generate the reset
initial begin
    reset = 1'b1;
    #10
    reset = 1'b0;
end

endmodule : tb_risc_v_cpu
