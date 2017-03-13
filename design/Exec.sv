module Exec(
	input logic PCSrcD,
	input logic RegWriteD,
	input logic MemtoRegD,
	input logic MemWriteD,
	input logic ALUControlD,
	input logic ALUSrcD,
	input logic FlagWriteD,
	input logic ImmSrcD);

	flopr EReg #(/*TODO find out actual size of this flop*/);
endmodule
