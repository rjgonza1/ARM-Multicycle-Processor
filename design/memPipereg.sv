module memPipereg(
    input logic clk, reset, PCSrcE, RegWriteE, MemtoRegE, MemWriteE, 
    input logic [3:0] RdE,
    input logic [31:0] ALUResultE, WriteDataE,
    output logic PCSrcM, RegWriteM, MemtoRegM, MemWriteM,
    output logic [3:0] RdM,
    output logic [31:0] ALUResultM, WriteDataM
    );

    always_ff @(posedge clk, posedge reset)
    begin
         if (reset)
            begin
            PCSrcM <= 0;
            RegWriteM <= 0;
            MemtoRegM <= 0;
            MemWriteM <= 0;
            RdM <= 4'b0000;
            ALUResultM <= 32'b0;
            WriteDataM <= 32'b0;
            end
        else
            begin
            PCSrcM <= PCSrcE;
            RegWriteM <= RegWriteE;
            MemtoRegM <= MemtoRegE;
            MemWriteM <= MemWriteE;
            RdM <= RdE;
            ALUResultM <= ALUResultE;
            WriteDataM <= WriteDateE;
            end
    end
endmodule
