module mux3
	#(parameter WIDTH = 8)
	(
		input logic [WIDTH-1 : 0] d0, d1, d2,
		input logic [1:0] s,
		output logic [WIDTH-1 : 0] y
	);
	always_comb
	begin
	case(s)

		2'b00:
		begin
			y = d0;
		end

		2'b01:
		begin
			y = d1;
		end

		2'b10:
		begin
			y = d2;
		end

		default:
		begin
			y = 32'bx;
		end
	endcase
	end
endmodule
