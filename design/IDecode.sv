module IDecode(
	input logic clk, reset, RegWriteW, stall,
	input logic [31:0] InstrF, PCPlus8, ResultW,
     	output logic MemWriteD, MemtoRegD, PCSrcD, ALUSrcD, RegWriteD,   
	output logic [1:0] FlagWriteD, 
	output logic [3:0] byteEnable, ALUControlD, RdD, CondD, RA1, RA2,   
	output logic [31:0] SrcAD, ShiftSourceD, ExtImmD, Rs
	);
	
	logic [1:0] RegSrcD, ImmSrcD;
	logic branch_link;

// flop
	flopr #(32) IDReg((clk & ~stall), reset, InstrF, InstD);

// decoder
	decoder dec(InstrF[27:26], InstrF[25:20], InstrF[15:12], InstrF[11:0],
			FlagWriteD, PCSrcD, RegWriteD, MemWriteD, MemtoRegD, ALUSrcD,
			ImmSrcD, RegSrcD, ALUControlD, byteEnable, branch_link);

// register file logic 
	mux2 #(4) ra1mux(RA1D, 4'b1111, RegSrcD[0], RA1); 
	mux2 #(4) ra2mux(RA2D, InstrF[15:12], RegSrcD[1], RA2); 

	regfile rf(clk, RegWriteW, RA1, RA2, InstrF[11:8], InstrF[15:12], ResultW, 
			PCPlus8, SrcAD, ShiftSourceD, Rs, branch_link);

// extender     
	extend ext(InstrF[23:0], ImmSrcD, ExtImmD);

// pass Rd through the pipeline stages
     assign RdD = InstrF[15:12];
     assign CondD = InstrF[31:28];
endmodule
