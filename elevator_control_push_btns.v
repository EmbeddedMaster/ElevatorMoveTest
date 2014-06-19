module elevator_control_push_btns(clk, push_btns,
											 current, destination, input_confirm);//,
											 //input_confirm, check_new_btn_input);

	input clk;
	input [8:0] push_btns;
	
	output [4:0] current;
	output [4:0] destination;
	reg [4:0] current_reg;
	reg [4:0] destination_reg;
		 
	wire [4:0] __what_button;
	reg [4:0] prev_what_button;
	
	output input_confirm;	//confirm push btn current and dest
	reg input_confirm;
	
	reg input_status;
	
	assign current = current_reg;
	assign destination = destination_reg;
	
	initial
	begin
		current_reg = 9'b000000001;
		destination_reg = 9'b000000001;

		prev_what_button = 0;
		
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
		
		if(__what_button != 0 && prev_what_button != __what_button) begin
	
			if (input_status == 1'b0) begin
				current_reg = __what_button;
				
				input_status = 1'b1;
				input_confirm = 1'b0;
			end
			else begin
				destination_reg = __what_button;
				
				input_status = 1'b0;
				input_confirm = 1'b1;	//generate posedge
			end
			
		end
		
		prev_what_button = __what_button;
		
	end
	
endmodule
