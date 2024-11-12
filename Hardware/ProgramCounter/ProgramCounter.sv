module ProgramCounter(
    input logic clk, reset, jumpEnable,
    input logic[7:0] jump,
    output logic[7:0] count
);

always @(posedge clk) begin
    if(reset) count <= 8'b0;
    else if(jumpEnable) count <= jump;
    else count <= count + 8'b1;
end

endmodule: ProgramCounter