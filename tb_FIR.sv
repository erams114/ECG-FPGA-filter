`timescale 1ns/100ps

`define PERIOD 10 //clock period
`define DATAWIDTH 64
`define ORDER 41
`define COEFFDATAWIDTH 32


module tb_FIR;
    int ptrFileWrite;
    int ptrFileRead;

    // Create FIR module
    logic signed [`DATAWIDTH-1:0] FiltOut;
    logic signed [`DATAWIDTH-1:0] FiltIn;
    logic Clk, nRst;

    FILTER filt(.*);

    // Clock Generation
    initial
    begin
        Clk = '0;
        forever #(`PERIOD/2) Clk = ~Clk;
    end
	
	initial begin 
		#500000;
		$stop;
	end

    // Store the output in the file
    always @(posedge Clk) 
    begin
        $fwrite(ptrFileWrite, "%d\n", FiltOut); //store the value of out in file
    end

    // Main test
    initial 
    begin
        ptrFileWrite = $fopen("OutputSignal.txt","w"); //Create output file
        ptrFileRead = $fopen("InputSignal.txt","r"); //Open input file
        
        //Reset
        nRst = 1'b0;
        FiltIn = '0;
        #1
        nRst = 1'b1;

        //Read inputs
        while(!$feof(ptrFileRead))
        begin
            void'($fscanf(ptrFileRead, "%d", FiltIn));
            @(negedge Clk);
        end
        
        // Extra values to complete the signal
        FiltIn = '0;
        for (int i=0; i<`ORDER; i++) @(negedge Clk);

        $display("Test finished");
        $fclose(ptrFileWrite);
        $stop;
        
    end    

endmodule

