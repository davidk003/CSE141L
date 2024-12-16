module TopLevel
(
  input wire clk,
  input wire reset,
  input wire start,
  output logic done
);
// 9 BIT INSTRUCTION SET
// 4 8-BIT REGISTERS

// R(00) Instruction Type
// AND - 2 bit type (00), 3 bits opcode (000), 2 bit operand destination register (XX), 2 bit operand register (XX)
// OR - 2 bit type (00), 3 bits opcode (001), 2 bit operand destination register (XX), 2 bit operand register (XX)
// XOR -2 bit type (00), 3 bits opcode (010), 2 bit operand destination register (XX), 2 bit operand register (XX)
// ADD - 2 bit type (00), 3 bits opcode (011), 2 bit operand destination register (XX), 2 bit operand register (XX)
// SUB - 2 bit type (00), 3 bits opcode (100), 2 bit operand destination register (XX), 2 bit operand register (XX)
// SLT(Set less than) - 2 bit type (00), 3 bits opcode (101), 2 bit operand register (XX), 2 bit operand register (XX)
// SLTE(Set less than or equal to) - 2 bit type (00), 3 bits opcode (110), 2 bit operand register (XX), 2 bit operand register (XX)
// SEQ(Set equal to) -  2 bit type (00), 3 bits opcode (111), 2 bit operand register (XX), 2 bit operand register (XX)

// Memory(01) M Instruction Type
// SB(store byte) - 2 bit type (01), 3 bit opcode (000), 2 bit destination memory address register (XX), 2 bit source value register address(XX)
//  Ex: SB R0 R1 stores value of R1 into address at R0
// LB(load byte) - 2 bit type (01), 3 bit opcode (001), 2 bit destination register (XX), 2 bit source memory address register (XX)
//  Ex: LB R0 R1 loads value at memory address R1 into R0
// LL(load LUT val) - 2 bit type (01), 3 bit opcode (010), 4-bit LUT index (XXXX) //1st LUT loader, Load value into special reg
// LL2(Load LUT 2 val) - 2 bit type (01), 3 bit opcode (011), 4-bit LUT index (XXXX) //2nd LUT loader, Load value into special reg

// LIL(Load immediate lower) - 2 bit type (01), 3 bit opcode (100), 4-bit LUT index (XXXX) //Load lower value into special LUT reg
// LIU(Load immediate upper) - 2 bit type (01), 3 bit opcode (101), 4-bit LUT index (XXXX) //Load upper value into special LUT reg
// LLR(Load LUTreg to main Register) - 2 bit type (01), 3 bit opcode (110), 2-bit register(XX), 2-bit dummy //Loads from special LUT register to desired register.


// Branch(10) B Instruction Type
// BEQ(Branch equal to) - 2 bit type (10), 2 bit opcode (00), 5 bit immediate for LUT index
// BLT(Branch less than) - 2 bit type (10), 2 bit opcode (01), 5 bit immediate for LUT index
// BLTE(Branch less than or equal to) - 2 bit type (10), 2 bit opcode (10), 5 bit immediate for LUT index
// BUN(Branch unconditional) - 2 bit type (10), 2 bit opcode (11), 5 bit immediate for LUT index

// Shift and other(11) S Instruction Type
// LSL(Left shift) - 2 bit type (11), 2 bit opcode (00), 2 bit operand destination register, 2-bit register shift amount, 1-bit dummy
// LSR(Right shift) - 2 bit type (11), 2 bit opcode (01), 2 bit operand destination register, 2-bit register shift amount, 1-bit dummy
// LSI(Left shift immediate) - 2 bit type (11), 2 bit opcode (10), 2-bit operand register, 3 bit immediate in instruction for shift amount
// RSI(Right shift immediate) - 2 bit type (11), 2 bit opcode (11), 2-bit operand register, 3 bit immediate in instruction for shift amount

//DEPRECATE BRANCHING DIRECTION FOR ABSOLUTE ADDRESSING
// BF(Branch forwards) - 2 bit type (11), 2 bit opcode (10), 5 bit immediate for LUT index
// BB(Branch backwards) - 2 bit type (11), 2 bit opcode (11), 5 bit immediate for LUT index

  wire [7:0]   PC;
  wire [2:0]   Aluop;
  wire [1:0]   r_addr1, r_addr2, w_addr;
  wire [8:0]   mach_code;
  wire [7:0]   data1, data2;      // ALU inputs
  wire [7:0]   Rslt;            // ALU output
  wire [7:0]   RdatA, RdatB;    // RegFile outputs
  wire [7:0]   WdatR;           // RegFile data input (from ALU)
  wire [7:0]   WdatD;           // Data memory data input
  wire [7:0]   Rdat;            // Data memory data output
  wire [7:0]   mem_addr;            // Data memory address


  wire jumpEnable; // PC jump enable
  wire branchEnable;
  wire shiftEnable;

  wire carry; //ALU carry out

  // Comparison flags
  wire equal; // ALU equal flag
  wire lessThan; // ALU less than flag



  wire regToReg;
  wire memToReg;
  wire regToMem;

  wire regWrite;
  wire memWrite;

  wire [7:0] jumpAmount;
  wire [7:0] branchLUTIndex;

  wire         shiftDirection;
  wire         shiftImmediateEnable;
  wire [7:0]   shiftImmediate;

  wire [7:0]  LUTIndex;
  wire [7:0]  index;
  wire [7:0]  value;

  wire [7:0] ALUop1, ALUop2;

  logic [7:0] LUTreg;
  wire LUTwrite;
  wire LUTtoReg;
  wire [1:0] LUTRegtoRegIndex;

  wire immediateLUTEnable;
  wire [7:0] immediateToLUTReg;
  logic [7:0] LUTvalue;

  assign data1 = RdatA;          // ALU operand A from RegFile
  assign data2 = RdatB;          // ALU operand B from RegFile
