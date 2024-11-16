module ControlUnit(
    input logic [8:0] bits,
    input logic equal,
    input logic lessThan,
    output logic branch,
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
        branch = 1'b0;
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
                    if(equal) branch = 1'b1;
                end
                2'b01: begin //BLT
                    if(lessThan) branch = 1'b1;
                end
                2'b10: begin //BLTE
                    if(lessThan || equal) branch = 1'b1;
                end
                2'b11: begin //BUN
                    branch = 1'b1;
                end
                default: begin
                    branch = 1'b0;
                end
            endcase
        end
        else if(bits[8:7] == S) begin   
            regWrite = 1'b1;
            shiftDirection = bits[5];
            shiftAmount = bits[2:0];
        end
    end
endmodule: ControlUnit