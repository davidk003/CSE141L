module ALUInMux ( 
	input logic [1:0] instruction_type,
	input logic [1:0] reg1,
	input logic [1:0] reg2,
	input logic [2:0] Aluop,
	output logic [7:0] op1,
	output logic [7:0] op2
   );
   //Mux input for ALU

always_comb begin
	if(Aluop == 3'b000) begin
		op1 = reg1;
		op2 = reg2;
	end
	else begin
		op1 = 8'b0;
		op2 = 8'b0;
	end
end
endmodule
