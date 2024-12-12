module ALU_mux ( 
	input logic [1:0] control_in,
	input logic [7:0] val2,
	input logic [2:0] lsr_immediate,
	input logic [3:0] dump_r0,
	input logic [0:0] bit_1,
	output logic [7:0] out
   );
	
	/* immediate:
			0: value in r2
			1: lsr -- 3 bit unsigned int
			2: dump -- 4 but unsigned int in r0
			3: and1 -- 1 bit int value of 1
	*/
	
always_comb begin
	 if (control_in == 0) begin
		out <= val2;
	//	$display("Out is val2. control_in is %d", control_in);
	 end else if (control_in == 1) begin
		out <= {5'b00000, lsr_immediate};
//		$display("Out is lsr_immediate. control_in is %d", control_in);
	 end else if (control_in == 2) begin		// dmp works
	 
		//$display("DUMPING %d!", dump_r0);
	 
		out <= {4'b0000, dump_r0};
		
		
	 end else if (control_in == 3) begin
		out <= {7'b0000000, bit_1};
	//	$display("Out is and1_1 or lsl (left shift). control_in is %d", control_in);
	 end else begin
		out <= 0;
//		$display("Weird control_in value of %d", control_in);
	 end
  end
endmodule
