module LookUpTable(
    input logic [7:0] index,
    output logic[7:0] value
);
    logic[8:0] constants1[32];
    logic[8:0] constants2[32];
    
    initial begin
        $readmemb("lookuptable1.txt", constants1);
        $readmemb("lookuptable2.txt", constants2);
    end

    always_comb value = (index < 32) ? constants1[index] : constants2[index];
endmodule