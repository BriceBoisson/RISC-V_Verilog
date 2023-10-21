module mux2_1 #(parameter BUS_SIZE = 32)
               (input [BUS_SIZE - 1:0] A, B,
                input S,
                output [BUS_SIZE - 1:0] O);
    
    assign O = S ? B : A;

endmodule