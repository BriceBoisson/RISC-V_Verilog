module mux2_1 (input [31:0] A, B,
               input S,
               output [31:0] O);
    
    assign O = S ? B : A;

endmodule