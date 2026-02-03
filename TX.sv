module TX(
    input wire Clk,          
    input wire nRst,          
    input wire tx_start,     // Start transmission signal
    input wire [7:0] tx_data,// Data to transmit
    output reg tx,           // UART Transmit line
    output reg tx_busy       // Busy flag
);
   
    parameter CLK_FREQ = 50000000; // 50 MHz
    parameter BAUD_RATE = 115200;
    parameter BIT_PERIOD = CLK_FREQ / BAUD_RATE;

    reg [3:0] bit_index;     // Tracks which bit is being sent
    reg [15:0] clk_count;    // Clock counter for baud timing
    reg [9:0] shift_reg;     // Shift register containing start, data, stop bits

    always @(posedge Clk, negedge nRst) begin
        if (~nRst) begin
            tx <= 1'b1;  // UART idle state is HIGH
            tx_busy <= 1'b0;
            clk_count <= 0;
            bit_index <= 0;
        end
        else if (tx_start && !tx_busy) begin
            // Load shift register: {Stop bit, Data, Start bit}
            shift_reg <= {1'b1, tx_data, 1'b0};
            tx_busy <= 1'b1;
            clk_count <= 0;
            bit_index <= 0;
            tx <= 1'b0; // Start bit
        end
        else if (tx_busy) begin
            if (clk_count < BIT_PERIOD - 1) begin
                clk_count <= clk_count + 1;
            end
            else begin
                clk_count <= 0;
                if (bit_index < 9) begin
                    bit_index <= bit_index + 1;
                    tx <= shift_reg[bit_index];
                end else begin
                    tx_busy <= 1'b0; // Transmission complete
                    tx <= 1'b1;  // Idle state
                end
            end
        end
    end
endmodule

