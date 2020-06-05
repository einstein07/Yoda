`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCT
// Engineer: Sindiso Mkhatshwa
// 
// Create Date: 04.06.2020 05:29:06
// Design Name: 
// Module Name: filter
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


module filter(
    input clk,
    input reset,
    input len,
    input [7:0] src,
    input [7:0] dest,
    input [7:0] win_size,
    output done    
    );
    //internal registers
    reg [7:0] i;        //current index   
    reg [7:0] j;        //(i-1)%len
    reg [7:0] k;        //(i+1)%len
    reg [7:0] l;        //(i+2)%len
    reg [9:0] sum;      //extra bits to handle carry
    reg       round_up; //set if we need to round
    reg       Done;
     // Memory IO
    reg ena = 1;
    reg wea = 0;
    reg [7:0] addra=0;
    reg [10:0] dina=0; //We're not putting data in, so we can leave this unassigned
    wire [10:0] douta;
    blk_mem_gen_0 mem (clk, ena, wea, addra, dina, douta);
    
    always @(posedge clk)begin
        if(reset)begin
            i <= src;
            j <= 0;
            k <= 0;
            Done <= 0;
        end 
        if(i == (len-1))Done = 1'b1;
        else begin
            j = (i > 0)? (j - 1):(len - 1); 
            
            k = i + 1;
            if(k == len)k = 0;
            else if (k == (len + 1))k = 1;
            
            l = i + 2;
            if(l == len)l = 0;
            else if(l == (len+1))l = 1;
            
            //Calculate the average:
            //sum =
            i = i + 1; 
        end
    end
    assign done = Done;
    
endmodule
