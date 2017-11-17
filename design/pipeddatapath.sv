module pipeddatapath(
	input logic clk, reset,
	output logic [3:0] byteEnable,
	input logic [31:0] InstrF, ReadDataM,
	output logic MemWriteM,
	output logic [31:0] PCF, ALUResultM, WriteDataM,
	output logic [1:0] Instr27_26M, Instr6_5M
	);
    
	logic   PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, BranchD,
		PCSrcE, RegWriteE, MemtoRegE, MemWriteE,
		PCSrcM, RegWriteM, MemtoRegM,
		PCSrcW, RegWriteW, MemtoRegW, BranchTakenE,
		StallF, StallD,
		FlushD, FlushE;
	logic [1:0] FlagWriteD, forwardAE, forwardBE, Instr27_26, Instr6_5;
	logic [3:0] RA1, RA2, ALUControlD, RdD, CondD,
		    RA1E, RA2E, RdE,
				RdM,
				RdW;
	logic [3:0] byteEnableD, byteEnableE; // byteEnable coming out of the decode stage
	logic [31:0] PC, PCIntermediate,PCPlus4F, ResultW, SrcAD, ShiftSourceD, ExtImmD, Rs,
		ALUResultE, WriteDataE,
		ALUResultW, ReadDataW, InstrD;

	    
	// Instruction Fetch
	mux2 #(32) pcmuxintermediate(PCPlus4F, ResultW, PCSrcW === 1, PCIntermediate); //adding fetchmux1
	mux2 #(32) pcmuxfinal(PCIntermediate, ALUResultE, BranchTakenE === 1, PC); //ading fetchmux2

	ifetch IFetch(clk, reset, StallF, PC, PCF, PCPlus4F);
	
	// Instruction Decode
	idecode IDecode(clk, reset, FlushD, RdW, RegWriteW, StallD, InstrF, PCPlus4F, ResultW, MemWriteD,
			MemtoRegD, PCSrcD, ALUSrcD, RegWriteD, FlagWriteD, byteEnableD, ALUControlD,
			RdD, CondD, RA1, RA2, SrcAD, ShiftSourceD, ExtImmD, Rs, BranchD, InstrD);
    
	// Execute
	exec Exec(clk, reset, FlushE, PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUControlD, BranchD, ALUSrcD, FlagWriteD,
		  CondD, RdD, RA1, RA2, SrcAD, ShiftSourceD, ExtImmD, forwardAE, forwardBE, ResultW, ALUResultM, Rs, InstrD,
		  PCSrcE, RegWriteE,
		  MemtoRegE, MemWriteE, BranchTakenE, RdE, RA1E, RA2E, ALUResultE, WriteDataE, Instr27_26, Instr6_5,
		  byteEnableD, byteEnableE); //WORK HERE

	// Memory
	mempipereg memReg(clk, reset, PCSrcE, RegWriteE, MemtoRegE, MemWriteE, RdE,
			  ALUResultE, WriteDataE, Instr27_26, Instr6_5, byteEnableE, PCSrcM, RegWriteM, MemtoRegM, MemWriteM,
			  RdM, ALUResultM, WriteDataM, Instr27_26M, Instr6_5M, byteEnable);

	// Write Back
	wbpipereg wbReg(clk, reset, PCSrcM, RegWriteM, MemtoRegM, RdM,
			ALUResultM, ReadDataM, PCSrcW, RegWriteW, MemtoRegW, RdW,
			ALUResultW, ReadDataW);

	// Write Back mux
	mux2 #(32) wbmux(ALUResultW, ReadDataW, MemtoRegW, ResultW);
	
	// Hazard Detection Unit
	hazardunit hUnit(clk, RegWriteM, RegWriteW, RA1E, RA2E, RdM, RdW, forwardAE, forwardBE, (MemtoRegE && RegWriteE), RA1, RA2, RdE, PCSrcD, PCSrcE, PCSrcM,
			 PCSrcW, BranchTakenE, StallF, StallD, FlushD, FlushE);
	

endmodule
