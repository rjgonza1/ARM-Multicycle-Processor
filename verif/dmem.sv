module dmem (
		input logic clk , we ,
		input logic [31:0] a ,
		input logic [3:0] be ,
		input logic [1:0] op, [1:0] op2,
		input logic [31:0] wd ,
		output logic [31:0] rd
	);

	// double packed array
	logic [3:0][7:0] RAM [511:0];
	logic [7:0] rd0, rd1, rd2, rd3;

	// assign individual bytes into rd3,rd2,rd1,rd0 and send to rd
	// shift most significant bits if op=00 and op2=10 or 11
	always_comb
	begin
 
		if(op == 2'b00 && op2 == 2'b10) begin
			rd0 = RAM [a][0] & {8{be[0]}};
			rd1 = {8{rd0[7]}};
			rd2 = {8{rd0[7]}};
			rd3 = {8{rd0[7]}};
			
		end
		else if(op == 2'b00 && op2 == 2'b11) begin
			rd0 = RAM [a][0] & {8{be[0]}};
			rd1 = RAM [a][1] & {8{be[1]}};
			rd2 = {8{rd1[7]}};
			rd3 = {8{rd1[7]}};
		end
		else begin
			rd3 = RAM [a][3] & {8{be[3]}};
			rd2 = RAM [a][2] & {8{be[2]}};
			rd1 = RAM [a][1] & {8{be[1]}};
			rd0 = RAM [a][0] & {8{be[0]}};
		end

		rd = {rd3, rd2, rd1, rd0};
	end

	always_ff @ ( posedge clk )
		if ( we )
			if (be[0] && be[1] && ~be[2] && ~be[3])
			begin
				RAM [a][1:0] <= wd[15:0];
			end
			else if (be[0] && ~be[1] && ~be[2] && ~be[3])
			begin
				RAM [a][0] <= wd[7:0];
			end
			else if (be[0] && be[1] && be[2] && be[3])
			begin
				RAM [a][3:0] <= wd[31:0];
			end

endmodule
