module ControlUnit(
    input logic [7:0] opcode,
    output logic jump,
    output logic memWrite,
    output logic memRead,
    output logic regWrite,
    output logic [2:0] aluOp,
);

    assign jump = (opcode == 8'b00);
    assign memWrite = (opcode == 8'b00);
    assign memRead = (opcode == 8'b00);
    assign regWrite = (opcode == 8'b00);
    assign aluOp = opcode[2:0];

endmodule: ControlUnit