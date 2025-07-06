module uart_top (
    input wire clk,
    input wire reset,
    input wire tx_start,
    input wire [7:0] tx_data,
    
    output wire [7:0] rx_data,
    output wire rx_done_tick
);

    // Internal wires
    wire tick;
    wire tx;

    // Baud Generator Instance
    baud_generator #(
        .CLOCK_FREQ(50000000),
        .BAUD_RATE(9600)
    ) baud_gen_inst (
        .clk(clk),
        .reset(reset),
        .tick(tick)
    );

    // UART Transmitter Instance
    uart_tx #(
        .DATA_BITS(8)
    ) uart_tx_inst (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tick(tick),
        .tx(tx),
        .tx_busy() // optional
    );

    // UART Receiver Instance
    uart_rx #(
        .DATA_BITS(8)
    ) uart_rx_inst (
        .clk(clk),
        .reset(reset),
        .s_tick(tick),
        .rx(tx),  // loopback from TX
        .rx_data(rx_data),
        .rx_done_tick(rx_done_tick)
    );

endmodule
