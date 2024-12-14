module ControlUnit(
    input logic [8:0] bits,
    input logic equal,
    input logic lessThan,
    output logic branchEnable,
    output logic memWrite,
    output logic memRead,
    output logic regWrite,
    output logic [4:0] LUTIndex,
    output logic [2:0] Aluop,
    output logic shiftDirection,
    output logic [2:0] shiftAmount
);
    typedef enum {R=2'b00, M=2'b01, B=2'b10, S=2'b11 } instruction_type;
    instruction_type instruction;

    always begin
        regWrite = 1'b0;
        memWrite = 1'b0;
        memRead = 1'b0;
        branchEnable = 1'b0;
        LUTIndex = bits[4:0];
        Aluop = 3'b000;
        shiftDirection = 1'b0;
        shiftAmount = 3'b000;

        if(bits[8:7] == R) begin
            Aluop = bits[6:4];
        end
        else if(bits[8:7] == M) begin
            case(bits[6:4])
                3'b000: begin
                    memWrite = 1'b1;
                end
                3'b001: begin
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
                    shiftDirection = 1'b0;
                    shiftAmount = bits[4:0]; // 5-bit
                    regWrite = 1'b1;
                end
                2'b01: begin //LSR
                    shiftDirection = 1'b1;
                    shiftAmount = bits[4:0];
                    regWrite = 1'b1;
                end
                2'b10: begin //BF
                    if(equal) branchEnable = 1'b1;
                end
                2'b11: begin //BB
                    if(lessThan) branchEnable = 1'b1;
                end
                default: begin
                    branchEnable = 1'b0;
                end
            endcase 
        end
    end
endmodule: ControlUnit