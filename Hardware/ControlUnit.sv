module ControlUnit(
    input logic [8:0] bits,
    input logic equal,
    input logic lessThan,
    output logic branchEnable,
    output logic memWrite,
    output logic memRead,
    output logic regWrite,
    output logic LUTen,
    output logic [4:0] LUTIndex,
    output logic [2:0] Aluop,
    output logic shiftEnable,
    output logic shiftDirection,
    output logic [2:0] shiftAmount
    // output logic immediate
);
    typedef enum logic [1:0] {R=2'b00, M=2'b01, B=2'b10, S=2'b11 } instruction_type;
    instruction_type instruction;

    always begin
        shiftEnable = 1'b0;
        regWrite = 1'b0;
        memWrite = 1'b0;
        memRead = 1'b0;
        branchEnable = 1'b0;
        LUTIndex = 4'b0000;
        Aluop = 3'b000;
        shiftDirection = 1'b0;
        shiftAmount = 3'b000;
        LUTen = 1'b0;
        // immediate = 1'b0;
        

        if(bits[8:7] == R) begin
            Aluop = bits[6:4];
            case(bits[3:0])
                4'b0000: begin //AND
                    regWrite = 1'b1;
                end
                4'b0001: begin //OR
                    regWrite = 1'b1;
                end
                4'b0010: begin //XOR
                    regWrite = 1'b1;
                end
                4'b0011: begin //ADD
                    regWrite = 1'b1;
                end
                4'b0100: begin //SUB
                    regWrite = 1'b1;
                end
                4'b0101: begin //SLT
                    regWrite = 1'b0;
                end
                4'b0110: begin //SLTE
                    regWrite = 1'b0;
                end
                4'b0111: begin //EQ
                    regWrite = 1'b0;
                end
                default: begin
                    regWrite = 1'b0;
                    memRead = 1'b0;
                    memWrite = 1'b0;
                end
        endcase
        end
        else if(bits[8:7] == M) begin
            case(bits[6:4])
                3'b000: begin //Store byte
                    memWrite = 1'b1;
                end
                3'b001: begin //Load byte
                    regWrite = 1'b1;
                end
                3'b010: begin //Load LUT
                    memRead = 1'b1;
                    LUTen = 1'b1;
                    LUTIndex = bits[3:0];
                end
                3'b011: begin //Load LUT 2
                    memRead = 1'b1;
                    LUTen = 1'b1;
                    LUTIndex = bits[3:0];
                end
                3'b100: begin //Load immediate lower
                    regWrite = 1'b1;
                    LUTIndex = bits[3:0];
                end
                3'b101: begin //Load immediate upper
                    regWrite = 1'b1;
                    LUTIndex = bits[3:0];
                end
                3'b110: begin //Load LUT Memory
                    regWrite = 1'b1;
                end
                default: begin
                    memWrite = 1'b0;
                    regWrite = 1'b0;
                end
            endcase
        end
        else if(bits[8:7] == B) begin
            case(bits[6:5])
                2'b00: begin //BEQ
                    if(equal) branchEnable = 1'b1;
                end
                2'b01: begin //BLT
                    if(lessThan) branchEnable = 1'b1;
                end
                2'b10: begin //BLTE
                    if(lessThan || equal) branchEnable = 1'b1;
                end
                2'b11: begin //BUN
                    branchEnable = 1'b1;
                end
                default: begin
                    branchEnable = 1'b0;
                end
            endcase
        end
        else if(bits[8:7] == S) begin  
            case(bits[6:5])
                2'b00: begin //LSL
                    shiftEnable = 1'b1;
                    shiftDirection = 1'b0;
                    shiftAmount = bits[4:0]; // 5-bit
                    regWrite = 1'b1;
                end
                2'b01: begin //LSR
                    shiftEnable = 1'b1;
                    shiftDirection = 1'b1;
                    shiftAmount = bits[4:0];
                    regWrite = 1'b1;
                end
                2'b10: begin //LSI
                    if(equal) begin
                        shiftEnable = 1'b1;
                        shiftDirection = 1'b0;
                        shiftAmount = bits[4:0]; //5-bit immediate
                        regWrite = 1'b1;
                    end
                end
                2'b11: begin //RSI
                    if(lessThan) begin
                        shiftEnable = 1'b1;
                        shiftDirection = 1'b1;
                        shiftAmount = bits[4:0]; //5-bit immediate
                        regWrite = 1'b1;
                    end
                end
                default: begin
                    branchEnable = 1'b0;
                end
            endcase 
        end
    end
endmodule: ControlUnit