`timescale 1ns / 1ps

module tb_mux2_1 ();
    reg         ctrl;
    reg  [31:0] in_a;
    reg  [31:0] in_b;
    wire [31:0] out;

    mux2_1 mux (
        .S(ctrl),
        .A(in_a),
        .B(in_b),
        .O(out)
    );

    initial begin
        $monitor("time=%3d, in_a=%d, in_b=%d, ctrl=%b, q=%d \n",
                    $time, in_a, in_b, ctrl, out);

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
