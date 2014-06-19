module elevator_control_push_btns(clk, push_btns,
											 current, destination, input_confirm);//,
											 //input_confirm, check_new_btn_input);

	input clk;
	input [8:0] push_btns;
	
	output [4:0] current;
	output [4:0] destination;
	reg [4:0] current_reg;
	reg [4:0] destination_reg;
	reg [4:0] __current_reg;
	reg [4:0] __destination_reg;
	
	reg [8:0]__push_btn;
	reg __push_btns;
	reg __push_btn1,__push_btn2,__push_btn3,__push_btn4,__push_btn5,
		 __push_btn6,__push_btn7,__push_btn8,__push_btn9;
	reg __prev_push_btn1,__prev_push_btn2,__prev_push_btn3,
		 __prev_push_btn4,__prev_push_btn5,__prev_push_btn6,
		 __prev_push_btn7,__prev_push_btn8,__prev_push_btn9;
		 
	reg [4:0] what_button;
	wire [4:0] __what_button;
	
	output input_confirm;	//confirm push btn current and dest
	reg input_confirm;
	
	reg input_status;
	
	assign current = current_reg;
	assign destination = destination_reg;
	
	initial
	begin
		__current_reg = 9'b000000001;
		__destination_reg = 9'b000000001;
		current_reg = 9'b000000001;
		destination_reg = 9'b000000001;
		
		__push_btns = 1'b0;
		__push_btn1 = 1'b0;
		__push_btn2 = 1'b0;
		__push_btn3 = 1'b0;
		__push_btn4 = 1'b0;
		__push_btn5 = 1'b0;
		__push_btn6 = 1'b0;
		__push_btn7 = 1'b0;
		__push_btn8 = 1'b0;
		__push_btn9 = 1'b0;
		
		__prev_push_btn1 = 1'b0;
		__prev_push_btn2 = 1'b0;
		__prev_push_btn3 = 1'b0;
		__prev_push_btn4 = 1'b0;
		__prev_push_btn5 = 1'b0;
		__prev_push_btn6 = 1'b0;
		__prev_push_btn7 = 1'b0;
		__prev_push_btn8 = 1'b0;
		__prev_push_btn9 = 1'b0;
		
		what_button = 0;
		
		input_confirm = 1'b0;
		input_status = 1'b0;
	end
	
	assign __what_button = (push_btns == 9'b000000001) ? 1 :
								  (push_btns == 9'b000000010) ? 2 :
								  (push_btns == 9'b000000100) ? 3 :
								  (push_btns == 9'b000001000) ? 4 :
								  (push_btns == 9'b000010000) ? 5 :
								  (push_btns == 9'b000100000) ? 6 :
								  (push_btns == 9'b001000000) ? 7 :
								  (push_btns == 9'b010000000) ? 8 :
								  (push_btns == 9'b100000000) ? 9 :
								  0;
								  
	always @(posedge clk)
	begin
		
		if(__push_btns != 0)
		begin
			//__push_btn1 = 1'b0; __push_btn2 = 1'b0; __push_btn3 = 1'b0;
			//__push_btn4 = 1'b0; __push_btn5 = 1'b0; __push_btn6 = 1'b0;
			//__push_btn7 = 1'b0; __push_btn8 = 1'b0; __push_btn9 = 1'b0;
	
		//if (input_status == 1'b0)
			//begin
				/*case(push_btns)
					9'b000000001: __current_reg = 1;
					9'b000000010: __current_reg = 2;
					9'b000000100: __current_reg = 3;
					9'b000001000: __current_reg = 4;
					9'b000010000: __current_reg = 5;
					9'b000100000: __current_reg = 6;
					9'b001000000: __current_reg = 7;
					9'b010000000: __current_reg = 8;
					9'b100000000: __current_reg = 9;
					default: begin __current_reg = current_reg; current_reg = 0; end
				endcase*/
				
				current_reg = __what_button;
				
				input_status = 1'b1;
				input_confirm = 1'b0;
			//end
		//else
			//begin
				case(push_btns)
					9'b000000001: __destination_reg = 1;
					9'b000000010: __destination_reg = 2;
					9'b000000100: __destination_reg = 3;
					9'b000001000: __destination_reg = 4;
					9'b000010000: __destination_reg = 5;
					9'b000100000: __destination_reg = 6;
					9'b001000000: __destination_reg = 7;
					9'b010000000: __destination_reg = 8;
					9'b100000000: __destination_reg = 9;
					default: begin __destination_reg = destination_reg; destination_reg = 0; end
				endcase
				
				destination_reg = __destination_reg;
				
				input_status = 1'b0;
				input_confirm = 1'b1;	//generate posedge
			//end
		end
	end
	
	
	always @(posedge push_btns[0])
	begin
		__push_btn1 = 1'b1;
		what_button = 1;
	end
	
	always @(posedge push_btns[1])
	begin
		__push_btn2 = 1'b1;
		//what_button = 2;
	end
	
	always @(posedge push_btns[2])
	begin
		__push_btn3 = 1'b1;
		//what_button = 3;
	end
	
	always @(posedge push_btns[3])
	begin
		__push_btn4 = 1'b1;
		//what_button = 4;
	end
	
	always @(posedge push_btns[4])
	begin
		__push_btn5 = 1'b1;
		//what_button = 5;
	end
	
	always @(posedge push_btns[5])
	begin
		__push_btn6 = 1'b1;
		//what_button = 6;
	end
	
	always @(posedge push_btns[6])
	begin
		__push_btn7 = 1'b1;
		//what_button = 7;
	end
	
	always @(posedge push_btns[7])
	begin
		__push_btn8 = 1'b1;
		//what_button = 8;
	end
	
	always @(posedge push_btns[8])
	begin
		__push_btn9 = 1'b1;
		//what_button = 9;
	end
	
	/*always @(posedge clk)
	begin
		if (check_new_btn_input == 1'b0)
		begin
			input_confirm = 1'b0;
		end
		
		if (push_btns)
		begin
			if(input_status == 1'b0)
			begin
				case(push_btns)
					9'b000000001: current = 1;
					9'b000000010: current = 2;
					9'b000000100: current = 3;
					9'b000001000: current = 4;
					9'b000010000: current = 5;
					9'b000100000: current = 6;
					9'b001000000: current = 7;
					9'b010000000: current = 8;
					9'b100000000: current = 9;
				endcase
				input_status = 1;
			end
			
			
		
	end*/
	
endmodule
