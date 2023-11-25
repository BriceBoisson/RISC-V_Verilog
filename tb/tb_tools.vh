`define assert(message, expected, got) \
    #4 \
    if(expected !== got) begin \
        $display("\033[0;31m[FAIL]\033[0m %s - got: %0d, expected: %0d", message, expected, got); \
    end else \
        $display("\033[0;32m[PASS]\033[0m %s", message);

`define assert_no_wait(message, expected, got) \
    if(expected !== got) begin \
        $display("\033[0;31m[FAIL]\033[0m %s - got: %0d, expected: %0d", message, expected, got); \
    end else \
        $display("\033[0;32m[PASS]\033[0m %s", message);

`define assert_no_wait_reg(message, instr_addr, reg_addr, expected, got) \
    if(expected !== got) begin \
        $display("\033[0;31m[FAIL]\033[0m %s - INSTR: %0d - REG[%0d] = %0d, got: %0d", message, instr_addr, reg_addr, expected, got); \
    end else \
        $display("\033[0;32m[PASS]\033[0m %s - INSTR: %0d - REG[%0d] = %0d", message, instr_addr, reg_addr, expected);

`define assert_no_wait_pc(message, instr_addr, expected, got) \
    if(expected !== got) begin \
        $display("\033[0;31m[FAIL]\033[0m %s - INSTR: %0d - PC = %0d, got: %0d", message, instr_addr, expected, got); \
    end else \
        $display("\033[0;32m[PASS]\033[0m %s - INSTR: %0d - PC = %0d", message, instr_addr, expected);

`define assert_no_wait_mem(message, instr_addr, mem_addr, expected, got) \
    if(expected !== got) begin \
        $display("\033[0;31m[FAIL]\033[0m %s - INSTR: %0d - MEM[%0d] = %0d, got: %0d", message, instr_addr, mem_addr, expected, got); \
    end else \
        $display("\033[0;32m[PASS]\033[0m %s - INSTR: %0d - MEM[%0d] = %0d", message, instr_addr, mem_addr, expected);

`define end_message $display("\033[0;32mIf no \033[0mFAIL\033[0;32m messages, all tests passed!\033[0m");

`define next_cycle \
    #1 clk = ~clk; \
    #1 clk = ~clk;