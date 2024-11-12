`timescale 1ns / 1ps
module Shifter_testbench;

    logic [7:0] operand;
    logic direction;
    logic [2:0] shift;
    logic [7:0] result;

    Shifter shifter_inst (
        .operand(operand),
        .direction(direction),
        .shift(shift),
        .result(result)
    );
    initial begin
        $display("Time\tOperand\tDirection\tShift\tResult\tExpected Result");

        //Right shift 1
        operand = 8'b1100_0011;
        direction = 0;
        shift = 3'b001;
        #10;
        $display("%0dns\t%b\t%b\t%d\t%b\t%b", 
                 $time, operand, direction, shift, result, operand >> shift);

        //Left shift 2
        operand = 8'b0011_1100;
        direction = 1;
        shift = 3'b010;
        #10;
        $display("%0dns\t%b\t%b\t%d\t%b\t%b", 
                 $time, operand, direction, shift, result, operand << shift);

        //Right shift 3
        operand = 8'b1111_0000;
        direction = 0;
        shift = 3'b011;
        #10;
        $display("%0dns\t%b\t%b\t%d\t%b\t%b", 
                 $time, operand, direction, shift, result, operand >> shift);

        //Left shift 4
        operand = 8'b0001_0010;
        direction = 1;
        shift = 3'b100;
        #10;
        $display("%0dns\t%b\t%b\t%d\t%b\t%b", 
                 $time, operand, direction, shift, result, operand << shift);

        //Right shift 0
        operand = 8'b1010_1010;
        direction = 0;
        shift = 3'b000;
        #10;
        $display("%0dns\t%b\t%b\t%d\t%b\t%b", 
                 $time, operand, direction, shift, result, operand >> shift);

        //Left shift 0
        operand = 8'b0101_0101;
        direction = 1;
        shift = 3'b000;
        #10;
        $display("%0dns\t%b\t%b\t%d\t%b\t%b", 
                 $time, operand, direction, shift, result, operand << shift);

        $stop;
    end

endmodule: Shifter_testbench