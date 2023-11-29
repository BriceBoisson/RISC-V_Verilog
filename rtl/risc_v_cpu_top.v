module risc_v_cpu_top (input         clock, reset,
                       output [31:0] out);

    /* You can use the following file as your top layer for your FPGA synthesis */

    risc_v_cpu risc_v_cpu (
        .clock(clock),
        .reset(reset),
        .out(out)
    );

endmodule

