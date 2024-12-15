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
    uint16_t testCases[] = {
        0b0000000000000000, // Test case 1
        0b0011110000000000, // Test case 2
        0b0100000000000000, // Test case 3
        0b0100001000000000, // Test case 4
        0b0100000001000000, // Test case 5
        0b0100000001000000, // Test case 6
        0b0100101100000000, // Test case 7
        0b0100101110000000, // Test case 8
        0b0110001100000000, // Test case 9
        0b0110011100000000, // Test case 10
        0b0111011110000000, // Test case 11
        0b0111101110000000, // Test case 12
        0b1000000000000000, // Test case 13
        0b1011110000000000, // Test case 14
        0b1011110100000000, // Test case 15
        0b1100000000000000, // Test case 16
        0b1100001000000000, // Test case 17
        0b1100000001000000, // Test case 18
        0b1100000001000000, // Test case 19
        0b1100101100000000, // Test case 20
        0b1100101110000000, // Test case 21
        0b1110001100000000, // Test case 22
        0b1110011100000000, // Test case 23
        0b1111011110000000, // Test case 24
        0b1111101110000000  // Test case 25
    };


    uint16_t trueOutputs[] = {
        0b0000000000000000, // Test case 1
        0b0000000000000001, // Test case 2
        0b0000000000000010, // Test case 3
        0b0000000000000011, // Test case 4
        0b0000000000000010, // Test case 5
        0b0000000000000010, // Test case 6
        0b0000000000001110, // Test case 7
        0b0000000000001111, // Test case 8
        0b0000001110000000, // Test case 9
        0b0000011100000000, // Test case 10
        0b0111100000000000, // Test case 11
        0b0111111111111111, // Test case 12
        0b0000000000000000, // Test case 13
        0b1111111111111111, // Test case 14
        0b1111111111111111, // Test case 15
        0b1111111111111110, // Test case 16
        0b1111111111111101, // Test case 17
        0b1111111111111110, // Test case 18
        0b1111111111111110, // Test case 19
        0b1111111111110010, // Test case 20
        0b1111111111110001, // Test case 21
        0b1111110010000000, // Test case 22
        0b1111100100000000, // Test case 23
        0b1000100000000000, // Test case 24
        0b1000000000000000  // Test case 25
    };

    int numTestCases = 25;

    // Declare arrays for inputs
    uint8_t inputs1[numTestCases]; // First 8 bits
    uint8_t inputs2[numTestCases]; // Last 8 bits

    // Populate inputs1 with the first 8 bits and inputs2 with the last 8 bits
    for (int i = 0; i < numTestCases; i++) {
        inputs1[i] = (testCases[i] >> 8) & 0xFF; // Extract the first 8 bits (higher byte)
        inputs2[i] = testCases[i] & 0xFF;        // Extract the last 8 bits (lower byte)
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


    // Iterate over the test cases
    for (int i = 0; i < numTestCases; i++) {
        uint16_t output = testFunction(inputs1[i], inputs2[i]); // Call the test function

        // Compare output with trueOutputs
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
