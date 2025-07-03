`timescale 1ns/1ps

module vending_machine_tb;
reg clk,rst;
reg[1:0] coin;
wire product,change;

vending_machine uut(
    .clk(clk),
    .rst(rst),
    .coin(coin),
    .product(product),
    .change(change)
);

always #10 clk =~clk;

initial begin
    $dumpfile("vending_machine.vcd");
    $dumpvars(0, vending_machine_tb);

    clk =0;
    rst =1;
    #20;

    rst =0;
    coin =2'b01;
    #20;
    coin =2'b01;
    #20;
    coin =2'b01;
    #20;
    coin =2'b01;
    #20;
    rst =1;
    #20;
    rst =0;
    #10;
    coin=2'b01;
    #10;
    coin=2'b10;
    #20;
    $finish;
end
endmodule