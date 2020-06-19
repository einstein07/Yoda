/**
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Emmanuel Francis
// Create Date: 28.05.2020 18:48:38
// Module Name: lpf
// Project Name: YODA
// Description: Low Pass Filter
//////////////////////////////////////////////////////////////////////////////////

 */

/* Library Includes */
#include <iostream>

/* Name space includes */
using namespace std;

/** Define BYTE type which is an 8-bit unsigned quantity. */
typedef unsigned char BYTE;

/** Define hard-coded test vector. */
BYTE y_test[25] =
   { 100, 125, 148, 168, 184, 185, 200,
     198, 190, 177, 159, 148, 113, 87 ,
      63,  41,  23,  17,   2,   0,  5 ,
      16,  32,  52,  75 };

/** Desired filtered output vector. */
BYTE y_lpf[25];

/** Function to do calculate the average of 4 bytes */
BYTE avg4 ( BYTE a, BYTE b, BYTE c, BYTE d )
{
    unsigned sum = (a + b + c + d);
    sum = sum / 4;
    return sum;
}

void lpf ( int      reset,
           int      loadmem,
           int      readmem,
           int      dolpf,
           unsigned i,
           BYTE     xin,
           BYTE&    xout )
{
    static BYTE mem_raw[100];
    static BYTE mem_lpf[100];
    static unsigned n;
    if (reset) {
        n = 0;
    } else
    if (loadmem) {
       BYTE nxt = i + 1;
       mem_raw[i] = xin;
       if (nxt > n) n = nxt;
    } else
    if (readmem) {
       xout = mem_lpf[i];
    }
    if (dolpf) {
       int j;
       // check for backwards wrap
       if (i>0) j=i-1; else j=n-1;
       // apply the filter
       mem_lpf[i] = avg4(
            mem_raw[j],
            mem_raw[i],
            mem_raw[(i+1) % n],
            mem_raw[(i+2) % n]
            );
    }
}

/** Entry point to this application which implements the
    LPF routine. */
int main()
{
    // instantiate local variables
    unsigned int i;
    BYTE     temp;
    // display welcome message
    cout << "LPF using wrapping moving average of 4!" << endl;

    // reset the LPF module
    lpf(1,0,0,0,0,0,temp);

    // load in the raw data to be filtered
    for (i=0; i<25; i++)
        lpf (0,1,0,0,i,y_test[i],temp);

    // apply the LPF
    for (i=0; i<25; i++)
        lpf (0,0,0,1,i,y_test[i],temp);

    // display the output (or save to a file)
    cout << "LPF4(Y) = " << endl;

    for (i=0; i<25; i++) {
       lpf (0,0,1,0,i,0,temp);
       cout << (int)temp << endl;
    }

    // return success
    return 0;
}
