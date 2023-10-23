module program_counter (input             clock, reset,
                        input      [31:0] pc_new_addr,
                        output reg [31:0] pc_addr);
    
    always @ (posedge clock, posedge reset) begin
        if (reset == 1'b1)
            pc_addr <= 32'b0;
        else
            pc_addr <= pc_new_addr;
    end

endmodule
