module pipereg(
    input logic clk, reset, PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, 
    input logic [1:0] FlagWriteD,
    input logic [3:0] ALUControlD, Flags, CondD, RdD,
    input logic [31:0] SrcAD, ShiftSourceD, ExtImmD,
    output logic PCSrcE, RegWriteE, MemtoRegE, MemWriteE, ALUSrcE,
    output logic [1:0] FlagWriteE,
    output logic [3:0] ALUControlE, CondE, FlagsE, RdE
    output logic [31:0] SrcAE, ShiftSourceE, ExtImmE
    );

    always_ff @(posedge clk, posedge reset)
         if (reset)
            PCSrcE <= 0;
            RegWriteE <= 0;
            MemtoRegE <= 0;
            MemWriteE <= 0;
            ALUSrcE <= 0;
            FlagWriteE <= 2'b00;
            ALUControlE <= 4'b0000;
            CondE <= 4'b0000;
            FlagsE <= 4'b0000;
	    RdE <= 4'b0000;
	    SrcAE <= 32'b0;
	    ShiftSourceE <= 32'b0;
	    ExtImmE <= 32'b0;
        else
            PCSrceE <= PCSrcD;
            RegWriteE <= RegWriteD;
            MemtoRegE <= MemtoRegD;
            MemWriteE <= MemWriteD;
            ALUSrcE <= ALUSrcD;
            FlagWriteE <= FlagWriteD;
            ALUControlE <= ALUControlD;
            CondE <= CondD;
            FlagsE <= FlagsD;
	    RdE <= RdD;
	    SrcAE <= SrcAD;
	    ShiftSourceE <= ShiftSourceD;
	    ExtImmE <= ExtImmD;
endmodule
