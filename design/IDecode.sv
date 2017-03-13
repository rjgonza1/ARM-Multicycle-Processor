module IDecode(
     input logic clk,
     input logic [31:0] InstrF, PCPlus8, ResultW,
     input logic RegWriteW, 
     output logic [1:0] FlagWriteD, 
    	output logic MemWriteD, MemtoRegD, PCSrcD, ALUSrcD, RegWriteD, Rs,
    	output logic [3:0] byteEnable, ALUControlD,   
     output logic [31:0] SrcAD, SrcBD, ExtImmD,
//   output logic BranchD   implement this when decoder is changed to output BranchD
     );

    logic [3:0] RA1, RA2;
    logic [1:0] RegSrcD, ImmSrcD;
    logic branch_link;

// flop
   //still have to implment flop

// decoder
    decoder dec(InstrF[27:26], InstrF[25:20], InstrF[15:12], InstrF[11:0],
			FlagWriteD, PCSrcD, RegWriteD, MemWriteD, MemtoRegD, ALUSrcD,
			ImmSrcD, RegSrcD, ALUControlD, byteEnable, branch_link
			);
// decoder neeeds to be changed, needs to output branch

// register file logic 
	mux2 #(4) ra1mux(InstrF[19:16], 4'b1111, RegSrcD[0], RA1); 
	mux2 #(4) ra2mux(InstrF[3:0], InstrF[15:12], RegSrcD[1], RA2); 

	regfile rf(clk, RegWriteW, RA1, RA2, InstrF[11:8], InstrF[15:12], ResultW, PCPlus8, SrcAD, ShiftSource, Rs, branch_link);

// extender     
	extend ext(InstrF[23:0], ImmSrcD, ExtImmD);

