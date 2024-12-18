module Shifter(
    input logic[7:0] operand,
    input logic[7:0] shiftAmount,
    input logic direction,
    output logic[7:0] result
);
    //Direction = 0 for left shift, 1 for right shift
    always_comb begin
        if (direction == 1) begin
            result = operand >> shiftAmount;
        end
        else begin
            result = operand << shiftAmount;
        end
    end

endmodule: Shifter
