
#include <stdint.h>
#include <stdio.h>
// 1 bit sign, 5 bit exp, 11 bit mantissa
uint16_t concatFloat(uint8_t float1, uint8_t float2)
{
    return (float1 << 8) | float2;
}
// Converts 2 halves of 8 bit fixed point number to a 16 bit float
uint16_t fltflt(uint8_t float1_1, uint8_t float1_2, uint8_t float2_1, uint8_t float2_2) {
    uint8_t LEADING_ONE = 0b10000000;
    uint8_t EXP_MASK = 0b01111100;

    uint8_t sign1 = float1_1 & LEADING_ONE;
    uint8_t sign2 = float2_1 & LEADING_ONE;
    if(sign1 != sign2) {
        // no round code says to just copy first float if signs not equal
        return concatFloat(float1_1, float1_2);
    }
    uint8_t exp1 = float1_1 & EXP_MASK;
    uint8_t exp2 = float2_1 & EXP_MASK;
    // uint8_t mant1 = float1_2;
    // uint8_t mant2 = float2_2;
    uint8_t exp3 = 0; //Dont initialize until later in asm
    if (exp1 > exp2)
    {

    }
    if (exp1 < exp2)
    {

    }
    if (exp1 == exp2)
    {
        //exp3 = exp1 reinitialize for asm friendly
        exp3 = float1_1 & EXP_MASK;
    }
    // Check for wraparound
    //A + B < A or A + B < B means unsigned overflow
    uint8_t overflowCheck = mant1 + mant2;
    uint8_t mant3 = mant1 + mant2;
    if (overflowCheck < mant1)
    {
        exp3++;
        mant3 = mant3 >> 1;
    }
    else if (overflowCheck < mant2)
    {
        exp3++;
        mant3 = mant3 >> 1;
    }

    // WHY CHECK TWICE AHHHHH IM GOING INSANE
    // if(mant3[11]) begin	           // overflow case
    // exp3++;					   // incr. exp & right-shift mant.
    // mant3  = mant3>>1;
    // end

    // if(mant3[11]) begin		       // round-induced overflow
    //     mant3 = mant3>>1;
    //     exp3++;
    // end
}

int main() {
    uint8_t fixed1 = 0b00000000;
    uint8_t fixed2 = 0b01000000;
    uint16_t out = int2float(fixed1, fixed2);
    // Print out as binary
    for (int i = 0; i < 16; i++) {
        printf("%d", (out >> (15 - i)) & 1);
    }
    return 0;
}