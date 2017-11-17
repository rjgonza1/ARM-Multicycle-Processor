module controller(input logic clk,reset, 
		input logic [31:12] Instr,
		input logic [11:0] Src2, 
		input logic [3:0] ALUFlags,
		output logic [3:0] StatusRegister, 
		output logic [1:0] RegSrc, 
		output logic RegWrite, 
		output logic [1:0] ImmSrc, 
		output logic ALUSrc, 
		output logic [3:0] ALUControl, 
		output logic MemWrite, MemtoReg, 
		output logic PCSrc,
		output logic [3:0] byteEnable,
		output logic branch_link);

	logic [1:0] FlagW; 
	logic PCS, RegW, MemW;

	decoder dec(	Instr[27:26], Instr[25:20], Instr[15:12], Src2,
			FlagW, PCS, RegW, MemW, MemtoReg, ALUSrc,
			ImmSrc, RegSrc, ALUControl, byteEnable, branch_link
			);

	condlogic cl(clk, reset, Instr[31:28],
			ALUFlags, StatusRegister, FlagW, PCS, RegW, MemW, 
			PCSrc, RegWrite, MemWrite
		);
endmodule
