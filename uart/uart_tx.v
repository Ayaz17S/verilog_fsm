module uart_tx #(
    parameter DATA_BITS = 8
)(
    input  wire clk,
    input  wire reset,
    input  wire tx_start,
    input  wire [DATA_BITS-1:0] tx_data,
    input  wire tick,
    output wire tx,
    output wire tx_busy
);

    localparam IDLE  = 3'b000,
               START = 3'b001,
               DATA  = 3'b010,
               STOP  = 3'b011,
               DONE  = 3'b100;

    reg [2:0] state;
    reg [2:0] bit_cnt;
    reg [DATA_BITS-1:0] shift_reg;
    reg tx_reg, tx_busy_reg;

    assign tx = tx_reg;
    assign tx_busy = tx_busy_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            tx_busy_reg <= 0;
            tx_reg <= 1;
            bit_cnt <= 0;
            shift_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (tx_start) begin
                        state <= START;
                        tx_busy_reg <= 1;
                        shift_reg <= tx_data;
                        bit_cnt <= 0;
                    end
                end
                START: begin
                    tx_reg <= 0;
                    if (tick) state <= DATA;
                end
                DATA: begin
                    if (tick) begin
                        tx_reg <= shift_reg[0];
                        shift_reg <= shift_reg >> 1;
                        bit_cnt <= bit_cnt + 1;
                        if (bit_cnt == DATA_BITS-1)
                            state <= STOP;
                    end
                end
                STOP: begin
                    tx_reg <= 1;
                    if (tick) state <= DONE;
                end
                DONE: begin
                    tx_busy_reg <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule

