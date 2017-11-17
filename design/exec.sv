module exec(
	input logic clk, reset, FlushE,
	input logic PCSrcD,
	input logic RegWriteD,
	input logic MemtoRegD,
	input logic MemWriteD,
	input logic [3:0] ALUControlD,
	input logic BranchD,
	input logic ALUSrcD,
	input logic [1:0] FlagWriteD,
	input logic [3:0] CondD,
	input logic [3:0] RdD, RA1, RA2,
	input logic [31:0] Rd1D, Rd2D, ExtD,
	input logic [1:0] forwardAE, forwardBE,
	input logic [31:0] ResultW, ALUResultM,
	input logic [31:0] Rs,
	// shifter input logic
	input logic [31:0] InstrD,
	    
	output logic PCSrcE, // send branch bit out of Exec stage
	output logic RegWriteE,
	output logic MemtoRegE,
	output logic MemWriteE,
	output logic BranchTakenE,
	output logic [3:0] RdE, RA1E, RA2E,
	output logic [31:0] ALUResultE,
	output logic [31:0] WriteDataE,
	output logic [1:0] Instr27_26, Instr6_5,
	input logic [3:0] byteEnableD,
	output logic [3:0] byteEnableE
	);

	// internal signal declarations
	logic ALUSrcE, ImmSrcE, BranchE;
	logic [1:0] FlagWriteE;
	logic [3:0] WriteAddrE, CondE, ALUControlE, Flags;
	logic [31:0] Rd1E, Rd2E, ExtE, InstrE, RsE;

		logic [31:0] OpA, OpB, nonImmOpB;
		logic [3:0] ALUFlags;
		// signal for shifter output
		logic [31:0] ShiftOut;
		logic ShiftCarry;
		logic PCS, RegWE, MemWE;
   

	// Assignments and logic
	
		assign WriteDataE = ShiftOut; 	// shiftOut is the shifter output
		assign Instr27_26 = InstrE[26:26];
		assign Instr6_5 = InstrE[6:5];

	// declaring other modules
		// I did not include Flags in Exec.sv because the flags
		// already get delayed by 1 clock cycle in the condlogic.sv.
		// If this is not correct, add flags as an input port and
		// include flags into this pipereg below. -Julian
		//Thanks Julian -Noah
	pipereg eReg (clk, reset, FlushE, PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, 
				FlagWriteD, ALUControlD, CondD, RdD, RA1, RA2, Rd1D, Rd2D, Rs, ExtD, InstrD, byteEnableD, BranchD,
				PCS, RegWE, MemtoRegE, MemWE, ALUSrcE, FlagWriteE, ALUControlE, CondE, RdE, RA1E, RA2E,
				Rd1E, Rd2E, RsE, ExtE, InstrE, byteEnableE, BranchE);
		
		// INPUT clk, reset, [3:0] cond, [3:0] ALUFlags
		// INPUT [1:0] FlagW, PCS, RegW, MemW,
		// OUTPUT PCSrc, RegWrite, MemWrite
	condlogic cond (clk, reset, CondE, ALUFlags, Flags, FlagWriteE, PCS, RegWE, MemWE, BranchE, PCSrcE,
		       RegWriteE, MemWriteE, BranchTakenE); 
		
		// INPUT [31:0] Rm, [7:0] RsShift, Immediate, [1:0] Sh, [4:0] Shamt, IsRegister, Carry
		// OUTPUT [31:0] Result, ShiftCarry,
		// INPUT [3:0] ALUControl
   shifter shft (nonImmOpB, RsE[7:0], InstrE[25], InstrE[6:5], InstrE[11:7], InstrE[4], Flags[1], 
				ShiftOut, ShiftCarry, ALUControlE);
		
		// mux
		mux3 #(32) m1(Rd1E, ResultW, ALUResultM, forwardAE, OpA);
		mux3 #(32) m2(Rd2E, ResultW, ALUResultM, forwardBE, nonImmOpB);
		mux2 #(32) m3(ShiftOut, ExtE, ALUSrcE, OpB);

	alu a(OpA, OpB, ALUControlE, ALUResultE, ALUFlags, shiftCarry);

endmodule
