module vending_machine (
    input clk,
    input rst,
    input [1:0] coin,       // 01 for Rs.5, 10 for Rs.10
    output reg product,
    output reg change
);

parameter S0  = 2'b00,
          S5  = 2'b01,
          S10 = 2'b10,
          S15 = 2'b11;

reg [1:0] state, next_state;

// Sequential state transition
always @(posedge clk or posedge rst) begin
    if (rst)
        state <= S0;
    else
        state <= next_state;
end

// Combinational logic
always @(*) begin
    product = 0;
    change  = 0;
    case (state)
        S0: begin
            case (coin)
                2'b01: next_state = S5; 
                2'b10: next_state = S10;
                default: next_state = S0;
            endcase
        end 
        S5: begin
            case (coin)
                2'b01: next_state = S10; 
                2'b10: begin
                    product = 1;
                    next_state = S15;
                end
                default: next_state = S5;
            endcase
        end
        S10: begin
            case (coin)
                2'b01: begin
                    product = 1;
                    next_state = S15;
                end 
                2'b10: begin
                    product = 1;
                    change  = 1;
                    next_state = S0;
                end
                default: next_state = S10;
            endcase
        end
        S15: begin
            product = 1;
            change  = 1;
            next_state = S0;
        end
        default: next_state = S0;
    endcase
end

endmodule
