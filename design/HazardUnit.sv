module HazardUnit (
	input logic clk,
//////////////////////////////forwarding
	input logic RegWriteM, RegWriteWB,
	input logic [3:0] ra1E, ra2E, wa3M, wa3WB,
	output logic [1:0] forwardaE, forwardbE,
//////////////////////////////forwarding

//////////////////////////////stalling
	input logic MemtoRegE,
	input logic [3:0] ra1D, ra2D, wa3E,
	input logic PCSrcD, PCSrcE, PCSrcE, PCSrcM, PCSrcWB,
	input logic BranchTakenE,
	output logic StallF, StallD,
	output logic FlushD, FlushE);
//////////////////////////////stalling

	logic ldrStallD;
	logic PCWrPendingF;

//////////////////////////////forwarding
	if (RegWriteM && (ra1E == wa3M))
		forwardaE = 2'b10;
	else if (RegWriteM && (ra1E == wa3WB))
		forwardaE = 2'b01;
	else
		forwardaE = 2'b00;
	
	if (RegWriteM && (ra2E == wa3M))
		forwardbE = 2'b10;
	else if (RegWriteM && (ra2E == wa3WB))
		forwardbE = 2'b01;
	else
		forwardbE = 2b00;
//////////////////////////////forwarding

//////////////////////////////stalling
	ldrStallD = ((ra1D == wa3E) | (ra2D == wa3E)) && MemtoRegE;
	PCWrPendingF = PCSrcD | PCSrcE | PCSrcM;
	
	StallF = ldrStallD | PCWrPendingF;
	FlushD = PCWrPendingF | PCSrcWB | BranchTakenE;
	FlushE = ldrStallD + BranchTakenE;
	StallD = ldrStallD; 
//////////////////////////////stalling
endmodule
