`timescale 1ns / 1ps

module tb_alu ();
// Design Inputs and outputs
reg [31:0] in_a;
reg [31:0] in_b;
reg [2:0] op_code;
wire [31:0] out;

// DUT instantiation
alu alu (
    .input_a(in_a),
    .input_b(in_b),
    .op_code(op_code),
    .out(out)
);

// Test stimulus
initial begin
    // Use the monitor task to display the FPGA IO
    $monitor("time=%3d, in_a=%d, in_b=%d, ctrl=%b, q=%d \n",
                $time, in_a, in_b, op_code, out);

    // Generate each input with a 20 ns delay between them
    in_a = 1'b0;
    in_b = 1'b0;
    op_code = 3'b000;
    #20
    if (out !== 0) $display("[FAILED] output should be 0");
    in_a = 1'b1;
    #20
    if (out !== 1) $display("[FAILED] output should be 1");
    in_b = 1'b1;
    #20
    if (out !== 2) $display("[FAILED] output should be 2");
    op_code = 3'b001;
    #20
    if (out !== 2) $display("[FAILED] output should be 2");
end

endmodule : tb_alu
