module shifter(
	input logic [31:0] Rm,
  input logic [7:0] RsShift,    //added this
  input logic Immediate,
  input logic [1:0] Sh,
  input logic [4:0] Shamt,
  input logic IsRegister, Carry,
  output logic [31:0] Result,
  output logic ShiftCarry,
  input logic [3:0] ALUControl
  );
  
  always_comb
      /*shift operations*/
      begin
      	if(ALUControl != 4'b1101)
        	begin
          	Result = Rm;
            ShiftCarry = Carry;
          end
      	/*Move*/
        else if (Immediate || (&(~Shamt) && &(~Sh) && ~IsRegister))
        	begin
         		Result = Rm;
          	ShiftCarry = Carry;
          end
        /*LSL*/
      	else if (~Immediate && &(~Sh) && !(&(~{Shamt, {Sh, IsRegister}}))) //third condition -> Instr[11:4] != 0
        	begin
          	if(IsRegister)
          		Result = Rm<<RsShift;
            else
            	Result = Rm<<Shamt;
            ShiftCarry = Carry;
          end
        /*LSR*/
        else if (~Immediate && Sh == 2'b01)
        	begin
          	if(IsRegister)
          		Result = Rm>>RsShift;
            else
		begin
            		if (Shamt != 0) Result = Rm>>Shamt;   //added this
			else            Result = Rm>>32 ;     //added this
		end
            ShiftCarry = Carry;
          end
        /*ASR*/
        else if (~Immediate && Sh == 2'b10)
        	begin
          	if(IsRegister)
            	Result = $signed(Rm)>>>RsShift;
            else
		begin
            		if (Shamt != 0) Result = $signed(Rm)>>>Shamt ;  //added this
			else            Result = $signed(Rm)>>>32  ;  //added this
		end
            ShiftCarry = Carry;
          end
        /*RRX*/
        else if (~Immediate && Sh == 2'b11 && &(~Shamt) && ~IsRegister)
        	begin
		ShiftCarry = Rm[0];
          	Result = {Carry, Rm}>>1;
          end 
        /*RR*/
        else if (~Immediate && Sh == 2'b11 && !(&(~Shamt)))
        	begin
          	if(IsRegister)
            	Result = {Rm, Rm}>>RsShift[4:0]; //added this
            else
            	Result = {Rm, Rm}>>Shamt;
            ShiftCarry = Carry;
          end
        else
        	begin
          	Result = Rm;
            ShiftCarry = Carry;
          end
    	end
endmodule
  