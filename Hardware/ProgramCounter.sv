module ProgramCounter(
    input logic clk, reset, jumpEnable,
    input logic[7:0] jumpAmount,
    output logic[7:0] count
);

always @(posedge clk) begin
    $display("PC: %d", count);
    if(reset) count <= 8'b0;
    else if(jumpEnable) count <= jumpAmount;
    else count <= count + 8'b1;
end

endmodule: ProgramCounter