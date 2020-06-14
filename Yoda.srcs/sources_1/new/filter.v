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
    parameter MEM_LEN = 1024;
    reg [7:0] i;        //current index   
    reg [7:0] j;        //(i-1)%len
    reg [7:0] k;        //(i+1)%len
    reg [7:0] l;        //(i+2)%len
    reg [9:0] sum;      //extra bits to handle carry
    reg       round_up; //set if we need to round
    reg       Done;
    reg [7:0] load_i;
    reg       load;     //load data into internal memory
    reg       lpf;      //set if busy processing
    reg       write_m;  //set if we are writing results back to memory
     // Memory IO
    reg ena;
    reg wea;
    reg [9:0] addra;
    reg [31:0] dina; 
    wire [31:0] douta;
    blk_mem_gen_0 mem_w (clk, ena, wea, addra, dina, douta);
        
    blk_mem_gen_0 mem_r (clk, ena, wea, addra, dina, douta);
    reg [31:0] raw_mem[0:MEM_LEN-1];
    reg [31:0] filtered_mem[0:MEM_LEN-1];
    always @(posedge clk)begin
        if(reset)begin
            i <= src;
            j <= 0;
            k <= 0;
            load <= 1; //On reset load data first
            ena <= 1; //enable
            addra <= src; //On reset set source address
            wea <= 0; //On reset we want to load data first, write disabled
            dina <= 0;
            lpf <= 0;
            Done <= 0;
        end 
        if(i == (len-1))Done = 1'b1;
        else begin
            if(load)begin//Read in all data to be processed
                raw_mem[i] = douta;
                if(i == len-1)begin
                    load <= 0; //done loading data from memory
                    i <= 0; //Set to zero to start from first element of internal reg
                    lpf <= 1; //Enable filtering
                end
                else begin //Increments
                    i <= i + 1;
                    addra <= addra + 1;
                end
                    
                
                 
            end 
            else if(lpf)begin //Start filtering
                
                j = (i > 0)? (i - 1):(len - 1); 
                
                k = i + 1;
                if(k == len)k = 0;
                else if (k == (len + 1))k = 1;
                
                l = i + 2;
                if(l == len)l = 0;
                else if(l == (len+1))l = 1;
                
                //Calculate the average:
                sum = raw_mem[j] + raw_mem[i] + raw_mem[k] + raw_mem[l];
                round_up = (sum[1] == 1)?1:0;
                sum = sum >> 2;
                if(round_up)
                    sum = sum + 1;
                filtered_mem[i] = sum;
                if(i == len-1)begin
                    lpf <= 0;
                    i <= 0; //Assign destinantion address
                    addra <= dest;
                    write_m <= 1; 
                    wea <= 1; //Set ready to write
                end else
                    i = i + 1;
            end
            else if(write_m)begin
                dina = filtered_mem[i]; //write results to destination address
                if(i == len - 1)begin
                    wea <= 0;
                    Done <= 1;
                end else begin
                    addra <= addra + 1;
                    i <= i + 1;
                end    
            end 
        end
    end
    assign done = Done;
    
endmodule
