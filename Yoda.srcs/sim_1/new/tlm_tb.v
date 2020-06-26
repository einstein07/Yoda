`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2020 20:57:46
// Design Name: 
// Module Name: tlm_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tlm_tb();
    reg clk, BTNC;
    reg [9:0] src;
    reg [7:0] length;
    reg [9:0] dest;
    wire active;
    wire done;
    wire LED;
 
    
    SmoothingFilter uut(clk, BTNC, src, length, dest, LED, active, done);
    
    always begin
        #5 clk =~clk;
        //addr <= addr+1;  
        $display("raw data i=%d: %d\tfiltered data: %d", f.i, f.raw_mem[f.i], f.filtered_mem[f.i]);
        $monitor("Memory enable: %d\tLoad memory: %d\tFilter: %d\tWrite back: %d\tDone: %d", f.ena, f.load, f.lpf, f.write_m, done);

        //if( f.i== 19 && f.write_m == 1)begin
            //w_en<=1;
            //$display("Done\ti=0: %d\ti=1: %d\ti=2: %d\ti=3: %d\ti=4: %d\ti=5: %d", f.raw_mem[0], f.raw_mem[1], f.raw_mem[2], f.raw_mem[3], f.raw_mem[4], f.raw_mem[5]);
            
            //#5 clk =~clk;
            //#5 clk =~clk;        
            //addr <= addr+1;  

        //end
        
    end
    
    
    initial begin
        // Initialize Inputs
        clk <= 0;
        
        BTNC <= 0;
         
        src <= 0;
        length <= 26;
        dest = 30;
 
        BTNC <= 1; //reset
        #5 clk =~clk;
        BTNC = 0;
        #5 clk =~clk;
        #5 clk =~clk;
        #5 clk =~clk;
        #5 clk =~clk;
        
   end
   
   
   
    filter f (clk, BTNC, length, src, dest,done);
   
endmodule
