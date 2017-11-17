module top(
    input  logic clk, reset,
    output logic [31:0] DataAdr,
    output logic [31:0] WriteData,
    output logic MemWrite
    );

    logic [31:0] PC, Instr, ReadData;
    logic [3:0] byteEnable;
    logic [1:0] Instr27_26, Instr6_5; 

    // instantiate processor and memories
    arm  arm(clk, reset, PC, Instr, byteEnable, MemWrite, DataAdr, WriteData, ReadData, Instr27_26, Instr6_5);
    
    imem imem(PC, Instr);
   
    // pass dmem a different value for Instr[26:26] and Instr[6:5] 
    dmem dmem(clk, MemWrite, DataAdr, byteEnable, Instr27_26, Instr6_5, WriteData, ReadData);
    
endmodule
