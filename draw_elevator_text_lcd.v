`define lcd_blank 8'b00100000
`define lcd_0 8'b00110000
`define lcd_o 8'b01001111
`define lcd_s_o 8'b01101111
`define lcd_ev 8'b11111111


module draw_elevator_text_lcd(clk, resetn, lcd_rs, lcd_rw, lcd_en, lcd_data, elv1_floor, elv2_floor);

	input clk;
	input resetn;
	
	output lcd_rs;
	output lcd_rw;
	output lcd_en;
	output [7:0] lcd_data;
	
	input [4:0] elv1_floor;
	input [4:0] elv2_floor;

	reg [31:0] reg_a;
	reg [31:0] reg_b;
	reg [31:0] reg_c;
	reg [31:0] reg_d;
	reg [31:0] reg_e;
	reg [31:0] reg_f;
	reg [31:0] reg_g;
	reg [31:0] reg_h;
	reg [31:0] reg_i;
	reg [31:0] reg_j;
	
	reg [23:0] delay_lcdclk;
	reg [15:0] count_lcd;
	reg lcd_en;		//text-lcd device enable signal
	
	initial
	begin
		reg_a = 0;
		reg_b = 0;
		reg_c = 0;
		reg_d = 0;
		reg_e = 0;
		reg_f = 0;
		reg_g = 0;
		reg_h = 0;
		reg_i = 0;
		reg_j = 0;
		
		delay_lcdclk = 0;
		count_lcd = 0;
		lcd_en = 0;
	end
	
	always @(posedge clk)
	begin
		if (resetn == 0)
			begin
				reg_a <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
				reg_b <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
				reg_c <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
				reg_d <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
				
				reg_e <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
				reg_f <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
				reg_g <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
				reg_h <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
				reg_i <= 32'h71982000;
		
				delay_lcdclk <= 0;
				count_lcd <= 0;
				lcd_en <= 1'b0;
			end
		else 
			begin		// draw elevator
				reg_a <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ;
				reg_e <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ;

				case (elv1_floor)
					1 : begin
						reg_f <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_g <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_h <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_ev		} ; 
						end
					2 : begin
						reg_f <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_g <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_h <= {`lcd_blank, 	`lcd_blank, 	`lcd_ev,			`lcd_blank	} ; 
						end 
					3 : begin
						reg_f <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_g <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_h <= {`lcd_blank, 	`lcd_ev, 		`lcd_blank, 	`lcd_blank	} ; 
						end
					4 : begin
						reg_f <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_g <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_h <= {`lcd_ev, 		`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						end
					5 : begin
						reg_f <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_g <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_ev		} ; 
						reg_h <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						end
					6 : begin
						reg_f <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_g <= {`lcd_blank, 	`lcd_blank, 	`lcd_ev, 		`lcd_blank	} ; 
						reg_h <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						end
					7 : begin
						reg_f <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_g <= {`lcd_blank, 	`lcd_ev, 		`lcd_blank, 	`lcd_blank	} ; 
						reg_h <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						end
					8 : begin
						reg_f <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_g <= {`lcd_ev, 		`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_h <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						end
					9 : begin
						reg_f <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_ev		} ; 
						reg_g <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_h <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						end
				endcase
				
				case (elv2_floor)
					1 : begin
						reg_b <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_c <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_d <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_ev		} ; 
						end
					2 : begin
						reg_b <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_c <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_d <= {`lcd_blank, 	`lcd_blank, 	`lcd_ev,			`lcd_blank	} ; 
						end 
					3 : begin
						reg_b <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_c <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_d <= {`lcd_blank, 	`lcd_ev, 		`lcd_blank, 	`lcd_blank	} ; 
						end
					4 : begin
						reg_b <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_c <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_d <= {`lcd_ev, 		`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						end
					5 : begin
						reg_b <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_c <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_ev		} ; 
						reg_d <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						end
					6 : begin
						reg_b <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_c <= {`lcd_blank, 	`lcd_blank, 	`lcd_ev, 		`lcd_blank	} ; 
						reg_d <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						end
					7 : begin
						reg_b <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_c <= {`lcd_blank, 	`lcd_ev, 		`lcd_blank, 	`lcd_blank	} ; 
						reg_d <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						end
					8 : begin
						reg_b <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_c <= {`lcd_ev, 		`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ;  
						reg_d <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						end
					9 : begin
						reg_b <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_ev		} ; 
						reg_c <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						reg_d <= {`lcd_blank, 	`lcd_blank, 	`lcd_blank, 	`lcd_blank	} ; 
						end
				endcase
				
				reg_i <= 32'h71982000;
				
				
				if (delay_lcdclk < 2000)
					delay_lcdclk <=  delay_lcdclk + 1;
				else
					delay_lcdclk <= 0;
				
				if (delay_lcdclk == 0) 
					begin
						if (count_lcd < 40)
							count_lcd <= count_lcd + 1;
						else
							count_lcd <= 7;
					end
				
				if (delay_lcdclk == 200)
					lcd_en <= 1'b1;
				else if (delay_lcdclk == 1800)
					lcd_en <= 1'b0;
					
			end
	end


	
	/*** manipulate text lcd ***/
	reg  [4:0] lcd_mode = 0;
	wire [4:0] mode_pwron = 1 ;  // power on
	wire [4:0] mode_fnset = 2 ;  // function set
	wire [4:0] mode_onoff = 3 ;  // display on/off control
	wire [4:0] mode_entr1 = 4 ;  // 
	wire [4:0] mode_entr2 = 5 ;  // 
	wire [4:0] mode_entr3 = 6 ;  // 
	wire [4:0] mode_seta1 = 7 ;  // set addr 1st line
	wire [4:0] mode_wr1st = 8 ;  // write 1st line
	wire [4:0] mode_seta2 = 9 ;  // set addr 2nd line
	wire [4:0] mode_wr2nd = 10;  // write 2nd line
	wire [4:0] mode_delay = 11;  // dealy
	wire [4:0] mode_actcm = 12;  // user command

	
	// count_lcd
	always @(posedge clk)// or posedge presetn)
	begin
		if (resetn == 0)
			lcd_mode <= mode_pwron;
		else 
			begin
				case (count_lcd)
					0  : lcd_mode <= mode_pwron ;
					1  : lcd_mode <= mode_fnset ;
					2  : lcd_mode <= mode_onoff ;
					3  : lcd_mode <= mode_entr1 ;
					4  : lcd_mode <= mode_entr2 ;
					5  : lcd_mode <= mode_entr3 ;
					6  : lcd_mode <= mode_seta1 ;
					7  : lcd_mode <= mode_wr1st ;
					23 : lcd_mode <= mode_seta2 ;
					24 : lcd_mode <= mode_wr2nd ;
					40 : lcd_mode <= mode_delay ;
					41 : lcd_mode <= mode_actcm ;
					default : begin end 
				endcase	
			end
	end

	
	//text lcd device input signal
	reg [9:0] set_data;
					
	assign lcd_rs = set_data[9];
	assign lcd_rw = set_data[8];
	assign lcd_data = set_data[7:0];

	always @(clk or lcd_mode or count_lcd)// or presetn
	begin 
		if (resetn == 0)
			set_data <= 10'b0000000000;
		else
			begin
				case (lcd_mode)
					mode_pwron : set_data <= {2'b00, 8'h38};
					mode_fnset : set_data <= {2'b00, 8'h38};
					mode_onoff : set_data <= {2'b00, 8'h0e};
					mode_entr1 : set_data <= {2'b00, 8'h06};
					mode_entr2 : set_data <= {2'b00, 8'h02};
					mode_entr3 : set_data <= {2'b00, 8'h01};			    
					mode_seta1 : set_data <= {2'b00, 8'h80};
					mode_wr1st : 
						begin 
							case (count_lcd)
								 7 : set_data <= {1'b1, 1'b0, reg_a[31:24]};
								 8 : set_data <= {1'b1, 1'b0, reg_a[23:16]};
								 9 : set_data <= {1'b1, 1'b0, reg_a[15: 8]}; 
								10 : set_data <= {1'b1, 1'b0, reg_a[7 : 0]}; 
								11 : set_data <= {1'b1, 1'b0, reg_b[31:24]};
								12 : set_data <= {1'b1, 1'b0, reg_b[23:16]};
								13 : set_data <= {1'b1, 1'b0, reg_b[15: 8]}; 
								14 : set_data <= {1'b1, 1'b0, reg_b[7 : 0]}; 
								15 : set_data <= {1'b1, 1'b0, reg_c[31:24]};
								16 : set_data <= {1'b1, 1'b0, reg_c[23:16]};
								17 : set_data <= {1'b1, 1'b0, reg_c[15: 8]}; 
								18 : set_data <= {1'b1, 1'b0, reg_c[7 : 0]}; 
								19 : set_data <= {1'b1, 1'b0, reg_d[31:24]};
								20 : set_data <= {1'b1, 1'b0, reg_d[23:16]};
								21 : set_data <= {1'b1, 1'b0, reg_d[15: 8]};
								22 : set_data <= {1'b1, 1'b0, reg_d[7 : 0]};
							endcase
						end
					 
					mode_seta2 : set_data <= {2'b00, 8'hc0};
					mode_wr2nd : 
						begin
							case (count_lcd)
								24 : set_data <= {1'b1, 1'b0, reg_e[31:24]};
								25 : set_data <= {1'b1, 1'b0, reg_e[23:16]};
								26 : set_data <= {1'b1, 1'b0, reg_e[15: 8]}; 
								27 : set_data <= {1'b1, 1'b0, reg_e[7 : 0]}; 
								28 : set_data <= {1'b1, 1'b0, reg_f[31:24]};
								29 : set_data <= {1'b1, 1'b0, reg_f[23:16]};
								30 : set_data <= {1'b1, 1'b0, reg_f[15: 8]}; 
								31 : set_data <= {1'b1, 1'b0, reg_f[7 : 0]}; 
								32 : set_data <= {1'b1, 1'b0, reg_g[31:24]};
								33 : set_data <= {1'b1, 1'b0, reg_g[23:16]};
								34 : set_data <= {1'b1, 1'b0, reg_g[15: 8]}; 
								35 : set_data <= {1'b1, 1'b0, reg_g[7 : 0]}; 
								36 : set_data <= {1'b1, 1'b0, reg_h[31:24]};
								37 : set_data <= {1'b1, 1'b0, reg_h[23:16]};
								38 : set_data <= {1'b1, 1'b0, reg_h[15: 8]};
								39 : set_data <= {1'b1, 1'b0, reg_h[7 : 0]};
							endcase
						end
									
					mode_delay : set_data <= {2'b00, 8'h02};
					mode_actcm : set_data <= {2'b00, 8'h02};
					default : begin end
				endcase
			end
	end

endmodule
