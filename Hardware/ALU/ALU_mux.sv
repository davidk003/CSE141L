module ALU_mux ( 
	input logic [1:0] instruction_type,
	input logic [1:0] reg1,
	input logic [1:0] reg2,
	output logic [7:0] op1,
	output logic [7:0] op2
   );
	
always_comb begin
	if(instruction_type == 2'b00) begin //R type normal usage
		op1 = reg1;
		op2 = reg2;
	end
	else begin
		op1 = 8'b0;
		op2 = 8'b0;
	end
end
endmodule
