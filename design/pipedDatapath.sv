module pipedDatapath(
	input logic clk, reset,
	output logic [3:0] byteEnable,
	input logic [31:0] Instruction, ReadDataM,
	output logic MemWriteM,
	output logic [31:0] PCF, ALUResultM, WriteDataM
	);
    
	logic   RegWriteD, MemWriteD, MemtoRegD, PCSrcD, ALUSrcD, BranchD,
		PCSrcE, RegWriteE, MemtoRegE, MemWriteE,
		PCSrcM, RegWriteM, MemtoRegM,
		PCSrcW, RegWriteW, MemtoRegW, BranchTakenE,
		StallF, StallD,
		FlushD, FlushE;
	logic [1:0] FlagWriteD, forwardAE, forwardBE;
	logic [3:0] RA1, RA2, ALUControlD, RdD, CondD,
		    RA1E, RA2E, RdE,
				RdM,
				RdW;
	logic [31:0] PC, PCIntermediate,PCPlus4F, InstrF, ResultW, SrcAD, ShiftSourceD, ExtImmD, Rs,
		ALUResultE, WriteDataE,
		ALUResultW, ReadDataW;
	
	// Instruction Fetch
	mux2 #(32) pcmuxintermediate(PCPlus4F, ResultW, PCSrcW, PCIntermediate); //adding fetchmux1
	mux2 #(32) pcmuxfinal(PCIntermediate, ALUResultE, BranchTakenE, PC); //ading fetchmux2

	IFetch ifetch(clk, reset, StallF, PC, PCF, PCPlus4F);
	
	// Instruction Decode
	IDecode idecode(clk, (reset || FlushD), RegWriteW, StallD, InstrF, PCPlus4F, ResultW, MemWriteD,
			MemtoRegD, PCSrcD, ALUSrcD, RegWriteD, FlagWriteD, byteEnable, ALUControlD,
			RdD, CondD, RA1, RA2, SrcAD, ShiftSourceD, ExtImmD, Rs);
    
	// Execute
	Exec exec(clk, (reset || FlushE), PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUControlD, BranchD, ALUSrcD, FlagWriteD,
		  CondD, RdD, RA1, RA2, SrcAD, ShiftSourceD, ExtImmD, forwardAE, forwardBE, ResultW, ALUResultM, Rs, Instruction[25],
		  Instruction[6:5], Instruction[11:7], Instruction[4], PCSrcE, RegWriteE,
		  MemtoRegE, MemWriteE, BranchTakenE, RdE, RA1E, RA2E, ALUResultE, WriteDataE);

	// Memory
	memPipereg memReg(clk, reset, PCSrcE, RegWriteE, MemtoRegE, MemWriteE, RdE,
			  ALUResultE, WriteDataE, PCSrcM, RegWriteM, MemtoRegM, MemWriteM,
			  RdM, ALUResultM, WriteDataM);

	// Write Back
	wbPipereg wbReg(clk, reset, PCSrcM, RegWriteM, MemtoRegM, RdM,
			ALUResultM, ReadDataM, PCSrcW, RegWriteW, MemtoRegW, RdW,
			ALUResultW, ReadDataW);

	// Write Back mux
	mux2 #(32) wbmux(ReadDataW, ALUResultW, MemtoRegW, ResultW);
	
	// Hazard Detection Unit
	HazardUnit hUnit(RegWriteM, RegWriteW, RA1E, RA2E, RdM, RdW, forwardAE, forwardBE, MemtoRegE, RA1, RA2, RdE, PCSrcD, PCSrcE, PCSrcM,
			 PCSrcW, BranchTakenE, StallF, StallD, FlushD, FlushE);
	

endmodule
