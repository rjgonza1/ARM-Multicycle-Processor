module top(
    input  logic clk, reset,
    output logic [31:0] DataAdr,
    output logic [31:0] WriteData,
    output logic MemWrite
    );

    logic [31:0] PC, Instr, ReadData;
    logic [3:0] byteEnable; 

    // instantiate processor and memories
    arm  arm(clk, reset, PC, Instr, byteEnable, MemWrite, DataAdr, WriteData, ReadData);
    
    imem imem(PC, Instr);
    
    dmem dmem(clk, MemWrite, DataAdr, byteEnable, Instr[27:26], Instr[6:5], WriteData, ReadData);
    
endmodule
