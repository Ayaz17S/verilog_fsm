module fifo_fsm (
    input clk,
    input reset,
    input rd_en,
    input wr_en,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);

reg [7:0] mem [7:0] ;
reg [2:0] write_ptr=0 ;
reg [2:0] read_ptr=0 ;
reg [3:0] count =0 ;

parameter IDLE = 2'b00,
          WRITE = 2'b01,
          READ = 2'b10;

reg [1:0] state, next_state;


always @(posedge clk) begin
    if (reset) begin
        state<=IDLE;
    end else begin
        state<=next_state;
    end
end

always @(*) begin
    next_state=IDLE;
    full =(count==8);
    empty=(count==0);

    case (state)
        IDLE:begin
            if(wr_en && !full) next_state=WRITE;
            else if(rd_en && !empty) next_state =READ;
            else next_state =IDLE;
        end 
        WRITE:begin
            next_state =IDLE;
        end
        READ:begin
            next_state=IDLE;
        end 
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        write_ptr<=0;
        read_ptr<=0;
        count<=0;
        data_out<=0;
    end else begin
        case (state)
            WRITE:begin
                mem[write_ptr]<=data_in;
                write_ptr<=write_ptr+1;
                count<=count+1;
            end 
            READ:begin
                data_out<=mem[read_ptr];
                read_ptr<=read_ptr+1;
                count<=count-1;
            end
            
        endcase
    end
end
    
endmodule