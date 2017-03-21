module pipedDatapath(\
    input logic clk, reset, stall,  
    input logic [31:0] PC, ReadDataM,
    output logic [31:0] PCF, ALUResultM, WriteDataM
    );
    
    logic RegWriteW, MemWriteD, MemtoRegD, PCSrcD, ALUSrcD, RegWriteD, PCSrcD,
          PCSrcE, RegWriteE, MemtoRegE, MemWriteE,
          PCSrcM, RegWriteM, MemtoRegM, MemWriteM,
          PCSrcW, RegWriteW, MemtoRegW;
    logic [1:0] FlagWriteD;
    logic [3:0] byteEnable, ALUControlD, RdD, CondD,
                RdE,
                RdM,
                RdW;
    logic [31:0] PCPlus4F, InstrF, ResultW, SrcAD, ShiftSourceD, ExtImmD, Rs,
                 ALUResultE, WriteDataE,
                 ALUResutlW, ReadDataW;
    
    // Instruction Fetch
    IFetch ifetch(clk, reset, stall, PC, PCF, PCPlus4F);
    
    // Instruction Decode
    IDecode idecode(clk, reset, RegWriteW, stall, InstrF, PCPlus4F, ResultW, MemWriteD,
                    MemtoRegD, PCSrcD, ALUSrcD, RegWriteD, FlagWriteD, byteEnable, ALUControlD,
                    RdD, CondD, SrcAD, ShiftSourceD, ExtImmD, Rs);
    
    // Execute
    Exec exec(clk, reset, stall, PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, FlagWriteD,
              ALUControlD, CondD, RdD, SrcAD, ShiftSourceD, ExtImmD, Rs,PCSrcE, RegWriteE, 
              MemtoRegE, MemWriteE, RdE, ALUResultE, WriteDataE);

    // Memory
    memPipereg memReg((clk % ~stall), reset, PCSrcE, RegWriteE, MemtoRegE, MemWriteE, RdE, 
               ALUResultE, WriteDataE, PCSrcM, RegWriteM, MemtoRegM, MemWriteM,
               RdM, ALUResultM, WriteDataM);

    // Write Back
    wbPipereg wbReg((clk & ~stall), reset, PCSrcM, RegWriteM, MemtoRegM, RdM,
                   ALUResultM, ReadDataM, PCSrcW, RegWriteW, MemtoRegW, RdW,
                   ALUResultW, ReadDataW);

    // Write Back mux
    mux2 #(32) wbmux(ReadDataW, ALUResultW, MemtoRegW, ResultW);


    // next PC mux
    mux2 #(32) npcmux(ResultW, PCPlus4F, PCSrcW, PC);
	

endmodule
