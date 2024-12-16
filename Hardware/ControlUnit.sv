module ControlUnit(
    input logic [8:0] bits,
    input logic equal,
    input logic lessThan,
    output logic branchEnable,
    output logic [4:0] branchLUTIndex,
    output logic regToReg,
    output logic memToReg,
    output logic regToMem,
    output logic [2:0] Aluop,
    output logic shiftEnable,
    output logic shiftDirection,
    output logic shiftImmediateEnable,
    output logic [7:0] shiftImmediate,
    output logic [7:0] LUTIndex,
    output logic LUTtoReg,
    output logic LUTwrite,
    output logic[1:0] LUTRegtoRegIndex,
    output logic [7:0] immediateToLUTReg,
    output logic immediateLUTEnable,
    output logic [1:0] r_addr1,
    output logic [1:0] r_addr2
);
    typedef enum logic [1:0] {R=2'b00, M=2'b01, B=2'b10, S=2'b11 } instruction_type;
    instruction_type instruction;

    always begin
        shiftImmediateEnable = 1'b0;
        shiftEnable = 1'b0;
        shiftImmediate = 8'b0;
        shiftDirection = 1'b0;

        branchEnable = 1'b0;
        branchLUTIndex = 4'b0000;
        LUTIndex = 4'b0000;
        LUTRegtoRegIndex = 2'b00;
        Aluop = 3'b000;
        LUTwrite = 1'b0;

        regToMem = 1'b0;
        regToReg = 1'b0;
        memToReg = 1'b0;
        LUTtoReg = 1'b0;

        immediateToLUTReg = 8'b0;
        immediateLUTEnable = 1'b0;

        r_addr1 = 2'b00;
        r_addr2 = 2'b00;

        if(bits[8:7] == R) begin
            Aluop = bits[6:4];
            r_addr1 = bits[3:2];
            r_addr2 = bits[1:0];
            case(bits[3:0])
                4'b0000: begin //AND
                    regToReg = 1'b1;
                end
                4'b0001: begin //OR
                    regToReg = 1'b1;
                end
                4'b0010: begin //XOR
                    regToReg = 1'b1;
                end
                4'b0011: begin //ADD
                    regToReg = 1'b1;
                end
                4'b0100: begin //SUB
                    regToReg = 1'b1;
                end
                4'b0101: begin //SLT //NOTE THE COMPARATORS DONT WRITE OR READ
                    regToReg = 1'b0;
                end
                4'b0110: begin //SLTE
                    regToReg = 1'b0;
                end
                4'b0111: begin //EQ
                    regToReg = 1'b0;
                end
                default: begin
                    $display("Invalid Register Instruction");
                end
            endcase
        end
        else if(bits[8:7] == M) begin
            case(bits[6:4])
                3'b000: begin //Store byte stores from register to memory
                    r_addr1 = bits[3:2];
                    r_addr2 = bits[1:0];
                    regToMem = 1'b1;
                end
                3'b001: begin //Load byte loads from memory to register
                    r_addr1 = bits[3:2];
                    r_addr2 = bits[1:0];
                    memToReg = 1'b1;
                end
                3'b010: begin //Load LUT (since LUTIndex is 8 bits, treat this as the lower 4 bits)
                    LUTwrite = 1'b1;
                    LUTIndex = {4'b0000, bits[3:0]};
                end
                3'b011: begin //Load LUT 2 (since LUTIndex is 8 bits, treat this as the upper 4 bits)
                    LUTwrite = 1'b1;
                    LUTIndex = {bits[3:0], 4'b0000};
                end
                3'b100: begin //Load immediate lower into special LUT register
                    LUTwrite = 1'b1;
                    immediateLUTEnable = 1'b1;
                    immediateToLUTReg = {4'b0000, bits[3:0]};
                end
                3'b101: begin //Load immediate upper into special LUT register
                    LUTwrite = 1'b1;
                    immediateLUTEnable = 1'b1;
                    immediateToLUTReg = {bits[3:0], 4'b0000};
                end
                3'b110: begin //Load LUT Memory
                    LUTtoReg = 1'b1;
                    LUTRegtoRegIndex = bits[3:2]; //bits[3:2] has register to load to
                end
                default: begin
                    $display("Invalid Memory Instruction");
                end
            endcase
        end
        else if(bits[8:7] == B) begin
            case(bits[6:5])
                2'b00: begin //BEQ
                    if(equal) begin
                        branchEnable = 1'b1;
                        branchLUTIndex = bits[4:0];
                    end
                end
                2'b01: begin //BLT
                    if(lessThan) begin
                        branchEnable = 1'b1;
                        branchLUTIndex = bits[4:0];
                    end
                end
                2'b10: begin //BLTE
                    if(lessThan || equal) begin
                        branchEnable = 1'b1;
                        branchLUTIndex = bits[4:0];
                    end
                end
                2'b11: begin //BUN
                    branchEnable = 1'b1;
                    branchLUTIndex = bits[4:0];
                end
                default: begin
                    branchEnable = 1'b0;
                    $display("Invalid Branch Instruction");
                end
            endcase
        end
        else if(bits[8:7] == S) begin
            r_addr1 = bits[3:2];
            r_addr2 = bits[1:0];
            case(bits[6:5])
                2'b00: begin //LSL
                    shiftEnable = 1'b1;
                    shiftDirection = 1'b0;
                    regToReg = 1'b1;
                end
                2'b01: begin //LSR
                    shiftEnable = 1'b1;
                    shiftDirection = 1'b1;
                    regToReg = 1'b1;
                end
                2'b10: begin //LSI
                    if(equal) begin
                        shiftEnable = 1'b1;
                        shiftDirection = 1'b0;
                        shiftImmediateEnable = 1'b1;
                        shiftImmediate = {3'b000, bits[4:0]};
                        regToReg = 1'b1;
                    end
                end
                2'b11: begin //RSI
                    if(lessThan) begin
                        shiftEnable = 1'b1;
                        shiftDirection = 1'b1;
                        shiftImmediateEnable = 1'b1;
                        shiftImmediate = {3'b000, bits[4:0]};
                        regToReg = 1'b1;
                    end
                end
                default: begin
                    branchEnable = 1'b0;
                    $display("Invalid Shift Instruction");
                end
            endcase 
        end
    end
endmodule: ControlUnit