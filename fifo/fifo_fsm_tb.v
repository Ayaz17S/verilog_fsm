`timescale 1ns/1ps
module fifo_fsm_tb;
reg clk=0,reset,rd_en,wr_en;
reg[7:0] data_in;
wire [7:0] data_out;
wire full,empty;

always #5 clk=~clk;
fifo_fsm uut(
    .clk(clk),
    .reset(reset),
    .rd_en(rd_en),
    .wr_en(wr_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
);

initial begin
    $dumpfile("fifo_fsm.vcd");
    $dumpvars(0, fifo_fsm_tb);
    reset=1;
    wr_en = 0; rd_en = 0; data_in = 8'h00;
    #10;
    reset=0;

    repeat(3) begin
      @(negedge clk);
      data_in =$random%256;
      wr_en=1;
      @(negedge clk);
      wr_en=0;
    end

    repeat(3) begin
      @(negedge clk);
      
      rd_en=1;
      @(negedge clk);
      rd_en=0;
    end
    #20;
    $finish;


end
endmodule