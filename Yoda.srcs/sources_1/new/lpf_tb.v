`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Emmanuel Francis
// Create Date: 14.06.2020 20:35:50
// Module Name: lpf_tb
// Project Name: YODA- Smoothing Filter
//////////////////////////////////////////////////////////////////////////////////


module lpf_tb();
    
      // set up regsiters
    reg  clk; // need a clock for activating the module
    reg  reset, loadmem, readmem, dolpf;
    reg  [7:0] i;
    reg  [7:0] xin;
    wire [7:0] xout;
    reg  [7:0] y_test [0:24]; // using 25 samples!
    
    // simulation variables
    integer j;
    
    // instantiate the module under test
    lpf uut (clk,reset,loadmem,readmem,dolpf,i,xin,xout);
    
    // perform simulation operations
    initial
    begin
        $display("clk reset loadmem readmem dolpf\t   i   xin  xout");
        $monitor("%b   %b\t     %b       %b       %b     %03d  %03d\t %03d", 
               clk, reset, loadmem, readmem, dolpf, i, xin, xout);
        // initialize control registers
        clk   <= 0; reset <= 0; loadmem <= 0; readmem <= 0; 
        dolpf <= 0;     i <= 0;     xin <= 0;
        
        // set up the memory
        y_test[0]<=100;  y_test[1]<=125;  y_test[2]<=148;
        y_test[3]<=168;  y_test[4]<=184;  y_test[5]<=185;
        y_test[6]<=200;  y_test[7]<=198;  y_test[8]<=190;
        y_test[9]<=177;  y_test[10]<=159; y_test[11]<=148;
        y_test[12]<=113; y_test[13]<=87;  y_test[14]<=63;
        y_test[15]<=41;  y_test[16]<=23;  y_test[17]<=17;
        y_test[18]<=2;   y_test[19]<=0;   y_test[20]<=5;
        y_test[21]<=16;  y_test[22]<=32;  y_test[23]<=52;
        y_test[24]<=75;
        
        // do a reset of the lpf
        #5 reset<=1; 
        // do a clock so that the lpf sees the reset
        #5 clk = ~clk; #5 clk = ~clk; 
        reset<=0;
        
        // Load in y_test to raw data
        loadmem = 1;  // change to loadmem mode
        for (j = 0; j < 25; j = j + 1)
        begin
          i<=j;
          xin<=y_test[j];
          // do a clk pulse to make the module process the new input
          #5 clk = ~clk; #5 clk = ~clk;
        end
        
        // change to apply lpf process
        loadmem<=0; xin<=0; dolpf <= 1;
        for (j = 0; j < 25; j = j + 1)
        begin
          i<=j; // need to set reg i, fed to lpf, to the simulated var
          // do a clk pulse to make the module process the new input
          #5 clk = ~clk; #5 clk = ~clk;
        end
        // now read the memory out
        dolpf<=0; xin<=0; readmem<=1;
        // the results should be displayed due to the monitor
        for (j = 0; j < 25; j = j + 1)
        begin
          i<=j;
          #5 clk = ~clk; #5 clk = ~clk;
        end
    end //end initial begin
endmodule
    
    
