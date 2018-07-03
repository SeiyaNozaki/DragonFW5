//dragon_ver3_readout_board
//KONNO Yusuke
//Kyoto Univ.
//digital trigger module

module DIGITAL_TRIGGER(
			 L1_SC_EN,
			 L1_SC_DIN,
			 L1_SC_CLK,
			 L1_SC_DOUT,
			 DIGITAL_TRIG_OUT_P,
			 DIGITAL_TRIG_OUT_N,
			 TRGL1_P,
			 TRGL1_N,
			 TRIG_BPOUT_P,
			 TRIG_BPOUT_N,
			 
			 clk,
			 clk_133m,
			 rst,
			 dtrig_en,
			 command_dacset,
			 command_dacset_finish,
			 
			 DTRIG_THRESHOLD_0,
			 DTRIG_THRESHOLD_1,
			 DTRIG_THRESHOLD_2,
			 DTRIG_THRESHOLD_3,
			 DTRIG_THRESHOLD_4,
			 DTRIG_THRESHOLD_5,
			 DTRIG_THRESHOLD_6,
			 
			 dtrig_trig,
			 trigl1,
			 TRIGL1_async,
			 
			 IPR_0,
			 IPR_1,
			 IPR_2,
			 IPR_3,
			 IPR_4,
			 IPR_5,
			 IPR_6,
			 RATE_TRIGL1,
			 RATE_WINDOW,
			 msec_133m
		 );
	 
//--------------------------------------------
//Port declaration
	output L1_SC_EN;
	output L1_SC_DIN;
	output L1_SC_CLK;
	input L1_SC_DOUT;
	input[6:0] DIGITAL_TRIG_OUT_P;
	input[6:0] DIGITAL_TRIG_OUT_N;
	input TRGL1_P;
	input TRGL1_N;
	output[6:0] TRIG_BPOUT_P;
	output[6:0] TRIG_BPOUT_N;
	
	input clk;
	input clk_133m;
	input rst;
	output dtrig_en;
	input command_dacset;
	output command_dacset_finish;
			 
	input[7:0] DTRIG_THRESHOLD_0;
	input[7:0] DTRIG_THRESHOLD_1;
	input[7:0] DTRIG_THRESHOLD_2;
	input[7:0] DTRIG_THRESHOLD_3;
	input[7:0] DTRIG_THRESHOLD_4;
	input[7:0] DTRIG_THRESHOLD_5;
	input[7:0] DTRIG_THRESHOLD_6;
	
	output[6:0] dtrig_trig;
	output trigl1;
	output TRIGL1_async;
	
	output[15:0] IPR_0;
	output[15:0] IPR_1;
	output[15:0] IPR_2;
	output[15:0] IPR_3;
	output[15:0] IPR_4;
	output[15:0] IPR_5;
	output[15:0] IPR_6;
	output[15:0] RATE_TRIGL1;
	input[15:0] RATE_WINDOW;
	input msec_133m;
	
