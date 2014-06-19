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



module elevator_simulator(
	clk_in, resetn,
	dot_col, dot_raw,							// dot matrix
	segout, segcom,							// 7-segment
	lcd_rs, lcd_rw, lcd_en, lcd_data,	// text lcd
	motor_out,									//	motor
	push_btns,									// 9 buttons
	led_s											// led segment
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
	
	output [3:0] motor_out;
	
	input[8:0] push_btns;
	
	output[7:0] led_s;
	
	//clk_out counting
	reg[32:0] cnt,cnt2; 
	reg clk_out,clk_out2; 
	
	//manipulating elevator
	wire[4:0] __current;
	wire[4:0] __destination;
	wire input_confirm;
	
	//About elevator info
	reg[7:0] elv_count;
	
	reg[4:0] elv1_floor, elv2_floor;
	reg[1:0] elv1_dir, elv2_dir;
	reg[8:0] elv1_stop_list, elv2_stop_list;
	
	reg[4:0] dest;
	reg sched_target;
	
	//7-segment. presentate floor
	floor_seven_segment md_elv_floors
	(
		.clk				(clk_in), 
		.segout			(segout), 
		.segcom			(segcom), 
		.elv1_floor		(elv1_floor), 
		.elv2_floor		(elv2_floor)
	);
	
	//dot-matrix. presentate direction
	direction_state_dot_matrix md_elv_directions
	(
		.clk			(clk_in),
		.resetn		(resetn),
		.dot_col		(dot_col),
		.dot_raw		(dot_raw),
		.elv1_dir	(elv1_dir),
		.elv2_dir	(elv2_dir)
	);
	
	//text-lcd. draw elevator (with floor)
	draw_elevator_text_lcd md_elv_draw
	(
		.clk				(clk_in),
		.resetn			(resetn),
		.lcd_rs			(lcd_rs),
		.lcd_rw			(lcd_rw),
		.lcd_en			(lcd_en),
		.lcd_data		(lcd_data),
		.elv1_floor		(elv1_floor),
		.elv2_floor		(elv2_floor)
	);
	
	//motor, spin motor (elevator1 direction)
	spin_elevator_step_motor md_elv_spin
	(
		.clk			(clk_in),
		.motor_out	(motor_out),
		.elv1_dir	(elv1_dir)
	);
	
	elevator_control_push_btns md_elv_control
	(
		.clk				(clk_in),
		.push_btns		(push_btns),
		.led_s			(led_s),
		.current			(__current),
		.destination	(__destination),
		.input_confirm	(input_confirm)
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
		
		elv1_stop_list = 0;
		elv2_stop_list = 0;
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
	   
	always @(posedge clk_out2)
	begin
		if (resetn == 0)
			begin
				//elv1_floor = 9;
				//elv2_floor = 1;
				elv1_dir = 1'b0;
				elv2_dir = 1'b1;
			end
		else
			begin
				/*if(elv2_dir==1'b0)
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
					end*/
					
				//elv1_floor = __current;
				//elv2_floor = __destination;
        	end
			
	end
	
	always @(posedge input_confirm)
	begin
		//sched_target = min(get_weight(elv1_stop_list,__current,__destination,elv1_dir),get_weight(elv2_stop_list,__current,__destination,elv2_dir));
		dest = __destination;
		//elv1_floor = __current;
		//elv2_floor = __destination;
	end

	function [4:0] get_weight;
		input [8:0] stop_list;
		input [4:0] current;
		input [4:0] destination;
		input [1:0] direction;
	begin
		if(direction == 1)
		begin
			get_weight = 2*(get_max_floor(stop_list)-current) + abs(destination - current); 
		end
		else if(direction == 0)
		begin
			get_weight = 2*(current-get_min_floor(stop_list)) + abs(destination-current);
		end
	end
	endfunction
	
	function min;
		input [4:0] a,b;
	begin
		min = (a<=b)?0:1;
	end
	endfunction
	
	function abs;
		input [4:0] a;
	begin
		if(a<0)
		begin
			abs = 0 - a;
		end
		else
		begin
			abs = a;
		end
	end
	endfunction
	
	function [4:0] get_max_floor;
		input [8:0] stop_list;
		reg [4:0] i;
	begin
		for(i=8; i>=0; i = i-1)
		begin
			if(stop_list[i]==1)
				get_max_floor = i;
		end
	end
	endfunction
	
	function [4:0] get_min_floor;
		input [8:0] stop_list;
		reg [4:0] i;
	begin
		for(i=0; i<8; i = i+1)
		begin
			if(stop_list[i]==1)
				get_min_floor = i;
		end
	end
	endfunction
	
endmodule
