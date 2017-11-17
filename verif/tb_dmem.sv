module tb_dmem();
    logic clk;
    logic we;
    logic [31:0] a, wd, rd;
    logic [3:0] be;
    logic [1:0] op, op2;


    // instantiate device to be tested
    dmem mem(
           .clk (clk), 
           .we (we),
           .a (a), 
           .be (be),
	   .op (op),
	   .op2 (op2),
           .wd (wd),
	   .rd (rd)
           );

    // initialize test
    initial
    begin
        clk <= 0; we <= 0; a <= 0; be <=0; wd <= 0; op <= 0; op2 <= 0; #20;
    end

    // generate clock to sequence tests
    always
    begin
        clk <= 0; we <= 1; a <= 63; be <= 4'b1111; wd <= 1000000;  # 10;
	clk <= 1; # 10;
	clk <= 0; we <= 1; a <= 40; be <= 4'b0011; wd <= 1048575;  # 10;
	clk <= 1; # 10;
	clk <= 0; we <= 1; a <= 41; be <= 4'b0001; wd <= 1048575;  # 10;
	clk <= 1; # 10;

	// LDRSB test
	clk <= 0; we <= 0; a <= 41; be <= 4'b0001; op <= 2'b00; op2 <= 2'b10; # 10;
	clk <= 1; # 10;

	// LDRSH test
	clk <= 0; we <= 0; a <= 40; be <= 4'b0011; op <= 2'b00; op2 <= 2'b11; # 10;
	clk <= 1; # 10;

	// LDR test 1
	clk <= 0; we <= 0; a <= 63; be <= 4'b1111; op <= 2'b01; # 10;
	clk <= 1; # 10;

	// LDR test 2
	clk <= 0; we <= 0; a <= 63; be <= 4'b0001; op <= 2'b00; op2 <= 2'b10; # 10;
	clk <= 1; # 10;

	// LDR test 3
	clk <= 0; we <= 0; a <= 63; be <= 4'b0011; op <= 2'b00; op2 <= 2'b11; # 10;
	clk <= 1; # 10;
    end

   
   int clk_cnt;
    always @(posedge clk) begin
      clk_cnt++;
      
      if( clk_cnt > 3 ) begin
	$display("%g rd = %b", clk_cnt, rd);
	end

      if( clk_cnt > 7 ) begin
         for(int i =0; i<64; i++) begin
            $display("%g %b", i, $signed(tb_dmem.mem.RAM[i]) );
         end
         $finish;
      end
    end
    
endmodule
