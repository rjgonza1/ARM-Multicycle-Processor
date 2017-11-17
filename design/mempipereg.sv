module mempipereg(
    input logic clk, reset, PCSrcE, RegWriteE, MemtoRegE, MemWriteE, 
    input logic [3:0] RdE,
    input logic [31:0] ALUResultE, WriteDataE,
    input logic [1:0] Instr27_26, Instr6_5,
    input logic [3:0] byteEnableE, 
    output logic PCSrcM, RegWriteM, MemtoRegM, MemWriteM,
    output logic [3:0] RdM,
    output logic [31:0] ALUResultM, WriteDataM,
    output logic [1:0] Instr27_26M, Instr6_5M,
    output logic [3:0] byteEnableM
    );

    always_ff @(posedge clk, posedge reset)
      begin
         if (reset)
	   begin
            PCSrcM <= 1'bx;
            RegWriteM <= 1'bx;
            MemtoRegM <= 1'bx;
            MemWriteM <= 1'bx;
            RdM <= 4'bx;
            ALUResultM <= 32'bx;
            WriteDataM <= 32'bx;
	    Instr27_26M <= 2'bx;
	    Instr6_5M <= 2'bx;
	    byteEnableM <= 4'bx;
	   end
         else
	   begin
            PCSrcM <= PCSrcE;
            RegWriteM <= RegWriteE;
            MemtoRegM <= MemtoRegE;
            MemWriteM <= MemWriteE;
            RdM <= RdE;
            ALUResultM <= ALUResultE;
            WriteDataM <= WriteDataE;
	    Instr27_26M <= Instr27_26;
	    Instr6_5M <= Instr6_5;
	    byteEnableM <= byteEnableE;
	 end
      end
endmodule
