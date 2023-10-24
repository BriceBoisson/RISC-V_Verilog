`define assert(message, expected, got) \
    #4 \
    if(expected !== got) begin \
        $display("\033[0;31m[FAILED]\033[0m : %s - got: %d, expected: %d", message, expected, got); \
    end

`define end_message $display("\033[0;32mIf no \033[0m[FAILED]\033[0;32m messages, all tests passed!\033[0m");
