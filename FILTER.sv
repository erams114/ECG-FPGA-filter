module FILTER #(parameter DATAWIDTH=64, ORDER=41, COEFFDATAWIDTH=32)
                    (output logic signed [DATAWIDTH-1:0] FiltOut,  // Single output
                     input logic signed [DATAWIDTH-1:0] FiltIn,
                     input logic Clk, nRst
					 //input logic rx,         // UART RX line
					 //output logic tx,        // UART TX line
					 //output logic [7:0] led
                    );

    // Low-pass filter coefficients
    logic signed [COEFFDATAWIDTH-1:0] CoefficientsLow [0:ORDER-1] = 
        '{-2791288, -3015958, -3440238, -3878685, -4007889, -3390546, -1519675, 2121310,
		7989367, 16411691, 27523593, 41222798, 57146946, 74678612, 92978973, 111047890,
		127804922, 142183157, 153225986, 160176394, 162548932, 160176394, 153225986, 
		142183157, 127804922, 111047890, 92978973, 74678612, 57146946, 41222798, 27523593,
		16411691, 7989367, 2121310, -1519675, -3390546, -4007889, -3878685, -3440238, 
		-3015958, -2791288};

    // High-pass filter coefficients
    logic signed [COEFFDATAWIDTH-1:0] CoefficientsHigh [0:ORDER-1] = 
        '{-42782684, -42907916, -43261887, -43840013, -44631619, -45620169, -46783653,
		-48095131, -49523420, -51033904, -52589439, -54151343, -55680428, -57138054, 
		-58487173, -59693334, -60725622, -61557499, -62167529, -62539968, 2086421570, 
		-62539968, -62167529, -61557499, -60725622, -59693334, -58487173, -57138054, 
		-55680428, -54151343, -52589439, -51033904, -49523420, -48095131, -46783653, 
		-45620169, -44631619, -43840013, -43261887, -42907916, -42782684};

    logic signed [DATAWIDTH-1:0] LowOut;

    // Instantiate Low-Pass FIR
    FIR #(DATAWIDTH, ORDER, COEFFDATAWIDTH) FIR_Low (
        .FiltOut(FiltOut),
        .FiltIn(LowOut),
        .Coefficients(CoefficientsLow),
        .Clk(Clk),
        .nRst(nRst)
    );

    // Instantiate High-Pass FIR (with LowOut as input)
    FIR #(DATAWIDTH, ORDER, COEFFDATAWIDTH) FIR_High (
        .FiltOut(LowOut),  // Directly assign the final output
        .FiltIn(FiltIn),
        .Coefficients(CoefficientsHigh),
        .Clk(Clk),
        .nRst(nRst)
    );

//UART program
    /*logic [7:0] rx_data;
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

    assign led = rx_data; // Show received data on LEDs*/
endmodule