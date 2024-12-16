
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
    while(i < 7) {
        uint8_t temp = float1 & LEADING_ONE_CONST;
        if (temp  == LEADING_ONE_CONST) {
            goto end;
        }
        else{
            float1 = float1 << 1;
            // exp = exp - 1;
            i = i + 1;
        }
    }
    

    //Check second byte for leading exp 1 (8 bits)
    // i = ZERO_CONST;
    while(i < 14) {
        uint8_t temp = fixed1 & LEADING_ONE_CONST;
        if (temp == LEADING_ONE_CONST) {
            goto end;
        }
        else{
            float1 = float1 << 1;
            // exp--;
            i++;
        }
    }
    printf("Error: No leading 1 found in fixed point number. This should never happen\n");

    end:
        uint8_t sign = fixed1 & LEADING_ONE_CONST;
        //Exp is 5 bits, so shift 2 into place Ex: _11101_____ -> 0001_1101 -> _11101_____
        //Then OR with sign and mantissa.
        //bit 1 = sign, bit 2-6 = exp, bit 7-16 = mantissa
        //Note that upper two bits of mantissa have to be moved to upper half
        uint8_t mantissa = 0b00000000; //Initialize mantissa
        if(i < 7)
        {
            
        }

        uint8_t exp = BIAS_INITIAL_EXP - i;
        exp = exp << 2;
        
        

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