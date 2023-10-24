module mux4_1 #(parameter BUS_SIZE = 32)
               (input  [BUS_SIZE - 1:0] in_1, in_2, in_3, in_4,
                input  [1:0]            sel,
                output [BUS_SIZE - 1:0] out);
    
    assign out = sel[1] ? (sel[0] ? in_4 : in_3)
                        : (sel[0] ? in_2 : in_1);

endmodule
