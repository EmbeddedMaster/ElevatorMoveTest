module spin_elevator_step_motor(clk, motor_out, elv1_dir);

	input clk;
	
	output [3:0] motor_out;
	reg [3:0] motor_out;
	
	input[1:0] elv1_dir;
	
	reg [29:0] motor_count;
	
	initial
	begin
		motor_count = 30'd960000;
		motor_out = 0;
	end
	
	always@(posedge clk)
	begin
		if(elv1_dir < 2)
		begin
			if(motor_count == 30'd960000)
			begin
				case(elv1_dir)
				2'b0: begin motor_out = 4'b1001; end
				2'b1: begin motor_out = 4'b0101; end
				endcase
				motor_count = 0;
			end
			
			else if(motor_count == 30'd240000)
			begin
				case(elv1_dir)
				2'b0: begin motor_out = 4'b1010; end
				2'b1: begin motor_out = 4'b0110; end
				endcase
				motor_count = motor_count + 1;
			end
			
			else if(motor_count == 30'd480000)
			begin
				case(elv1_dir)
				2'b0: begin motor_out = 4'b0110; end
				2'b1: begin motor_out = 4'b1010; end
				endcase
				motor_count = motor_count + 1;
			end
			
			else if(motor_count == 30'd720000)
			begin
				case(elv1_dir)
				2'b0: begin motor_out = 4'b0101; end
				2'b1: begin motor_out = 4'b1001; end
				endcase
				motor_count = motor_count + 1;
			end
			
			else
			begin
				motor_count = motor_count + 1;
			end
		end
	end

endmodule
