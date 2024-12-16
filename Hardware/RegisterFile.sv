module RegisterFile(
  input      clk,	 // clock
             wen,    // write enable
  input[1:0] r_addr1,     // read address pointer A
  input[1:0] r_addr2,     // read address pointer B
  input[1:0] w_addr,	 // write address pointer
  input[7:0] dataIn,   // write data in
  output[7:0] dataOut1,
  output[7:0] dataOut2
            //  RdatB
  ); // read data out B

  logic[7:0] Core[4] = '{8'h00, 8'h00, 8'h00, 8'h00};
// reg file itself (4*8 array)


  always_ff @(posedge clk) begin
    // $display("RegisterFile");
    if(wen) Core[w_addr] <= dataIn;
  end
  assign dataOut1 = Core[r_addr1];
  assign dataOut2 = Core[r_addr2];

endmodule