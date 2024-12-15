module ALUInMux ( 
	input logic shiftImmediateEnable,
	input logic [7:0] operand1,
	input logic [7:0] operand2,
	input logic [7:0] shiftImmediate,
	output logic [7:0] ALUop1,
	output logic [7:0] ALUop2,
   );
	//Mux for ALU input, 

always_comb begin
	if (shiftImmediateEnable) begin
		ALUin1 = operand1;
		ALUop2 = shiftImmediate;
	end
	else begin
		ALUin1 = operand1;
		ALUin2 = operand2;
	end
end
endmodule
