module traffic_light(
    input clk,
    input rst,
    output reg [2:0] light
);

    // Define state encoding
    parameter S0 = 2'b00, // RED
              S1 = 2'b01, // YELLOW
              S2 = 2'b10; // GREEN

    // Define light encoding
    parameter RED    = 3'b100,
              YELLOW = 3'b010,
              GREEN  = 3'b001;

    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S0;
            light <= RED;
        end else begin
            case (state)
                S0: begin
                    light <= RED;
                    state <= S1;
                end
                S1: begin
                    light <= YELLOW;
                    state <= S2;
                end
                S2: begin
                    light <= GREEN;
                    state <= S0;
                end
                default: begin
                    light <= RED;
                    state <= S0;
                end
            endcase
        end
    end

endmodule
