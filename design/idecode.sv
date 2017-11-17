module idecode(
	input logic clk, reset, FlushD,
	input logic [3:0] RdW,
	input logic RegWriteW, StallD,
	input logic [31:0] InstrF, PCPlus8, ResultW,
     	output logic MemWriteD, MemtoRegD, PCSrcD, ALUSrcD, RegWriteD,   
	output logic [1:0] FlagWriteD, 
	output logic [3:0] byteEnable, ALUControlD, RdD, CondD, RA1, RA2,   
	output logic [31:0] SrcAD, ShiftSourceD, ExtImmD, Rs,
	output logic BranchD,
	output logic [31:0] InstrD
	);
	
	logic [1:0] RegSrcD, ImmSrcD;
	logic branch_link;
   

// flop

   always_ff @(posedge clk, posedge reset)
     if (StallD);
     else if (reset || FlushD) InstrD <= 32'bx;
     else InstrD <= InstrF;
   
//     flopr #(32)IDReg((clk & ~stall), reset, InstrF, InstrD);

// decoder
	decoder dec(InstrD[27:26], InstrD[25:20], InstrD[15:12], InstrD[11:0],
			FlagWriteD, PCSrcD, RegWriteD, MemWriteD, MemtoRegD, ALUSrcD,
			ImmSrcD, RegSrcD, ALUControlD, byteEnable, BranchD, branch_link);

// register file logic 
	mux2 #(4) ra1mux(InstrD[19:16], 4'b1111, RegSrcD[0], RA1); 
	mux2 #(4) ra2mux(InstrD[3:0], InstrD[15:12], RegSrcD[1], RA2); 

	regfile rf(clk, RegWriteW, RA1, RA2, InstrD[11:8], RdW, ResultW, 
			PCPlus8, SrcAD, ShiftSourceD, Rs, branch_link);

// extender     
	extend ext(InstrD[23:0], ImmSrcD, ExtImmD);

// pass Rd through the pipeline stages
     assign RdD = InstrD[15:12];
     assign CondD = InstrD[31:28];
endmodule
