#include <stdint.h>

uint16_t concatFixed(uint8_t float1, uint8_t float2)
{
    return (float1 << 8) | float2;
}

// 1 bit sign, 11 bit mantissa, 5 bit exponent
uint16_t floatAdd(uint8_t op1_1, uint8_t op1_2, uint8_t op2_1, uint8_t op2_2)
{
    //Store in LUTs
    uint8_t SIGN_MASK = 0b10000000;
    uint8_t EXP_MASK = 0b01110000;
    uint8_t MANT_MASK = 0b00001111;

    //Will likely have to be stored in memory, not enough registers
    uint8_t exp1 = op1_1 & EXP_MASK;
    uint8_t exp2 = op2_1 & EXP_MASK;
    uint8_t res_sign = sign1; // No sub case so just assign sign

    uint8_t mantissa1 = op1 & MANT_MASK;
    uint8_t mantissa2 = op2 & MANT_MASK;

    uint8_t exp1 = op1 & EXP_MASK;
    uint8_t exp2 = op2 & EXP_MASK;
    uint8_t res_exp = exp1;
    uint8_t exp_diff = 0;
    if (exp1 < exp2)
    {
        res_exp = exp2;
        exp_diff = exp2 - exp1;
        mantissa1 = mantissa1 >> exp_diff;
    }
    else
    {
        exp_diff = exp1 - exp2;
        mantissa2 = mantissa2 >> exp_diff;
    }

    uint8_t res_mantissa = mantissa1 + mantissa2;
    if (res_mantissa > 15)
    {
        res_mantissa = res_mantissa >> 1;
        res_exp++;
    }

    

}



int main(int argc, char const *argv[])
{
    
    return 0;
}
