# CSE141L
Record a video describing and demonstrating your design. Submit the project files along with a README to help us navigate through your work. Tell us clearly what worked and what did not. Please carefully follow the detailed instructions at the end of this document. As incentive, if you choose this option, you do not need to write or submit a formal report.

# Folders
## Hardware
Contains all SystemVerilog files relevant for modelsim and synthesis. Ignore all testbenches. Include mach-code.txt for instructions and lookuptable1.txt + lookuptable2.txt contain LUT constants.

During synthesis, use TopLevel as the top level design.

ignore all testbenches besides program1-test.sv

The hardware is both compileable and synthesizable.

## program-templates/

### program-testers

Contains tester files for the C Pseudocode, emulating the system verilog testbenches(no round).

### Software

Program1 Psuedocode: int2float-combine.c

Program2 Psuedocode: floatToFixed.c

Program3 Pseudocode: floatAdd.c

fixedToFloat.asm assembly implementation of program 1


# Assembler
assembler.py used to assemble. Make sure to change PATH variable in the python file to change the input.

