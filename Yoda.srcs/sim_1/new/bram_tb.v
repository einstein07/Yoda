`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCT
// Engineer: Sindiso Mkhatshwa
// 
// Create Date: 12.05.2020 04:32:27
// Design Name: 
// Module Name: bram_tb
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


module bram_tb(douta);



    reg clk; //clock
    reg [1:0]w_en; //write enable
    reg [9:0] addr;//address
    

    reg [31:0] dina;     // data in
    output [31:0] douta;// data out

    // Instantiate the Unit Under Test (UUT)
    blk_mem_gen_1 uut (
        .clka(clk),
        .ena(1'b1), 
        .wea(w_en), 
        .addra(addr), 
        .dina(dina), 
        .douta(douta)
    );

    always begin
        #5 clk =~clk;
        #5 clk =~clk;

        addr <= addr+1;  

    end

    initial begin
        // Initialize Inputs
        clk = 0;
        addr = 0;
        dina = 0;
        w_en = 0;
   end

endmodule





















