#include <stdio.h>
#include <stdint.h>

// Dummy test function
uint16_t testFunction(uint8_t input1, uint8_t input2) {
    // Placeholder function with no logic
    return 0;
}

// Function to print binary representation of an 8-bit number
void printBinary(uint8_t num) {
    for (int i = 7; i >= 0; i--) {
        printf("%c", (num & (1 << i)) ? '1' : '0');
    }
}

int main() {
    // Test cases based on the file
    uint16_t trueOutputs[] = {
        0b0000000000000000, 0b0011110000000000, 0b0100000000000000, 0b0100001000000000,
        0b0100101000000000, 0b0101001000000000, 0b0111010011110000, 0b1111011100010000,
        0b0111011111110000, 0b0111001000010000, 0b1111011110000000, 0b1111011111100000,
        0b0101010101010000, 0b0110010101010000, 0b0111010000001000, 0b0110000001011000,
        0b1111011111111110, 0b1101010000000000
    };

    int numTestCases = 19;

    // Declare arrays for inputs
    uint8_t inputs1[numTestCases]; // First 8 bits
    uint8_t inputs2[numTestCases]; // Last 8 bits

    // Populate inputs1 with the first 8 bits and inputs2 with the last 8 bits
    for (int i = 0; i < numTestCases; i++) {
        inputs1[i] = (trueOutputs[i] >> 8) & 0xFF; // Extract the first 8 bits (higher byte)
        inputs2[i] = trueOutputs[i] & 0xFF;        // Extract the last 8 bits (lower byte)
    }

    // Print inputs1 and inputs2 arrays
    printf("Inputs1 (First 8 bits):\n");
    for (int i = 0; i < numTestCases; i++) {
        printf("Test case %2d: ", i + 1);
        printBinary(inputs1[i]);
        printf("\n");
    }

    printf("\nInputs2 (Last 8 bits):\n");
    for (int i = 0; i < numTestCases; i++) {
        printf("Test case %2d: ", i + 1);
        printBinary(inputs2[i]);
        printf("\n");
    }


    // Iterate through all test cases
    for (int i = 0; i < numTestCases; i++) {
        uint16_t output = testFunction(inputs1[i], inputs2[i]);
        if (output != trueOutputs[i]) {
            printf("Test case %d FAILED: input1 = 0b%08b, input2 = 0b%08b, trueOutput = 0b%016b, got = 0b%016b\n",
                   i + 1, inputs1[i], inputs2[i], trueOutputs[i], output);
        } else {
            printf("Test case %d PASSED: input1 = 0b%08b, input2 = 0b%08b, output = 0b%016b\n",
                   i + 1, inputs1[i], inputs2[i], output);
        }
    }

    return 0;
}
