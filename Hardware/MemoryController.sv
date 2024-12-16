module MemoryController(
    input logic [1:0] operandRegister1,
    input logic [1:0] operandRegister2,
    input logic [1:0] LUTRegtoRegAddress,
    input logic regToReg,
    input logic regToMem,
    input logic memToReg,
    input logic LUTtoReg,
    input logic [7:0] reg1Data,
    input logic [7:0] reg2Data,
    input logic [7:0] ALUdata,
    input logic [7:0] memData,
    input logic [7:0] LUTdata,
    output logic [1:0] regAddress,
    output logic [7:0] memAddress,
    output logic regWrite,
    output logic memWrite,
    output logic [7:0] writeMemData,
    output logic [7:0] writeRegData
);

always_comb begin
    regAddress = 2'b00;
    memAddress = 8'b0;
    regWrite = 1'b0;
    memWrite = 1'b0;
    writeMemData = 8'b0;
    writeRegData = 8'b0;

    if (regToReg) begin
        writeRegData = ALUdata;
        regAddress = operandRegister1; //Write to own register (first operand)
        regWrite = 1'b1;
    end
    else if (regToMem) begin //Store byte
    //Store byte in operand2 register address to operand1 memory address register
        memAddress = reg1Data;
        writeMemData = reg2Data;
        memWrite = 1'b1;
    end
    else if (memToReg) begin //Load byte
    //Load byte from operand1 memory address register to operand2 register address
        memAddress = reg2Data;
        writeRegData = memData;
        regWrite = 1'b1;
    end
    else if (LUTtoReg) begin //Load LUT reg to register
        regAddress = LUTRegtoRegAddress;
        writeRegData = LUTdata;
        regWrite = 1'b1;
    end
    else begin
        // $display("MemoryController: No operation selected"); //Triggered during branching
    end
end



endmodule