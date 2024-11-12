module ControlUnit(
    input logic [8:0] bits,
    output logic jump,
    output logic memWrite,
    output logic memRead,
    output logic regWrite,
    output logic [2:0] aluOp
);
    typedef enum {R=2'b00, M=2'b01, B=2'b10, S=2'b11 } instruction_type;
    instruction_type instruction;

    always_comb begin
        if(bits[8:7] == R) begin
            aluOp = bits[6:4];
        end
        else if(bits[8:7] == M) begin
            instruction = M;
        end
        else if(bits[8:7] == B) begin
            instruction = B;
        end
        else if(bits[8:7] == S) begin
            instruction = S;
        end
        else begin
            instruction = 2'b00;

        end

    end

    assign jump = (bits == 8'b00);
    assign memWrite = (bits == 8'b00);
    assign memRead = (bits == 8'b00);
    assign regWrite = (bits == 8'b00);
    assign aluOp = bits[2:0];

endmodule: ControlUnit