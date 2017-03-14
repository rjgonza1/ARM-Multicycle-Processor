module Exec(
	input logic clk, reset, PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, 
     input logic [1:0] FlagWriteD,
	input logic [3:0] ALUControlD, CondD, RdD,
     output logic PCSrcE, RegWriteE, MemtoRegE, MemWriteE,
     output logic [3:0] RdE,
     output logic [31:0] ALUResultE, WriteDataE
	);

     logic ALUSrcE;
     logic [1:0] FlagWriteE;
     logic [3:0] ALUControlE, CondE, FlagsE, Flags;

     pipereg EReg(clk, reset, PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, FlagWriteD,
                 ALUControlD, Flags, CondD, RdD, PCSrcE, RegWriteE, MemtoRegE, MemWriteE,
                 ALUSrcE, FlagWriteE, ALUControlE, CondE, FlagsE, RdE
                 );
endmodule
