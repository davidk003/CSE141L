FILE_NAME = "./Software/fixedToFloat.asm"
OUTPUT_FILE_NAME = "machine_code.txt"

# Define the instruction set
INSTRUCTION_SET = {
    # Arithmetic Instructions R-Type(00)
    # 2 bit type (00) 3 bits opcode (110), 2 bit operand register(XX), 2 bit operand register(XX)
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
    "LIL": "01011",
    "LIU": "01100",
    # Branch Instructions B-Type(10)
    "BEQ": "1000",
    "BLT": "1001",
    "BLTE": "1010",
    "BUN": "1011",
    # Shift Instructions S-Type(11)
    "LSL": "1100",
    "LSR": "1101",
    "BF": "1110",
    "BB": "1111",
}

REGISTERS = {
    "R1": "00",
    "R2": "01",
    "R3": "10",
    "R4": "11"
}

def convert_R_type(lineSplit):
    if lineSplit[0] in ["AND", "OR", "XOR", "ADD", "SUB", "SLT", "SLTE", "SEQ"]:
        if len(lineSplit) != 3:
            raise Exception(f"Invalid number of arguments on line {i+1}. {lineSplit}")
        if lineSplit[1] not in REGISTERS or lineSplit[2] not in REGISTERS:
            raise Exception(f"Invalid register on line {i+1}. {lineSplit}")
        machine_code_line = f"{INSTRUCTION_SET[lineSplit[0]]}_{REGISTERS[lineSplit[1]]}_{REGISTERS[lineSplit[2]]}"
        return machine_code_line
    return None

def convert_M_type(lineSplit):
    if lineSplit[0] in ["SB", "LB", "LL", "LIL", "LIU"]:
        if lineSplit[0] in ["LL", "LIL", "LIU"]:
            if len(lineSplit) != 2:
                raise Exception(f"Invalid number of arguments on line {i+1}. {lineSplit}")
            if "#" not in lineSplit[1]:
                raise Exception(f"Invalid immedate on line {i+1}. {lineSplit}")
            lineSplit[1] = lineSplit[1].strip('#')
            num = format(int(lineSplit[1]), '05b')
            machine_code_line = f"{INSTRUCTION_SET[lineSplit[0]]}_{str(num)}"
        else:
            if len(lineSplit) != 3:
                raise Exception(f"Invalid number of arguments on line {i+1}. {lineSplit}")
            if lineSplit[1] not in REGISTERS or lineSplit[2] not in REGISTERS:
                raise Exception(f"Invalid register on line {i+1}. {lineSplit}")
            machine_code_line = f"{INSTRUCTION_SET[lineSplit[0]]}_{REGISTERS[lineSplit[1]]}_{REGISTERS[lineSplit[2]]}"
        return machine_code_line
    return None

def convert_B_type(lineSplit):
    if lineSplit[0] in ["BEQ", "BLT", "BLTE", "BUN"]:
        if lineSplit[1][0] == "." and lineSplit[1] in labels:
                current = i+1
                target = labels[lineSplit[1]][0]
                jump = target - current
                num = format(~jump, '05b')
                machine_code_line = f"{INSTRUCTION_SET[lineSplit[0]]}_{str(num)}"
                return machine_code_line
        if lineSplit[0] == "BUN":
            if len(lineSplit) != 2:
                raise Exception(f"Invalid number of arguments on line {i+1}. {lineSplit}")
            if "#" not in lineSplit[1]:
                raise Exception(f"Invalid immedate on line {i+1}. {lineSplit}")
            lineSplit[1] = lineSplit[1].strip('#')
            num = format(int(lineSplit[1]), '05b')
            machine_code_line = f"{INSTRUCTION_SET[lineSplit[0]]}_{str(num)}"
        else:
            if len(lineSplit) != 3:
                raise Exception(f"Invalid number of arguments on line {i+1}. {lineSplit}")
            if lineSplit[1] not in REGISTERS or lineSplit[2] not in REGISTERS:
                raise Exception(f"Invalid register on line {i+1}. {lineSplit}")
            machine_code_line = f"{INSTRUCTION_SET[lineSplit[0]]}_{REGISTERS[lineSplit[1]]}_{REGISTERS[lineSplit[2]]}"
        return machine_code_line
    return None

