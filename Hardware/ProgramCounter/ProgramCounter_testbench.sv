`timescale 1ns/1ns
module ProgramCounter_testbench;

logic clk, reset, jumpEnable;
logic [7:0] jump, count;

ProgramCounter ProgramCounter_inst(
    .clk(clk),
    .reset(reset),
    .jumpEnable(jumpEnable),
    .jump(jump),
    .count(count)
);
initial begin
    //Initial
    reset = 1;
	clk = 1;
    jump = 4;
    reset = 0;

    #100ns; //Clock pulse 5 times so count should be 5
    jumpEnable = 1; //Jump ahead by 4, count = 9
    #100ns; //Jump ahead by 4, 5 times so count should be 29



end

always@(clk) begin
	#10ns clk <= !clk;
end
endmodule: ProgramCounter_testbench