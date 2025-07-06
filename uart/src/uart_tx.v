module uart_tx #(
    parameter DATA_BITS = 8
)(
    input  wire clk,           // System clock
    input  wire reset,         // Active-high asynchronous reset
    input  wire tx_start,      // Trigger to start transmission
    input  wire [DATA_BITS-1:0] tx_data, // Data to transmit
    input  wire tick,          // Baud rate tick (1 per bit-time)

    output wire tx,            // Serial output
    output wire tx_busy        // High when TX is active
);

    // FSM States
    localparam IDLE  = 3'b000;
    localparam START = 3'b001;
    localparam DATA  = 3'b010;
    localparam STOP  = 3'b011;
    localparam DONE  = 3'b100;

    // Internal registers
    reg [2:0] state;
    reg [2:0] bit_cnt;                    // Counter for data bits
    reg [DATA_BITS-1:0] shift_reg;       // Shift register for data
    reg tx_reg;                          // Output register for TX line
    reg tx_busy_reg;                     // Internal busy signal

    
    assign tx = tx_reg;
    assign tx_busy = tx_busy_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state<=IDLE;
        tx_busy_reg<=0;
        tx_reg<=1;
        bit_cnt<=0;
        shift_reg<=0;
    end else begin
        case (state)
            IDLE: begin
                if (tx_start) begin
                    state<=START;
                    tx_busy_reg<=1;
                    bit_cnt<=0;
                    shift_reg<=tx_data;
                end
            end 
            START: begin
                tx_reg<=0;
                if (tick) begin
                    state<=DATA;
                end
            end
            DATA:begin
                if (tick) begin
                    tx_reg<=shift_reg[0];
                    shift_reg<=shift_reg>>1;
                    bit_cnt<=bit_cnt+1;

                    if (bit_cnt==DATA_BITS-1) begin
                        state<=STOP;
                    end
                end
            end
            STOP:begin
                tx_reg<=1;
                if (tick) begin
                    state<=DONE;
                end
            end
            DONE:begin
                tx_busy_reg <= 0; 
                state <= IDLE;
            end
            default:begin
                state <= IDLE;
            end 
        endcase
    end
end

endmodule
