`timescale 1ns / 1ps

module tb_mux2_1 ();
// Clock and reset signals
reg clk;
reg reset;

// Design Inputs and outputs
reg [31:0] in_a;
reg [31:0] in_b;
reg ctrl;
wire [31:0] out;

// DUT instantiation
mux2_1 mux (
    .S(ctrl),
    .A(in_a),
    .B(in_b),
    .O(out)
);

// generate the clock
initial begin
    clk = 1'b0;
    // forever #1 clk = ~clk;
end

// Generate the reset
initial begin
    reset = 1'b1;
    #10
    reset = 1'b0;
end

// Test stimulus
initial begin
    // Use the monitor task to display the FPGA IO
    $monitor("time=%3d, in_a=%d, in_b=%d, ctrl=%b, q=%d \n",
                $time, in_a, in_b, ctrl, out);

    // Generate each input with a 20 ns delay between them
    in_a = 1'b0;
    in_b = 1'b0;
    ctrl = 1'b0;
    #20
    if (out !== 0) $display("[FAILED] output should be 0");
    in_a = 1'b1;
    #20
    if (out !== 1) $display("[FAILED] output should be 1");
    ctrl = 1'b1;
    in_a = 1'b0;
    in_b = 1'b1;
    #20
    if (out !== 1) $display("[FAILED] output should be 1");
    ctrl = 1'b0;
    in_a = 1'b1;
    #20
    if (out !== 1) $display("[FAILED] output should be 1");
end

endmodule : tb_mux2_1
