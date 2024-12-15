module ALUInMux ( 
	input logic shiftImmediateEnable,
	input logic [7:0] operand1,
	input logic [7:0] operand2,
	input logic [2:0] shiftImmediate,
	output logic [7:0] ALUop1,
	output logic [7:0] ALUop2,
   );
	//Mux for ALU input, 

always_comb begin
	if (shiftEnable) begin
		ALUin1 = operand1;
		ALUop2 = {3'b000, shiftImmediate}; // Zero-extend shiftImmediate to 8 bits
	end
	else begin
		ALUin1 = operand1;
		ALUin2 = operand2;
	end
end
endmodule
