`timescale 1ns/1ps

module ram_tb;

    reg clk = 0, reset, start, rw;
    reg [7:0] addr, data_in;
    wire [7:0] data_out;
    wire cs, rd, wr, done;
    wire [7:0] ram_data;

    // Clock
    always #5 clk = ~clk;

    // Instantiate FSM
    ram_fsm fsm (
        .clk(clk), .reset(reset), .start(start), .rw(rw),
        .addr(addr), .data_in(data_in), .data_out(data_out),
        .done(done), .ram_data(ram_data), .cs(cs), .rd(rd), .wr(wr)
    );

    // Instantiate RAM
    ram memory (
        .clk(clk), .cs(cs), .rd(rd), .wr(wr),
        .addr(addr), .data(ram_data)
    );

    initial begin
        // Setup
        reset = 1; start = 0;
        addr = 8'd5;
        data_in = 8'hAA;
        rw = 0; // 0 = write
        #20 reset = 0;

        // --- WRITE ---
        start = 1; #10 start = 0;
        wait(done == 1); #20;

        // --- READ ---
        rw = 1; // 1 = read
        start = 1; #10 start = 0;
        wait(done == 1); #20;

        $display("Read data = %h", data_out);
        #10 $finish;
    end
endmodule
