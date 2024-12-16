#include <stdio.h>
#include <stdint.h>

//gcc -o program1 programtesters/program1.c Software/int2float-combine.c

uint16_t int2float(uint8_t input1, uint8_t input2);

// Dummy test function
uint16_t testFunction(uint8_t input1, uint8_t input2) {
    // Placeholder function with no logic
    return int2float(input1, input2);
}

// Function to print binary representation of an 8-bit number
void printBinary(uint8_t num) {
    for (int i = 7; i >= 0; i--) {  // Iterate over all 8 bits
        printf("%d", (num >> i) & 1);  // Shift right and mask to get each bit
    }
}

void printBinary16(uint16_t num) {
    for (int i = 15; i >= 0; i--) {  // Iterate over all 16 bits
        printf("%d", (num >> i) & 1);  // Shift right and mask to get each bit
    }
}

int main() {
    // Test cases based on the file
    uint16_t testCases[] = {
        0b0000000000000000, // Test case 1
        0b0000000000000001, // Test case 2
        0b0000000000000010, // Test case 3
        0b0000000000000011, // Test case 4
        0b0000000000001100, // Test case 5
        0b0000000000110000, // Test case 6
        0b0100111100000000, // Test case 7
        0b1000111100000000, // Test case 8
        0b0111111100000000, // Test case 9
        0b0011000010000000, // Test case 10
        0b1000100000000000, // Test case 11
        0b1000001000000000, // Test case 12
        0b0000000001010101, // Test case 13
        0b0000010101010000, // Test case 14
        0b0100000010000000, // Test case 15
        0b0000001000101100, // Test case 16
        0b1000000000100000, // Test case 17
        0b0111111111110000, // Test case 18
        0b1111111111000000, // Test case 19
        0b0000000011111111, // Test case 20
        0b1111000000001111, // Test case 21
        0b0000111100001111, // Test case 22
        0b1010101010101010, // Test case 23
        0b1100110011001100, // Test case 24
        0b1111111111111111  // Test case 25
    };


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
        inputs1[i] = (testCases[i] >> 8) & 0xFF; // Extract the first 8 bits (higher byte)
        inputs2[i] = testCases[i] & 0xFF;        // Extract the last 8 bits (lower byte)
    }

    // Print inputs1 and inputs2 arrays
    printf("Inputs1 (First 8 bits):\n");
    for (int i = 0; i < numTestCases; i++) {
        printf("Test case %2d: ", i);
        printBinary(inputs1[i]);
        printf("\n");
    }

    int i;
    printf("\nInputs2 (Last 8 bits):\n");
    for (i = 0; i < numTestCases; i++) {
        printf("Test case %2d: ", i);
        printBinary(inputs2[i]);
        printf("\n");
    }


    // Iterate through all test cases
    for (int i = 0; i < numTestCases; i++) {
    uint16_t output = testFunction(inputs1[i], inputs2[i]);  // Declare and initialize `output`

    printf("Test case %d %s: input1 = 0b", i, (output == trueOutputs[i]) ? "PASSED" : "FAILED");
    printBinary(inputs1[i]);  // Print input1 as binary
    printf(", input2 = 0b");
    printBinary(inputs2[i]);  // Print input2 as binary

    if (output != trueOutputs[i]) {
        printf(", trueOutput = 0b");
        printBinary16(trueOutputs[i]);  // Print true output
        printf(", got = 0b");
        printBinary16(output);  // Print actual output
    } else {
        printf(", output = 0b");
        printBinary16(output);  // Print actual output
    }

    printf("\n");  // New line after each test case
}

    return 0;
}