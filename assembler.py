FILE_NAME = "something.txt"
OUTPUT_FILE_NAME = "machine_" + FILE_NAME

# Define the instruction set
INSTRUCTION_SET = {
    # Arithmetic Instructions R-Type(00)
    "AND": "00000",
    "OR": "00001",
    "XOR": "00010",
    "ADD": "00011",
    "SUB": "00100",
    "SLT": "00101",
    "SLTE": "00110",
    "SEQ": "00111",
    # Memory Instructions M-Type(01)
    "SB": "01000",
    "LB": "01001",
    "LL": "01010",
    # Branch Instructions B-Type(10)
}

REGISTERS = {
    "R0": "00",
    "R1": "01",
    "R2": "10",
    "R3": "11"
}

machine_code = []

with open(FILE_NAME, "r") as file:
    for i, line in enumerate(file):
        line = line.split(" ")
        print(line)
        if line[0] in INSTRUCTION_SET:
            if line[0] in ["AND", "OR", "XOR", "ADD", "SUB", "SLT", "SLTE", "SEQ"]:
                machine_code.append(INSTRUCTION_SET[line[0]] + REGISTERS[line[1]] + REGISTERS[line[2]] + REGISTERS[line[3]])
            elif line[0] in ["SB", "LB", "LL"]:
                machine_code.append(INSTRUCTION_SET[line[0]] + REGISTERS[line[1]] + REGISTERS[line[2]] + line[3])
            else:
                print(f"Invalid instruction on line {i+1}. {line}")
                quit()
