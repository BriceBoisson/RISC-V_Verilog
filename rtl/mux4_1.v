module mux4_1 (input [31:0] A, B, C, D,
               input [1:0] S,
               output [31:0] O);
    
    assign O = S[0] ? (S[1] ? D : C)
                    : (S[1] ? B : A);

endmodule
