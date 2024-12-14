module ALU_testbench();

    logic [7:0] op1, op2;
    logic [2:0] Aluop;
    logic [7:0] out;
    logic equal, lessThan;

ALU ALU_inst(
        .op1(op1),
        .op2(op2),
        .Aluop(Aluop),
        .result(out),
        .equal(equal),
        .lessThan(lessThan)
    );

initial begin
        // AND operation
        op1 = 8'b00001111;
        op2 = 8'b11110000;
        Aluop = 3'b000;
        #10;

        // OR operation
        Aluop = 3'b001;
        #10;

        // XOR operation
        Aluop = 3'b010;
        #10;

        // ADD operation
        op1 = 8'b00000011;
        op2 = 8'b00000010;
        Aluop = 3'b011;
        #10;

        // SUB operation
        Aluop = 3'b100;
        #10;

        // SLT operation
        Aluop = 3'b101;
        #10;

        // SLTE operation
        Aluop = 3'b110;
        #10;

        // EQ operation
        op1 = 8'b00000001;
        op2 = 8'b00000001;
        Aluop = 3'b111;
        #10;

        $stop;
    end
endmodule: ALU_testbench