module ProgramCounter(
    input logic clk, reset, jumpEnable,
    input logic[7:0] jumpAmount,
    output logic[7:0] count
);

always @(posedge clk) begin
    if(reset) begin
        count <= 8'b0;
        $display("Reset Signal High");
    end
    else if(jumpEnable) begin
        count <= jumpAmount;
        $display("PC: Jump to %d", jumpAmount);
    end
    else begin
        $display("PC incremented: %d", count+1);
        count <= count + 8'b1;
    end
end

endmodule: ProgramCounter