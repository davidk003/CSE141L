
#include <stdint.h>
#include <stdio.h>

uint16_t concatFloat(uint8_t float1, uint8_t float2)
{
    return (float1 << 8) | float2;
}
// Converts 2 halves of 8 bit fixed point number to a 16 bit float
uint16_t int2float(uint8_t fixed1, uint8_t fixed2) {
    uint8_t float1, float2;
    // Check if last half is zeros, then check the next half
    uint8_t ZERO_CONST = 0b00000000;
    uint8_t LEADING_ONE_CONST = 0b10000000;
    uint8_t MIN_EXP = 0b11111000;
    // TRAP CASES
    if(fixed2 == 0b00000000) {
        if(fixed1 == LEADING_ONE_CONST) //Minimum float case
        {
            float1 = MIN_EXP;
            float2 = ZERO_CONST;
            //Ignore return float 16 bit conversion for asm conversion
            return concatFloat(float1, float2);
        }
        if(fixed1 == ZERO_CONST) //Zero float case
        {
            float1 = ZERO_CONST;
            float2 = ZERO_CONST;
            //Ignore return float 16 bit conversion for asm conversion
            return concatFloat(float1, float2);
        }
    }
    //Check sign bit, if 1 get absolute value of fixed point
    uint8_t sign = fixed1 & LEADING_ONE_CONST;
    if (sign == LEADING_ONE_CONST) {
        fixed1 = ~fixed1 + 1; //Abs value (2s comp)
        fixed2 = ~fixed2 + 1;
    }
    uint8_t expMask = 0b01111111; //This might not be it
    // Check leftmost bit after sign (exp)
    //Normalization
    uint8_t exp = 0;
    uint8_t i = 1;
    while()
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