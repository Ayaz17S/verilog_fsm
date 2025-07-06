module uart_rx #(
    parameter DATA_BITS=8
)(
    input wire clk,
    input wire reset,
    input wire s_tick,
    input wire rx,

    output wire [DATA_BITS-1:0] rx_data,
    output wire rx_done_tick
);

    // FSM states
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;
    

    reg [1:0] state;
    reg[3:0] sample_cnt;
    reg[2:0]bit_cnt;
    reg[DATA_BITS-1:0] shift_reg;
    reg rx_done_tick_reg;
    reg[DATA_BITS-1:0] rx_data_reg;

    // Output assignments
    assign rx_done_tick = rx_done_tick_reg;
    assign rx_data = rx_data_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state<=IDLE;
            sample_cnt<=0;
            bit_cnt<=0;
            shift_reg<=0;
            rx_done_tick_reg<=0;
            rx_data_reg<=0;
        end else begin
            case (state)
                IDLE: begin
                    rx_done_tick_reg<=0;
                    if (~rx) begin
                        sample_cnt<=0;
                        bit_cnt<=0;
                        state<=START;
                    end
                end
                START: begin
                    if (s_tick) begin
                        sample_cnt<=sample_cnt+1;
                        if (sample_cnt==7) begin
                            if (~rx) begin
                                sample_cnt<=0;
                                state<=DATA;
                            end
                            else begin
                                state<=IDLE;
                            end
                        end
                    end
                end
                DATA: begin
                    if (s_tick) begin
                        sample_cnt<=sample_cnt+1;
                        if (sample_cnt==7) begin
                            shift_reg<={rx,shift_reg[DATA_BITS-1:1]};
                        end 
                       if (sample_cnt == 15) begin
                            sample_cnt <= 0;
                            if (bit_cnt == DATA_BITS - 1) begin
                            state <= STOP;
                            end else begin
                        bit_cnt <= bit_cnt + 1;
                     end
                end
                end    
                end
                STOP: begin
                    if (s_tick) begin
                        sample_cnt<=sample_cnt+1;
                        if (sample_cnt==7) begin
                            if (~rx) begin
                                state<=START;
                            end 
                        end
                        if(sample_cnt==15)begin
                            rx_data_reg <= shift_reg;
                            rx_done_tick_reg<=1;
                            state<=IDLE;
                            bit_cnt<=0;
                        end
                    end
                end
            endcase
        end
    end
    endmodule