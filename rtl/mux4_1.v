module mux4_1 #(parameter BUS_SIZE = 32)
               (input [BUS_SIZE - 1:0] A, B, C, D,
                input [1:0] S,
                output [BUS_SIZE - 1:0] O);
    
    assign O = S[1] ? (S[0] ? D : C)
                    : (S[0] ? B : A);

endmodule
