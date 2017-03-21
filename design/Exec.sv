module Exec(
	input logic clk, reset, stall, PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, 
     input logic [1:0] FlagWriteD,
	input logic [3:0] ALUControlD, CondD, RdD,
     input logic [31:0] SrcAD, ShiftSourceD, ExtImmD, Rs,
     output logic PCSrcE, RegWriteE, MemtoRegE, MemWriteE,
     output logic [3:0] RdE,
     output logic [31:0] ALUResultE, WriteDataE
	);

     logic ALUSrcE;
     logic [1:0] FlagWriteE;
     logic [3:0] ALUControlE, CondE, FlagsE, Flags;
     logic [31:0] SrcAE, ShiftSourceE, ExtImmE;

     pipereg EReg((clk & ~stall), reset, PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, FlagWriteD,
                 ALUControlD, Flags, CondD, RdD, SrcAD, ShiftSourceD, ExtImmD, PCSrcE,
                 RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, FlagWriteE, ALUControlE, 
                 CondE, FlagsE, RdE, SrcAE, ShiftSourceE, ExtImmE 
                 );
endmodule
