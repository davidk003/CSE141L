module DataMemory(
    input logic clk,
    input logic wen,
    // input logic ren, no read enable ig
    input logic [7:0] writeData,
    input logic [7:0] address,
    output logic [7:0] dataMemoryOut
    );

    logic [7:0] core [256];

    assign dataMemoryOut = core[address];

    always @(posedge clk) begin
        if(wen) begin
            core[address] <= writeData;
            $display("Writing: %d", writeData);
        end
        else begin
            $display("Reading: %d", core[address]);
        end
    end
endmodule: DataMemory