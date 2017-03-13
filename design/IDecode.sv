module IDecode(
	input logic clk, reset, RegWriteW,
	input logic [31:0] InstrF, PCPlus8, ResultW,
     output logic MemWriteD, MemtoRegD, PCSrcD, ALUSrcD, RegWriteD,   
	output logic [1:0] FlagWriteD, 
	output logic [3:0] byteEnable, ALUControlD,   
	output logic [31:0] SrcAD, ShiftSource, ExtImmD, Rs
	);

	logic [3:0] RA1, RA2;
	logic [1:0] RegSrcD, ImmSrcD;
	logic branch_link;

// flop
	flopr #(32) IDReg(clk, reset, InstrF, InstD);

// decoder
	decoder dec(InstrD[27:26], InstrD[25:20], InstrD[15:12], InstrD[11:0],
			FlagWriteD, PCSrcD, RegWriteD, MemWriteD, MemtoRegD, ALUSrcD,
			ImmSrcD, RegSrcD, ALUControlD, byteEnable, branch_link);

// register file logic 
	mux2 #(4) ra1mux(InstrD[19:16], 4'b1111, RegSrcD[0], RA1); 
	mux2 #(4) ra2mux(InstrD[3:0], InstrD[15:12], RegSrcD[1], RA2); 

	regfile rf(clk, RegWriteW, RA1, RA2, InstrD[11:8], InstrD[15:12], ResultW, 
			PCPlus8, SrcAD, ShiftSource, Rs, branch_link);

// extender     
	extend ext(InstrD[23:0], ImmSrcD, ExtImmD);
endmodule
