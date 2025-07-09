module ram (
    input clk,
    input cs,
    input rd,
    input wr,
    input [7:0] addr,
    inout [7:0] data
);

reg [7:0] mem [0:255];
reg [7:0] data_out;

assign data = (cs && rd) ? data_out : 8'bz;

always @(posedge clk) begin
    if (cs && wr && !rd)
        mem[addr] <= data;
    else if (cs && rd && !wr)
        data_out <= mem[addr];
end

endmodule
