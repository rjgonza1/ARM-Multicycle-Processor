module pipereg(
    input logic clk, reset, FlushE, PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, 
    input logic [1:0] FlagWriteD,
    input logic [3:0] ALUControlD, CondD, RdD, RA1, RA2, 
    input logic [31:0]  Rd1D, Rd2D, RsShiftD, ExtD, InstrD, // removed Flags from here
    input logic [3:0] byteEnableD, 
    input logic BranchD,
    output logic PCSrcE, RegWriteE, MemtoRegE, MemWriteE, ALUSrcE,
    output logic [1:0] FlagWriteE,
    output logic [3:0] ALUControlE, CondE, RdE, RA1E, RA2E, 
    output logic [31:0] Rd1E, Rd2E, RsShiftE, ExtE, InstrE, // removed FlagsE from here
    output logic [3:0] byteEnableE, 
    output logic BranchE
    );

    always_ff @(posedge clk, posedge reset)
      begin
         if (reset)
	   begin
            PCSrcE <= 1'bx;
            RegWriteE <= 1'bx;
            MemtoRegE <= 1'bx;
            MemWriteE <= 1'bx;
            ALUSrcE <= 1'bx;
            FlagWriteE <= 2'bx;
            ALUControlE <= 4'bx;
            CondE <= 4'bx;
            RdE <= 4'bx;
            RA1E <= 4'bx;
            RA2E <= 4'bx;
            Rd1E <= 32'bx;
            Rd2E <= 32'bx;
            RsShiftE <= 32'bx;
            ExtE <= 32'bx;
	    InstrE <= 32'bx;
	    byteEnableE <= 4'bx;
	    BranchE <= 4'bx;	      
	   end
         else if (FlushE)
	   begin
	    PCSrcE <= PCSrcD;
            RegWriteE <= RegWriteD;
            MemtoRegE <= MemtoRegD;
            MemWriteE <= MemWriteD;
            ALUSrcE <= ALUSrcD;
            FlagWriteE <= FlagWriteD;
            ALUControlE <= ALUControlD;
            CondE <= CondD;
            RdE <= 4'bx;
            RA1E <= 4'bx;
            RA2E <= 4'bx;
            Rd1E <= 32'bx;
            Rd2E <= 32'bx;
            RsShiftE <= 32'bx;
            ExtE <= 32'bx;
	    InstrE <= 32'bx;
	    byteEnableE <= 4'bx;
	    BranchE <= BranchD;  
	   end
	 else
	   begin
            PCSrcE <= PCSrcD;
            RegWriteE <= RegWriteD;
            MemtoRegE <= MemtoRegD;
            MemWriteE <= MemWriteD;
            ALUSrcE <= ALUSrcD;
            FlagWriteE <= FlagWriteD;
            ALUControlE <= ALUControlD;
            CondE <= CondD;
            RdE <= RdD;
            RA1E <= RA1;
            RA2E <= RA2;
            Rd1E <= Rd1D;
            Rd2E <= Rd2D;
            RsShiftE <= RsShiftD;
            ExtE <= ExtD;
	    InstrE <= InstrD;
	    byteEnableE <= byteEnableD;
	    BranchE <= BranchD;	      
	   end
      end
endmodule
