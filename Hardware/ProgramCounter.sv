module ProgramCounter(
    input logic clk, reset, jumpEnable,
    input logic[7:0] jumpAmount,
    output logic[7:0] count
);

always @(posedge clk) begin
    $display("PC: %d", count);
    if(reset) begin
        count <= 8'b0;
        $display("PC: Reset to 0");
    end
    else if(jumpEnable) begin
        count <= jumpAmount;
        $display("PC: Jump to %d", jumpAmount);
    end
    else begin
        count <= count + 8'b1;
    end
end

endmodule: ProgramCounter