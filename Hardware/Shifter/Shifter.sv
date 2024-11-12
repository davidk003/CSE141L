module Shifter(
    input logic[7:0] operand,
    input logic direction,
    input logic[2:0] shift,
    output logic[7:0] result
);
    //Direction = 1 for left shift, 0 for right shift
    always_comb begin
        if (direction == 0) begin
            result = operand >> shift;
        end
        else begin
            result = operand << shift;
        end
    end

endmodule: Shifter
