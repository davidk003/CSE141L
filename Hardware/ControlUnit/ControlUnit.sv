module ControlUnit(
    input logic [8:0] bits,
    output logic jump,
    output logic memWrite,
    output logic memRead,
    output logic regWrite,
    output logic [2:0] aluOp,
);
    enum {R=2'b00, M=2'b01, B=2'b10, S=2'b11 } instruction_type;
    always_comb begin
        type =
        if()
    end

    assign jump = (opcode == 8'b00);
    assign memWrite = (opcode == 8'b00);
    assign memRead = (opcode == 8'b00);
    assign regWrite = (opcode == 8'b00);
    assign aluOp = opcode[2:0];

endmodule: ControlUnit