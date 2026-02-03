module FIR #(parameter DATAWIDTH=64, ORDER=41, COEFFDATAWIDTH=32)
            (output logic signed [DATAWIDTH-1:0] FiltOut,
             input logic signed [DATAWIDTH-1:0] FiltIn,
			 input wire logic signed [COEFFDATAWIDTH-1:0] Coefficients [0:ORDER-1],
             input logic Clk, nRst
            );
  
    logic signed [DATAWIDTH-1:0] Taps [ORDER]; //Extra tap to also store the current input value. 
    logic signed [DATAWIDTH-1:0] Products [ORDER];
    logic signed [DATAWIDTH-1:0] Sum;

    assign FiltOut = Sum >>> 31; // Assign the output

    // Async. reset
    always @(posedge Clk, negedge nRst)
    begin
        if(!nRst)
            for( int i=0; i<ORDER; i++)
                Taps[i] <= '0;
        else
        begin
            Taps[0] <= FiltIn;
            for( int i=1; i<ORDER; i++)
                Taps[i] <= Taps[i-1];
        end
    end

    // Calculate products
    always_comb
    begin
        for (int j=0; j<ORDER; j++)
            Products[j] = Taps[j] * Coefficients[j];
    end

    // Calculate accumulating sum
    always_comb
    begin
        Sum = Products[0];
        for (int k=1; k<ORDER;k++)
                Sum = Sum + Products[k];
    end

    


endmodule