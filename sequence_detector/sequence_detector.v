module sequence_detector(
    input clk,
    input rst,
    input bit_in,
    output reg detected
);

    // States for detecting 1011
    parameter S0=0, S1=1, S2=2, S3=3;

    reg [1:0] state, next_state;

    // Sequential block
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = (bit_in == 1) ? S1 : S0;
            S1: next_state = (bit_in == 0) ? S2 : S1;
            S2: next_state = (bit_in == 1) ? S3 : S0;
            S3: next_state = (bit_in == 1) ? S1 : S2;  // allow overlap
            default: next_state = S0;
        endcase
    end

    // Output logic (Moore-style)
    always @(posedge clk or posedge rst) begin
        if (rst)
            detected <= 0;
        else
            detected <= (state == S3 && bit_in == 1);
    end

endmodule
