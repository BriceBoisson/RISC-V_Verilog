module program_counter (input clock, reset,
           input [31:0] new_pc,
           output reg [31:0] pc);
    
    always @ (posedge clock, reset) begin
        if (reset == 1)
            pc <= 32'b0;
        else
            pc <= new_pc;
    end

endmodule
