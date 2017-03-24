module pipereg(
    input logic clk, reset, PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, 
    input logic [1:0] FlagWriteD,
    input logic [3:0] ALUControlD, CondD, RdD, Rd1D, Rd2D, RsShiftD, ExtD, // removed Flags from here
    output logic PCSrcE, RegWriteE, MemtoRegE, MemWriteE, ALUSrcE,
    output logic [1:0] FlagWriteE,
    output logic [3:0] ALUControlE, CondE, RdE, Rd1E, Rd2E, RsShiftE, ExtE // removed FlagsE from here
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
            RdD <= 4'b0000;
            Rd1E <= 3'b000;
            Rd2D <= 3'b000;
            RsShiftD <= 3'b000;
            ExtD <= 3'b000;
        else
            PCSrceE <= PCSrcD;
            RegWriteE <= RegWriteD;
            MemtoRegE <= MemtoRegD;
            MemWriteE <= MemWriteD;
            ALUSrcE <= ALUSrcD;
            FlagWriteE <= FlagWriteD;
            ALUControlE <= ALUControlD;
            CondE <= CondD;
            RdE <= RdD
            Rd1E <= Rd1D;
            Rd2E <= Rd2D;
            RsShiftE <= RsShiftD;
            ExtE <= ExtD;
endmodule
