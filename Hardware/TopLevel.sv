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
// SB(store byte) - 2 bit type (01), 3 bit opcode (000), 2 bit destination memory address register (XX), 2 bit source (XX)
// LB(load byte) - 2 bit type (01), 3 bit opcode (001), 2 bit destination register (XX), 2 bit source memory address register (XX)
// LL(load LUT) - 2 bit type (01), 3 bit opcode (010), 4-bit LUT index (XXXX)
// LL2(Load LUT 2) - 2 bit type (01), 3 bit opcode (011), 4-bit LUT index (XXXX) //2nd LUT loader

// LIL(Load immediate lower) - 2 bit type (01), 3 bit opcode (100), 4-bit LUT index (XXXX)
// LIU(Load immediate upper) - 2 bit type (01), 3 bit opcode (101), 4-bit LUT index (XXXX)
// LLM(LOAD LUT Memory) - 2 bit type (01), 3 bit opcode (110), 2-bit register, 2-bit dummy //Loads from LUT register to desired register.

// Branch(10) B Instruction Type
// BEQ(Branch equal to) - 2 bit type (10), 2 bit opcode (00), 5 bit immediate for LUT index
// BLT(Branch less than) - 2 bit type (10), 2 bit opcode (01), 5 bit immediate for LUT index
// BLTE(Branch less than or equal to) - 2 bit type (10), 2 bit opcode (10), 5 bit immediate for LUT index
// BUN(Branch unconditional) - 2 bit type (10), 2 bit opcode (11), 5 bit immediate for LUT index

// Shift and other(11) S Instruction Type
// LSL(Left shift) - 2 bit type (11), 2 bit opcode (00), 2 bit operand destination register, 2-bit register shift amount, 1-bit dummy
// LSR(Right shift) - 2 bit type (11), 2 bit opcode (01), 2 bit operand destination register, 2-bit register shift amount, 1-bit dummy
// LSI(Left shift immediate) - 2 bit type (11), 2 bit opcode (10), 5 bit immediate in instruction for shift amount
// RSI(Right shift immediate) - 2 bit type (11), 2 bit opcode (11), 5 bit immediate in instruction for shift amount

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
  wire [7:0]   Addr;            // Data memory address


  wire jumpEnable; // PC jump enable
  wire branchEnable;
  wire shiftEnable;

  wire carry; //ALU carry out

  // Comparison flags
  wire equal; // ALU equal flag
  wire lessThan; // ALU less than flag

  // Data Memory control signals
  wire WenR, WenD;     // Write enables
  wire Ldr, Str;       // LOAD and STORE controls
  wire memWriteEnable;
  wire memReadEnable;
  wire regWrite;

  wire [7:0] jumpAmount;

  wire [4:0]   LUTIndex;
  wire         shiftDirection;
  wire [2:0]   shiftAmount;

  logic [4:0]  index;
  logic [7:0]  value;

  wire [7:0] ALUop1, ALUop2;

  assign data1 = RdatA;          // ALU operand A from RegFile
  assign data2 = RdatB;          // ALU operand B from RegFile
  assign WdatR = Rslt;          // ALU result to RegFile

  assign index = LUTIndex;

  LookUpTable LUT_inst (
      .index(index),
      .value(value)
  );

  LookUpTable branchLUT (
      .index(),
      .value()
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
      .bits(mach_code),

      .equal(equal),
      .lessThan(lessThan),
    //   .immediate(),,
      .LUTen(LUTen),
      .branchEnable(branchEnable),
      .memWrite(memWriteEnable),
      .memRead(memReadEnable),
      .regWrite(regWrite),
      .LUTIndex(LUTIndex),
      .Aluop(Aluop),
      .shiftDirection(shiftDirection),
      .shiftAmount(shiftAmount),
      .shiftEnable(shiftEnable)
  );

  // Register file contains 4 * 8-bit registers
  RegisterFile RF_inst (
      .clk(clk),
      .wen(regWrite),
      .r_addr1(r_addr1),
      .r_addr2(r_addr2),
      .w_addr(w_addr),
      .dataIn(WdatR),
      .dataOut1(RdatA),
      .dataOut2(RdatB)
  );

    ALUInMux ALUInMux_inst (
      .shiftImmediateEnable(),,
      .operand1(data1),
      .operand2(data2),
      .shiftImmediate(shiftAmount),
      .ALUop1(ALUop1),
      .ALUop2(ALUop2)
  );

  ALU ALU_inst (
      .op1(ALUop1),
      .op2(ALUop2),
      .Aluop(Aluop),
      .result(Rslt),
      .shiftEnable(shiftEnable),
      .equal(equal),
      .lessThan(SCo)
  );

  DataMemory data_mem1 (
      .clk(clk),
      .address(Addr),
      .writeData(WdatD),
      .dataMemoryOut(Rdat),
      .wen(memWriteEnable)
  );

  // Logic to determine Done signal (example condition)
  always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
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
