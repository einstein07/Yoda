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
    input BTNU,         //Increase window size
    input BTND,         //Decrease window size
    input src,          //Source address
    input length,       //Length of data to be processed
    input dest,         //Destination address
    input active,      //Set this bit to indicate that device is busy working
    output done         //Set this bit to high once processing is complete
    );
    //Internal wires
    wire Reset;         //Reset signal
    wire btn_up;        //increase smoothing factor signal
    wire btn_down;      //decrease smoothing factor signal
    wire Done;
    //Internal registers
    reg [7:0] window_size;          //Smoothing factor  
    //Reset 
    Delay_Reset d(CLK100MHZ, BTNC, Reset);                 
    //Instantiate debounce module
    Debounce debounce_up(CLK100MHZ, BTNU, btn_up);         //Debounce BTNU
    Debounce debounce_dn(CLK100MHZ, BTND, btn_down);       //Debounce BTNU
    //Instantiate filter module
    filter(CLK100MHZ, Reset, length, src, dest, window_size, Done);
   
    
    always @(posedge CLK100MHZ)begin
        if(Reset)begin      //Handle reset
            window_size = 4;    //Default value of 4
        end else 
        if(btn_up)begin     //Handle smoothing factor increment
            if(window_size < length) window_size = window_size + 1;
        end else
        if(btn_down)begin   //Handle smoothing factor decrease
            if(window_size > 4) window_size = window_size - 1;
        end
     
    end
    
    assign done = Done;
    assign active = ~Done;
    
endmodule
