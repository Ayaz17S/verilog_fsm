module uart_rx #(
    parameter DATA_BITS = 8
)(
    input wire clk,
    input wire reset,
    input wire s_tick,
    input wire rx,
    output wire [DATA_BITS-1:0] rx_data,
    output wire rx_done_tick
);

    localparam IDLE = 2'b00,
               START = 2'b01,
               DATA = 2'b10,
               STOP = 2'b11;

    reg [1:0] state;
    reg [3:0] sample_cnt;
    reg [2:0] bit_cnt;
    reg [DATA_BITS-1:0] shift_reg;
    reg rx_done_tick_reg;
    reg [DATA_BITS-1:0] rx_data_reg;

    assign rx_data = rx_data_reg;
    assign rx_done_tick = rx_done_tick_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            sample_cnt <= 0;
            bit_cnt <= 0;
            shift_reg <= 0;
            rx_done_tick_reg <= 0;
        end else begin
            rx_done_tick_reg <= 0;
            case (state)
                IDLE:
                    if (~rx) begin
                        sample_cnt <= 0;
                        bit_cnt <= 0;
                        state <= START;
                    end
                START:
                    if (s_tick) begin
                        sample_cnt <= sample_cnt + 1;
                        if (sample_cnt == 7) begin
                            if (~rx)
                                state <= DATA;
                            else
                                state <= IDLE;
                            sample_cnt <= 0;
                        end
                    end
                DATA:
                    if (s_tick) begin
                        sample_cnt <= sample_cnt + 1;
                        if (sample_cnt == 15) begin
                        // Shift new bit into the LSB (correct for UART LSB-first)
                        shift_reg <= {rx, shift_reg[DATA_BITS-1:1]};  // <-- This is correct
                        bit_cnt <= bit_cnt + 1;
                        sample_cnt <= 0;
                        if (bit_cnt == DATA_BITS-1) state <= STOP;
                     end
                end
                STOP:
                    if (s_tick) begin
                        sample_cnt = sample_cnt + 1;
                        if (sample_cnt == 15) begin
                            rx_data_reg = shift_reg;
                            rx_done_tick_reg = 1;
                            state = IDLE;
                        end
                    end
            endcase
        end
    end
endmodule