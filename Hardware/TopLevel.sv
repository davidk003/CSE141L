module TopLevel(
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
// SB(store byte) - 2 bit type (01), 3 bit opcode (000), 2 bit destination memory address register (XX), 2 bit source (XX)
// LB(load byte) - 2 bit type (01), 3 bit opcode (001), 2 bit destination register (XX), 2 bit source memory address register (XX)
// LL(load LUT) - 2 bit type (01), 3 bit opcode (010), 4-bit LUT index (XXXX)
// LIL(Load immediate lower) - 2 bit type (01), 3 bit opcode (011), 4-bit LUT index (XXXX)
// LIU(Load immediate upper) - 2 bit type (01), 3 bit opcode (100), 4-bit LUT index (XXXX)

// Branch(10) B Instruction Type
// BEQ(Branch equal to) - 2 bit type (10), 2 bit opcode (00), 5 bit immediate for LUT index
// BLT(Branch less than) - 2 bit type (10), 2 bit opcode (01), 5 bit immediate for LUT index
// BLTE(Branch less than or equal to) - 2 bit type (10), 2 bit opcode (10), 5 bit immediate for LUT index
// BUN(Branch unconditional) - 2 bit type (10), 2 bit opcode (11), 5 bit immediate for LUT index

// Shift and other(11) S Instruction Type
// LSL(Left shift) - 2 bit type (11), 2 bit opcode (00), 2 bit operand destination register, 2-bit register shift amount, 1-bit dummy
// LSR(Right shift) - 2 bit type (11), 2 bit opcode (01), 2 bit operand destination register, 2-bit register shift amount, 1-bit dummy
// BF(Branch forwards) - 2 bit type (11), 2 bit opcode (10), 5 bit immediate for LUT index
// BB(Branch backwards) - 2 bit type (11), 2 bit opcode (11), 5 bit immediate for LUT index

  wire [5:0]   Jump;            // Assuming Jump address is 6 bits
  wire [7:0]   PC;
  wire [2:0]   Aluop;
  wire [1:0]   Ra, Rb, Wd;      // Updated to 2 bits based on RegisterFile
  wire [2:0]   Jptr;            // Assuming Jptr remains 3 bits
  wire [8:0]   mach_code;
  wire [7:0]   DatA, DatB;      // ALU inputs
  wire [7:0]   Rslt;            // ALU output
  wire [7:0]   RdatA, RdatB;    // RegFile outputs
  wire [7:0]   WdatR;           // RegFile data input (from ALU)
  wire [7:0]   WdatD;           // Data memory data input
  wire [7:0]   Rdat;            // Data memory data output
  wire [7:0]   Addr;            // Data memory address

  wire Jen; // PC jump enable

  wire carry; //ALU carry out
  wire lessThan
  wire WenR, WenD;     // Write enables
  wire Ldr, Str;       // LOAD and STORE controls
  wire branch;
  wire memWrite;
  wire memRead;
  wire regWrite;
  wire [4:0]   LUTIndex;
  wire         shiftDirection;
  wire [2:0]   shiftAmount;

  logic [7:0]  index;
  logic [7:0]  value;

  assign DatA = RdatA;          // ALU operand A from RegFile
  assign DatB = RdatB;          // ALU operand B from RegFile
  assign WdatR = Rslt;          // ALU result to RegFile

  LookUpTable LUT_inst (
      .index(index),
      .value(value)
  );

  ProgramCounter PC_inst (
      .clk(clk),
      .reset(reset),
      .jumpEnable(Jen),
      .jump(Jump),
      .count(PC)
  );

  InstructionMemory IM_inst (
      .PC(PC),
      .mach_code(mach_code)
  );

  ControlUnit CU_inst (
      .bits(mach_code),
      .equal(Zero),
      .lessThan(SCo),
      .branch(branch),
      .memWrite(memWrite),
      .memRead(memRead),
      .regWrite(regWrite),
      .LUTIndex(LUTIndex),
      .Aluop(Aluop),
      .shiftDirection(shiftDirection),
      .shiftAmount(shiftAmount)
  );

  // Register file contains 4 * 8-bit registers
  RegisterFile RF_inst (
      .clk(clk),
      .Wen(regWrite),
      .Ra(Ra),
      .Rb(Rb),
      .Wd(Wd),
      .Wdat(WdatR),
      .RdatA(RdatA),
      .RdatB(RdatB)
  );

  ALU ALU_inst (
      .control_in(Aluop[1:0]),
      .op1(DatA),
      .op2(DatB),
      .Aluop(Aluop),
      .result(Rslt),
      .equal(Zero),
      .lessThan(SCo)
  );

  DataMemory data_mem1 (
      .clk(clk),
      .addr(Addr),
      .Wdat(WdatD),
      .Rdat(Rdat),
      .Wen(memWrite)
  );

  // Logic to determine Done signal (example condition)
  always_ff @(posedge clk or posedge reset) begin
      if (reset) begin
          Done <= 1'b0;
      end else begin
          // Example: Set Done when PC reaches a specific value
          if (PC == 8'hFF) //CHANGE LATER WITH INSTRUCTION MEMORY LAST ADDRESS
              Done <= 1'b1;
          else
              Done <= 1'b0;
      end
  end
  

  // // Example: If memRead (LOAD) is active, set Addr from LUT value
  // // If memWrite (STORE) is active, set Addr from LUT value and data from ALU result
  // always_comb begin
  //     if (memRead) begin
  //         Addr = value;              // Address for LOAD from LUT
  //         WdatD = Rslt;              // Data to write back from ALU
  //     end else if (memWrite) begin
  //         Addr = value;              // Address for STORE from LUT
  //         WdatD = Rslt;              // Data to store from ALU
  //     end else begin
  //         Addr = 8'd0;
  //         WdatD = 8'd0;
  //     end
  // end

endmodule
