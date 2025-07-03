`timescale 1ns/1ps

module traffic_light_tb;

reg clk,rst;
wire [2:0]light;

traffic_light uut(
    .clk(clk),
    .rst(rst),
    .light(light)
);

  always #10 clk = ~clk;

    initial begin
        $dumpfile("traffic_light.vcd");
        $dumpvars(0, traffic_light_tb);

         clk = 0;
        rst = 1;

        #20 rst = 0;

        #60;
        $finish;
    end
    endmodule