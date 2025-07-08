`timescale 1ns/1ps

module ram_tb;

    reg clk = 0;
    always #5 clk = ~clk;

    reg [9:0] addr;
    reg rd, wr, cs;
    wire [7:0] data;
    reg [7:0] drive_data;
    reg drive_enable;

    assign data = drive_enable ? drive_data : 8'bz;

    ram uut (
        .addr(addr),
        .data(data),
        .clk(clk),
        .rd(rd),
        .wr(wr),
        .cs(cs)
    );

    initial begin
        $dumpfile("ram_waveform.vcd");
        $dumpvars(0, ram_tb);

        // Initialize
        addr = 0;
        rd = 0;
        wr = 0;
        cs = 0;
        drive_enable = 0;
        drive_data = 8'h00;

        // Write to addr 5
        @(negedge clk);
        addr = 10'd5;
        drive_data = 8'hAA;
        drive_enable = 1;
        wr = 1;
        cs = 1;

        @(negedge clk);
        wr = 0;
        drive_enable = 0;
        cs = 0;

        // Write to addr 10
        @(negedge clk);
        addr = 10'd10;
        drive_data = 8'h55;
        drive_enable = 1;
        wr = 1;
        cs = 1;

        @(negedge clk);
        wr = 0;
        drive_enable = 0;
        cs = 0;

        // Read from addr 5
        @(negedge clk);
        addr = 10'd5;
        rd = 1;
        cs = 1;

        @(posedge clk); #1;
        $display("Read from addr 5: %h", data);

        rd = 0;
        cs = 0;

        // Read from addr 10
        @(negedge clk);
        addr = 10'd10;
        rd = 1;
        cs = 1;

        @(posedge clk); #1;
        $display("Read from addr 10: %h", data);

        rd = 0;
        cs = 0;

        #20;
        $finish;
    end

endmodule
