module wbpipereg(
    input logic clk, reset, PCSrcM, RegWriteM, MemtoRegM, 
    input logic [3:0] RdM,
    input logic [31:0] ALUResultM, ReadDataM,
    output logic PCSrcW, RegWriteW, MemtoRegW,
    output logic [3:0] RdW,
    output logic [31:0] ALUResultW, ReadDataW
    );

    always_ff @(posedge clk, posedge reset)
      begin
         if (reset)
	   begin
            PCSrcW <= 1'bx;
            RegWriteW <= 1'bx;
            MemtoRegW <= 1'bx;
            RdW <= 4'bx;
            ALUResultW <= 32'bx;
            ReadDataW <= 32'bx;
	   end
         else
	   begin
            PCSrcW <= PCSrcM;
            RegWriteW <= RegWriteM;
            MemtoRegW <= MemtoRegM;
            RdW <= RdM;
            ALUResultW <= ALUResultM;
            ReadDataW <= ReadDataM;
	   end
      end
endmodule
