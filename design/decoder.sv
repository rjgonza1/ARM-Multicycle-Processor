module decoder(
	input logic [1:0] Op,
	input logic [5:0] Funct,
	input logic [3:0] Rd,
	input logic [11:0] Src2,
	output logic [1:0] FlagW,
	output logic PCS, RegW, MemW,
	output logic MemtoReg, ALUSrc,
	output logic [1:0] ImmSrc, RegSrc, 
	output logic [3:0] ALUControl,
	output logic [3:0] ByteEnable,
	output logic BLSrc //added for bl noah
);

	logic [14:0] controls; //15 bits now noah
	logic Branch, ALUOp;

	// Main Decoder
	always_comb
	casex(Op)
		2'b00:
		begin
			if (Funct[5] || ~Funct[5] && ~Src2[4] || ~Funct[5] && ~Src2[7] && Src2[4])
				begin				
					controls = 15'b00000x0x0011111;
					controls[9] = Funct[5];
					controls[7] = ~(Funct[4:3] == 2'b10);
				end	
			else	//Extra Memory
				begin
					controls = 15'b0x011x1xx0000x1;
					controls[13] = ~Funct[0];
					controls[9] = Funct[2]; 
					controls[7] = Funct[0];
					controls[6] = ~Funct[0];
					controls[1] = (Src2[6:5] != 2'b10);
					//TODO add register indexing
	         		end
		end
		2'b01:
		begin
			controls = 15'b0x001x1xx00xxx1;
			controls[13] = ~Funct[0];
			controls[9] = ~Funct[5];	// determines 
			controls[7] = Funct[0];
			controls[6] = ~Funct[0];
			controls[3:1] = ~Funct[2]? 3'b111 : 3'b000;
			//TODO add shift operations
			//TODO add register indexing
		end
		2'b10:
		begin
			if (Funct[5])
				begin
					controls = 15'bx01101000100000;
					controls[14] = Funct[4];	//Funct[4] ~ 1:BL 0:B
				end
		end
		// Unimplemented
		default: controls = 15'bx;
	endcase
	
	assign {BLSrc, RegSrc, ImmSrc, ALUSrc, MemtoReg,
	RegW, MemW, Branch, ALUOp, ByteEnable} = controls; //added branch_link noah

	// ALU Decoder
	always_comb
	if (ALUOp)
		begin // which DP Instr?
			case(Funct[4:1])
				4'b0000: ALUControl = 4'b1000; // AND
				4'b0001: ALUControl = 4'b1010; // EOR
				4'b0010: ALUControl = 4'b0001; // SUB
				4'b0011: ALUControl = 4'b0010; // RSB
				4'b0100: ALUControl = 4'b0000; // ADD
				4'b0101: ALUControl = 4'b0011; // ADC
				4'b0110: ALUControl = 4'b0100; // SBC
				4'b0111: ALUControl = 4'b0101; // RSC
				4'b1000: ALUControl = 4'b1000; // TST
				4'b1001: ALUControl = 4'b1010; // TEQ
				4'b1010: ALUControl = 4'b0001; // CMP
				4'b1011: ALUControl = 4'b0000; // CMN
				4'b1100: ALUControl = 4'b1001; // ORR
				4'b1101: ALUControl = 4'b1101; // SHIFT OPERATION
				4'b1110: ALUControl = 4'b1110; // BIC
				4'b1111: ALUControl = 4'b1111; // MVN
				default: ALUControl = 4'bx; // unimplemented
			endcase
			// update flags if S bit is set (C & V only for arith)
			FlagW[1] = Funct[0];
			FlagW[0] = Funct[0] & ALUControl[3];
		end 
	else 
		begin
			ALUControl = 4'b0000; // add for non-DP instructions
			FlagW = 2'b00; // don't update Flags
		end
	// PC Logic
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule
