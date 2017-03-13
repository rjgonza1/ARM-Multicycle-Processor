module IFetch(
	input logic clk, reset, stall,
	input logic [31:0] PC,
	output logic [31:0] InstrF, PCPlus4F);
	
	logic [31:0] PCF;
	
	flopr #(32) IFReg((clk & ~stall), reset, PC, PCF);

	imem imem(PCF, InstrFetch);

	adder #(32) IFAdd(PCF, 32'b100, PCPlus4F)

endmodule
