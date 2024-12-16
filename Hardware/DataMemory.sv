module DataMemory(
    input logic clk,
    input logic wen,
    // input logic ren, no read enable ig
    input logic [7:0] writeData,
    input logic [7:0] address,
    output logic [7:0] dataMemoryOut
    );

    logic [7:0] mem_core [256];

    assign dataMemoryOut = mem_core[address];

    always @(posedge clk) begin
        $display("DataMemory");
        if(wen) begin
            mem_core[address] <= writeData;
            $display("Writing: %d", writeData);
        end
        else begin
            $display("Memory Reading @ %d: %b", address, mem_core[address]);
        end
    end
endmodule: DataMemory