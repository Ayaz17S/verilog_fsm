module ram(
    input [9:0] addr,
    inout [7:0] data,
    input clk,
    input rd,
    input wr,
    input cs
);

    reg [7:0] mem [0:1023];
    reg [7:0] data_out;
    reg data_drive;

    assign data = (cs && rd && !wr && data_drive) ? data_out : 8'bz;

    always @(posedge clk) begin
        if (cs && wr && !rd) begin
            mem[addr] <= data;
        end
        if (cs && rd && !wr) begin
            data_out <= mem[addr];
            data_drive <= 1;
        end else begin
            data_drive <= 0;
        end
    end
endmodule