//--------------------------------------------
//digital trigger l0
	reg dtrig_cs;
	reg dtrig_sdi;
	reg dtrig_clk;
	
	reg[7:0] dtrig_c;
	reg[3:0] dtrig_dac_c;
	reg[15:0] dtrig_sr;
	reg dtrig_en;
	reg[1:0] dtrig_state;
	
	reg command_dacset_finish;
	
	assign L1_SC_CLK = dtrig_clk;
	assign L1_SC_EN = dtrig_cs;
	assign L1_SC_DIN = dtrig_sdi;

	always@(posedge clk or posedge rst)begin
		if(rst)begin
			dtrig_cs <= 1'b1;
			dtrig_sdi <= 1'b0;
			dtrig_clk <= 1'b0;
			dtrig_c <= 8'd0;
			dtrig_dac_c <= 4'd0;
			dtrig_sr <= 16'd0;
			dtrig_en <= 1'b0;
			dtrig_state <= 2'd0;
			command_dacset_finish <= 1'b0;
		end else begin
			case(dtrig_state)
				2'd0:begin //setting threshold ch0-6
					if(dtrig_c == 8'd0)begin
						
						if(dtrig_dac_c == 4'd0)begin
							dtrig_sr <= {4'd0,DTRIG_THRESHOLD_0,4'd0};
						end else if(dtrig_dac_c == 4'd1)begin
							dtrig_sr <= {4'd1,DTRIG_THRESHOLD_1,4'd0};
						end else if(dtrig_dac_c == 4'd2)begin
							dtrig_sr <= {4'd2,DTRIG_THRESHOLD_2,4'd0};
						end else if(dtrig_dac_c == 4'd3)begin
							dtrig_sr <= {4'd3,DTRIG_THRESHOLD_3,4'd0};
						end else if(dtrig_dac_c == 4'd4)begin
							dtrig_sr <= {4'd4,DTRIG_THRESHOLD_4,4'd0};
						end else if(dtrig_dac_c == 4'd5)begin
							dtrig_sr <= {4'd5,DTRIG_THRESHOLD_5,4'd0};
						end else if(dtrig_dac_c == 4'd6)begin
							dtrig_sr <= {4'd6,DTRIG_THRESHOLD_6,4'd0};
						end else if(dtrig_dac_c == 4'd7)begin
							dtrig_sr <= {4'b1101,4'd0,8'b1000_000}; //ch8 power down
						end else if(dtrig_dac_c == 4'd8)begin
							dtrig_sr <= {4'b1010,4'd0,8'b0111_1111}; //update DAC output
						end
						
						dtrig_c <= dtrig_c + 8'd1;
					end else if (dtrig_c == 8'd1) begin
						dtrig_cs <= 1'b0;
						dtrig_clk <= 1'b1;
						dtrig_sdi <= dtrig_sr[15];
						dtrig_c <= dtrig_c + 8'd1;
					end else if(dtrig_c < 8'd18) begin
						if(dtrig_clk == 1'b0)begin
							dtrig_clk <= 1'b1;
							dtrig_sdi <= dtrig_sr[15];
						end else begin
							dtrig_clk <= 1'b0;
							dtrig_sr[15:0] <= {dtrig_sr[14:0],1'b0};
							dtrig_c <= dtrig_c + 8'd1;
						end
					end else if(dtrig_c == 8'd18) begin
						dtrig_cs <= 1'b1;
						dtrig_sdi <= 1'b0;
						dtrig_c <= 8'd0;
						dtrig_sr <= 16'd0;
						if(dtrig_dac_c == 4'd8)begin
							dtrig_dac_c <= 4'd0;
						end else begin
							dtrig_dac_c <= dtrig_dac_c + 4'd1;
						end
					end
										
					if(dtrig_c == 8'd18 && dtrig_dac_c == 4'd8) begin
						dtrig_state <= 2'd3;
					end
				end
								
				2'd1:begin //done
					dtrig_en <= 1'b1;
					if(command_dacset)begin
						dtrig_state <= 2'd2;
					end
				end
				
				2'd2:begin //reset	
					dtrig_cs <= 1'b1;
					dtrig_sdi <= 1'b0;
					dtrig_clk <= 1'b0;
					dtrig_c <= 8'd0;
					dtrig_dac_c <= 4'd0;
					dtrig_sr <= 16'd0;
					dtrig_en <= 1'b0;

					dtrig_state <= 2'd0;
				end

				2'd3:begin //dacset finish flag
					if(command_dacset == 1'b1) begin
						command_dacset_finish <= 1'b1;
					end else begin
						command_dacset_finish <= 1'b0;
					end
					
					if(command_dacset == 1'b0) begin
						dtrig_state <= 2'd1;
					end
				end
				
			endcase
		end
	end
	
//----------------------------------------------------------------------
//trigger input buffer
	wire[6:0] dtrig_trig_ibufo;
	wire[6:0] trig_bpout;
	reg[6:0] dtrig_trig_ir;
	reg[6:0] dtrig_trig_ir2;

	generate
		genvar i;
		for(i=0;i<7;i=i+1) begin:TRIG_GEN
			IBUFDS #(.DIFF_TERM("TRUE"), .IOSTANDARD("LVDS_33")) TRIG_IBUFDS(.I(DIGITAL_TRIG_OUT_P[i]), .IB(DIGITAL_TRIG_OUT_N[i]), .O(dtrig_trig_ibufo[i]));
			
			OBUFDS #(
				.IOSTANDARD("LVDS_33")
				) OBUFDS_TRIG_BPOUT (
				.O(TRIG_BPOUT_P[i]),
				.OB(TRIG_BPOUT_N[i]),
				.I(trig_bpout[i])
			);
		end
	endgenerate

	assign trig_bpout = dtrig_trig_ibufo;
/*
	assign trig_bpout[0] = dtrig_trig_ibufo[6];
	assign trig_bpout[1] = dtrig_trig_ibufo[4];
	assign trig_bpout[2] = dtrig_trig_ibufo[0];
	assign trig_bpout[3] = dtrig_trig_ibufo[1];
	assign trig_bpout[4] = dtrig_trig_ibufo[3];
	assign trig_bpout[5] = dtrig_trig_ibufo[5];
	assign trig_bpout[6] = dtrig_trig_ibufo[2];
*/

	always@(posedge clk_133m or posedge rst) begin
		if(rst) begin
			dtrig_trig_ir <= 7'd0;
			dtrig_trig_ir2 <= 7'd0;
		end else begin
			dtrig_trig_ir <= dtrig_trig_ibufo;
			dtrig_trig_ir2 <= dtrig_trig_ir;
		end
	end

	assign dtrig_trig = dtrig_trig_ir & ~dtrig_trig_ir2;
	
//L1	
	reg trigl1_ir;
	reg trigl1_ir2;
	wire trigl1_ibufo;

	assign TRIGL1_async = trigl1_ibufo;
	//assign trigl1_ibufo = TRGL1_P;
	
	IBUFDS #(.DIFF_TERM ("TRUE"), .IOSTANDARD("LVDS_33")) TRGL1_INPUTBUFFER (
		.I(TRGL1_P),
		.IB(TRGL1_N),
		.O(trigl1_ibufo)
	);

	always@(posedge clk_133m or posedge rst) begin
		if(rst) begin
			trigl1_ir <= 1'b0;
			trigl1_ir2 <= 1'b0;
		end else begin
			trigl1_ir <= trigl1_ibufo;
			trigl1_ir2 <= trigl1_ir;
		end
	end
	
	assign trigl1 = trigl1_ir & ~trigl1_ir2;
	
//----------------------------------------------------------------------
//RATE Monitor

	reg[15:0] IPR_0;
	reg[15:0] IPR_1;
	reg[15:0] IPR_2;
	reg[15:0] IPR_3;
	reg[15:0] IPR_4;
	reg[15:0] IPR_5;
	reg[15:0] IPR_6;
	reg[15:0] RATE_TRIGL1;

	reg[15:0] rate_msec_c;
	reg rate_start;
	reg[15:0] rate_ipr0_reg;
	reg[15:0] rate_ipr1_reg;
	reg[15:0] rate_ipr2_reg;
	reg[15:0] rate_ipr3_reg;
	reg[15:0] rate_ipr4_reg;
	reg[15:0] rate_ipr5_reg;
	reg[15:0] rate_ipr6_reg;
	reg[15:0] rate_trigl1_reg;
	reg[15:0] rate_window_reg;
	reg rate_ipr0_buf;
	reg rate_ipr1_buf;
	reg rate_ipr2_buf;
	reg rate_ipr3_buf;
	reg rate_ipr4_buf;
	reg rate_ipr5_buf;
	reg rate_ipr6_buf;
	reg rate_trigl1_buf;

	always@(posedge clk_133m or posedge rst) begin
		if(rst) begin
			rate_msec_c <= 16'd0;
			rate_start <= 1'b0;
			rate_ipr0_reg <= 16'd0;
			rate_ipr1_reg <= 16'd0;
			rate_ipr2_reg <= 16'd0;
			rate_ipr3_reg <= 16'd0;
			rate_ipr4_reg <= 16'd0;
			rate_ipr5_reg <= 16'd0;
			rate_ipr6_reg <= 16'd0;
			rate_trigl1_reg <= 16'd0;
			rate_window_reg <= 16'd0;
		end else begin
			if(msec_133m == 1'b1) begin
				if(rate_msec_c[15:0] == rate_window_reg[15:0]) begin
					rate_msec_c <= 16'd0;
					rate_window_reg <= RATE_WINDOW[15:0];
				end else begin
					rate_msec_c <= rate_msec_c + 16'd1;
				end
			end

			if(rate_msec_c[15:0] == rate_window_reg[15:0] && msec_133m == 1'b1) begin
				rate_start <= 1'b1;
			end else begin
				rate_start <= 1'b0;
			end

			if(rate_start) begin
				IPR_0[15:0] <= rate_ipr0_reg[15:0];
				IPR_1[15:0] <= rate_ipr1_reg[15:0];
				IPR_2[15:0] <= rate_ipr2_reg[15:0];
				IPR_3[15:0] <= rate_ipr3_reg[15:0];
				IPR_4[15:0] <= rate_ipr4_reg[15:0];
				IPR_5[15:0] <= rate_ipr5_reg[15:0];
				IPR_6[15:0] <= rate_ipr6_reg[15:0];
				RATE_TRIGL1[15:0] <= rate_trigl1_reg[15:0];
				rate_ipr0_reg <= 16'd0;
				rate_ipr1_reg <= 16'd0;
				rate_ipr2_reg <= 16'd0;
				rate_ipr3_reg <= 16'd0;
				rate_ipr4_reg <= 16'd0;
				rate_ipr5_reg <= 16'd0;
				rate_ipr6_reg <= 16'd0;
				rate_trigl1_reg <= 16'd0;
			end else begin
				if(rate_ipr0_buf == 1'b0 && dtrig_trig[0] == 1'b1) begin
					rate_ipr0_reg <= rate_ipr0_reg + 16'd1;
				end
				if(rate_ipr1_buf == 1'b0 && dtrig_trig[1] == 1'b1) begin
					rate_ipr1_reg <= rate_ipr1_reg + 16'd1;
				end
				if(rate_ipr2_buf == 1'b0 && dtrig_trig[2] == 1'b1) begin
					rate_ipr2_reg <= rate_ipr2_reg + 16'd1;
				end
				if(rate_ipr3_buf == 1'b0 && dtrig_trig[3] == 1'b1) begin
					rate_ipr3_reg <= rate_ipr3_reg + 16'd1;
				end
				if(rate_ipr4_buf == 1'b0 && dtrig_trig[4] == 1'b1) begin
					rate_ipr4_reg <= rate_ipr4_reg + 16'd1;
				end
				if(rate_ipr5_buf == 1'b0 && dtrig_trig[5] == 1'b1) begin
					rate_ipr5_reg <= rate_ipr5_reg + 16'd1;
				end
				if(rate_ipr6_buf == 1'b0 && dtrig_trig[6] == 1'b1) begin
					rate_ipr6_reg <= rate_ipr6_reg + 16'd1;
				end
				if(rate_trigl1_buf == 1'b0 && trigl1 == 1'b1) begin
					rate_trigl1_reg <= rate_trigl1_reg + 16'd1;
				end
			end

		end
	end

	always@(posedge clk_133m) begin
		rate_ipr0_buf <= dtrig_trig[0];
		rate_ipr1_buf <= dtrig_trig[1];
		rate_ipr2_buf <= dtrig_trig[2];
		rate_ipr3_buf <= dtrig_trig[3];
		rate_ipr4_buf <= dtrig_trig[4];
		rate_ipr5_buf <= dtrig_trig[5];
		rate_ipr6_buf <= dtrig_trig[6];
		rate_trigl1_buf <= trigl1;
	end
	
endmodule
