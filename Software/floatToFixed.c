#include <stdint.h>

uint16_t floatAdd(uint8_t op1, uint8_t op2)
{
    
}
//   Handle special cases for overflow or underflow:
//     If the exponent indicates overflow (exp[4:1] all 1s):
//       If sign bit is set (negative number):
//         return `0x8000` (largest negative)
//       Else:
//         return `0x7FFF` (largest positive)

//  Load the floating-point input:
//     sign = MSB of input
//     exp = Extract bits [14:10] from input
//     int_frac = Concatenate 31 zero bits, the OR of exp bits, and the 10-bit mantissa [9:0] of flt_in

//   Adjust integer fraction based on the exponent:
//     Shift int_frac left by the value of exp.

//   Extract fixed-point value:
//     output = Extract bits [39:25] from int_frac

//   Handle regular conversion:
//     If overflow is detected in int_frac:
//       Clamp int_frac to `0x7FFF`. //MIGHT NOT BE NEEDED LOOKS USELESS IN TB
    
//     If the sign bit is set (negative number):
//       return twos complement of output
//     Else:
//       return output

int main(int argc, char const *argv[])
{
    
    return 0;
}
