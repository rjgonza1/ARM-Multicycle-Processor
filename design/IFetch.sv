module IFetch(
	input logic clk,
	input logic [31:0] PC,
	output logic [31:0] InstrF, PCPlus4F);
	
	logic [31:0] PCF;
	
	flopr #(32) IFReg(clk, 1'b0, PC, PCF);

	imem imem(PCF, InstrFetch);

	adder #(32) IFAdd(PCF, 32'b100, PCPlus4F)

endmodule
