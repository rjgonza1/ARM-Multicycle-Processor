module decoder_tb;
	logic [31:0] Instr;

	wire [1:0] FlagW_tb;
	wire PCS_tb, RegW_tb, MemW_tb;
	wire MemtoReg_tb, ALUSrc_tb;
	wire [1:0] ImmSrc_tb, RegSrc_tb;
	wire [3:0] ALUControl_tb;
	wire [3:0] ByteEnable_tb;
	wire BLSrc_tb;
decoder D1(
	.Op(Instr[27:26]),
	.Funct(Instr[25:20]),
	.Rd(Instr[15:12]),
	.Src2(Instr[11:0]),
	.FlagW(FlagW_tb),
	.PCS(PCS_tb),
	.RegW(RegW_tb),
	.MemW(MemW_tb),
	.MemtoReg(MemtoReg_tb),
	.ALUSrc(ALUSrc_tb),
	.ImmSrc(ImmSrc_tb),
	.RegSrc(RegSrc_tb),
	.ALUControl(ALUControl_tb),
	.ByteEnable(ByteEnable_tb),
	.BLSrc(BLSrc_tb)
);

	initial begin
		Instr = 32'b00000010100010011001000000000001;
		#100;
		Instr = 32'b11100001010100100000000000000110;
		#100;
	end
endmodule	
