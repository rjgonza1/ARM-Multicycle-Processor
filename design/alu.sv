module alu(
	input logic[31:0] SrcA,SrcB,
	input logic [3:0] ALUControl,
	output logic [31:0] ALUResult,
	output logic [3:0] ALUFlags,
	input logic CarryIn
	);

	logic[30:0] CarryExtend;

	always_comb
	begin
		ALUFlags = 4'b0;
		ALUResult = 32'd0;
		CarryExtend = 31'b0;

		case(ALUControl)
			/*arithmetic operations*/
			4'b0000:	// ADD
				begin
					{ALUFlags[1], ALUResult} = SrcA + SrcB;
					if (SrcA[31] & SrcB[31] & ~ALUResult[31])
						ALUFlags[0] = 1'b1;
					else if (~SrcA[31] & ~SrcB[31] & ALUResult[31])
						ALUFlags[0] = 1'b1;
					else
						ALUFlags[0] = 1'b0;
						ALUFlags[2] = &(~ALUResult);
						ALUFlags[3] = ALUResult[31];
				end
			4'b0001:	// SUB
				begin
					{ALUFlags[1], ALUResult} = SrcA - SrcB;
					if (SrcA[31] & ~SrcB[31] & ~ALUResult[31])
						ALUFlags[0] = 1'b1;
					else if (~SrcA[31] & SrcB[31] & ALUResult[31])
						ALUFlags[0] = 1'b1;
					else
						ALUFlags[0] = 1'b0;
						
					ALUFlags[2] = &(~ALUResult);
					ALUFlags[3] = ALUResult[31];
				end
			4'b0010:	// RSB
				begin
					{ALUFlags[1], ALUResult} = SrcB - SrcA;
					if (SrcB[31] & ~SrcA[31] & ~ALUResult[31])
						ALUFlags[0] = 1'b1;
					else if (~SrcB[31] & SrcA[31] & ALUResult[31])
						ALUFlags[0] = 1'b1;
					else
						ALUFlags[0] = 1'b0;
					
					ALUFlags[2] = &(~ALUResult);
					ALUFlags[3] = ALUResult[31];
				end
			4'b0011:	// ADC
				begin
					{ALUFlags[1], ALUResult} = SrcA + SrcB + {CarryExtend, CarryIn};
					if (SrcA[31] & SrcB[31] & ~ALUResult[31])
						ALUFlags[0] = 1'b1;
					else if (~SrcA[31] & ~SrcB[31] & ALUResult[31])
						ALUFlags[0] = 1'b1;
					else
						ALUFlags[0] = 1'b0;
					
					ALUFlags[2] = &(~ALUResult);
					ALUFlags[3] = ALUResult[31];
				end
			4'b0100:	// SBC
				begin
					{ALUFlags[1], ALUResult} = SrcA - SrcB - {CarryExtend, ~CarryIn};
					if (SrcA[31] & ~SrcB[31] & ~ALUResult[31])
						ALUFlags[0] = 1'b1;
					else if (~SrcA[31] & SrcB[31] & ALUResult[31])
						ALUFlags[0] = 1'b1;
					else
						ALUFlags[0] = 1'b0;

					ALUFlags[2] = &(~ALUResult);
					ALUFlags[3] = ALUResult[31];
				end
			4'b0101:	// RSC
				begin
					{ALUFlags[1], ALUResult} = SrcB - SrcA - {CarryExtend, ~CarryIn};
					if (SrcB[31] & ~SrcA[31] & ~ALUResult[31])
						ALUFlags[0] = 1'b1;
					else if (~SrcB[31] & SrcA[31] & ALUResult[31])
						ALUFlags[0] = 1'b1;
					else
						ALUFlags[0] = 1'b0;

					ALUFlags[2] = &(~ALUResult);
					ALUFlags[3] = ALUResult[31];
				end
      
			/*logical operations*/
			4'b1000:	// AND
				begin
					ALUResult = SrcA & SrcB;
					ALUFlags[0] = 1'b0;
					ALUFlags[1] = 1'b0;
					ALUFlags[2] = &(~ALUResult);
					ALUFlags[3] = ALUResult[31];
				end
			4'b1001:	// ORR
				begin
					ALUResult = SrcA | SrcB;
					ALUFlags[0] = 1'b0;
					ALUFlags[1] = 1'b0;
					ALUFlags[2] = &(~ALUResult);
					ALUFlags[3] = ALUResult[31];
				end
			4'b1010:	// EOR
				begin
					ALUResult = SrcA ^ SrcB;
					ALUFlags[0] = 1'b0;
					ALUFlags[1] = 1'b0;
					ALUFlags[2] = &(~ALUResult);
					ALUFlags[3] = ALUResult[31];
				end
			4'b1110:	//Bitwise Clear
				begin
					ALUResult = SrcA & ~SrcB;
					ALUFlags[0] = 1'b0;
					ALUFlags[1] = 1'b0;
				      	ALUFlags[2] = &(~ALUResult);
					ALUFlags[3] = ALUResult[31];
				end
			4'b1111:	//Bitwise Not
				begin
					ALUResult = ~SrcB;
					ALUFlags[0] = 1'b0;
					ALUFlags[1] = 1'b0;
					ALUFlags[2] = &(~ALUResult);
					ALUFlags[3] = ALUResult[31];
				end
			/*shift operations*/	/*Added shift with ALU flag updates*/
			4'b1101:
				begin
					ALUResult = SrcB;
					ALUFlags[0] = 1'b0;
					ALUFlags[1] = CarryIn;
					ALUFlags[2] = &(~ALUResult);
					ALUFlags[3] = ALUResult[31];
        end
			default:
			begin
				ALUResult = 32'bx;
				ALUFlags = 4'bx;
			end		
		endcase
	end
endmodule
