module RX( 
    input wire Clk,          
    input wire nRst,        
    input wire rx,          // UART Receive line
    output reg [7:0] rx_data, // Received data
    output reg rx_ready     // Data ready flag
);

    parameter CLK_FREQ = 50000000; // 50 MHz
    parameter BAUD_RATE = 115200;
    parameter BIT_PERIOD = CLK_FREQ / BAUD_RATE;

    reg [3:0] bit_index;    // Tracks which bit is being received
    reg [15:0] clk_count;   // Clock counter for baud timing
    reg [9:0] shift_reg;    // Shift register to store received bits
    reg rx_active;          // Indicates ongoing reception

    always @(posedge Clk, negedge nRst) begin
        if (~nRst) begin
            rx_data <= 8'b0;
            rx_ready <= 1'b0;
            rx_active <= 1'b0;
            clk_count <= 0;
            bit_index <= 0;
        end
        else begin
            if (!rx_active && !rx) begin
                // Start bit detected (rx goes LOW)
                rx_active <= 1'b1;
                clk_count <= BIT_PERIOD / 2;  // Align sampling to middle of bit
                bit_index <= 0;
            end
            else if (rx_active) begin
                if (clk_count < BIT_PERIOD - 1) begin
                    clk_count <= clk_count + 1;
                end
                else begin
                    clk_count <= 0;
                    shift_reg[bit_index] <= rx; // Shift in received bit
                    if (bit_index < 9) begin
                        bit_index <= bit_index + 1;
                    end
                    else begin
                        rx_active <= 1'b0;
                        rx_data <= shift_reg[8:1]; // Extract 8-bit data
                        rx_ready <= 1'b1;
                    end
                end
            end
            else begin
                rx_ready <= 0; // Clear data ready flag after one cycle
            end
        end
    end
endmodule
