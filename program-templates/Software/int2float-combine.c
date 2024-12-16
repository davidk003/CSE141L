#include <stdint.h>
#include <stdio.h>
#include <math.h>
#include <string.h>

// Converts a float to half-precision (IEEE 754 half) 
// Sign: 1 bit, Exponent: 5 bits, Fraction: 10 bits, Bias = 15
static uint16_t float_to_half(float f) {
    // Handle special cases
    if (f == 0.0f) {
        return 0;
    }
    if (isinf(f)) {
        // Infinity: sign bit + all exponent bits set + fraction = 0
        uint16_t sign = (signbit(f)) ? 0x8000 : 0x0000;
        return sign | 0x7C00; // 0x7C00 = Inf in half precision
    }
    if (isnan(f)) {
        // NaN: sign bit + all exponent bits set + nonzero fraction
        return 0xFE00; // Just a simple NaN pattern
    }

    // Normal conversion
    uint32_t bits;
    memcpy(&bits, &f, sizeof(bits));

    // Extract sign, exponent, mantissa from float32
    uint32_t sign = (bits >> 31) & 0x1;
    int32_t exponent = (int32_t)((bits >> 23) & 0xFF) - 127; // float32 bias = 127
    uint32_t mantissa = bits & 0x7FFFFF;

    // Convert exponent and mantissa to half
    // Half bias = 15
    int32_t half_exp = exponent + 15;
    if (half_exp <= 0) {
        // Subnormal or too small
        if (half_exp < -10) {
            // Value too small to represent as subnormal half => 0
            return (uint16_t)(sign << 15);
        }
        // Subnormal (exponent too small): shift mantissa accordingly
        mantissa |= 0x800000; // restore the hidden leading 1
        uint32_t shift = (uint32_t)(14 - half_exp);
        uint32_t half_mant = mantissa >> shift;
        // Round to nearest, tie to even: Just truncation for simplicity
        return (uint16_t)((sign << 15) | (half_mant >> 13));
    } else if (half_exp >= 31) {
        // Overflow => Infinity
        return (uint16_t)((sign << 15) | 0x7C00);
    } else {
        // Normal
        // Mantissa is 23 bits, need to get 10 bits for half
        uint16_t half_mant = (uint16_t)(mantissa >> 13);
        // Round to nearest, tie to even could be considered, but we assume truncation
        uint16_t half_exp_bits = (uint16_t)(half_exp << 10);
        return (uint16_t)((sign << 15) | half_exp_bits | half_mant);
    }
}

uint16_t concatFloat(uint8_t float1, uint8_t float2)
{
    return ((uint16_t)float1 << 8) | float2;
}

uint16_t int2float(uint8_t fixed1, uint8_t fixed2) {
    uint8_t ZERO_CONST = 0x00;
    uint8_t LEADING_ONE_CONST = 0x80;
    uint8_t MIN_EXP = 0xF8; // as per your original code for negative infinity

    // Trap cases
    if (fixed2 == ZERO_CONST) {
        if (fixed1 == LEADING_ONE_CONST) {
            // Negative infinity (custom as per your original code)
            return concatFloat(MIN_EXP, ZERO_CONST);
        }
        if (fixed1 == ZERO_CONST) {
            // Zero
            return 0;
        }
    }

    // Combine into signed 16-bit
    int16_t value = (int16_t)((fixed1 << 8) | fixed2);

    // Convert to float
    float f = (float)value;

    // Convert float to half
    uint16_t half = float_to_half(f);
    return half;
}