def convert_S_type(lineSplit):
    if lineSplit[0] in ["LSL", "LSR", "BF", "BB"]:
        if lineSplit[0] in ["BF", "BB"]:
            if len(lineSplit) != 2:
                raise Exception(f"Invalid number of arguments on line {i+1}. {lineSplit}")
            if "#" not in lineSplit[1]:
                raise Exception(f"Invalid immedate on line {i+1}. {lineSplit}")
            lineSplit[1] = lineSplit[1].strip('#')
            num = format(int(lineSplit[1]), '05b')
            machine_code_line = f"{INSTRUCTION_SET[lineSplit[0]]}_{str(num)}"
        else:
            if len(lineSplit) != 3:
                raise Exception(f"Invalid number of arguments on line {i+1}. {lineSplit}")
            if lineSplit[1] not in REGISTERS:
                raise Exception(f"Invalid register on line {i+1}. {lineSplit}")
            if lineSplit[2] not in REGISTERS:
                raise Exception(f"Invalid register on line {i+1}. {lineSplit}")
            machine_code_line = f"{INSTRUCTION_SET[lineSplit[0]]}_{REGISTERS[lineSplit[1]]}_{REGISTERS[lineSplit[2]]}"
        return machine_code_line
    return None

machine_code = []
asm_code = []
labels = {} # Key: label, Value: (machine address, asm line number)
with open(FILE_NAME, "r") as file:
    for i, line in enumerate(file):
        line = line.split("//")[0]
        line = line.replace("\n", " ")
        line = line.replace("\t", " ")
        lineSplit = line.split(" ")

        while lineSplit.count("") > 0:
            machine_code_line = ""
            lineSplit.remove("")
        if len(line)==0:
            continue
        if len(lineSplit) == 1 and lineSplit[0][0] == ".":
            if lineSplit[0] in labels:
                print(f"Label already defined on line {labels[lineSplit[0]][0]}. {lineSplit}")
                break
            labels[lineSplit[0]] = ((i+1)- len(labels), i+1)
        else:
                asm_code.append(line)
print(labels)



with open(FILE_NAME, "r") as file:
    for i, line in enumerate(asm_code):
        line = line.replace("\n", " ")
        line = line.replace("\t", " ")
        lineSplit = line.split(" ")

        while lineSplit.count("") > 0:
            machine_code_line = ""
            lineSplit.remove("")
        print(lineSplit)
        if lineSplit[0] == "RETURN":
            machine_code_line = lineSplit[0]
            machine_code.append((i+1, machine_code_line, line))
            continue
        elif lineSplit[0] not in INSTRUCTION_SET:
            print(f"Instruction parse error on line {i+1}. {lineSplit}")
            break
        try:
            machine_code_line = convert_R_type(lineSplit)
            if machine_code_line:
                machine_code.append((i+1, machine_code_line, line))
                continue
            machine_code_line = convert_M_type(lineSplit)
            if machine_code_line:
                machine_code.append((i+1, machine_code_line, line))
                continue
            machine_code_line = convert_B_type(lineSplit)
            if machine_code_line:
                machine_code.append((i+1, machine_code_line, line))
                continue
            machine_code_line = convert_S_type(lineSplit)
            if machine_code_line:
                machine_code.append((i+1, machine_code_line, line))
                continue
            if lineSplit[0][0] == ".":
                print("Label: " + lineSplit[0])
                continue
            print(f"Invalid instruction on line {i+1}. {lineSplit}")
            machine_code.append((i+1, machine_code_line, line))
        except Exception as e:
            # print(f"Instruction parse error on line {i+1}. {lineSplit}")
            print(e)
            break

for line in machine_code:
    print(line)

with open(OUTPUT_FILE_NAME, "w") as file:
    for line in machine_code:
        file.write(line[1] + "\n")
    file.write("RETURN")
