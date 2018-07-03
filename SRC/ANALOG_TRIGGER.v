//dragon_ver3_readout_board
//KONNO Yusuke
//Kyoto Univ.
//analog trigger module
//20140219: include Analog Trigger ASIC

module ANALOG_TRIGGER_ASICMEZZ(
			 L0_CTR7,
			 L0_CTR6,
			 L0_CTR5,
			 L0_CTR4,
			 L0_CTR3,
			 L0_CTR2,
			 L0_CTR1,
			 L0_CTR0,
			 L1_OUT_P,
			 L1_OUT_N,
			 L1_OUT2_P,
			 L1_OUT2_N,
			 L1_SC_DOUT,
			 L1_SC_CLK,
			 L1_SC_DIN,
			 L1_SC_EN,
			 L1_INIT_R,
			 TRIG_BPOUT_P,
			 TRIG_BPOUT_N,
			 TRIGL1_P,
			 TRIGL1_N,
			 TRIGL1_async,
			 dtrig_trig,
			 
			 clk_133m,
			 clk_66m,
			 rst,
			 l1_out,
			 l1_out2,
			 trigl1,
			 command_l0_sc_write,
			 command_l0_sc_read,
			 command_l0_reset,
			 command_l0dela_reset,
			 command_l0dela_set,
			 l0_sc_write_done,
			 l0_sc_read_done,
			 l0_reset_done,
			 l0dela_reset_done,
			 l0dela_set_done,
			 command_l1_sc_write,
			 command_l1_sc_read,
			 command_l1_reset,
			 l1_sc_write_done,
			 l1_sc_read_done,
			 l1_reset_done,
			 
			 DIGITAL_TRIG_BPOUT_P,
			 DIGITAL_TRIG_BPOUT_N,
			 DIGITAL_TRIG_OUT_P,
			 DIGITAL_TRIG_OUT_N, 
			 IPR_0,
			 IPR_1,
			 IPR_2,
			 IPR_3,
			 IPR_4,
			 IPR_5,
			 IPR_6,
			 
			 RATE_WINDOW,
			 RATE_WINDOWL1,
			 RATE_L1OUT,
			 RATE_L1OUT2,
			 RATE_TRIGL1,
			 L0_SC_ADDRESS,
			 L0_SC_DATA,
			 L0_SC_READ,
			 L0_DELAYEXPAND_DATA,
			 L1_SC_ADDRESS,
			 L1_SC_DATA,
			 L1_SC_READ,
			 msec_133m,
			 usec_66m
				 
			 //DEBUG //debug
		 );
	 
//--------------------------------------------
//Port declaration
	output L0_CTR7;
	output L0_CTR6;
	output L0_CTR5;
	output L0_CTR4;
	input L0_CTR3;
	output L0_CTR2;
	output L0_CTR1;
	output L0_CTR0;
	input  L1_OUT_P;
	input  L1_OUT_N;
	input  L1_OUT2_P;
	input  L1_OUT2_N;
	input  L1_SC_DOUT;
	output L1_SC_CLK;
	output L1_SC_DIN;
	output L1_SC_EN;
	output L1_INIT_R;
	output[1:0] TRIG_BPOUT_P;
	output[1:0] TRIG_BPOUT_N;
	input TRIGL1_P;
	input TRIGL1_N;
	output TRIGL1_async;
	output[6:0] dtrig_trig;

	input clk_133m;
	input clk_66m;
	input rst;
	output l1_out;
	output l1_out2;
	output trigl1;
	input command_l0_sc_write;
	input command_l0_sc_read;
	input command_l0_reset;
	input command_l0dela_reset;
	input command_l0dela_set;
	output l0_sc_write_done;
	output l0_sc_read_done;
	output l0_reset_done;
	output l0dela_reset_done;
	output l0dela_set_done;
	input command_l1_sc_write;
	input command_l1_sc_read;
	input command_l1_reset;
	output l1_sc_write_done;
	output l1_sc_read_done;
	output l1_reset_done;

	output[6:0] DIGITAL_TRIG_BPOUT_P;
	output[6:0] DIGITAL_TRIG_BPOUT_N;
	input[6:0] DIGITAL_TRIG_OUT_P;
	input[6:0] DIGITAL_TRIG_OUT_N;
	output[15:0] IPR_0;
	output[15:0] IPR_1;
	output[15:0] IPR_2;
	output[15:0] IPR_3;
	output[15:0] IPR_4;
	output[15:0] IPR_5;
	output[15:0] IPR_6;
	
	input[15:0] RATE_WINDOW;
	input[15:0] RATE_WINDOWL1;
	output[15:0] RATE_L1OUT;
	output[15:0] RATE_L1OUT2;
	output[15:0] RATE_TRIGL1;
	input[6:0] L0_SC_ADDRESS;
	input[15:0] L0_SC_DATA;
	output[23:0] L0_SC_READ;
	input[23:0] L0_DELAYEXPAND_DATA;
	input[6:0] L1_SC_ADDRESS;
	input[15:0] L1_SC_DATA;
	output[23:0] L1_SC_READ;
	input msec_133m;
	input usec_66m;
	
	//input[7:0] DEBUG; //debug

