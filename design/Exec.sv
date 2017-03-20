module Exec(
	input logic PCSrcD,
	input logic RegWriteD,
	input logic MemtoRegD,
	input logic MemWriteD,
	input logic ALUControlD,
	input logic ALUSrcD,
	input logic FlagWriteD,
	input logic ImmSrcD,
	input logic [3:0] WriteAddrD,
	input logic [31:0] Rd1D, Rd2D, ExtD,
	input logic [1:0] forwardAE, forwardBE,
	input logic [31:0] ALUResultM,
	input logic [31:0] ResultW,
	output logic PCSrcE,
	output logic RegWriteE,
	output logic MemtoRegE,
	output logic MemWriteE,
	output logic [31:0] ALUResultE,
	output logic [31:0] WriteDataE,
	output logic [3:0] WriteAddrE
	);

	// internal signal declarations
		logic 	PCSrcE, RegWriteE, MemtoRegE, MemWriteE, 
			ALUControlE, ALUSrcE, FlagWriteE, ImmSrcE;
		logic [3:0] WriteAddrE;
		logic [31:0] Rd1E, Rd2E, ExtE;

		logic [31:0] OpA, OpB, nonImmOpB;
		logic [3:0] ALUFlags;
		logic carryIn;

	// Assignments and logic
	
		MemtoRegM <= MemtoRegD;
		WriteAddrM <= WriteAddrD;
		WriteDataM <= nonImmOpB;

	// declaring other modules

		flopr EReg #(/*TODO find out actual size of this flop*/);

		mux3 m1(Rd1E, ResultW, ALUResultM, forwardAE, OpA);
		mux3 m2(Rd2E, ResultW, ALUResultM, forwardBE, nonImmOpB);
		mux2 m3(nonImmOpB, ExtE, ALUSrcE, OpB);

		alu a(OpA, OpB, ALUControlE, ALUResultE, ALUFlags, carryIn);

endmodule
