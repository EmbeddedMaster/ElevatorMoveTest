////////////////////////////////////////////////////////////////////////////////
// company		: GDG SSU
// engineer		: kim nam yoon, jung han ter
// create date	: 14/06/16
//
// project name	:  Elevator Simultator
// design name	:  elevator_simulator   
// module name	:  elevator_simulator
//
// dependencies	:
//		product 		: EasySoC V1.2
//		synthesis tool 	: altera quartus-ii 13.0
// 		target device	: ep2c50f672c8
//
// description	: elevator_simulator
//
// additional comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define lcd_0 8'b00110000
`define lcd_o 8'b01001111
`define lcd_s_o 8'b01101111
`define lcd_ev ldc_0
`define add_line_1 8'b10000000
`define add_line_2 8'b11000000
`define add_line_3 8'b10010100
`define add_line_4 8'b11010100

module elevator_simulator(
	clk_in, resetn,
	dot_col, dot_raw,			//dot matrix
	segout, segcom,			//7-segment
	lcd_rs, lcd_rw, lcd_en, lcd_data		//text lcd
);

	input clk_in;
	input resetn;

	output [9:0] dot_col;
	output [13:0] dot_raw;
	
	output [7:0] segout;
	output [7:0] segcom;
	
	output lcd_rs;
	output lcd_rw;
	output lcd_en;
	output[7:0] lcd_data;
	
	//dot matrix
	reg [9:0] dot_col_reg;
	reg [13:0] dot_raw_reg;
	reg [3:0] dot_clk_count;	//count
	reg [7:0] dot_count;
	
	//7-setment
	wire [7:0] seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8;
	reg [7:0] segcom_tmp;
	reg [7:0] segout_tmp
	
	//text lcd
	
	//clk_out counting
	reg[32:0] cnt,cnt2; 
	reg clk_out,clk_out2,clk_out3; 

	assign dot_col = dot_col_reg;
	assign dot_raw = dot_raw_reg;

	initial
	begin
		//dot matrix
		dot_col_reg	= 0;
		dot_raw_reg = 0;
		dot_clk_count 		= 0;
		dot_count 	= 0;
		
		
		
		//clk_out counting
		cnt 		= 0;
		cnt2 		= 0;
		clk_out 	= 0;
		clk_out2 	= 0;
		clk_out3 	= 0;
	end

	always @(posedge clk_in)
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
			clk_out2 = 0;
		end
		else if(dot_clk_count == 4'd9)
        begin
			dot_clk_count = 4'd0;
			clk_out2 = ~clk_out2;
        end
		else
		begin
			dot_clk_count = dot_clk_count + 1'b1;
		end
    end

	always @(posedge clk_out2)
	begin
		if (resetn == 0)
		begin
			cnt2 = 0; 
			clk_out3 = 0;
		end
		else if (cnt2 < 39)
		begin
			cnt2 = cnt2 + 1; 
		end
		else if (cnt2 == 39)
		begin
			cnt2 = 0; 
			clk_out3 = ~clk_out3; 
		end 
	end
	   
    always@(posedge clk_out3)
    begin
		if (resetn == 0)
		begin
			dot_count = 0;
		end
        else if(dot_count == 4'd10)
			begin
				dot_count = 4'b0;
			end
		else
			begin
				dot_count = dot_count + 1'b1;
        	end
    end

    always@(posedge clk_out)
    begin
		
		if(dot_count == 4'd0)
		  begin
			case(dot_clk_count)
            	4'd0	: begin	dot_col_reg = 10'b1000000000; dot_raw_reg = 14'b11111111111111; end
            	4'd1	: begin	dot_col_reg = 10'b0100000000; dot_raw_reg = 14'b00111111000011; end
            	4'd2	: begin	dot_col_reg = 10'b0010000000; dot_raw_reg = 14'b00111111000011; end
            	4'd3	: begin	dot_col_reg = 10'b0001000000; dot_raw_reg = 14'b00111100111100; end
            	4'd4	: begin	dot_col_reg = 10'b0000100000; dot_raw_reg = 14'b00111100111100; end
            	4'd5	: begin	dot_col_reg = 10'b0000010000; dot_raw_reg = 14'b00111100111100; end
            	4'd6	: begin	dot_col_reg = 10'b0000001000; dot_raw_reg = 14'b00111100111100; end
            	4'd7	: begin	dot_col_reg = 10'b0000000100; dot_raw_reg = 14'b11000011111100; end
            	4'd8	: begin	dot_col_reg = 10'b0000000010; dot_raw_reg = 14'b11000011111111; end
            	4'd9	: begin	dot_col_reg = 10'b0000000001; dot_raw_reg = 14'b11111111111111; end
            endcase
        end
        

		else if(dot_count == 4'd1)
		  begin
			case(dot_clk_count)
            	4'd0	: begin	dot_col_reg = 10'b1000000000; dot_raw_reg = 14'b11111111111111; end
            	4'd1	: begin	dot_col_reg = 10'b0100000000; dot_raw_reg = 14'b11000000000011; end
            	4'd2	: begin	dot_col_reg = 10'b0010000000; dot_raw_reg = 14'b11000000000011; end
            	4'd3	: begin	dot_col_reg = 10'b0001000000; dot_raw_reg = 14'b00111111111100; end
            	4'd4	: begin	dot_col_reg = 10'b0000100000; dot_raw_reg = 14'b00111111111100; end
            	4'd5	: begin	dot_col_reg = 10'b0000010000; dot_raw_reg = 14'b00111111111100; end
            	4'd6	: begin	dot_col_reg = 10'b0000001000; dot_raw_reg = 14'b00111111111100; end
            	4'd7	: begin	dot_col_reg = 10'b0000000100; dot_raw_reg = 14'b11000000000011; end
            	4'd8	: begin	dot_col_reg = 10'b0000000010; dot_raw_reg = 14'b11000000000011; end
            	4'd9	: begin	dot_col_reg = 10'b0000000001; dot_raw_reg = 14'b11111111111111; end
            endcase
        end

		else if(dot_count == 4'd2)
		  begin
			case(dot_clk_count)
            	4'd0	: begin	dot_col_reg = 10'b1000000000; dot_raw_reg = 14'b11111111111111; end
            	4'd1	: begin	dot_col_reg = 10'b0100000000; dot_raw_reg = 14'b11111111111111; end
            	4'd2	: begin	dot_col_reg = 10'b0010000000; dot_raw_reg = 14'b00111111111111; end
            	4'd3	: begin	dot_col_reg = 10'b0001000000; dot_raw_reg = 14'b00111111111111; end
            	4'd4	: begin	dot_col_reg = 10'b0000100000; dot_raw_reg = 14'b00000000000000; end
            	4'd5	: begin	dot_col_reg = 10'b0000010000; dot_raw_reg = 14'b00000000000000; end
            	4'd6	: begin	dot_col_reg = 10'b0000001000; dot_raw_reg = 14'b00111111111100; end
            	4'd7	: begin	dot_col_reg = 10'b0000000100; dot_raw_reg = 14'b00111111111111; end
            	4'd8	: begin	dot_col_reg = 10'b0000000010; dot_raw_reg = 14'b11111111111111; end
            	4'd9	: begin	dot_col_reg = 10'b0000000001; dot_raw_reg = 14'b11111111111111; end
            endcase
        end

		else if(dot_count == 4'd3)
			begin
				case(dot_clk_count)
            	4'd0	: begin	dot_col_reg = 10'b1000000000; dot_raw_reg = 14'b11111111111111; end
            	4'd1	: begin	dot_col_reg = 10'b0100000000; dot_raw_reg = 14'b11000000000011; end
            	4'd2	: begin	dot_col_reg = 10'b0010000000; dot_raw_reg = 14'b11000000000011; end
            	4'd3	: begin	dot_col_reg = 10'b0001000000; dot_raw_reg = 14'b00111111111100; end
            	4'd4	: begin	dot_col_reg = 10'b0000100000; dot_raw_reg = 14'b00111111111100; end
            	4'd5	: begin	dot_col_reg = 10'b0000010000; dot_raw_reg = 14'b00111111111100; end
            	4'd6	: begin	dot_col_reg = 10'b0000001000; dot_raw_reg = 14'b00111111111100; end
            	4'd7	: begin	dot_col_reg = 10'b0000000100; dot_raw_reg = 14'b11000000000011; end
            	4'd8	: begin	dot_col_reg = 10'b0000000010; dot_raw_reg = 14'b11000000000011; end
            	4'd9	: begin	dot_col_reg = 10'b0000000001; dot_raw_reg = 14'b11111111111111; end
				endcase
			end

		else if(dot_count == 4'd4)
        begin
			case(dot_clk_count)
            	4'd0	: begin	dot_col_reg = 10'b1000000000; dot_raw_reg = 14'b11111111111111; end
            	4'd1	: begin	dot_col_reg = 10'b0100000000; dot_raw_reg = 14'b00111111000011; end
            	4'd2	: begin	dot_col_reg = 10'b0010000000; dot_raw_reg = 14'b00111111000011; end
            	4'd3	: begin	dot_col_reg = 10'b0001000000; dot_raw_reg = 14'b00111100111100; end
            	4'd4	: begin	dot_col_reg = 10'b0000100000; dot_raw_reg = 14'b00111100111100; end
            	4'd5	: begin	dot_col_reg = 10'b0000010000; dot_raw_reg = 14'b00111100111100; end
            	4'd6	: begin	dot_col_reg = 10'b0000001000; dot_raw_reg = 14'b00111100111100; end
            	4'd7	: begin	dot_col_reg = 10'b0000000100; dot_raw_reg = 14'b11000011111100; end
            	4'd8	: begin	dot_col_reg = 10'b0000000010; dot_raw_reg = 14'b11000011111111; end
            	4'd9	: begin	dot_col_reg = 10'b0000000001; dot_raw_reg = 14'b11111111111111; end
            endcase
        end

		else if(dot_count == 4'd5)
        begin
			case(dot_clk_count)
            	4'd0	: begin	dot_col_reg = 10'b1000000000; dot_raw_reg = 14'b11111111111111; end
            	4'd1	: begin	dot_col_reg = 10'b0100000000; dot_raw_reg = 14'b00000000000111; end
            	4'd2	: begin	dot_col_reg = 10'b0010000000; dot_raw_reg = 14'b00000000000111; end
            	4'd3	: begin	dot_col_reg = 10'b0001000000; dot_raw_reg = 14'b11111111111100; end
            	4'd4	: begin	dot_col_reg = 10'b0000100000; dot_raw_reg = 14'b11111111111100; end
            	4'd5	: begin	dot_col_reg = 10'b0000010000; dot_raw_reg = 14'b11111111111100; end
            	4'd6	: begin	dot_col_reg = 10'b0000001000; dot_raw_reg = 14'b11111111111100; end
            	4'd7	: begin	dot_col_reg = 10'b0000000100; dot_raw_reg = 14'b11111111000011; end
            	4'd8	: begin	dot_col_reg = 10'b0000000010; dot_raw_reg = 14'b11111111000011; end
            	4'd9	: begin	dot_col_reg = 10'b0000000001; dot_raw_reg = 14'b11111111111111; end
            endcase
        end

		else if(dot_count == 4'd6)
        begin
			case(dot_clk_count)
            	4'd0	: begin	dot_col_reg = 10'b1000000000; dot_raw_reg = 14'b11111111111111; end
            	4'd1	: begin	dot_col_reg = 10'b0100000000; dot_raw_reg = 14'b11000000000011; end
            	4'd2	: begin	dot_col_reg = 10'b0010000000; dot_raw_reg = 14'b11000000000011; end
            	4'd3	: begin	dot_col_reg = 10'b0001000000; dot_raw_reg = 14'b00111111111100; end
            	4'd4	: begin	dot_col_reg = 10'b0000100000; dot_raw_reg = 14'b00111111111100; end
            	4'd5	: begin	dot_col_reg = 10'b0000010000; dot_raw_reg = 14'b00111111111100; end
            	4'd6	: begin	dot_col_reg = 10'b0000001000; dot_raw_reg = 14'b00111111111100; end
            	4'd7	: begin	dot_col_reg = 10'b0000000100; dot_raw_reg = 14'b11000000000011; end
            	4'd8	: begin	dot_col_reg = 10'b0000000010; dot_raw_reg = 14'b11000000000011; end
            	4'd9	: begin	dot_col_reg = 10'b0000000001; dot_raw_reg = 14'b11111111111111; end
            endcase
        end


		else if(dot_count == 4'd7)
        begin
			case(dot_clk_count)
            	4'd0	: begin	dot_col_reg = 10'b1000000000; dot_raw_reg = 14'b11111111111111; end
            	4'd1	: begin	dot_col_reg = 10'b0100000000; dot_raw_reg = 14'b11000011000011; end
            	4'd2	: begin	dot_col_reg = 10'b0010000000; dot_raw_reg = 14'b11000011000011; end
            	4'd3	: begin	dot_col_reg = 10'b0001000000; dot_raw_reg = 14'b00111100111100; end
            	4'd4	: begin	dot_col_reg = 10'b0000100000; dot_raw_reg = 14'b00111100111100; end
            	4'd5	: begin	dot_col_reg = 10'b0000010000; dot_raw_reg = 14'b00111100111100; end
            	4'd6	: begin	dot_col_reg = 10'b0000001000; dot_raw_reg = 14'b00111100111100; end
            	4'd7	: begin	dot_col_reg = 10'b0000000100; dot_raw_reg = 14'b11000011000011; end
            	4'd8	: begin	dot_col_reg = 10'b0000000010; dot_raw_reg = 14'b11000011000011; end
            	4'd9	: begin	dot_col_reg = 10'b0000000001; dot_raw_reg = 14'b11111111111111; end
            endcase
        end


		else if(dot_count == 4'd8)
        begin
			case(dot_clk_count)
            	4'd0	: begin	dot_col_reg = 10'b1000000000; dot_raw_reg = 14'b11111111111111; end
            	4'd1	: begin	dot_col_reg = 10'b0100000000; dot_raw_reg = 14'b11000000000000; end
            	4'd2	: begin	dot_col_reg = 10'b0010000000; dot_raw_reg = 14'b10000000000000; end
            	4'd3	: begin	dot_col_reg = 10'b0001000000; dot_raw_reg = 14'b00111111111100; end
            	4'd4	: begin	dot_col_reg = 10'b0000100000; dot_raw_reg = 14'b00111111111100; end
            	4'd5	: begin	dot_col_reg = 10'b0000010000; dot_raw_reg = 14'b00111111111100; end
            	4'd6	: begin	dot_col_reg = 10'b0000001000; dot_raw_reg = 14'b10011111111100; end
            	4'd7	: begin	dot_col_reg = 10'b0000000100; dot_raw_reg = 14'b11000011111100; end
            	4'd8	: begin	dot_col_reg = 10'b0000000010; dot_raw_reg = 14'b11100011111100; end
            	4'd9	: begin	dot_col_reg = 10'b0000000001; dot_raw_reg = 14'b11111111111111; end
            endcase
        end


		else if(dot_count == 4'd9)
        begin
			case(dot_clk_count)
            	4'd0	: begin	dot_col_reg = 10'b1000000000; dot_raw_reg = 14'b11111111111111; end
            	4'd1	: begin	dot_col_reg = 10'b0100000000; dot_raw_reg = 14'b00000000000000; end
            	4'd2	: begin	dot_col_reg = 10'b0010000000; dot_raw_reg = 14'b00000000000000; end
            	4'd3	: begin	dot_col_reg = 10'b0001000000; dot_raw_reg = 14'b11111100111111; end
            	4'd4	: begin	dot_col_reg = 10'b0000100000; dot_raw_reg = 14'b11111100111111; end
            	4'd5	: begin	dot_col_reg = 10'b0000010000; dot_raw_reg = 14'b11111100111111; end
            	4'd6	: begin	dot_col_reg = 10'b0000001000; dot_raw_reg = 14'b11111100111111; end
            	4'd7	: begin	dot_col_reg = 10'b0000000100; dot_raw_reg = 14'b00000000000000; end
            	4'd8	: begin	dot_col_reg = 10'b0000000010; dot_raw_reg = 14'b00000000000000; end
            	4'd9	: begin	dot_col_reg = 10'b0000000001; dot_raw_reg = 14'b11111111111111; end
            endcase
        end
		  
		else if(dot_count == 4'd10)
        begin
			case(dot_clk_count)
            	4'd0	: begin	dot_col_reg = 10'b1000000000; dot_raw_reg = 14'b11111111111111; end
            	4'd1	: begin	dot_col_reg = 10'b0100000000; dot_raw_reg = 14'b11111111111100; end
            	4'd2	: begin	dot_col_reg = 10'b0010000000; dot_raw_reg = 14'b11111111111100; end
            	4'd3	: begin	dot_col_reg = 10'b0001000000; dot_raw_reg = 14'b11111111111100; end
            	4'd4	: begin	dot_col_reg = 10'b0000100000; dot_raw_reg = 14'b00000000000000; end
            	4'd5	: begin	dot_col_reg = 10'b0000010000; dot_raw_reg = 14'b00000000000000; end
            	4'd6	: begin	dot_col_reg = 10'b0000001000; dot_raw_reg = 14'b11111111111100; end
            	4'd7	: begin	dot_col_reg = 10'b0000000100; dot_raw_reg = 14'b11111111111100; end
            	4'd8	: begin	dot_col_reg = 10'b0000000010; dot_raw_reg = 14'b11111111111100; end
            	4'd9	: begin	dot_col_reg = 10'b0000000001; dot_raw_reg = 14'b11111111111111; end
            endcase
        end
	end
endmodule