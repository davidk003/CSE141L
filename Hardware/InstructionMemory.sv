module InstructionMemory(
  input[7:0] PC,
  output logic[8:0] mach_code);

  logic[8:0] Core[256];

  initial begin
  for (int i = 0; i < 256; i++) begin
      Core[i] = 9'b0;
  end
  $readmemb("mach_code.txt", Core);
  end
  always_comb begin
    mach_code = Core[PC];
    $display("InstructionMemory @ %d: %b",PC, mach_code);
  end

endmodule