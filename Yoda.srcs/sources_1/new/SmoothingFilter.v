`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Sindiso Mkhatshwa
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
    input BTNC,        //Reset signal
    input[9:0] src,          //Source address
    input[7:0] length,       //Length of data to be processed
    input[9:0] dest,        //Destination address
    output LED,         
    output active,      //Set this bit to indicate that device is busy working
    output done         //Set this bit to high once processing is complete
    );
    //Internal wires
    wire Reset;         //Reset signal
    wire btn_up;        //increase smoothing factor signal
    wire btn_down;      //decrease smoothing factor signal
    wire Done;
    //Reset 
    Delay_Reset d(CLK100MHZ, BTNC, Reset);                 
    //Instantiate debounce module
    //Debounce debounce_up(CLK100MHZ, BTNU, btn_up);         //Debounce BTNU
    //Debounce debounce_dn(CLK100MHZ, BTND, btn_down);       //Debounce BTNU
    //Instantiate filter module
    filter f(CLK100MHZ, Reset, length, src, dest, Done);
   
    
    assign done = Done;
    assign active = ~Done;
    assign LED = done;
    
endmodule
