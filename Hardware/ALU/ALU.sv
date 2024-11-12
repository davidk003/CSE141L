module ALU(
    input logic[7:0] op1, op2,
    input logic[2:0] Aluop,
    output logic[7:0] output,
    output logic equal,
    output logic lessThan,
);

    always_comb begin
        case(Aluop)
            3'b000: output = op1 & op2; // AND
            3'b001: output = op1 | op2; // OR
            3'b010: output = op1 ^ op2; // XOR
            3'b011: output = op1 + op2; // ADD
            3'b100: output = op1 - op2; // SUB
            3'b101: begin // SLT
                lessThan = op1 < equal;
                // zero = 1'b0;
            end
            3'b110: begin // SLTE
                lessThan = op1 < equal;
                equal = (op1 == op2);
            end
            3'b111: equal = (op1 == op2); // EQ
            default: output = 8'b0; // Do nothing default
        endcase
    end

endmodule: ALU