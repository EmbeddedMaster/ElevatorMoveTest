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
`define lcd_ev ldc_o

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
	
	
	//text lcd
	
	//clk_out counting
	reg[32:0] cnt,cnt2; 
	reg clk_out,clk_out2; 
	
	//About elevator info
	reg[7:0] elv_count;
	
	reg[4:0] elv1_floor, elv2_floor;
	reg[1:0] elv1_dir, elv2_dir;
	
	//7-segment. presentate floor
	floor_seven_segment m_elv_floors
	(
		.clk				(clk_in), 
		.segout			(segout), 
		.segcom			(segcom), 
		.elv1_floor		(elv1_floor), 
		.elv2_floor		(elv2_floor)
	);
	
	direction_state_dot_matrix
	(
		.clk			(clk_in),
		.resetn		(resetn),
		.dot_col		(dot_col),
		.dot_raw		(dot_raw),
		.elv1_dir	(elv1_dir),
		.elv2_dir	(elv2_dir)
	);
	
	initial
	begin
		//clk_out counting
		cnt 		= 0;
		cnt2 		= 0;
		clk_out 	= 0;
		clk_out2 	= 0;
		
		//elvator
		elv_count = 0;
		elv1_floor = 9;
		elv2_floor = 1;
		elv1_dir = 1'b0;
		elv2_dir = 1'b1;
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

	always @(posedge clk_out)
	begin
		if (resetn == 0)
			begin
				cnt2 = 0; 
				clk_out2 = 0;
			end
		else if (cnt2 < 1000)
			begin
				cnt2 = cnt2 + 1; 
			end
		else if (cnt2 == 1000)
			begin
				cnt2 = 0; 
				clk_out2 = ~clk_out2; 
			end 
	end
	   
	always@(posedge clk_out2)
	begin
		if (resetn == 0)
			begin
				elv1_floor = 9;
				elv2_floor = 1;
				elv1_dir = 1'b0;
				elv2_dir = 1'b1;
			end
		else
			begin
				if(elv2_dir==1'b0)
					begin
						elv2_floor = elv2_floor - 1;
					end
				else
					begin
						elv2_floor = elv2_floor + 1;
					end
				
				elv1_floor = 10 - elv2_floor;
				
				if(elv2_floor == 9)
					begin
						elv1_dir = 1'b1;
						elv2_dir = 1'b0;
					end
				else if(elv2_floor == 1)
					begin
						elv1_dir = 1'b0;
						elv2_dir = 1'b1;
					end
        	end
	end

endmodule