//--------------------------------------------
//Analog L0 Trigger mezzanine with ASIC

	reg l0_subclk;
	reg[5:0] l0_subclk_c;
	reg l0_sc_en;
	reg l0_sc_clk;
	reg l0_sc_din;
	wire l0_sc_dout;
	reg l0_rst_asic; //active high
	reg[23:0] l0_sc_reg;
	reg[23:0] l0_sc_reg_start;
	reg[3:0] l0_state;
	reg[5:0] l0_count;
	reg l0_sc_write_done;
	reg l0_sc_read_done;
	reg l0_reset_done;

	reg[23:0] L0_SC_READ;
	reg[15:0] RATE_L1OUT;
	reg[15:0] RATE_L1OUT2;
	reg[15:0] RATE_TRIGL1;
	reg[15:0] IPR_0;
	reg[15:0] IPR_1;
	reg[15:0] IPR_2;
	reg[15:0] IPR_3;
	reg[15:0] IPR_4;
	reg[15:0] IPR_5;
	reg[15:0] IPR_6;

//delay line
	reg l0_cs_dela; // din/clk are shared with ASIC
	reg l0_rst_dela_n; //active low
	reg [7:0] l0_count3;
	reg [23:0] dela_reg;
	reg [23:0] dela_reg_start;
	reg l0dela_reset_done;
	reg l0dela_set_done;

	assign L0_CTR0 = l0_sc_clk;
	assign L0_CTR1 = l0_sc_din;
	assign L0_CTR2 = l0_sc_en;
	assign l0_sc_dout = L0_CTR3;
	assign L0_CTR4 = 1'b0;
	assign L0_CTR5 = l0_cs_dela; 
	assign L0_CTR6 = l0_rst_dela_n;
	assign L0_CTR7 = l0_rst_asic;

	always@(posedge clk_66m or posedge rst) begin
		if(rst) begin	
			l0_subclk <= 1'b0;
			l0_subclk_c <= 6'd0;
			l0_sc_en <= 1'b0;
			l0_sc_clk <=1'b0;
			l0_sc_din <= 1'b0;

			l0_rst_asic <= 1'b1;

			l0_sc_reg <= 24'd0;
			l0_sc_reg_start <= 24'd0;
			l0_state <= 4'd0;
			l0_count <= 6'd0;
			l0_sc_write_done <= 1'b0;
			l0_sc_read_done <= 1'b0;
			l0_reset_done <= 1'b0;
			L0_SC_READ <= 16'd0;
			l0_cs_dela <= 1'b1;
			l0_rst_dela_n <= 1'b0;
			l0_count3 <= 8'd0;
			dela_reg <= 24'd0;
			dela_reg_start <= 24'd0;
			l0dela_reset_done <= 1'b0;
			l0dela_set_done <= 1'b0;
		end else begin
			case(l0_state)
				4'd0: begin //command wait
					l0_subclk <= 1'b0;
					l0_subclk_c <= 6'd0;
					l0_sc_en <= 1'b0;
					l0_sc_clk <=1'b0;
					l0_sc_din <= 1'b0;
					l0_rst_asic <= 1'b0;
					l0_sc_reg <= 24'd0;
					l0_count <= 6'd0;
					l0_sc_write_done <= 1'b0;
					l0_sc_read_done <= 1'b0;
					l0_reset_done <= 1'b0;
					l0_cs_dela <= 1'b1;
					l0_rst_dela_n <= 1'b1;
					l0_count3 <= 8'd0;
					dela_reg <= 24'd0;
					l0dela_reset_done <= 1'b0;
					l0dela_set_done <= 1'b0;

					if(command_l0_reset == 1'b1) begin
						l0_state <= 4'd5;
					end else if(command_l0dela_reset == 1'b1) begin
						l0_state <= 4'd9;
					end else if(command_l0dela_set == 1'b1) begin
						l0_state <= 4'd7;
					end else if(command_l0_sc_write == 1'b1) begin
						l0_state <= 4'd1;
					end else if(command_l0_sc_read == 1'b1) begin
						l0_state <= 4'd2;
					end

					if(command_l0_sc_write == 1'b1) begin
						l0_sc_reg_start <= {1'b0,L0_SC_ADDRESS[6:0],L0_SC_DATA[15:0]};
					end else if(command_l0_sc_read == 1'b1) begin
						l0_sc_reg_start <= {1'b1,L0_SC_ADDRESS[6:0],L0_SC_DATA[15:0]};
					end else begin
						l0_sc_reg_start <= 24'd0;
					end

					if(command_l0dela_set == 1'b1) begin
						dela_reg_start <= L0_DELAYEXPAND_DATA;
					end else begin
						dela_reg_start <= 24'd0;
					end
				end

				4'd1: begin // write L0 ASIC register
					if(l0_subclk == 1'b1 && l0_count == 6'd28) begin
						l0_subclk_c <= 6'd0;
						l0_subclk <= 1'b0;
					end else if(l0_subclk_c == 6'd3)begin
						l0_subclk_c <= 6'd0;
						l0_subclk <= 1'b1;
					end else begin
						l0_subclk_c <= l0_subclk_c + 6'd1;
						l0_subclk <= 1'b0;
					end

					if(l0_subclk == 1'b1 && l0_count == 6'd28) begin
						l0_sc_clk <= 1'b0;
					end else if(l0_subclk == 1'b1) begin
						l0_sc_clk <= ~l0_sc_clk;
					end

					if(l0_subclk == 1'b1 && l0_count == 6'd28) begin
						l0_count <= 6'b0;
					end else if(l0_subclk == 1'b1 && l0_sc_clk == 1'b1) begin
						l0_count <= l0_count + 6'd1;
					end

					if(l0_subclk == 1'b1 && l0_count == 6'd0) begin
						l0_sc_en <= 1'b1;
					end else if(l0_subclk == 1'b1 && l0_count == 6'd24) begin
						l0_sc_en <= 1'b0;
					end

					if(l0_subclk == 1'b1 && l0_count == 6'd28) begin
						l0_sc_reg[23:0] <= 24'd0;
					end else if(l0_subclk == 1'b1 && l0_sc_clk == 1'b0 && l0_count == 6'd0) begin
						//l0_sc_reg[23:0] <= {1'b0,L0_SC_ADDRESS[6:0],L0_SC_DATA[15:0]};
						l0_sc_reg[23:0] <= l0_sc_reg_start[23:0];
					end else if(l0_subclk == 1'b1 && l0_sc_clk == 1'b1 && l0_sc_en == 1'b1) begin
						l0_sc_reg[23:0] <= {l0_sc_reg[22:0],1'b0};
					end

					if(l0_subclk == 1'b1 && l0_count == 6'd28) begin
						l0_sc_din <= 1'b0;
					end else if(l0_subclk == 1'b1 && l0_count == 6'd0) begin
						l0_sc_din <= 1'b0;
					end else if(l0_subclk == 1'b1) begin
						l0_sc_din <= l0_sc_reg[23];
					end

					if(l0_subclk == 1'b1 && l0_count == 6'd28) begin
						l0_state <= 4'd3;
					end
				end

				4'd2: begin // read L0 ASIC register
					if(l0_subclk == 1'b1 && l0_count == 6'd28) begin
						l0_subclk_c <= 6'd0;
						l0_subclk <= 1'b0;
					end else if(l0_subclk_c == 6'd3)begin
						l0_subclk_c <= 6'd0;
						l0_subclk <= 1'b1;
					end else begin
						l0_subclk_c <= l0_subclk_c + 6'd1;
						l0_subclk <= 1'b0;
					end

					if(l0_subclk == 1'b1 && l0_count == 6'd28) begin
						l0_sc_clk <= 1'b0;
					end else if(l0_subclk == 1'b1) begin
						l0_sc_clk <= ~l0_sc_clk;
					end

					if(l0_subclk == 1'b1 && l0_count == 6'd28) begin
						l0_count <= 6'b0;
					end else if(l0_subclk == 1'b1 && l0_sc_clk == 1'b1) begin
						l0_count <= l0_count + 6'd1;
					end

					if(l0_subclk == 1'b1 && l0_count == 6'd0) begin
						l0_sc_en <= 1'b1;
					end else if(l0_subclk == 1'b1 && l0_count == 6'd24) begin
						l0_sc_en <= 1'b0;
					end

					if(l0_subclk == 1'b1 && l0_count == 6'd28) begin
						l0_sc_reg[23:0] <= 24'd0;
					end else if(l0_subclk == 1'b1 && l0_sc_clk == 1'b0 && l0_count == 6'd0) begin
						//l0_sc_reg[23:0] <= {1'b1,L0_SC_ADDRESS[6:0],L0_SC_DATA[15:0]};
						//l0_sc_reg[23:0] <= l0_sc_reg_start[23:0];
						l0_sc_reg[23:0] <= {l0_sc_reg_start[23:16],16'd0};
					end else if(l0_subclk == 1'b1 && l0_sc_clk == 1'b1 && l0_sc_en == 1'b1) begin
						l0_sc_reg[23:0] <= {l0_sc_reg[22:0],1'b0};
					end

					if(l0_subclk == 1'b1 && l0_count == 6'd28) begin
						l0_sc_din <= 1'b0;
					end else if(l0_subclk == 1'b1 && l0_count == 6'd0) begin
						l0_sc_din <= 1'b1;
					end else if(l0_subclk == 1'b1) begin
						l0_sc_din <= l0_sc_reg[23];
					end

					L0_SC_READ[23:16] <= l0_sc_reg_start[23:16];
					if(l0_subclk == 1'b1 && l0_sc_clk == 1'b0 && l0_count >= 6'd9 && l0_count <= 6'd24) begin
						L0_SC_READ[15:0] <= {L0_SC_READ[14:0],l0_sc_dout};
					end

					if(l0_subclk == 1'b1 && l0_count == 6'd28) begin
						l0_state <= 4'd4;
					end
				end


				4'd3: begin //write done
					if(command_l0_sc_write == 1'b0) begin
						l0_state <= 4'd0;
						l0_sc_write_done <= 1'b0;
					end else begin
						l0_sc_write_done <= 1'b1;
					end
				end

				4'd4: begin //read done
					if(command_l0_sc_read == 1'b0) begin
						l0_state <= 4'd0;
						l0_sc_read_done <= 1'b0;
					end else begin
						l0_sc_read_done <= 1'b1;
					end
				end

				4'd5: begin //reset asic
					if(l0_subclk_c == 6'd63)begin
						l0_subclk_c <= 6'd0;
						l0_rst_asic <= 1'b0;
						l0_state <= 4'd6;
					end else begin
						if(usec_66m) begin
							l0_subclk_c <= l0_subclk_c + 6'd1;
						end
						l0_rst_asic <= 1'b1;
					end
				end

				4'd6: begin //reset asic done
					if(command_l0_reset == 1'b0) begin
						l0_state <= 4'd0;
						l0_reset_done <= 1'b0;
					end else begin
						l0_reset_done <= 1'b1;
					end
				end

				4'd7: begin // set analog delay
					if(l0_count3 == 8'd10) begin
						l0_count3 <= 8'd0;							
					end else begin
						l0_count3 <= l0_count3 +8'd1;
					end
		
					if(l0_count3 == 8'd10) begin
						if(l0_count == 6'd0) begin
							l0_cs_dela <= 1'b0;
							dela_reg <= dela_reg_start;
							
							l0_count <= l0_count + 6'd1;
						end else if(l0_count == 6'd1) begin
							l0_sc_din <= dela_reg[23];
							dela_reg[23:1] <= dela_reg[22:0];
							l0_count <= l0_count + 6'd1;
						end else if(l0_count == 6'd53) begin
							l0_count <= 6'd0;
						end else if (l0_count >= 6'd50)begin
							l0_count <= l0_count + 6'd1;
							l0_sc_clk <= 1'b0;
							l0_sc_din <= 1'b0;
							l0_cs_dela <= 1'b1;
						end else begin
							l0_sc_clk <= ~l0_sc_clk;
							l0_count <= l0_count + 6'd1;
							if(l0_sc_clk == 1'b1) begin
								l0_sc_din <= dela_reg[23];
								dela_reg[23:1] <= dela_reg[22:0];
							end
						end
					end
					
					if(l0_count == 6'd53 && l0_count3 == 8'd10) begin
						l0_state <= 4'd8;
					end
				end
				
				4'd8:begin //l0delayexpand finish flag
					if(command_l0dela_set == 1'b1) begin
						l0dela_set_done <= 1'b1;
					end else begin
						l0dela_set_done <= 1'b0;
					end
					
					if(command_l0dela_set == 1'b0) begin
						l0_state <= 4'd0;
					end
				end

				4'd9: begin //reset delay
					if(l0_subclk_c == 6'd63)begin
						l0_subclk_c <= 6'd0;
						l0_rst_dela_n <= 1'b1;
						l0_state <= 4'd10;
					end else begin
						if(usec_66m) begin
							l0_subclk_c <= l0_subclk_c + 6'd1;
						end
						l0_rst_dela_n <= 1'b0;
					end
				end

				4'd10: begin //reset delay done
					if(command_l0dela_reset == 1'b0) begin
						l0_state <= 4'd0;
						l0dela_reset_done <= 1'b0;
					end else begin
						l0dela_reset_done <= 1'b1;
					end
				end

			endcase
		end
	end

//----------------------------------------------------------------------
//Analog L1 Trigger mezzanine with ASIC

	reg l1_subclk;
	reg[5:0] l1_subclk_c;
	reg rl1_sc_en;
	reg rl1_sc_clk;
	reg rl1_sc_din;
	reg rl1_init_r;
	reg[23:0] l1_sc_reg;
	reg[23:0] l1_sc_reg_start;
	reg[2:0] l1_state;
	reg[5:0] l1_count;
	reg l1_sc_write_done;
	reg l1_sc_read_done;
	reg l1_reset_done;
	reg[23:0] L1_SC_READ;

	assign L1_SC_CLK = rl1_sc_clk;
	assign L1_SC_DIN = rl1_sc_din;
	assign L1_SC_EN = rl1_sc_en;
	assign L1_INIT_R = rl1_init_r;

	always@(posedge clk_66m or posedge rst) begin
		if(rst) begin	
			l1_subclk <= 1'b0;
			l1_subclk_c <= 6'd0;
			rl1_sc_en <= 1'b0;
			rl1_sc_clk <=1'b0;
			rl1_sc_din <= 1'b0;

			rl1_init_r <= 1'b1;

			l1_sc_reg <= 24'd0;
			l1_sc_reg_start <= 24'd0;
			l1_state <= 3'd0;
			l1_count <= 6'd0;
			l1_sc_write_done <= 1'b0;
			l1_sc_read_done <= 1'b0;
			l1_reset_done <= 1'b0;
			L1_SC_READ <= 23'd0;
		end else begin
			case(l1_state)

				3'd0: begin //command wait
					l1_subclk <= 1'b0;
					l1_subclk_c <= 6'd0;
					rl1_sc_en <= 1'b0;
					rl1_sc_clk <=1'b0;
					rl1_sc_din <= 1'b0;
					rl1_init_r <= 1'b0;
					l1_sc_reg <= 24'd0;
					l1_count <= 6'd0;
					l1_sc_write_done <= 1'b0;
					l1_sc_read_done <= 1'b0;
					l1_reset_done <= 1'b0;

					if(command_l1_reset == 1'b1) begin
						l1_state <= 3'd5;
					end else if(command_l1_sc_write == 1'b1) begin
						l1_state <= 3'd1;
					end else if(command_l1_sc_read == 1'b1) begin
						l1_state <= 3'd2;
					end

					if(command_l1_sc_write == 1'b1) begin
						l1_sc_reg_start <= {1'b0,L1_SC_ADDRESS[6:0],L1_SC_DATA[15:0]};
					end else if(command_l1_sc_read == 1'b1) begin
						l1_sc_reg_start <= {1'b1,L1_SC_ADDRESS[6:0],L1_SC_DATA[15:0]};
					end else begin
						l1_sc_reg_start <= 24'd0;
					end

				end

				3'd1: begin // write L1 ASIC register
					if(l1_subclk == 1'b1 && l1_count == 6'd29) begin
						l1_subclk_c <= 6'd0;
						l1_subclk <= 1'b0;
					end else if(l1_subclk_c == 6'd15)begin
						l1_subclk_c <= 6'd0;
						l1_subclk <= 1'b1;
					end else begin
						l1_subclk_c <= l1_subclk_c + 6'd1;
						l1_subclk <= 1'b0;
					end

					if(l1_subclk == 1'b1 && l1_count == 6'd29) begin
						rl1_sc_clk <= 1'b0;
					end else if(l1_subclk == 1'b1) begin
						rl1_sc_clk <= ~rl1_sc_clk;
					end

					if(l1_subclk == 1'b1 && l1_count == 6'd29) begin
						l1_count <= 6'b0;
					end else if(l1_subclk == 1'b1 && rl1_sc_clk == 1'b1) begin
						l1_count <= l1_count + 6'd1;
					end

					if(l1_subclk == 1'b1 && l1_count == 6'd2) begin
						rl1_sc_en <= 1'b1;
					end else if(l1_subclk == 1'b1 && l1_count == 6'd26) begin
						rl1_sc_en <= 1'b0;
					end

					if(l1_subclk == 1'b1 && l1_count == 6'd29) begin
						l1_sc_reg[23:0] <= 24'd0;
					end else if(l1_subclk == 1'b1 && l1_count == 6'd0) begin
						//l1_sc_reg[23:0] <= {1'b0,L1_SC_ADDRESS[6:0],L1_SC_DATA[15:0]};
						l1_sc_reg[23:0] <= l1_sc_reg_start[23:0];
					end else if(l1_subclk == 1'b1 && rl1_sc_clk == 1'b1 && rl1_sc_en == 1'b1) begin
						l1_sc_reg[23:0] <= {l1_sc_reg[22:0],1'b0};
					end

					if(l1_subclk == 1'b1 && l1_count == 6'd29) begin
						rl1_sc_din <= 1'b0;
					end else if(l1_subclk == 1'b1) begin
						rl1_sc_din <= l1_sc_reg[23];
					end

					if(l1_subclk == 1'b1 && l1_count == 6'd29) begin
						l1_state <= 3'd3;
					end
				end

				3'd2: begin // read L1 ASIC register
					if(l1_subclk == 1'b1 && l1_count == 6'd29) begin
						l1_subclk_c <= 5'd0;
						l1_subclk <= 1'b0;
					end else if(l1_subclk_c == 5'd15)begin
						l1_subclk_c <= 5'd0;
						l1_subclk <= 1'b1;
					end else begin
						l1_subclk_c <= l1_subclk_c + 5'd1;
						l1_subclk <= 1'b0;
					end

					if(l1_subclk == 1'b1 && l1_count == 6'd29) begin
						rl1_sc_clk <= 1'b0;
					end else if(l1_subclk == 1'b1) begin
						rl1_sc_clk <= ~rl1_sc_clk;
					end

					if(l1_subclk == 1'b1 && l1_count == 6'd29) begin
						l1_count <= 6'b0;
					end else if(l1_subclk == 1'b1 && rl1_sc_clk == 1'b1) begin
						l1_count <= l1_count + 6'd1;
					end

					if(l1_subclk == 1'b1 && l1_count == 6'd2) begin
						rl1_sc_en <= 1'b1;
					end else if(l1_subclk == 1'b1 && l1_count == 6'd26) begin
						rl1_sc_en <= 1'b0;
					end

					if(l1_subclk == 1'b1 && l1_count == 6'd29) begin
						l1_sc_reg[23:0] <= 24'd0;
					end else if(l1_subclk == 1'b1 && rl1_sc_clk == 1'b1 && l1_count == 6'd0) begin
						//l1_sc_reg[23:0] <= {1'b1,L1_SC_ADDRESS[6:0],L1_SC_DATA[15:0]};
						//l1_sc_reg[23:0] <= l1_sc_reg_start[23:0];
						l1_sc_reg[23:0] <= {l1_sc_reg_start[23:16],16'd0};
					end else if(l1_subclk == 1'b1 && rl1_sc_clk == 1'b1 && rl1_sc_en == 1'b1) begin
						l1_sc_reg[23:0] <= {l1_sc_reg[22:0],1'b1};
					end

					if(l1_subclk == 1'b1 && l1_count == 6'd29) begin
						rl1_sc_din <= 1'b0;
					end else if(l1_subclk == 1'b1) begin
						rl1_sc_din <= l1_sc_reg[23];
					end

					L1_SC_READ[23:16] <= l1_sc_reg_start[23:16];
					if(l1_subclk == 1'b1 && rl1_sc_clk == 1'b0 && l1_count >= 6'd11 && l1_count <= 6'd26) begin
						L1_SC_READ[15:0] <= {L1_SC_READ[14:0],L1_SC_DOUT};
					end

					if(l1_subclk == 1'b1 && l1_count == 6'd29) begin
						l1_state <= 3'd4;
					end
				end


				3'd3: begin //write done
					if(command_l1_sc_write == 1'b0) begin
						l1_state <= 3'd0;
						l1_sc_write_done <= 1'b0;
					end else begin
						l1_sc_write_done <= 1'b1;
					end
				end

				3'd4: begin //read done
					if(command_l1_sc_read == 1'b0) begin
						l1_state <= 3'd0;
						l1_sc_read_done <= 1'b0;
					end else begin
						l1_sc_read_done <= 1'b1;
					end
				end

				3'd5: begin //reset
					if(l1_subclk_c == 6'd32)begin
						l1_subclk_c <= 6'd0;
						rl1_init_r <= 1'b0;
						l1_state <= 3'd6;
					end else begin
						l1_subclk_c <= l1_subclk_c + 6'd1;
						rl1_init_r <= 1'b1;
					end
				end

				3'd6: begin //reset done
					if(command_l1_reset == 1'b0) begin
						l1_state <= 3'd0;
						l1_reset_done <= 1'b0;
					end else begin
						l1_reset_done <= 1'b1;
					end

				end

			endcase
		end
	end

//---------------------------------------------------------------------------------
//TRIGGER LVDS INPUT BUFFER
	wire l1_out_ibufo;
	wire l1_out2_ibufo;
	wire[6:0] dtrig_trig_ibufo;
	wire[6:0] dtrig_bpout;

	wire[6:0] dtrig;
	reg[6:0] dtrig_ir;
	reg[6:0] dtrig_resynch;
	reg[6:0] dtrig_resynchbuf;
	reg[6:0] dtrig_resynchbuf2;
	reg[6:0] dtrig_resynchbuf3;
	reg[6:0] dtrig_resynchrst;
	wire l1_out;
	wire l1_out2;
	reg l1_out_ir;
	reg l1_out2_ir;
	reg l1out_resynch;
	reg l1out_resynchbuf;
	reg l1out_resynchbuf2;
	reg l1out_resynchbuf3;
	reg l1out_resynchrst;
	reg l1out2_resynch;
	reg l1out2_resynchbuf;
	reg l1out2_resynchbuf2;
	reg l1out2_resynchbuf3;
	reg l1out2_resynchrst;

	IBUFDS #(.DIFF_TERM ("TRUE"), .IOSTANDARD("LVDS_33")) L1_OUT_INPUTBUFFER (
		.I(L1_OUT_P),
		.IB(L1_OUT_N),
		.O(l1_out_ibufo)
	); 

	IBUFDS #(.DIFF_TERM ("TRUE"), .IOSTANDARD("LVDS_33")) L1_OUTEXT_INPUTBUFFER (
		.I(L1_OUT2_P),
		.IB(L1_OUT2_N),
		.O(l1_out2_ibufo)
	); 
	
	assign dtrig_bpout = dtrig_trig_ibufo;

	generate
		genvar i;
		for(i=0;i<7;i=i+1) begin:TRIG_GEN
			IBUFDS #(.DIFF_TERM("TRUE"), .IOSTANDARD("LVDS_33")) TRIG_IBUFDS(.I(DIGITAL_TRIG_OUT_P[i]), .IB(DIGITAL_TRIG_OUT_N[i]), .O(dtrig_trig_ibufo[i]));
			
			OBUFDS #(
				.IOSTANDARD("LVDS_33")
				) OBUFDS_TRIG_BPOUT (
				.O(DIGITAL_TRIG_BPOUT_P[i]),
				.OB(DIGITAL_TRIG_BPOUT_N[i]),
				.I(dtrig_bpout[i])
			);

			always@(posedge clk_133m or posedge rst) begin
				if(rst) begin
					dtrig_resynchrst[i] <= 1'b1;
				end else begin
					dtrig_resynchrst[i] <= dtrig_resynchbuf3[i];
				end
			end

			always@(posedge dtrig_trig_ibufo[i] or posedge dtrig_resynchrst[i]) begin
				if(dtrig_resynchrst[i]) begin
					dtrig_resynch[i] <= 1'b0;
				end else begin
					dtrig_resynch[i] <= 1'b1;
				end
			end
		end
	endgenerate

	always@(posedge clk_133m or posedge rst) begin
		if(rst) begin
			dtrig_resynchbuf <= 7'd0;
			dtrig_resynchbuf2 <= 7'd0;
			dtrig_resynchbuf3 <= 7'd0;
		end else begin
			dtrig_resynchbuf <= dtrig_resynch;
			dtrig_resynchbuf2 <= dtrig_resynchbuf;
			dtrig_resynchbuf3 <= dtrig_resynchbuf2;
		end
	end
	
	OBUFDS #(
		.IOSTANDARD("LVDS_33")
		) OBUFDS_TRIG_BPOUT1 (
		.O(TRIG_BPOUT_P[1]),
		.OB(TRIG_BPOUT_N[1]),
		.I(l1_out2_ibufo)
	);	
	OBUFDS #(
		.IOSTANDARD("LVDS_33")
		) OBUFDS_TRIG_BPOUT0 (
		.O(TRIG_BPOUT_P[0]),
		.OB(TRIG_BPOUT_N[0]),
		.I(l1_out_ibufo)
	);

	always@(posedge clk_133m or posedge rst) begin
		if(rst) begin
			l1out_resynchrst <= 1'b1;
			l1out2_resynchrst <= 1'b1;
		end else begin
			l1out_resynchrst <= l1out_resynchbuf3;
			l1out2_resynchrst <= l1out2_resynchbuf3;
		end
	end
	always@(posedge l1_out_ibufo or posedge l1out_resynchrst) begin
		if(l1out_resynchrst) begin
			l1out_resynch <= 1'b0;
		end else begin
			l1out_resynch <= 1'b1;
		end
	end
	always@(posedge l1_out2_ibufo or posedge l1out2_resynchrst) begin
		if(l1out2_resynchrst) begin
			l1out2_resynch <= 1'b0;
		end else begin
			l1out2_resynch <= 1'b1;
		end
	end
	always@(posedge clk_133m or posedge rst) begin
		if(rst) begin
			l1out_resynchbuf <= 1'b0;
			l1out_resynchbuf2 <= 1'b0;
			l1out_resynchbuf3 <= 1'b0;
			l1out2_resynchbuf <= 1'b0;
			l1out2_resynchbuf2 <= 1'b0;
			l1out2_resynchbuf3 <= 1'b0;
		end else begin
			l1out_resynchbuf <= l1out_resynch;
			l1out_resynchbuf2 <= l1out_resynchbuf;
			l1out_resynchbuf3 <= l1out_resynchbuf2;
			l1out2_resynchbuf <= l1out2_resynch;
			l1out2_resynchbuf2 <= l1out2_resynchbuf;
			l1out2_resynchbuf3 <= l1out2_resynchbuf2;
		end
	end

	wire trigl1_ibufo;
	assign TRIGL1_async = trigl1_ibufo;
	reg trigl1_ir;
	reg trigl1_ir2;
	reg trigl1_resynch;
	reg trigl1_resynchbuf;
	reg trigl1_resynchbuf2;
	reg trigl1_resynchbuf3;
	reg trigl1_resynchrst;
	
	IBUFDS #(.DIFF_TERM ("TRUE"), .IOSTANDARD("LVDS_33")) TRIGL1_INPUTBUFFER (
		.I(TRIGL1_P),
		.IB(TRIGL1_N),
		.O(trigl1_ibufo)
	); 
	
	always@(posedge clk_133m or posedge rst) begin
		if(rst) begin
			trigl1_resynchrst <= 1'b1;
		end else begin
			trigl1_resynchrst <= trigl1_resynchbuf3;
		end
	end
	always@(posedge trigl1_ibufo or posedge trigl1_resynchrst) begin
		if(trigl1_resynchrst) begin
			trigl1_resynch <= 1'b0;
		end else begin
			trigl1_resynch <= 1'b1;
		end
	end
	always@(posedge clk_133m or posedge rst) begin
		if(rst) begin
			trigl1_resynchbuf <= 1'b0;
			trigl1_resynchbuf2 <= 1'b0;
			trigl1_resynchbuf3 <= 1'b0;
		end else begin
			trigl1_resynchbuf <= trigl1_resynch;
			trigl1_resynchbuf2 <= trigl1_resynchbuf;
			trigl1_resynchbuf3 <= trigl1_resynchbuf2;
		end
	end

	always@(posedge clk_133m or posedge rst) begin
		if(rst) begin
			l1_out_ir <= 1'b0;
			l1_out2_ir <= 1'b0;
			trigl1_ir <= 1'b0;
			dtrig_ir <= 7'd0;
		end else begin
			l1_out_ir <= l1out_resynchbuf3;
			l1_out2_ir <= l1out2_resynchbuf3;
			trigl1_ir <= trigl1_resynchbuf3;
			dtrig_ir <= dtrig_resynchbuf3;
		end
	end
	
	assign trigl1 = trigl1_resynchbuf3 & ~trigl1_ir;
	assign l1_out = l1out_resynchbuf3 & ~l1_out_ir;
	assign l1_out2 = l1out2_resynchbuf3 & ~l1_out2_ir;
	assign dtrig = dtrig_resynchbuf3 & ~dtrig_ir;
	assign dtrig_trig = dtrig;

//----------------------------------------------------------------------
//RATE Monitor

	reg[15:0] rate_msec_c;
	reg[15:0] ratel1_msec_c;
	reg rate_start;
	reg ratel1_start;
	reg[15:0] rate_l1out_reg;
	reg[15:0] rate_l1out2_reg;
	reg[15:0] rate_trigl1_reg;
	reg[15:0] rate_window_reg;
	reg[15:0] ratel1_window_reg;
	reg[15:0] rate_ipr0_reg;
	reg[15:0] rate_ipr1_reg;
	reg[15:0] rate_ipr2_reg;
	reg[15:0] rate_ipr3_reg;
	reg[15:0] rate_ipr4_reg;
	reg[15:0] rate_ipr5_reg;
	reg[15:0] rate_ipr6_reg;

	always@(posedge clk_133m or posedge rst) begin
		if(rst) begin
			rate_msec_c <= 16'd0;
			ratel1_msec_c <= 16'd0;
			rate_start <= 1'b0;
			ratel1_start <= 1'b0;
			rate_l1out_reg <= 16'd0;
			rate_l1out2_reg <= 16'd0;
			rate_trigl1_reg <= 16'd0;
			rate_window_reg <= 16'd0;
			ratel1_window_reg <= 16'd0;
			rate_ipr0_reg <= 16'd0;
			rate_ipr1_reg <= 16'd0;
			rate_ipr2_reg <= 16'd0;
			rate_ipr3_reg <= 16'd0;
			rate_ipr4_reg <= 16'd0;
			rate_ipr5_reg <= 16'd0;
			rate_ipr6_reg <= 16'd0;
		end else begin
			if(msec_133m == 1'b1) begin
				if(rate_msec_c[15:0] == rate_window_reg[15:0]) begin
					rate_msec_c <= 16'd0;
					rate_window_reg <= RATE_WINDOW[15:0];
				end else begin
					rate_msec_c <= rate_msec_c + 16'd1;
				end

				if(ratel1_msec_c[15:0] == ratel1_window_reg[15:0]) begin
					ratel1_msec_c <= 16'd0;
					ratel1_window_reg <= RATE_WINDOWL1[15:0];
				end else begin
					ratel1_msec_c <= ratel1_msec_c + 16'd1;
				end
			end

			if(rate_msec_c[15:0] == rate_window_reg[15:0] && msec_133m == 1'b1) begin
				rate_start <= 1'b1;
			end else begin
				rate_start <= 1'b0;
			end

			if(ratel1_msec_c[15:0] == ratel1_window_reg[15:0] && msec_133m == 1'b1) begin
				ratel1_start <= 1'b1;
			end else begin
				ratel1_start <= 1'b0;
			end

			if(rate_start) begin
				IPR_0[15:0] <= rate_ipr0_reg[15:0];
				IPR_1[15:0] <= rate_ipr1_reg[15:0];
				IPR_2[15:0] <= rate_ipr2_reg[15:0];
				IPR_3[15:0] <= rate_ipr3_reg[15:0];
				IPR_4[15:0] <= rate_ipr4_reg[15:0];
				IPR_5[15:0] <= rate_ipr5_reg[15:0];
				IPR_6[15:0] <= rate_ipr6_reg[15:0];
				rate_ipr0_reg <= 16'd0;
				rate_ipr1_reg <= 16'd0;
				rate_ipr2_reg <= 16'd0;
				rate_ipr3_reg <= 16'd0;
				rate_ipr4_reg <= 16'd0;
				rate_ipr5_reg <= 16'd0;
				rate_ipr6_reg <= 16'd0;
			end else begin
				if(dtrig[0] == 1'b1) begin
					rate_ipr0_reg <= rate_ipr0_reg==16'hFFFF ? rate_ipr0_reg : rate_ipr0_reg + 16'd1;
				end
				if(dtrig[1] == 1'b1) begin
					rate_ipr1_reg <= rate_ipr1_reg==16'hFFFF ? rate_ipr1_reg : rate_ipr1_reg + 16'd1;
				end
				if(dtrig[2] == 1'b1) begin
					rate_ipr2_reg <= rate_ipr2_reg==16'hFFFF ? rate_ipr2_reg : rate_ipr2_reg + 16'd1;
				end
				if(dtrig[3] == 1'b1) begin
					rate_ipr3_reg <= rate_ipr3_reg==16'hFFFF ? rate_ipr3_reg : rate_ipr3_reg + 16'd1;
				end
				if(dtrig[4] == 1'b1) begin
					rate_ipr4_reg <= rate_ipr4_reg==16'hFFFF ? rate_ipr4_reg : rate_ipr4_reg + 16'd1;
				end
				if(dtrig[5] == 1'b1) begin
					rate_ipr5_reg <= rate_ipr5_reg==16'hFFFF ? rate_ipr5_reg : rate_ipr5_reg + 16'd1;
				end
				if(dtrig[6] == 1'b1) begin
					rate_ipr6_reg <= rate_ipr6_reg==16'hFFFF ? rate_ipr6_reg : rate_ipr6_reg + 16'd1;
				end
			end

			if(ratel1_start) begin
				RATE_L1OUT[15:0] <= rate_l1out_reg[15:0];
				RATE_L1OUT2[15:0] <= rate_l1out2_reg[15:0];
				RATE_TRIGL1[15:0] <= rate_trigl1_reg[15:0];
				rate_l1out_reg <= 16'd0;
				rate_l1out2_reg <= 16'd0;
				rate_trigl1_reg <= 16'd0;
			end else begin
				if(l1_out == 1'b1) begin
					rate_l1out_reg <= rate_l1out_reg==16'hFFFF ? rate_l1out_reg : rate_l1out_reg + 16'd1;
				end
				if(l1_out2 == 1'b1) begin
					rate_l1out2_reg <= rate_l1out2_reg==16'hFFFF ? rate_l1out2_reg : rate_l1out2_reg + 16'd1;
				end
				if(trigl1 == 1'b1) begin
					rate_trigl1_reg <= rate_trigl1_reg==16'hFFFF ? rate_trigl1_reg : rate_trigl1_reg + 16'd1;
				end
			end

		end
	end

endmodule
