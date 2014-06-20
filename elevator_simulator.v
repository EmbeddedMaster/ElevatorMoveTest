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
	
	reg[63:0] count;
	
	//manipulating elevator
	wire[4:0] __current;
	wire[4:0] __destination;
	wire input_confirm;
	
	reg[63:0] confirm_cnt;
	reg[63:0] prev_confirm_cnt;
	
	//About elevator info
	reg[4:0] elv1_floor, elv2_floor;
	reg[1:0] elv1_dir, elv2_dir;
	reg[3:0] elv1_stop_count, elv2_stop_count;
	reg[4:0] elv1_stop_list [32:1]; 
	reg[4:0] elv2_stop_list [32:1];
	integer elv1_max_floor, elv2_max_floor;
	integer i;
	
	reg[4:0] curr, dest, prev_curr, prev_dest;
	reg sched_target, prev_sched_target;
	
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
		
		count = 0;
		
		//elvator
		elv1_floor = 1;
		elv2_floor = 9;
		elv1_dir = 3;
		elv2_dir = 3;
		elv1_stop_count = 0;
		elv2_stop_count = 0;
		
		for (i=1; i<33; i = i+1) begin
			elv1_stop_list[i] = 0;
		end
		
		for (i=1; i<33; i = i+1) begin
			elv2_stop_list[i] = 0;
		end
		
		curr = 1;
		dest = 1;
		prev_curr = 1;
		prev_dest = 1;
		
		sched_target = 0;
		prev_sched_target = 0;
		
		confirm_cnt = 0;
		prev_confirm_cnt = 0;
	end

	always @(posedge clk_in)
	begin
		// every clock
		if (count < 64'd24000000) begin
			count = count + 1; 
			
			/*** do something posedge cpu clock ***/
			//add stop list
			if(confirm_cnt != prev_confirm_cnt) begin
				if(sched_target == 0)
				begin
					elv1_stop_list[curr] = 1;
					elv1_stop_list[dest] = 1;
				end
				else if(sched_target == 1)
				begin
					elv2_stop_list[curr] = 1;
					elv2_stop_list[dest] = 1;
				end
				
				prev_confirm_cnt = confirm_cnt;
			end
		end
		// every 1 second
		else begin
			count = 0;
			/*** do someting...	(here is 1sec clk out) ***/
			
			/****** elevator1 ******/
			//check stop list (check arrival)
			if(elv1_stop_list[elv1_floor]==1) begin
				if(elv1_stop_count >= 3) begin
					elv1_stop_list[elv1_floor] = 0;
					elv1_stop_count = 0;
				end
				else begin
					elv1_stop_count = elv1_stop_count + 1;
					elv1_dir = 2;
				end
			end
			else begin
				
				elv1_max_floor = get_max_floor(0);
				
				//check dir
				if(elv1_max_floor == 0) begin	//check stop list is empty
					elv1_dir = 3;
				end
				else begin
					if((elv1_max_floor-elv1_floor)<0) begin
						elv1_dir = 0;
					end
					else if((elv1_max_floor-elv1_floor)>0) begin
						elv1_dir = 1;
					end
				end
			end
			
			//move the elevator to specific direction
			if(elv1_dir == 1) begin
				elv1_floor = elv1_floor + 1;
			end
			else if (elv1_dir == 0) begin
				elv1_floor = elv1_floor - 1;
			end
			else begin
			end
			
			/****** elevator2 ******/
			//check stop list
			if(elv2_stop_list[elv2_floor]==1) begin
				if(elv2_stop_count >= 3) begin
					elv2_stop_list[elv2_floor] = 0;
					elv2_stop_count = 0;
				end
				else begin
					elv2_stop_count = elv2_stop_count + 1;
					elv2_dir = 2;
				end
			end
			else begin
			
				elv2_max_floor = get_max_floor(1);
				
				//check dir
				if(elv2_max_floor == 0) begin	//check stop list is empty
					elv2_dir = 3;
				end
				else begin
					if((elv2_max_floor-elv2_floor)<0) begin
						elv2_dir = 0;
					end
					else if((elv2_max_floor-elv2_floor)>0) begin
						elv2_dir = 1;
					end
				end
			end
			
			//move
			if(elv2_dir == 1) begin
				elv2_floor = elv2_floor + 1;
			end
			else if (elv2_dir == 0) begin
				elv2_floor = elv2_floor - 1;
			end
			else begin
			end
		end

	end

	always @(posedge input_confirm)
	begin
		sched_target = min(get_weight(0, elv1_floor, __current, elv1_dir),
								 get_weight(1, elv2_floor, __current, elv2_dir));
		
		curr = __current;
		dest = __destination;
		
		confirm_cnt = confirm_cnt + 1;
	end

	
	function [4:0] get_weight;
		input [1:0] elevator;
		input [4:0] floor;
		input [4:0] current;
		input [1:0] direction;
	begin
		if(direction == 1)
		begin
			get_weight = 2*(get_max_floor(elevator)-floor) + abs(current - floor);
		end
		else if(direction == 0)
		begin
			get_weight = 2*(current-get_min_floor(elevator)) + abs(current-floor);
		end
		else
		begin
			get_weight = abs(current-floor);
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
	
	function integer get_max_floor;
		input [1:0] elevator;
		integer i;
	begin
		get_max_floor = 0;
	
		if(elevator == 0) begin
			for(i=1; i<10; i = i+1)
			begin
				if(elv1_stop_list[i]==1) begin
					if(i>get_max_floor) begin
						get_max_floor = i;
					end
				end
			end
		end
		else begin
			for(i=1; i<10; i = i+1)
			begin
				if(elv2_stop_list[i]==1) begin
					if(i>get_max_floor) begin
						get_max_floor = i;
					end
				end
			end
		end		
	end
	endfunction
	
	function integer get_min_floor;
		input [1:0] elevator;
		integer i;
	begin
		get_min_floor = 10;
		
		if(elevator == 0) begin
			for(i=1; i<10; i = i+1)
			begin
				if(elv1_stop_list[i]==1) begin
					if(i<get_min_floor) begin
						get_min_floor = i;
					end
				end
			end
		end
		else begin
			for(i=1; i<10; i = i+1)
			begin
				if(elv2_stop_list[i]==1) begin
					if(i<get_min_floor) begin
						get_min_floor = i;
					end
				end
			end
		end
		
		if(get_min_floor==10) begin
			get_min_floor = 0;
		end
		
	end
	endfunction
	
endmodule
