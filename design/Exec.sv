module Exec(
	input logic clk, reset,
	input logic PCSrcD,
	input logic RegWriteD,
	input logic MemtoRegD,
	input logic MemWriteD,
	input logic [3:0] ALUControlD,
	input logic BranchD,
	input logic ALUSrcD,
	input logic [1:0] FlagWriteD,
	input logic ImmSrcD,
	input logic [3:0] CondD,
	input logic [3:0] WriteAddrD,
	input logic [31:0] Rd1D, Rd2D, ExtD,
	input logic [1:0] forwardAE, forwardBE,
	input logic [31:0] ALUResultM,
	input logic [31:0] ResultW,
	output logic PCSrcM,
	output logic RegWriteM,
	output logic MemtoRegM,
	output logic MemWriteM,
	output logic [31:0] ALUResultM,
	output logic [31:0] WriteDataM,
	output logic [3:0] WriteAddrM
	);

	// internal signal declarations
		logic 	PCSrcE, RegWriteE, MemWriteE, MemtoRegE, 
			ALUSrcE, FlagWriteE, ImmSrcE, BranchE;
		logic [1:0] FlagWriteE;
		logic [3:0] WriteAddrE, CondE, ALUControlE;
		logic [31:0] Rd1E, Rd2E, ExtE;

		logic [31:0] OpA, OpB, nonImmOpB;
		logic [3:0] ALUFlags;
		logic carryIn;

	// Assignments and logic
	
		MemtoRegM <= MemtoRegE;
		WriteAddrM <= WriteAddrE;
		WriteDataM <= nonImmOpB;

	// declaring other modules

		pipereg reg (clk, reset, PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, 
				FlagWriteD, ALUControlD, );
		
		// INPUT clk, reset, [3:0] cond, [3:0] ALUFlags
		// INPUT [1:0] FlagW, PCS, RegW, MemW,
		// OUTPUT PCSrc, RegWrite, MemWrite
		condlogic cond (clk, reset, condE, ALUFlags, FlagWriteE, PCSrcE, RegWriteE, MemWriteE, BranchE,
				PCSrcM, RegWriteM, MemWriteM); 

		mux3 m1(Rd1E, ResultW, ALUResultM, forwardAE, OpA);
		mux3 m2(Rd2E, ResultW, ALUResultM, forwardBE, nonImmOpB);
		mux2 m3(nonImmOpB, ExtE, ALUSrcE, OpB);

		alu a(OpA, OpB, ALUControlE, ALUResultE, ALUFlags, carryIn);

endmodule
