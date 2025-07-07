`timescale 1ns/1ps

module uart_tb;
    reg clk;
    reg reset;
    reg tx_start;
    reg [7:0] tx_data;
    wire [7:0] rx_data;
    wire rx_done_tick;

    uart_top uut (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .rx_data(rx_data),
        .rx_done_tick(rx_done_tick)
    );

    always #31.25 clk = ~clk; // ~16 KHz clock

    initial begin
        $dumpfile("uart_waveform.vcd");
        $dumpvars(0, uart_tb);
        clk = 0;
        reset = 1;
        tx_start = 0;
        tx_data = 8'b0;

        #100;
        reset = 0;
        #100;

        tx_data = 8'b10101010;
        tx_start = 1;
        #100;
        tx_start = 0;

        wait(rx_done_tick);
        $display("TX: %b", tx_data);
        $display("RX: %b", rx_data);

        #200;
        $finish;
    end
endmodule
