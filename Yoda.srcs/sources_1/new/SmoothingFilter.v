`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2020 05:11:12
// Design Name: 
// Module Name: SmoothingFilter
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


module SmoothingFilter(
    input CLK100MHZ,    //Clock signal
    input BTNU,         //Increase window size
    input BTND,         //Decrease window size
    input src,          //Source address
    input length,       //Length of data to be processed
    input dest,
    input _active,      //Set this bit to indicate that device is busy working
    output done         //Set this bit to high once processing is complete
    );
    
    
    
endmodule
