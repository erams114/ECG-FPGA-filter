module UART( 
    input wire Clk,          
    input wire nRst,         // Reset
    input logic rx,         // UART RX line
    output logic tx,        // UART TX line
    output logic [7:0] led  // LED output to show received data
);

    logic [7:0] rx_data;
    logic rx_ready;
    logic tx_busy;
    logic tx_start;
    logic [7:0] tx_data;

    // Instantiate UART Receiver
    RX uart_rx(
        .Clk(Clk),
        .nRst(nRst),
        .rx(rx),
        .rx_data(rx_data),
        .rx_ready(rx_ready)
    );

    // Instantiate UART Transmitter
    TX uart_tx(
        .Clk(Clk),
        .nRst(nRst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // Loopback logic: Transmit received data
    always_ff @(posedge Clk) begin
        if (rx_ready && !tx_busy) begin
            tx_data <= rx_data;
            tx_start <= 1;
        end else begin
            tx_start <= 0;
        end
    end

    assign led = rx_data; // Show received data on LEDs

endmodule