//   assign WdatR = Rslt;          // ALU result to RegFile

//   assign index = LUTIndex;

  assign jumpEnable = branchEnable;

//  If lut immediate is enabled, change value to immediate value else regular LUT output
  assign LUTvalue = immediateLUTEnable ? immediateToLUTReg : value;
  // If LUT write is enabled, write to LUTreg, else keep LUTreg the same
  assign LUTreg = LUTwrite ? LUTvalue : LUTreg;

  // Immediate write to reg

  LookUpTable LUT_inst (
    .index(LUTIndex),
    .value(value)
  );

  LookUpTable branchLUT (
    .index(branchLUTIndex),
    .value(jumpAmount)
  );

  ProgramCounter PC_inst (
    .clk(clk),
    .reset(reset),
    .jumpEnable(jumpEnable),
    .jumpAmount(jumpAmount),
    .count(PC)
  );

  InstructionMemory IM_inst (
    .PC(PC),
    .mach_code(mach_code)
  );

  ControlUnit CU_inst (
    // Inputs
    .bits(mach_code),
    .equal(equal),
    .lessThan(lessThan),
    // Outputs
    .branchEnable(branchEnable),
    .branchLUTIndex(branchLUTIndex),
    .regToReg(regToReg),
    .memToReg(memToReg),
    .regToMem(regToMem),
    .Aluop(Aluop),
    .shiftEnable(shiftEnable),
    .shiftDirection(shiftDirection),
    .shiftImmediateEnable(shiftImmediateEnable),
    .shiftImmediate(shiftImmediate),
    .LUTIndex(LUTIndex),
    .LUTtoReg(LUTtoReg),
    .LUTwrite(LUTwrite),
    .LUTRegtoRegIndex(LUTRegtoRegIndex),
    .immediateToLUTReg(immediateToLUTReg),
    .immediateLUTEnable(immediateLUTEnable),
    .r_addr1(r_addr1),
    .r_addr2(r_addr2)
  );


  MemoryController mem_controller (
    // Inputs
    .operandRegister1(r_addr1),
    .operandRegister2(r_addr2),
    .LUTRegtoRegAddress(LUTRegtoRegIndex),
    .regToReg(regToReg),
    .regToMem(regToMem),
    .memToReg(memToReg),
    .LUTtoReg(LUTtoReg),
    //regData1 used as source memory address for store byte,
    //destination register address for load byte
    .reg1Data(RdatA),
    //regData2 used as register address to store for store byte
    //source memory address for load byte
    .reg2Data(RdatB),
    .ALUdata(Rslt),
    .memData(Rdat),
    .LUTdata(LUTreg),
    // Outputs
    .regAddress(w_addr),
    .memAddress(mem_addr),
    .regWrite(regWrite),
    .memWrite(memWrite),
    .writeMemData(WdatD),
    .writeRegData(WdatR)
  );

  // Register file contains 4 * 8-bit registers
  RegisterFile RF_inst (
    //Inputs
    .clk(clk),
    .wen(regWrite),
    .r_addr1(r_addr1),
    .r_addr2(r_addr2),
    .w_addr(w_addr),
    .dataIn(WdatR),
    // Outputs
    .dataOut1(RdatA),
    .dataOut2(RdatB)
  );

  ALUInMux ALUInMux_inst (
    .shiftImmediateEnable(shiftImmediateEnable),
    .operand1(data1),
    .operand2(data2),
    .shiftImmediate(shiftImmediate),
    //Outputs
    .ALUop1(ALUop1),
    .ALUop2(ALUop2)
);

  ALU ALU_inst (
    // Inputs
    .op1(ALUop1),
    .op2(ALUop2),
    .Aluop(Aluop),
    .shiftEnable(shiftEnable),
    .shiftDirection(shiftDirection),
    // Outputs
    .result(Rslt),
    .equal(equal),
    .lessThan(lessThan)
  );

  DataMemory data_mem1 (
    .clk(clk),
    .address(mem_addr),
    .writeData(WdatD),
    .dataMemoryOut(Rdat),
    .wen(memWrite)
  );
    initial $display("Loaded modules");
  // Logic to determine Done signal (example condition)
  always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            $display("Resetting");
            done <= 1'b0;
        end else begin
            // Example: Set Done when PC reaches a specific value
            if (PC == 8'hFF || mach_code == 9'b0)//IF PC hits certain number of 0 instruction, finish.
            begin
                done <= 1'b1;
                $display("Done, dumping registers");
                $display("R0 | Decimal: %d, Binary: %b", RF_inst.Core[0], RF_inst.Core[0]);
                $display("R1 | Decimal: %d, Binary: %b", RF_inst.Core[1], RF_inst.Core[1]);
                $display("R2 | Decimal: %d, Binary: %b", RF_inst.Core[2], RF_inst.Core[2]);
                $display("R3 | Decimal: %d, Binary: %b", RF_inst.Core[3], RF_inst.Core[3]);
            end
            else begin
                done <= 1'b0;
			    end
        end
  end

endmodule
