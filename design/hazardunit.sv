module hazardunit (
//////////////////////////////forwarding	 
	input logic clk, RegWriteM, RegWriteWB,
	input logic [3:0] ra1E, ra2E, wa3M, wa3WB,
	output logic [1:0] forwardaE, forwardbE,
//////////////////////////////forwarding

//////////////////////////////stalling
	input logic MemtoRegE,
	input logic [3:0] ra1D, ra2D, wa3E,
	input logic PCSrcD, PCSrcE, PCSrcM, PCSrcWB,
	input logic BranchTakenE,
	output logic StallF, StallD,
	output logic FlushD, FlushE);
//////////////////////////////stalling

	logic ldrStallD;
	logic PCWrPendingF;

//////////////////////////////forwarding

   always_comb
     begin
	if (RegWriteM && (ra1E == wa3M))
		forwardaE = 2'b10;
	else if (RegWriteWB && (ra1E == wa3WB))
		forwardaE = 2'b01;
	else
		forwardaE = 2'b00;
	
	if (RegWriteM && (ra2E == wa3M))
		forwardbE = 2'b10;
	else if (RegWriteWB && (ra2E == wa3WB))
		forwardbE = 2'b01;
	else
		forwardbE = 2'b00;
	
//////////////////////////////forwarding
	end
//////////////////////////////stalling
	always_ff @(negedge clk)
	begin
	ldrStallD = ((ra1D === wa3E) || (ra2D === wa3E)) && (MemtoRegE === 1);
        PCWrPendingF = (PCSrcD === 1) || (PCSrcE === 1) || (PCSrcM === 1);
	
	StallF = ldrStallD || PCWrPendingF;
	FlushD = PCWrPendingF || (PCSrcWB === 1) || (BranchTakenE === 1);
	FlushE = ldrStallD || (BranchTakenE === 1);
	StallD = ldrStallD;

	end
//////////////////////////////stalling
endmodule
