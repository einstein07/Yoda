`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Emmanuel Francis
// Create Date: 28.05.2020 18:48:38
// Module Name: lpf
// Project Name: YODA
// Description: Low Pass Filter
//////////////////////////////////////////////////////////////////////////////////


module lpf(
    input clk,
    input reset,
    input loadmem,
    input readmem,
    input dolpf,
    input [7:0] i, //8 bit value
    input [7:0] xin, //8 bit x input
    output reg [7:0] xout //8 bit x ouput
    );
    
    //reg n; //count value
    reg next; //count value
    //reg j; //count value
    reg[7:0] n; // amount of memory used
    reg[7:0] j; // (i-1) % n
    reg[7:0] k; // (i+2) % n
    reg[7:0] l; // (i+1) % n
    reg ru; // true if need to round up
    reg[9:0] sum; // sum - note need a few extra bits for carry
    
    // set up parameters
     parameter MEM_N = 100; // number of words of memory
    
    // internal memory
    reg[7:0] mem_raw [0:MEM_N-1];
    reg[7:0] mem_lpf [0:MEM_N-1];
    // Memory I/O
    reg ena = 1;
    reg wea = 0;
    reg [7:0] addra=0;
    reg [10:0] dina; 
    wire [10:0] douta;
    //reg [7:0] mem_raw;
    //reg [7:0] mem_lpf;
    
    //Instantiate block memory
    //blk_mem raw (clk,ena,wea,addra,dina,mem_raw);
    //blk_mem lpf (clk,ena,wea,addra,dina,mem_lpf);
    
    
    always @ (posedge clk)begin
        if(reset)begin
            n <= 0; j <= 0;
            l <= 0; k <=0;
        end//reset
        else begin
            if(loadmem)begin
                //next<=i+1;
                mem_raw[i]<= xin;
                if((i+1)>n) n<=i+1;
            end//if loadmem
            else if(readmem) xout <= mem_lpf[i];
            ///// Handle processing
            if(dolpf)begin
                /*check for backwards wrap
                if(i>0) j<=i-1; // j set to next sample
                else j<=n-1; // j set to last sample
                //check for forwards wrap
                if((i+1)>n) j<=0;// if larger than sample
                if((i+2)>n) j<=1; //if larger than sample*/
                 
                // calculate j = (i-1)%n
                j = (i>0) ? (i-1) : (n - 1);
                
                // calculate l = (i+1)%n
                l = i+1;
                if (l == n) l = 0;
                else if (l == (n+1)) l = 1;
                
                // calculate k = (i+2)%n
                k = i+2;
                if (k == n) k = 0;
                else if (k == (n+1)) k = 1;
                    
                // calculate the average: (a+b+c+d)/4
                sum = mem_raw[j] + mem_raw[i] + mem_raw[l] + mem_raw[k];
                   ru = (sum[1]==1)? 1 : 0;
                sum = sum >> 2; // divide by 4
                   if (ru) sum = sum + 1;
                mem_lpf[i] = sum;
             
            end //if dolpf
            
        end//else reset
          
    end// always @ clk or reset
    //raw (clk,ena,wea,addra,dina,mem_raw);
    //lpf (clk,ena,wea,addra,dina,mem_lpf);

endmodule

/*module lpf (
     clk, // clock - tells the module inputs have changed
     reset, // reset line
     loadmem, // load data byte into mem_raw
     readmem, // read data byte from mem_lpf
     dolpf, // do lpf processing on mem_raw[i]
     i, // index to process
     xin, // byte input
     xout // byte output
     );
    
     // set up parameters
     parameter MEM_N = 100; // number of words of memory
    
     // define the inputs bits
     input clk, reset, loadmem, readmem, dolpf;
     // define input bytes
     input[7:0] i;
     input[7:0] xin;
     // define the output
     output reg [7:0]xout;
    
     // internal registers
     reg[7:0] n; // amount of memory used
     reg[7:0] j; // (i-1) % n
     reg[7:0] k; // (i+2) % n
     reg[7:0] l; // (i+1) % n
     reg ru; // true if need to round up
     reg[9:0] sum; // sum - note need a few extra bits for carry
    
     // internal memory
     reg[7:0] mem_raw [0:MEM_N-1];
     reg[7:0] mem_lpf [0:MEM_N-1];
    
    
    // the machine triggers only on a clk pulse
     always @ (posedge clk)
         begin
         ///// Handle Reset
         if (reset) begin
             // it is a clocked reset, I suppose a student may get
             // a higher mark for implementing an unclocked reset.
             n <= 0; j <= 0;
             l <= 0; k <=0;
         end else
         ///// Handle loading
         if (loadmem) begin
             mem_raw[i]<=xin;
             if ( (i+1) > n ) n<= i+1;
         end
         else if (readmem) begin
            xout<=mem_lpf[i];
         end
         ///// Handle processing
         if (dolpf) begin
             // calculate j = (i-1)%n
             j = (i>0) ? (i-1) : (n - 1);
            
             // calculate l = (i+1)%n
             l = i+1;
             if (l == n) l = 0;
             else if (l == (n+1)) l = 1;
            
             // calculate k = (i+2)%n
             k = i+2;
             if (k == n) k = 0;
             else if (k == (n+1)) k = 1;
            
             // calculate the average: (a+b+c+d)/4
             sum = mem_raw[j] + mem_raw[i] + mem_raw[l] + mem_raw[k];
                ru = (sum[1]==1)? 1 : 0;
             sum = sum >> 2; // divide by 4
                if (ru) sum = sum + 1;
             mem_lpf[i] = sum;
        end
    end // end always@ (clk)
endmodule*/
