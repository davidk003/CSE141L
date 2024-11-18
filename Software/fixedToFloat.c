
#include <stdint.h>
#include <stdio.h>

// Converts 2 halves of 8 bit fixed point number to a 16 bit float
uint16_t fixedToFloat(uint8_t fixed1, uint8_t fixed2) {
    //Case for minimum possible and zero float.
    //Load in 0b00000000 from LUT beforehand

    if(fixed2 == 0b00000000) {
        if(fixed1 == 0b10000000)
        {
            //Return from LUT
            //Minimum float
            return 0b1111100000000000;
        }
        if(fixed1 == 0b00000000)
        {
            //Return from LUT
            //Zero float
            return 0b0000000000000000;
        }
    }

    // Get sign bit
    //Load in 0b10000000 from LUT beforehand
    uint8_t sign = fixed1 & 0b10000000;
    if (sign == 0b10000000) {
        fixed1 = ~fixed1 + 1; //Abs value (2s comp)
        fixed2 = ~fixed2 + 1;
    }

    int exp = 0;
    //Start scanning first byte for leading 1
    int i = 1; //Start at 0 instead of 1 for the sign bit
    while(i < 8)
    {
        if((fixed1 << i) & 0b10000000 == 0b10000000)
        {
            exp = 30-i;
            break;
        }
        i++;
    }
    if(exp == 0)
    {
        int i = 0; //Start at 0 for 2nd byte (no sign bit)
        while(i < 8)
        {
            if((fixed1 << i) & 0b10000000 == 0b10000000)
            {
                exp = 23-i;
                break;
            }
            i++;
        }
    }
    //Skip ahead past leading 1
    int skipped = (30-exp); //Not including sign bit
    // Now gets bits for mantissa
    // Need to cut off and round 10 bits for mantissa
    // N = 15 - exp = bits left to copy mantissa
    // create an N bit length bitmask of 1s to extract.
    // If N > 10, need to round.
    uint8_t mantissa1 = 0b00000000;
    uint8_t mantissa2 = 0b00000000;
    if(skipped < 7)
    {
        fixed1 = fixed1 << skipped;
    }
    else
    {
        fixed2 = fixed2 << skipped;
    }
    if(skipped < 5)
    {
        if(7-skipped > 0)
        {
            fixed2 = fixed2 >> (7-skipped);
        }
        else
        {
            fixed2 = fixed2 << (skipped-7);
        }
        //Need to round
        //Psuedocode from here:
        //Grab bits from first half
        // Bitmask and copy to mantissa1
        //grab bits from second half
        //Check one bit past grabbed on second half
        //If that bit is 1, add 1 to grabbed bits (rounding)
        // Bitmask and copy to mantissa2.
    }
    else        //No need to cut/round
    {
        //bits left to copy  = 15 - skipped
        int j = 0;
        int firstBits = (15-skipped)-8;
        if(firstBits > 0) //Copy from first 8 bits
        {
            int8_t oneMask = 0b10000000; //Make signed to trigger Arithmetic shift
            oneMask = oneMask >> (7-firstBits);
            oneMask = ~oneMask; //Invert to make mask of 1s for firstBits starting from right(avoids loop)
            mantissa1 = fixed1 & oneMask;
            mantissa2 = fixed2 & 0b11111111;
        }

    }
    //Ignore this part for the assembly
    uint16_t returnBitmask = 0b0000000000000000;
    returnBitmask = returnBitmask | (sign << 15);
    returnBitmask = returnBitmask | (exp << 10);

    //Need to shift mantissa values in reality.
    returnBitmask = returnBitmask | (mantissa1);
    returnBitmask = returnBitmask | (mantissa2);
    return returnBitmask;
}

int main() {
    uint8_t fixed1 = 0b00000000;
    uint8_t fixed2 = 0b01000000;
    uint16_t out = fixedToFloat(fixed1, fixed2);
    // Print out as binary
    for (int i = 0; i < 16; i++) {
        printf("%d", (out >> (15 - i)) & 1);
    }
    return 0;
}