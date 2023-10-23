`timescale 1ns / 1ps

module tb_risc_v_cpu ();
    reg         clk;
    reg         reset;
    integer     i;
    wire [31:0] out;

    risc_v_cpu risc_v_cpu (
        .clock(clk),
        .reset(reset),
        .out(out)
    );

    initial begin
        reset = 1'b1;
        #10
        reset = 1'b0;
    end

    initial begin
        clk = 1'b0;
        for (i = 0; i < 100; i = i + 1) begin
            #1 clk = ~clk;
        end
    end

endmodule : tb_risc_v_cpu
