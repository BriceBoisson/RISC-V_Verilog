module alu (S, A, B);
    output [31:0] S;
    input [31:0] A, B;

    xor N[31:0] (S, A, B);
endmodule