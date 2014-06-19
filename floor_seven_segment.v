`define seg7_0 8'b00000011
`define seg7_1 8'b10011111
`define seg7_2 8'b00100101
`define seg7_3 8'b00001101
`define seg7_4 8'b10011001
`define seg7_5 8'b01001001
`define seg7_6 8'b01000001
`define seg7_7 8'b00011011
`define seg7_8 8'b00000001
`define seg7_9 8'b00001001
`define seg7_no 8'b11111111

module floor_seven_segment(clk, segout, segcom, elv1_floor, elv2_floor);

	input clk;
	
	output [7:0] segout;
	output [7:0] segcom;
	
	input [4:0] elv1_floor;
	input [4:0] elv2_floor;
	
	reg[7:0] segcom_tmp; 
	reg[7:0] segout_tmp;
	
	reg[14:0] clk_cnt; 
	reg[15:0] com_cnt; 
	
	initial
	begin
		segcom_tmp = 0; 
		segout_tmp = 0; 
		clk_cnt = 0; 
		com_cnt = 0; 
	end
	
	always @(posedge clk)
	begin
	
		if (clk_cnt == 16384)
		begin
			clk_cnt = 0; 
			if (com_cnt == 7)
				com_cnt = 0; 
			else
				com_cnt = com_cnt + 1; 
		end
		
		else
		begin
			clk_cnt = clk_cnt + 1; 
		end 
	
      case (com_cnt)
			0 :
				begin
					segcom_tmp <= 8'b10000000 ; // seven_segment leftest 1st
					segout_tmp <= `seg7_no ;
				end
         1 :
				begin
					segcom_tmp <= 8'b01000000 ; // seven_segment 2nd
					segout_tmp <= `seg7_no ;
               end
         2 :
				begin
					segcom_tmp <= 8'b00100000 ; // seven_segment 3rd
					segout_tmp <= `seg7_no ;
				end
         3 :
				begin
					segcom_tmp <= 8'b00010000 ; // seven_segment 4th -> elv1 floor
					case (elv1_floor)
						1:
							begin
								segout_tmp <= `seg7_1;
							end
						2:
							begin
								segout_tmp <= `seg7_2;
							end
						3:
							begin
								segout_tmp <= `seg7_3;
							end
						4:
							begin
								segout_tmp <= `seg7_4;
							end
						5:
							begin
								segout_tmp <= `seg7_5;
							end
						6:
							begin
								segout_tmp <= `seg7_6;
							end
						7:
							begin
								segout_tmp <= `seg7_7;
							end
						8:
							begin
								segout_tmp <= `seg7_8;
							end
						9:
							begin
								segout_tmp <= `seg7_9;
							end
					endcase
				end
         4 :
				begin
					segcom_tmp <= 8'b00001000 ; // seven_segment 5th
					segout_tmp <= `seg7_no ;
				end
         5 :
				begin
					segcom_tmp <= 8'b00000100 ; // seven_segment 6th
					segout_tmp <= `seg7_no ;
				end
         6 :
				begin
					segcom_tmp <= 8'b00000010 ; // seven_segment 7th
					segout_tmp <= `seg7_no ;
				end
			//default :
			7 :
				begin
					segcom_tmp <= 8'b00000001 ; // seven_segment 8th -> elv2 floor
					case (elv2_floor)
						1:
							begin
								segout_tmp <= `seg7_1;
							end
						2:
							begin
								segout_tmp <= `seg7_2;
							end
						3:
							begin
								segout_tmp <= `seg7_3;
							end
						4:
							begin
								segout_tmp <= `seg7_4;
							end
						5:
							begin
								segout_tmp <= `seg7_5;
							end
						6:
							begin
								segout_tmp <= `seg7_6;
							end
						7:
							begin
								segout_tmp <= `seg7_7;
							end
						8:
							begin
								segout_tmp <= `seg7_8;
							end
						9:
							begin
								segout_tmp <= `seg7_9;
							end
					endcase		
				end   
              
		endcase 
	end 

   assign segcom = segcom_tmp ;
   assign segout = segout_tmp ;
	
endmodule
