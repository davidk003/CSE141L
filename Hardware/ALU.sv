module ALU(
    input logic[7:0] op1, op2,
    input logic[2:0] Aluop,
    input logic shiftEnable,
    input logic shiftDirection,
    output logic[7:0] result,
    output logic equal,
    output logic lessThan
);

logic [7:0] muxResult;
logic [7:0] shiftResult;

Shifter Shifter_inst (
    .operand(op1),
    .shiftOperand(op2),
    .direction(shiftDirection),
    .result(shiftResult)
);

    always_comb begin
        // Initialize signals to prevent latches
        result = 8'b0;
        equal = 1'b0;
        lessThan = 1'b0;

        if (control_in == 2'b00) begin
            case (Aluop)
                3'b000: result = op1 & op2;           // AND
                3'b001: result = op1 | op2;           // OR
                3'b010: result = op1 ^ op2;           // XOR
                3'b011: result = op1 + op2;           // ADD
                3'b100: result = op1 - op2;           // SUB
                3'b101: lessThan = (op1 < op2);       // SLT
                3'b110: begin                         // SLTE
                    lessThan = (op1 <= op2);
                    equal = (op1 == op2);
                end
                3'b111: equal = (op1 == op2);         // EQ
                default: result = 8'b0;               // Default to zero
        endcase
        end
        
    end

    assign muxResult = (shiftEnable) ? shiftResult : result;

endmodule: ALU
