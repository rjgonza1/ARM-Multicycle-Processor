module wbPipereg(
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
            PCSrcW <= 0;
            RegWriteW <= 0;
            MemtoRegW <= 0;
            RdW <= 4'b0000;
            ALUResultW <= 32'b0;
            ReadDataW <= 32'b0;
            end
        else
            begin
            PCSrcW <= PCSrcM;
            RegWriteW <= RegWritM;
            MemtoRegW <= MemtoRegM;
            RdW <= RdM;
            ALUResultW <= ALUResultM;
            ReadDataW <= ReadDataM;
            end
    end 
endmodule
