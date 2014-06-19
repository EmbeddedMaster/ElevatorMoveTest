module direction_state_dot_matrix(clk, resetn, dot_col, dot_raw, elv1_dir, elv2_dir);

	input clk;
	input resetn;
	
	output [9:0] dot_col;
	output [13:0] dot_raw;
	
	input [1:0] elv1_dir;
	input [1:0] elv2_dir;
	
	reg [1:0] elv1_prev_dir;
	reg [1:0] elv2_prev_dir;
	
	//dot matrix
	reg [9:0] dot_col_reg;
	reg [13:0] dot_raw_reg;
	reg [3:0] dot_clk_count;	//count
	
	//clk_out counting
	reg[32:0] cnt;
	reg clk_out;
	
	assign dot_col = dot_col_reg;
	assign dot_raw = dot_raw_reg;
	
	initial
	begin
		//dot matrix
		dot_col_reg		= 0;
		dot_raw_reg 	= 0;
		dot_clk_count	= 0;
		
		//prev dir
		elv1_prev_dir = elv1_dir;
		elv2_prev_dir = elv2_dir;
		
		//clk_out counting
		cnt 			= 0;
		clk_out 		= 0;
	end
	
	
	always @(posedge clk)
	begin
		if (resetn == 0)
		begin
			cnt = 0; 
			clk_out = 0;
		end
		else if (cnt < 5999)
		begin
			cnt = cnt + 1; 
		end
		else if (cnt == 5999)
		begin
			cnt = 0; 
			clk_out = ~clk_out; 
		end 
	end

    always@(posedge clk_out)
    begin
		if (resetn == 0)
		begin
			dot_clk_count = 0;
		end
		else if(dot_clk_count == 4'd9)
        begin
			dot_clk_count = 4'd0;
        end
		else
		begin
			dot_clk_count = dot_clk_count + 1'b1;
		end
    end

	 
    always@(posedge clk_out)
    begin
	 
		//if dir==1'b1 rising
		//elif dir==1'b0 falling
		case (elv1_dir)
			0 : begin
				case(dot_clk_count)
            	4'd9	: begin	dot_col_reg = 10'b0000000001; dot_raw_reg = 14'b11001111111111; end
            	4'd8	: begin	dot_col_reg = 10'b0000000010; dot_raw_reg = 14'b10011111111111; end
            	4'd7	: begin	dot_col_reg = 10'b0000000100; dot_raw_reg = 14'b00000000000000; end
            	4'd6	: begin	dot_col_reg = 10'b0000001000; dot_raw_reg = 14'b10011111111111; end
            	4'd5	: begin	dot_col_reg = 10'b0000010000; dot_raw_reg = 14'b11001111111111; end
				endcase
				elv1_prev_dir = elv1_dir;
			end
			1 : begin
				case(dot_clk_count)
            	4'd9	: begin	dot_col_reg = 10'b0000000001; dot_raw_reg = 14'b11111111110011; end
            	4'd8	: begin	dot_col_reg = 10'b0000000010; dot_raw_reg = 14'b11111111111001; end
            	4'd7	: begin	dot_col_reg = 10'b0000000100; dot_raw_reg = 14'b00000000000000; end
            	4'd6	: begin	dot_col_reg = 10'b0000001000; dot_raw_reg = 14'b11111111111001; end
            	4'd5	: begin	dot_col_reg = 10'b0000010000; dot_raw_reg = 14'b11111111110011; end
				endcase
				elv1_prev_dir = elv1_dir;
			end
			2 : begin
				case (elv1_prev_dir)
					2'b0 : begin
						case(dot_clk_count)
							4'd9	: begin	dot_col_reg = 10'b0000000001; dot_raw_reg = 14'b11001111111111; end
							4'd8	: begin	dot_col_reg = 10'b0000000010; dot_raw_reg = 14'b10011111111111; end
							4'd7	: begin	dot_col_reg = 10'b0000000100; dot_raw_reg = 14'b00000000000000; end
							4'd6	: begin	dot_col_reg = 10'b0000001000; dot_raw_reg = 14'b10011111111111; end
							4'd5	: begin	dot_col_reg = 10'b0000010000; dot_raw_reg = 14'b11001111111111; end
						endcase
					end
					2'b1 : begin
						case(dot_clk_count)
							4'd9	: begin	dot_col_reg = 10'b0000000001; dot_raw_reg = 14'b11111111110011; end
							4'd8	: begin	dot_col_reg = 10'b0000000010; dot_raw_reg = 14'b11111111111001; end
							4'd7	: begin	dot_col_reg = 10'b0000000100; dot_raw_reg = 14'b00000000000000; end
							4'd6	: begin	dot_col_reg = 10'b0000001000; dot_raw_reg = 14'b11111111111001; end
							4'd5	: begin	dot_col_reg = 10'b0000010000; dot_raw_reg = 14'b11111111110011; end
						endcase
					end
				endcase
			end
			3 : begin
				case(dot_clk_count)
            	4'd9	: begin	dot_col_reg = 10'b0000000001; dot_raw_reg = 14'b11111111111111; end
            	4'd8	: begin	dot_col_reg = 10'b0000000010; dot_raw_reg = 14'b11111111111111; end
            	4'd7	: begin	dot_col_reg = 10'b0000000100; dot_raw_reg = 14'b11111111111111; end
            	4'd6	: begin	dot_col_reg = 10'b0000001000; dot_raw_reg = 14'b11111111111111; end
            	4'd5	: begin	dot_col_reg = 10'b0000010000; dot_raw_reg = 14'b11111111111111; end
				endcase
			end
		endcase
		
		
		case (elv2_dir)
			0 : begin
				case(dot_clk_count)
            	4'd4	: begin	dot_col_reg = 10'b0000100000; dot_raw_reg = 14'b11001111111111; end
            	4'd3	: begin	dot_col_reg = 10'b0001000000; dot_raw_reg = 14'b10011111111111; end
            	4'd2	: begin	dot_col_reg = 10'b0010000000; dot_raw_reg = 14'b00000000000000; end
            	4'd1	: begin	dot_col_reg = 10'b0100000000; dot_raw_reg = 14'b10011111111111; end
            	4'd0	: begin	dot_col_reg = 10'b1000000000; dot_raw_reg = 14'b11001111111111; end
				endcase
				elv2_prev_dir = elv2_dir;
			end
			1 : begin
				case(dot_clk_count)
            	4'd4	: begin	dot_col_reg = 10'b0000100000; dot_raw_reg = 14'b11111111110011; end
            	4'd3	: begin	dot_col_reg = 10'b0001000000; dot_raw_reg = 14'b11111111111001; end
            	4'd2	: begin	dot_col_reg = 10'b0010000000; dot_raw_reg = 14'b00000000000000; end
            	4'd1	: begin	dot_col_reg = 10'b0100000000; dot_raw_reg = 14'b11111111111001; end
            	4'd0	: begin	dot_col_reg = 10'b1000000000; dot_raw_reg = 14'b11111111110011; end
				endcase
				elv2_prev_dir = elv2_dir;
			end
			2 : begin
				case (elv2_prev_dir)
					2'b0 : begin
						case(dot_clk_count)
							4'd4	: begin	dot_col_reg = 10'b0000100000; dot_raw_reg = 14'b11001111111111; end
							4'd3	: begin	dot_col_reg = 10'b0001000000; dot_raw_reg = 14'b10011111111111; end
							4'd2	: begin	dot_col_reg = 10'b0010000000; dot_raw_reg = 14'b00000000000000; end
							4'd1	: begin	dot_col_reg = 10'b0100000000; dot_raw_reg = 14'b10011111111111; end
							4'd0	: begin	dot_col_reg = 10'b1000000000; dot_raw_reg = 14'b11001111111111; end
						endcase
					end
					2'b1 : begin
						case(dot_clk_count)
							4'd4	: begin	dot_col_reg = 10'b0000100000; dot_raw_reg = 14'b11111111110011; end
							4'd3	: begin	dot_col_reg = 10'b0001000000; dot_raw_reg = 14'b11111111111001; end
							4'd2	: begin	dot_col_reg = 10'b0010000000; dot_raw_reg = 14'b00000000000000; end
							4'd1	: begin	dot_col_reg = 10'b0100000000; dot_raw_reg = 14'b11111111111001; end
							4'd0	: begin	dot_col_reg = 10'b1000000000; dot_raw_reg = 14'b11111111110011; end
						endcase
					end
				endcase
			end
			3 : begin
				case(dot_clk_count)
            	4'd4	: begin	dot_col_reg = 10'b0000100000; dot_raw_reg = 14'b11111111111111; end
            	4'd3	: begin	dot_col_reg = 10'b0001000000; dot_raw_reg = 14'b11111111111111; end
            	4'd2	: begin	dot_col_reg = 10'b0010000000; dot_raw_reg = 14'b11111111111111; end
            	4'd1	: begin	dot_col_reg = 10'b0100000000; dot_raw_reg = 14'b11111111111111; end
            	4'd0	: begin	dot_col_reg = 10'b1000000000; dot_raw_reg = 14'b11111111111111; end
				endcase
			end
		endcase
		
		
		
		/*if (elv1_dir == 1'b1 && elv2_dir == 1'b1)
			begin
				case(dot_clk_count)
            	4'd9	: begin	dot_col_reg = 10'b0000000001; dot_raw_reg = 14'b11111111110011; end
            	4'd8	: begin	dot_col_reg = 10'b0000000010; dot_raw_reg = 14'b11111111111001; end
            	4'd7	: begin	dot_col_reg = 10'b0000000100; dot_raw_reg = 14'b00000000000000; end
            	4'd6	: begin	dot_col_reg = 10'b0000001000; dot_raw_reg = 14'b11111111111001; end
            	4'd5	: begin	dot_col_reg = 10'b0000010000; dot_raw_reg = 14'b11111111110011; end
					
            	4'd4	: begin	dot_col_reg = 10'b0000100000; dot_raw_reg = 14'b11111111110011; end
            	4'd3	: begin	dot_col_reg = 10'b0001000000; dot_raw_reg = 14'b11111111111001; end
            	4'd2	: begin	dot_col_reg = 10'b0010000000; dot_raw_reg = 14'b00000000000000; end
            	4'd1	: begin	dot_col_reg = 10'b0100000000; dot_raw_reg = 14'b11111111111001; end
					4'd0	: begin	dot_col_reg = 10'b1000000000; dot_raw_reg = 14'b11111111110011; end
            endcase
			end
			
		else if (elv1_dir == 1'b1 && elv2_dir == 1'b0)
			begin
				case(dot_clk_count)
            	4'd9	: begin	dot_col_reg = 10'b0000000001; dot_raw_reg = 14'b11111111110011; end
            	4'd8	: begin	dot_col_reg = 10'b0000000010; dot_raw_reg = 14'b11111111111001; end
            	4'd7	: begin	dot_col_reg = 10'b0000000100; dot_raw_reg = 14'b00000000000000; end
            	4'd6	: begin	dot_col_reg = 10'b0000001000; dot_raw_reg = 14'b11111111111001; end
            	4'd5	: begin	dot_col_reg = 10'b0000010000; dot_raw_reg = 14'b11111111110011; end
					
            	4'd4	: begin	dot_col_reg = 10'b0000100000; dot_raw_reg = 14'b11001111111111; end
            	4'd3	: begin	dot_col_reg = 10'b0001000000; dot_raw_reg = 14'b10011111111111; end
            	4'd2	: begin	dot_col_reg = 10'b0010000000; dot_raw_reg = 14'b00000000000000; end
            	4'd1	: begin	dot_col_reg = 10'b0100000000; dot_raw_reg = 14'b10011111111111; end
					4'd0	: begin	dot_col_reg = 10'b1000000000; dot_raw_reg = 14'b11001111111111; end
            endcase
			end
			
		else if (elv1_dir == 1'b0 && elv2_dir == 1'b1)
			begin
				case(dot_clk_count)
            	4'd9	: begin	dot_col_reg = 10'b0000000001; dot_raw_reg = 14'b11001111111111; end
            	4'd8	: begin	dot_col_reg = 10'b0000000010; dot_raw_reg = 14'b10011111111111; end
            	4'd7	: begin	dot_col_reg = 10'b0000000100; dot_raw_reg = 14'b00000000000000; end
            	4'd6	: begin	dot_col_reg = 10'b0000001000; dot_raw_reg = 14'b10011111111111; end
            	4'd5	: begin	dot_col_reg = 10'b0000010000; dot_raw_reg = 14'b11001111111111; end
					
            	4'd4	: begin	dot_col_reg = 10'b0000100000; dot_raw_reg = 14'b11111111110011; end
            	4'd3	: begin	dot_col_reg = 10'b0001000000; dot_raw_reg = 14'b11111111111001; end
            	4'd2	: begin	dot_col_reg = 10'b0010000000; dot_raw_reg = 14'b00000000000000; end
            	4'd1	: begin	dot_col_reg = 10'b0100000000; dot_raw_reg = 14'b11111111111001; end
					4'd0	: begin	dot_col_reg = 10'b1000000000; dot_raw_reg = 14'b11111111110011; end
            endcase
			end
			
		else if (elv1_dir == 1'b0 && elv2_dir == 1'b0)
			begin
				case(dot_clk_count)
            	4'd9	: begin	dot_col_reg = 10'b0000000001; dot_raw_reg = 14'b11001111111111; end
            	4'd8	: begin	dot_col_reg = 10'b0000000010; dot_raw_reg = 14'b10011111111111; end
            	4'd7	: begin	dot_col_reg = 10'b0000000100; dot_raw_reg = 14'b00000000000000; end
            	4'd6	: begin	dot_col_reg = 10'b0000001000; dot_raw_reg = 14'b10011111111111; end
            	4'd5	: begin	dot_col_reg = 10'b0000010000; dot_raw_reg = 14'b11001111111111; end
					
            	4'd4	: begin	dot_col_reg = 10'b0000100000; dot_raw_reg = 14'b11001111111111; end
            	4'd3	: begin	dot_col_reg = 10'b0001000000; dot_raw_reg = 14'b10011111111111; end
            	4'd2	: begin	dot_col_reg = 10'b0010000000; dot_raw_reg = 14'b00000000000000; end
            	4'd1	: begin	dot_col_reg = 10'b0100000000; dot_raw_reg = 14'b10011111111111; end
					4'd0	: begin	dot_col_reg = 10'b1000000000; dot_raw_reg = 14'b11001111111111; end
            endcase
			end
		else*/
	end

endmodule
