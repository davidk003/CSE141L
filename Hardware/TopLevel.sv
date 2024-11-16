module TopLevel(
  input        clk,
		       reset,
  output logic Done);

  wire[5:0] Jump;
  wire[7:0] PC;
  wire[2:0] Aluop,
            Ra,
			Rb,
			Wd,
			Jptr;
  wire[8:0] mach_code;
  wire[7:0] DatA,	     // ALU data in
            DatB,
			Rslt,		 // ALU data out
			RdatA,		 // RF data out
			RdatB,
			WdatR,		 // RF data in
			WdatD,		 // DM data in
			Rdat,		 // DM data out
			Addr;		 // DM address
  wire      Jen,		 // PC jump enable
            Par,         // ALU parity flag
			SCo,         // ALU shift/carry out
            Zero,        // ALU zero flag
			WenR,		 // RF write enable
			WenD,		 // DM write enable
			Ldr,		 // LOAD
			Str;		 // STORE

    logic [7:0] index;
    logic[7:0] value;

assign  DatA = RdatA;
assign  DatB = RdatB; 
assign  WdatR = Rslt; 

LookUpTable JL1(
  .index,
  .value);

ProgramCounter PC1(
  .clk,
  .reset,
  .jumpEnable(Jen),
  .jump(Jump),
  .count(PC));

InstructionMemory IR1(
  .PC,
  .mach_code);

ControlUnit C1(
  .mach_code,
  .Aluop,
  .Jptr,
  .Ra,
  .Rb,
  .Wd,
  .WenR,
  .WenD,
  .Ldr,
  .Str);

// RegFile RF1(
//   .clk(clk),
//   .Wen(WenR),
//   .Ra,
//   .Rb,
//   .Wd,
//   .Wdat(WdatR),
//   .RdatA,
//   .RdatB
// );

ALU A1(
  .Aluop,
  .op1(DatA),
  .op2(DatB),
  .result(Rslt),
  .equal(Zero),
  .lessThan(Par),
//   .SCo
  );

DataMemory DM1(
  .clk,
  .wen (WenD),
  .writeData(WdatD),
  .address(Addr),
  .readData(Rdat));


endmodule: TopLevel