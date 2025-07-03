`timescale 1ns/1ps
module sequence_detector_tb;

    reg clk, rst, bit_in;
    wire detected;

    sequence_detector uut(
        .clk(clk),
        .rst(rst),
        .bit_in(bit_in),
        .detected(detected)
    );

    always #10 clk = ~clk;

    initial begin
        $dumpfile("sequence_detector.vcd");
        $dumpvars(0, sequence_detector_tb);

        clk = 0;
        rst = 1;
        bit_in = 0;

        #20 rst = 0;

        // Applying overlapping sequence: 1 0 1 1 0 1 1
        // Should detect at 1011 (ends at cycle 100ns), and again at 1011 (ends at 130ns)
        #20 bit_in = 1; // 20ns
        #20 bit_in = 0; // 40ns
        #20 bit_in = 1; // 60ns
        #20 bit_in = 1; // 80ns → detect = 1 (cycle 100ns)
        #20 bit_in = 0; // 100ns
        #20 bit_in = 1; // 120ns
        #20 bit_in = 1; // 140ns → detect = 1 (cycle 160ns)

        #40;
        $finish;
    end
endmodule
