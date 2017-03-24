module arm(	input logic clk, reset,
		output logic [31:0] PC,
		input logic [31:0] Instr,
		output logic [3:0] byteEnable,
		output logic MemWrite,
		output logic [31:0] ALUResult, WriteData,
		input logic [31:0] ReadData
	);

// 	logic [3:0] ALUFlags;
// 	logic [3:0] StatusRegister;
// 	logic RegWrite, ALUSrc, MemtoReg, PCSrc;
// 	logic [1:0] RegSrc, ImmSrc;
// 	logic [3:0] ALUControl;
// 	logic branch_link;
	// add byteEnable as output of controller later

// 	controller c(clk, reset, Instr[31:12], Instr[11:0], ALUFlags, StatusRegister,
// 			RegSrc, RegWrite, ImmSrc, ALUSrc, ALUControl,
// 			MemWrite, MemtoReg, PCSrc, byteEnable, branch_link);

// 	datapath dp(clk, reset, 
// 			RegSrc, RegWrite, ImmSrc, ALUSrc, ALUControl,
// 			MemtoReg, PCSrc, ALUFlags, StatusRegister, PC, Instr, ALUResult,
// 			WriteData, ReadData, branch_link);

	pipeDatapath dp(clk, reset, MemWrite, byteEnable, Instr, ReadData, PC, ALUResult, WriteData);
	
endmodule
