module mux2_1 #(parameter BUS_SIZE = 32)
               (input  [BUS_SIZE - 1:0] in_1, in_2,
                input                   sel,
                output [BUS_SIZE - 1:0] out);
    
    assign out = sel ? in_2 : in_1;

endmodule