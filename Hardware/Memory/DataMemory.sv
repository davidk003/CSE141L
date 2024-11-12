module DataMemory(
    input logic clk,
    input logic wen,
    input logic ren,
    input logic [7:0] writeData,
    input logic [7:0] address,
    output logic [7:0] readData,
    );

    logic [7:0] core [256];

    always @(posedge clk) begin
        if(wen) begin
            core[address] <= writeData;
            $display("Writing: %d", writeData);
        end
        else if(ren) begin
            readData <= core[address];
            $display("Reading: %d", core[address]);
        end
    end
endmodule: DataMemory