LL #11 //Use some LUT index to set address of arg2 to R1
LB R2 R1 //Load arg 2 from memory to register 2
LL #12 //Use some LUT index for grabbing 0b00000000 to R1
SEQ R1 R2 //Compare R1 and R2
BEQ .ZeroCheck
BUN .EndZeroCheck
.ZeroCheck
    LL #13 //Use some LUT index to set address of arg1 to R1
    LB R2 R1 //Load arg 1 from memory to register 2
    LL #14 //Use some LUT index for grabbing 0b10000000 to R1
    SEQ R1 R2 //Compare R1 and R2
    BEQ .ReturnMin
    BUN .EndReturnMin
    .ReturnMin
    RETURN //END PROGRAM HERE, set 0b1111100000000000
    .EndReturnMin   
    LL #13 //Use some LUT index to set address of arg1 to R1
    LB R2 R1 //Load arg 1 from memory to register 2
    LL #12 //Use some LUT index for grabbing 0b00000000 to R1
    SEQ R1 R2 //Compare R1 and R2
    BEQ .ReturnZero
    BUN .EndReturnZero
    .ReturnZero
    RETURN //END PROGRAM HERE, set 0b0000000000000000
    .EndReturnZero
.EndZeroCheck
//GET SIGN BIT
LL #13 //Use some LUT index to set address of arg1 to R1
LB R2 R1 //Load arg 1 from memory to register 2
LL #14 //Use some LUT index for grabbing 0b10000000 to R1
AND R2 R1 //AND arg1 with 0b10000000, store result in R2(sign bit)
LL #15 //LUT index containing memory address for sign bit
SB R2 R1 //Store sign bit in LUT specified memory address
LL #14 //Use some LUT index for grabbing 0b10000000 to R1
SEQ R1 R2 //if the result of and is equal to 0b10000000,
BEQ .TwosComp
BUN .EndTwosComp
.TwosComp  //Store back 2s comp of arg1 and arg2
    LL #13 //Use some LUT index to set address of arg1 to R1
    LB R2 R1 //Load arg 1 from memory to register 2
    LL #16 // Load 0b11111111 to R1
    XOR R2 R1 //2s Comp equivalent of arg1
    LIL #1 //Store 1 to R1
    ADD R2 R1 //Add 1 to 2s Comp of arg1
    LL #13 //Use some LUT index to set address of arg1 to R1
    SB R2 R1 //Store 2s Comp of arg1 in memory
    LL #11 //Use some LUT index to set address of arg2 to R1
    LB R2 R1 //Load arg 2 from memory to register 2
    LL #16 // Load 0b11111111 to R1
    XOR R2 R1 //2s Comp equivalent of arg2
    LIL #1 //Store 1 to R1
    ADD R2 R1 //Add 1 to 2s Comp of arg2
    LL #11 //Use some LUT index to set address of arg2 to R1
    SB R2 R1 //Store 2s Comp of arg2 in memory
.EndTwosComp
LIL #1 //Store 1 to R1
ADD R4 R1 //Store 1 to R4, treat as i
    .ScanLeadingOneLoop //While(i<8) loop
    LL #13 //Use some LUT index to set address of arg1 to R1
    LB R2 R1 //Load arg 1 from memory to register 2
    LSL R2 R4 //Shift left arg1 by i times, store into R2
    LL #14 //Use some LUT index for grabbing 0b10000000 to R1
    AND R2 R1 //AND arg1 with 0b10000000, store result in R2
    SEQ R1 R2 //Compare R1 and R2, if it equals 0b10000000
    LL #8 //Store 8 to R1 by LUT index
    LSL R3 R1 //Shift R3 8 times making it 0.
    LL #17 //Use some LUT index to store 30 to R1
    ADD R3 R1 //Move by adding, R3 is now 30.
    SUB R3 R4 //Subtract i from 30, store in R3 (30-i)
    LL #19 //Get memory address of exp variable by LUT index
    SB R1 R3 //Store 30-i in exp memory address
    BEQ .EndScanLeadingOneLoop //Break while loop
    LL #1 //Store 1 to R1
    ADD R4 R1 //Increment i
    LL #8 //Store 8 to R1
    SLT R4 R1  //Check if i<8
    BLT .ScanLeadingOneLoop //if i<8 loop
.EndScanLeadingOneLoop
LL #19 //Get memory address of exp variable by LUT index
LB R4 R1 //Load exp from memory to R4
LL #12 //Use some LUT index for grabbing 0b00000000 to R1
SEQ R1 R3 //Compare exp and 0, if equal
BEQ .ExpEqualZero
BUN .ExpNotEqualZero
.ExpEqualZero
LL #8 //Store 8 to R1 by LUT index
LSL R4 R1 //Shift R3 8 times making it 0, treat it as (R4)i = 0
.ScanSecondLeading //second while(i<8)
    LL #13 //Use some LUT index to set address of arg1 to R1
    LB R2 R1 //Load arg 1 from memory to register 2
    LSL R2 R4 //Shift left arg1 by i times, store into R2
    LL #14 //Use some LUT index for grabbing 0b10000000 to R1
    AND R2 R1 //AND arg1 with 0b10000000, store result in R2
    SEQ R1 R2 //Compare R1 and R2, if it equals 0b10000000
    LL #8 //Store 8 to R1 by LUT index
    LSL R3 R1 //Shift R3 8 times making it 0.
    LL #20 //Use some LUT index to store 23 to R1
    ADD R3 R1 //Move by adding, R3 is now 23.
    SUB R3 R4 //Subtract i from 23, store in R3 (23-i)
    LL #19 //Get memory address of exp variable by LUT index
    SB R1 R3 //Store 23-i in exp memory address
    BEQ .EndScanLeadingOneLoop //Break while loop
    LIL #1 //Store 1 to R1
    ADD R4 R1 //Increment i
    LL #8 //Store 8 to R1
    SLT R4 R1  //Check if i<8
    BLT .ScanSecondLeading //Loop if i<8
.ExpNotEqualZero
LL #19 //Get memory address of exp variable by LUT index
LB R3 R1 //Load exp from memory to R3
LL #12 //Use some LUT index for grabbing 0b00000000 to R1
AND R4 R1 //AND exp with 0b00000000, store result in R4
LL #17 //Use some LUT index to store 30 to R1
ADD R4 R1 //Move by adding, R4 is now 30.
SUB R4 R3 //Subtract exp from 30, store in R4 (30-exp)
LL #21 //Get memory address of "skipped" by LUT index
SB R1 R4 //Store 30-exp in "skipped" memory address
    LL #12 //Use some LUT index for grabbing 0b00000000 to R1
    AND R3 R1 //AND exp with 0b00000000, store result in R3
    LL #8 //Store 8 to R1 by LUT index
    ADD R3 R1 //Move by adding, R3 is now 8.
    LIL #1 //Store 1 to R1
    SUB R3 R1 //Subtract to get 7 in R3
    SLT R3 R4 //Check if 7 < skipped
    BLT .IfSkippedLTSeven
    BUN .ElseSkippedLTSeven
.IfSkippedLTSeven
    LL #13 //Use some LUT index to set address of arg1 to R1
    LB R2 R1 //Load arg 1 from memory to register 2
    LSL R2 R4 //Shift left arg1 by skipped(30-exp) times, store back into R2
    BUN .EndSkippedLTSeven
.ElseSkippedLTSeven
    LL #13 //Use some LUT index to set address of arg2 to R1
    LB R2 R1 //Load arg 2 from memory to register 2
    LSL R2 R4 //Shift left arg2 by skipped(30-exp) times, store back into R2
.EndSkippedLTSeven