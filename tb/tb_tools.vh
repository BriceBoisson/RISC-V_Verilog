`define assert(message, expected, got) \
    #4 \
    if(expected !== got) begin \
        $display("\033[0;31m[FAIL]\033[0m %s - got: %d, expected: %d", message, expected, got); \
    end else \
        $display("\033[0;32m[PASS]\033[0m %s", message);

`define assert_no_wait(message, expected, got) \
    if(expected !== got) begin \
        $display("\033[0;31m[FAIL]\033[0m %s - got: %d, expected: %d", message, expected, got); \
    end else \
        $display("\033[0;32m[PASS]\033[0m %s", message);

`define end_message $display("\033[0;32mIf no \033[0mFAIL\033[0;32m messages, all tests passed!\033[0m");

`define next_cycle \
    #1 clk = ~clk; \
    #1 clk = ~clk;