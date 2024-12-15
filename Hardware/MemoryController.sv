module MemoryController(
    input logic regToMem,
    input logic [7:0] address,  // Data memory address
    input logic [7:0] regData,
    input logic [7:0] ALUdata,
    // input logic [7:0] address
    output logic 
);

always_comb begin
    if (regToMem) begin
        WdatD = regData;
    end
    else begin
        WdatD = ALUdata;
    end
end



endmodule