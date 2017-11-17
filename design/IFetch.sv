module IFetch(
	input logic clk, reset, StallF,
	input logic [31:0] PC,	// Next PC value
	output logic [31:0] PCF, PCPlus4F);

	flopr #(32) IFReg((clk && ~stall), reset, PC, PCF);

	adder #(32) IFAdd(PCF, 32'b100, PCPlus4F);

endmodule
