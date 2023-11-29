module memory (input             clock, reset,
               input             we,
               input      [1:0]  func_in,
               input      [2:0]  func_out,
               input      [31:0] address,
               input      [31:0] data_in,
               output reg [31:0] data_out);

    `include "mem_func.vh"
    
    reg [7:0] memory [1023:0];

    always @(posedge clock, posedge reset) begin
        if (reset == 1)
            memory[0] <= 8'b0;
        else if (we == 1) begin
            case (func_in)
                SB : begin
                    memory[address] <= data_in[7:0];
                end
                SH : begin 
                    memory[address] <= data_in[7:0];
                    memory[address + 1] <= data_in[15:8];
                end
                SW : begin 
                    memory[address] <= data_in[7:0];
                    memory[address + 1] <= data_in[15:8];
                    memory[address + 2] <= data_in[23:16];
                    memory[address + 3] <= data_in[31:24];
                end
            endcase
        end
    end

    always @(*) begin
        case (func_out)
            LB      : data_out <= {(memory[address][7] == 1'b1 ? 24'b111111111111111111111111 : 24'b000000000000000000000000), memory[address]};
            LH      : data_out <= {(memory[address][15] == 1'b1 ? 16'b1111111111111111 : 16'b0000000000000000), memory[address], memory[address]};
            LW      : data_out <= {memory[address + 3], memory[address + 2], memory[address + 1], memory[address]};
            LBU     : data_out <= {24'b000000000000000000000000, memory[address]};
            LHU     : data_out <= {16'b0000000000000000, memory[address]};
            default : data_out <= 32'b00000000000000000000000000000000;
        endcase
    end

endmodule
