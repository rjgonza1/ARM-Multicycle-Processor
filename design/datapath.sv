module datapath(input logic clk, reset, 
		input logic [1:0] RegSrc, 
		input logic RegWrite, 
		input logic [1:0] ImmSrc, 
		input logic ALUSrc,
		input logic [3:0] ALUControl, 
		input logic MemtoReg, 
		input logic PCSrc, 
		output logic [3:0] ALUFlags,
		input logic [3:0] StatusRegister,
		output logic [31:0] PC, 
		input logic [31:0] Instr, 
		output logic [31:0] ALUResult, WriteData,
		input logic [31:0] ReadData,
    		input logic branch_link //added bl noah

	);

	logic [31:0] PCNext, PCPlus4, PCPlus8; 
	logic [31:0] ExtImm, SrcA, SrcB, Result, Rs, ShiftSource; //added Rs and ShiftSource which will go to shift
	logic [3:0] RA1, RA2;
  logic ShiftCarry; //added ShiftCarry

	// next PC logic 
	mux2 #(32) pcmux(PCPlus4, Result, PCSrc, PCNext); 
	flopr #(32) pcreg(clk, reset, PCNext, PC); 
	adder #(32) pcadd1(PC, 32'b100, PCPlus4); 
	adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8);

	// register file logic 
	mux2 #(4) ra1mux(Instr[19:16], 4'b1111, RegSrc[0], RA1); 
	mux2 #(4) ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], RA2); 

	regfile rf(clk, RegWrite, RA1, RA2, Instr[11:8], Instr[15:12], Result, PCPlus8, SrcA, ShiftSource, Rs, branch_link); //added Instr[11:7] which is Rs -> outputs to Rs; ShiftSource -> shifter
	mux2 #(32) resmux(ALUResult, ReadData, MemtoReg, Result); 																													//also added bl noah
	extend ext(Instr[23:0], ImmSrc, ExtImm);
  
  // Shifter logic
  shifter sh(ShiftSource, Rs[7:0], Instr[25], Instr[6:5], Instr[11:7], Instr[4], StatusRegister[1], WriteData, ShiftCarry, ALUControl); //added shifter that shifts ShiftSource into WriteData

	// ALU logic 
	mux2 #(32) srcbmux(WriteData, ExtImm, ALUSrc, SrcB); 
	alu alu(SrcA, SrcB, ALUControl, ALUResult, ALUFlags, ShiftCarry); //ShiftCarry transfers carry from shifter to ALU

endmodule
