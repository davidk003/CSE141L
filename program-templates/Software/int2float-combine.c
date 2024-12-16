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
    uint8_t ALL_ONE = 0b11111111;
    uint8_t FIRST_EXP_BIT = 0b01000000; //This might not be it
    uint8_t BIAS_INITIAL_EXP = 29;
    uint8_t UPPER_TWO = 0b11000000;
    uint8_t LOWER_SIX = 0b00111111;

    // TRAP CASES
    if(fixed2 == ZERO_CONST) {//If first half is zero, check second half
        if(fixed1 == LEADING_ONE_CONST) //Minimum float case (negative inf)
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
        // fixed1 = ~fixed1 + 1; //Abs value (2s comp)
        // fixed2 = ~fixed2 + 1;

        //Below is same is abs value
        float1 = fixed1 ^ ALL_ONE;
        float2 = fixed2 ^ ALL_ONE;
        float2 = float2 + 1;
        if (float2 == ZERO_CONST) //If overflow, add 1 to upper byte
        {
            float1 = float1 + 1;
        }
    }
    // Check leftmost bit after sign (exp)
    //X_XXXXXXX
    //X_1XXXXXX this break on this case
    //X_0XXXXXX shift left and decrement exp
    //Normalization
    uint8_t exp = BIAS_INITIAL_EXP; // Biased exponent start 29 (14+15)
    uint8_t i = ZERO_CONST;
    //Check first byte for leading exp 1 first (7 bits)
    float1 = float1 << 1; // Premove once for the sign bit
    uint8_t temp = float2 & LEADING_ONE_CONST;
    float2 = float2 << 1;
    float1 = float1 | temp;
    //Premove both parts to go without sign.
    i = 0;
    label1:
        if (i < 15)
        {
            temp = float1 & LEADING_ONE_CONST;
            if (temp == LEADING_ONE_CONST)
            {
                float1 = float1 << 1;
                temp = float2 & LEADING_ONE_CONST;
                float2 = float2 << 1;
                float1 = float1 | temp;
                goto end;
            }
            //Shift float1 and float2 together
            float1 = float1 << 1;
            temp = float2 & LEADING_ONE_CONST;
            float2 = float2 << 1;
            float1 = float1 | temp;
            i++;
            goto label1;
        }
    printf("Error: No leading 1 found in fixed point number. This should never happen\n");

    end:
        //Exp is 5 bits, so shift left 2 into place Ex: _11101_____ -> 0001_1101 -> _11101_____
        //Then OR with sign and mantissa.
        //bit 1 = sign, bit 2-6 = exp, bit 7-16 = mantissa
        //Note that upper two bits of mantissa have to be moved to upper half
        //Ex mantissa: 01010100_00 -> 01010100_00000000 -> 01_01010000
        // From original, float1 = 01010100, float2 = 00(extended)000000
        //to extract upper 2 bits, bitmask float1 with 0b11000000
        //to extract lower 8 bits, bitmask float1 with 0b00111111, shift by 2, then OR with bitmask of float2 with 0b11000000 shifted by 6.
        
        //Get lower 8 first
        temp = float1 & 0b00111111;
        temp = temp << 2;
        float2 = float2 & 0b11000000;
        float2 = float2 >> 6;
        float2 = float2 | temp;

        temp = float1 & 0b11000000;
        float1 = float1 >> 6; //Done with mantissa

        exp = BIAS_INITIAL_EXP - i;
        temp = exp << 2;
        float1 = float1 | temp; //Added exp to float1
        
        temp = fixed1 & 0b10000000;
        float1 = float1 | temp; //Added sign bit to float1
        return concatFloat(float1, float2);

}