module LookUpTable(
    input logic [7:0] index,
    output logic[7:0] value
);
    logic[8:0] constants[64];
    
    initial 
	$readmemb("lookuptable.txt",constants);

    always_comb value = constants[index];
endmodule