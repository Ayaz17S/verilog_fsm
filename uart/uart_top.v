module uart_top (
    input wire clk,
    input wire reset,
    input wire tx_start,
    input wire [7:0] tx_data,
    output wire [7:0] rx_data,
    output wire rx_done_tick
);

    wire tick_16x;       // 16x oversampling clock (for RX)
    wire tick_tx;        // 1x baud rate clock (for TX)
    reg [3:0] tick_div;  // Divider counter
    
    // Internal loopback connection (TX to RX)
    wire tx;

    // Baud rate generator for 16x oversampling (RX)
    // For 100 baud with 16x oversampling = 1600 Hz
    baud_generator #(
        .CLOCK_FREQ(16000),  // 16 KHz system clock
        .BAUD_RATE(1600)     // 16x oversampling clock (100 baud * 16)
    ) baud_gen_inst (
        .clk(clk),
        .reset(reset),
        .tick(tick_16x)
    );

    // Divide the 16x clock down to 1x baud rate for TX
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tick_div <= 0;
        end
        else if (tick_16x) begin
            if (tick_div == 15) begin
                tick_div <= 0;
            end
            else begin
                tick_div <= tick_div + 1;
            end
        end
    end
    
    assign tick_tx = (tick_16x && (tick_div == 0));  // 1x baud rate pulse

    // UART Transmitter
    uart_tx uart_tx_inst (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tick(tick_tx),
        .tx(tx),
        .tx_busy()  // Optional: connect if you want to monitor busy state
    );

    // UART Receiver
    uart_rx uart_rx_inst (
        .clk(clk),
        .reset(reset),
        .s_tick(tick_16x),
        .rx(tx),  // Loopback: receiving what we transmit
        .rx_data(rx_data),
        .rx_done_tick(rx_done_tick)
    );
endmodule