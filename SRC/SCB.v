//dragon_ver3_readout_board
//KONNO Yusuke
//Kyoto Univ.
//scb module

module SCB(
			 DEBUG_PARAM, //debug

			 SCB_MCSn,
			 SCB_MDI,
			 SCB_MSK,
			 SCB_MEX,
			 SCB_MDO,
			 SCB_TP_TRIG_P,
			 
			 clk,
			 rst,
			 scb_en,
			 command_dacset,
			 command_tp_trig,
			 command_monitor,
			 command_monitor_finish,
			 scb_command_dac_finish,
			 
			 SCB_HV_0,
			 SCB_HV_1,
			 SCB_HV_2,
			 SCB_HV_3,
			 SCB_HV_4,
			 SCB_HV_5,
			 SCB_HV_6,

			 SCB_EN_BIT,
			 SCB_TPEN_BIT,
			 SCB_TP_ATT,
			 SCB_TP_MODE,
			 SCB_TP_SEL,
			 SCB_TP_EN,
			 
			 SCB_ADC_HV_MONI_0, //CW HV
			 SCB_ADC_HV_MONI_1,
			 SCB_ADC_HV_MONI_2,
			 SCB_ADC_HV_MONI_3,
			 SCB_ADC_HV_MONI_4,
			 SCB_ADC_HV_MONI_5,
			 SCB_ADC_HV_MONI_6,
			 SCB_ADC_AN_CUR_0, //anode signal corresponds to current
			 SCB_ADC_AN_CUR_1,
			 SCB_ADC_AN_CUR_2,
			 SCB_ADC_AN_CUR_3,
			 SCB_ADC_AN_CUR_4,
			 SCB_ADC_AN_CUR_5,
			 SCB_ADC_AN_CUR_6,
			 SCB_ADC_POW_5V, //scb power 5V
			 SCB_ADC_POW_POS3V3, //scb power +3.3V
			 SCB_ADC_POW_NEG3V3, //scb power -3.3V
			 SCB_ADC_PMT_CUR, // signal corrensponds to current at 5V for 7PMTs
			 SCB_ADC_PMT_TEMP, // temperature
			 SCB_ADC_REF1V5 //reference
		 );
	 
//--------------------------------------------
//Port declaration
	input[15:0] DEBUG_PARAM; //debug

	input	SCB_MDO;
	output SCB_MCSn;
	output SCB_MDI;
	output SCB_MSK;
	output SCB_TP_TRIG_P;
	output SCB_MEX;
	
	input clk;
	input rst;
	output scb_en;
	input command_dacset;
	input command_tp_trig;
	input command_monitor;
	output command_monitor_finish;
	output scb_command_dac_finish;
			 
	input[11:0] SCB_HV_0;
	input[11:0] SCB_HV_1;
	input[11:0] SCB_HV_2;
	input[11:0] SCB_HV_3;
	input[11:0] SCB_HV_4;
	input[11:0] SCB_HV_5;
	input[11:0] SCB_HV_6;

	input[6:0] SCB_EN_BIT;
	input[6:0] SCB_TPEN_BIT;
	input[5:0] SCB_TP_ATT; // 0.5dB/bit
	input SCB_TP_MODE; // 0: pulse width 3nsec, 1: same width as tp_trig
	input[6:0] SCB_TP_SEL;
	input SCB_TP_EN;
	
	output[13:0] SCB_ADC_HV_MONI_0; //CW HV
	output[13:0] SCB_ADC_HV_MONI_1;
	output[13:0] SCB_ADC_HV_MONI_2;
	output[13:0] SCB_ADC_HV_MONI_3;
	output[13:0] SCB_ADC_HV_MONI_4;
	output[13:0] SCB_ADC_HV_MONI_5;
	output[13:0] SCB_ADC_HV_MONI_6;
	output[13:0] SCB_ADC_AN_CUR_0; //anode signal corresponds to current
	output[13:0] SCB_ADC_AN_CUR_1;
	output[13:0] SCB_ADC_AN_CUR_2;
	output[13:0] SCB_ADC_AN_CUR_3;
	output[13:0] SCB_ADC_AN_CUR_4;
	output[13:0] SCB_ADC_AN_CUR_5;
	output[13:0] SCB_ADC_AN_CUR_6;
	output[13:0] SCB_ADC_POW_5V; //scb power 5V
	output[13:0] SCB_ADC_POW_POS3V3; //scb power +3.3V
	output[13:0] SCB_ADC_POW_NEG3V3; //scb power -3.3V
	output[13:0] SCB_ADC_PMT_CUR; // signal corrensponds to current at 5V for 7PMTs
	output[13:0] SCB_ADC_PMT_TEMP;
	output[13:0] SCB_ADC_REF1V5;
	
//------------------------------------------------------------------
//Slow Control Board
	reg SCB_MCSn;
	reg SCB_MDI;
	reg SCB_MSK;
	reg SCB_MEX;
	reg[3:0] scb_state;
	reg[6:0] scb_c;
	reg[6:0] scb_c2;
	reg[19:0] scb_c3;//counter for wait
	reg[2:0] scb_c4;
	reg[34:0] scb_sr;
	reg scb_en;
	reg[13:0] scb_adc_reg;
	reg[4:0] scb_adc_sel;
	reg[7:0] scb_adc_mux;
	reg[13:0] scb_adc_cfg;
	reg[13:0] scb_adc_hv_moni_0_reg;
	reg[13:0] scb_adc_hv_moni_1_reg;
	reg[13:0] scb_adc_hv_moni_2_reg;
	reg[13:0] scb_adc_hv_moni_3_reg;
	reg[13:0] scb_adc_hv_moni_4_reg;
	reg[13:0] scb_adc_hv_moni_5_reg;
	reg[13:0] scb_adc_hv_moni_6_reg;
	reg[13:0] scb_adc_an_cur_0_reg;
	reg[13:0] scb_adc_an_cur_1_reg;
	reg[13:0] scb_adc_an_cur_2_reg;
	reg[13:0] scb_adc_an_cur_3_reg;
	reg[13:0] scb_adc_an_cur_4_reg;
	reg[13:0] scb_adc_an_cur_5_reg;
	reg[13:0] scb_adc_an_cur_6_reg;
	reg[13:0] scb_adc_pow_5v_reg;
	reg[13:0] scb_adc_pow_pos3v3_reg;
	reg[13:0] scb_adc_pow_neg3v3_reg;
	reg[13:0] scb_adc_pmt_cur_reg;
	reg[13:0] scb_adc_pmt_temp_reg;
	reg[13:0] scb_adc_ref1v5_reg;
	reg command_monitor_finish;
	reg scb_command_dac_finish;
	//wire[4:0] scb_tp_att_sw;
	//wire scb_tp_mode_sw;

	//assign scb_tp_att_sw = DIP_SWITCH[4:0];
	//assign scb_tp_mode_sw = DIP_SWITCH[5];
	
	assign SCB_ADC_HV_MONI_0[13:0] = scb_adc_hv_moni_0_reg[13:0]; //CW HV
	assign SCB_ADC_HV_MONI_1[13:0] = scb_adc_hv_moni_1_reg[13:0];
	assign SCB_ADC_HV_MONI_2[13:0] = scb_adc_hv_moni_2_reg[13:0];
	assign SCB_ADC_HV_MONI_3[13:0] = scb_adc_hv_moni_3_reg[13:0];
	assign SCB_ADC_HV_MONI_4[13:0] = scb_adc_hv_moni_4_reg[13:0];
	assign SCB_ADC_HV_MONI_5[13:0] = scb_adc_hv_moni_5_reg[13:0];
	assign SCB_ADC_HV_MONI_6[13:0] = scb_adc_hv_moni_6_reg[13:0];
	assign SCB_ADC_AN_CUR_0[13:0] = scb_adc_an_cur_0_reg[13:0]; //anode signal corresponds to current
	assign SCB_ADC_AN_CUR_1[13:0] = scb_adc_an_cur_1_reg[13:0];
	assign SCB_ADC_AN_CUR_2[13:0] = scb_adc_an_cur_2_reg[13:0];
	assign SCB_ADC_AN_CUR_3[13:0] = scb_adc_an_cur_3_reg[13:0];
	assign SCB_ADC_AN_CUR_4[13:0] = scb_adc_an_cur_4_reg[13:0];
	assign SCB_ADC_AN_CUR_5[13:0] = scb_adc_an_cur_5_reg[13:0];
	assign SCB_ADC_AN_CUR_6[13:0] = scb_adc_an_cur_6_reg[13:0];
	assign SCB_ADC_POW_5V[13:0] = scb_adc_pow_5v_reg[13:0]; //scb power 5V
	assign SCB_ADC_POW_POS3V3[13:0] = scb_adc_pow_pos3v3_reg[13:0]; //scb power +3.3V
	assign SCB_ADC_POW_NEG3V3[13:0] = scb_adc_pow_neg3v3_reg[13:0]; //scb power -3.3V
	assign SCB_ADC_PMT_CUR[13:0] = scb_adc_pmt_cur_reg[13:0]; // signal corrensponds to current at 5V for 7PMTs
	assign SCB_ADC_PMT_TEMP[13:0] = scb_adc_pmt_temp_reg[13:0];
	assign SCB_ADC_REF1V5[13:0] = scb_adc_ref1v5_reg[13:0];

	always@(posedge clk or posedge rst) begin
		if(rst) begin
			SCB_MCSn <= 1'b1;
			SCB_MDI <= 1'b0;
			SCB_MSK <= 1'b0;
			SCB_MEX <= 1'b0;
			scb_state <= 4'd0;
			scb_c <= 7'd0;
			scb_c2 <= 7'd0;
			scb_c3 <= 20'd0;
			scb_c4 <= 3'd0;
			scb_sr <= 35'd0;
			scb_en <= 1'b0;
			scb_adc_reg <= 14'd0;
			scb_adc_sel <= 5'd0;
			scb_adc_mux <= 8'd0;
			scb_adc_cfg <= 14'd0;
			
			scb_adc_hv_moni_0_reg <= 14'd0;
			scb_adc_hv_moni_1_reg <= 14'd0;
			scb_adc_hv_moni_2_reg <= 14'd0;
			scb_adc_hv_moni_3_reg <= 14'd0;
			scb_adc_hv_moni_4_reg <= 14'd0;
			scb_adc_hv_moni_5_reg <= 14'd0;
			scb_adc_hv_moni_6_reg <= 14'd0;
			scb_adc_an_cur_0_reg <= 14'd0;
			scb_adc_an_cur_1_reg <= 14'd0;
			scb_adc_an_cur_2_reg <= 14'd0;
			scb_adc_an_cur_3_reg <= 14'd0;
			scb_adc_an_cur_4_reg <= 14'd0;
			scb_adc_an_cur_5_reg <= 14'd0;
			scb_adc_an_cur_6_reg <= 14'd0;
			scb_adc_pow_5v_reg <= 14'd0;
			scb_adc_pow_pos3v3_reg <= 14'd0;
			scb_adc_pow_neg3v3_reg <= 14'd0;
			scb_adc_pmt_cur_reg <= 14'd0;
			scb_adc_pmt_temp_reg <= 14'd0;
			scb_adc_ref1v5_reg <= 14'd0;
			command_monitor_finish <= 1'b0;
			scb_command_dac_finish <= 1'b0;
		end else begin
			case(scb_state)
				4'd0:begin //pmt +5V
					if(scb_c == 7'd0) begin
						SCB_MCSn <= 1'b0;
						scb_sr[34:0] <= {3'b001,SCB_EN_BIT,25'd0};
						scb_c <= scb_c + 7'd1;
					end else if(scb_c < 7'd11) begin
						if(scb_c2 == 7'd0) begin
							SCB_MDI <= scb_sr[34];
							scb_c2 <= scb_c2 + 7'd1;
						end else if(scb_c2 == 7'd1) begin
							SCB_MSK <= 1'b1;
							scb_c2 <= scb_c2 + 7'd1;
						end else begin
							SCB_MSK <= 1'b0;
							scb_sr[34:0] <= {scb_sr[33:0],1'b0};
							scb_c2 <= 7'd0;
							scb_c <= scb_c + 7'd1;
						end
					end else begin
						SCB_MCSn <= 1'b1;
						SCB_MDI <= 1'b0;
						SCB_MSK <= 1'b0;
						scb_c <= 7'd0;
					end
					
					if(scb_c == 7'd11) begin
						scb_state <= 4'd1;
					end
				end
				
				4'd1:begin //pmt hv
					if(scb_c == 7'd0) begin
						SCB_MCSn <= 1'b0;
						if(scb_c4 == 3'd0) begin
							scb_sr[34:0] <= {3'b011,8'b10010000,8'b00110000,SCB_HV_0,4'd0};
						end else if(scb_c4 == 3'd1) begin
							scb_sr[34:0] <= {3'b011,8'b10010000,8'b00110010,SCB_HV_1,4'd0};
						end else if(scb_c4 == 3'd2) begin
							scb_sr[34:0] <= {3'b011,8'b10010000,8'b00110111,SCB_HV_2,4'd0};
						end else if(scb_c4 == 3'd3) begin
							scb_sr[34:0] <= {3'b011,8'b10010000,8'b00110100,SCB_HV_3,4'd0};
						end else if(scb_c4 == 3'd4) begin
							scb_sr[34:0] <= {3'b011,8'b10010000,8'b00110001,SCB_HV_4,4'd0};
						end else if(scb_c4 == 3'd5) begin
							scb_sr[34:0] <= {3'b011,8'b10010000,8'b00110110,SCB_HV_5,4'd0};
						end else if(scb_c4 == 3'd6) begin
							scb_sr[34:0] <= {3'b011,8'b10010000,8'b00110101,SCB_HV_6,4'd0};
						end
						scb_c <= scb_c + 7'd1;
					end else if(scb_c < 7'd4) begin
						if(scb_c2 == 7'd0) begin
							SCB_MDI <= scb_sr[34];
							scb_c2 <= scb_c2 + 7'd1;
						end else if(scb_c2 == 7'd1) begin
							SCB_MSK <= 1'b1;
							scb_c2 <= scb_c2 + 7'd1;
						end else begin
							SCB_MSK <= 1'b0;
							scb_sr[34:0] <= {scb_sr[33:0],1'b0};
							scb_c2 <= 7'd0;
							scb_c <= scb_c + 7'd1;
						end
					end else if(scb_c < 7'd45) begin
						if(scb_c3 == 20'd500) begin
							scb_c3 <= 20'd0;
							if(scb_c == 7'd4) begin
								SCB_MDI <= 1'b1;
								SCB_MSK <= 1'b1;
								scb_c <= scb_c + 7'b1;
							end else if(scb_c == 7'd5) begin
								SCB_MDI <= 1'b0;
								scb_c <= scb_c + 7'd1;
							end else if(scb_c == 7'd6) begin
								SCB_MSK <=1'b0;
								scb_c <= scb_c + 7'd1;
							end else if((scb_c < 7'd42) & (scb_c != 7'd15) & (scb_c != 7'd24) & (scb_c != 7'd33)) begin
								if(scb_c2 == 7'd0) begin
									SCB_MDI <= scb_sr[34];
									scb_c2 <= scb_c2 + 7'd1;
								end else if(scb_c2 == 7'd1) begin
									SCB_MSK <= 1'b1;
									scb_c2 <= scb_c2 + 7'd1;
								end else begin
									SCB_MSK <= 1'b0;
									scb_sr[34:0] <= {scb_sr[33:0],1'b0};
									scb_c2 <= 7'd0;
									scb_c <= scb_c + 7'd1;
								end
							end else if((scb_c == 7'd15) | (scb_c == 7'd24) | (scb_c == 7'd33) | (scb_c == 7'd42)) begin
								if(scb_c2 == 7'd0) begin
									SCB_MDI <= 1'b1;
									SCB_MSK <= 1'b0;
									scb_c2 <= scb_c2 + 7'b1;
								end else if(scb_c2 == 7'd1) begin
									SCB_MSK <= 1'b1;
									scb_c2 <= scb_c2 + 7'd1;
								end else begin
									SCB_MSK <=1'b0;
									scb_c2 <= 7'd0;
									scb_c <= scb_c + 7'd1;
								end
							end else if(scb_c == 7'd43) begin
								SCB_MSK <= 1'b1;
								SCB_MDI <= 1'b0;
								scb_c <= scb_c + 7'd1;
							end else if(scb_c == 7'd44) begin
								SCB_MDI <= 1'b1;
								scb_c <= scb_c + 7'd1;
							end
						end else begin
							scb_c3 <= scb_c3 + 20'd1;
						end
					end else if(scb_c == 7'd45) begin
						if(scb_c4 < 3'd6) begin
							scb_c <= 7'd0;
							scb_c4 <= scb_c4 + 3'd1;
						end else begin
							scb_c4 <= 3'd0;
							scb_c <= scb_c + 7'd1;
						end
					end else begin
						SCB_MCSn <= 1'b1;
						SCB_MSK <= 1'b0;
						SCB_MDI <= 1'b0;
						scb_c <= 7'd0;
					end
					
					if(scb_c == 7'd46) begin
						scb_state <= 4'd2;
					end
				end

				4'd2:begin //tp mode
					if(scb_c == 7'd0) begin
						SCB_MCSn <= 1'b0;
						scb_sr[34:0] <= {3'b101,1'b1,SCB_TP_MODE,30'd0};
						//scb_sr[34:0] <= {3'b101,1'b1,scb_tp_mode_sw,30'd0};
						scb_c <= scb_c + 7'd1;
					end else if(scb_c < 7'd6) begin
						if(scb_c2 == 7'd0) begin
							SCB_MDI <= scb_sr[34];
							scb_c2 <= scb_c2 + 7'd1;
						end else if(scb_c2 == 7'd1) begin
							SCB_MSK <= 1'b1;
							scb_c2 <= scb_c2 + 7'd1;
						end else begin
							SCB_MSK <= 1'b0;
							scb_sr[34:0] <= {scb_sr[33:0],1'b0};
							scb_c2 <= 7'd0;
							scb_c <= scb_c + 7'd1;
						end
					end else begin
						SCB_MCSn <= 1'b1;
						SCB_MDI <= 1'b0;
						SCB_MSK <= 1'b0;
						scb_c <= 7'd0;
					end
					
					if(scb_c == 7'd6) begin
						scb_state <= 4'd3;
					end
				end
				
				4'd3:begin //tp enable
					if(scb_c == 7'd0) begin
						SCB_MDI <= 1'b1;
						scb_sr[34:0] <= {3'b011,SCB_TPEN_BIT,25'd0};
						scb_c <= scb_c + 7'd1;
					end else if(scb_c == 7'd1) begin
						SCB_MCSn <= 1'b0;
						scb_c <= scb_c + 7'd1;
					end else if(scb_c < 7'd12) begin
						if(scb_c2 == 7'd0) begin
							SCB_MDI <= scb_sr[34];
							scb_c2 <= scb_c2 + 7'd1;
						end else if(scb_c2 == 7'd1) begin
							SCB_MSK <= 1'b1;
							scb_c2 <= scb_c2 + 7'd1;
						end else begin
							SCB_MSK <= 1'b0;
							scb_sr[34:0] <= {scb_sr[33:0],1'b0};
							scb_c2 <= 7'd0;
							scb_c <= scb_c + 7'd1;
						end
					end else begin
						SCB_MCSn <= 1'b1;
						SCB_MDI <= 1'b0;
						SCB_MSK <= 1'b0;
						scb_c <= 7'd0;
					end
					
					if(scb_c == 7'd12) begin
						scb_state <= 4'd4;
					end
				end
				
				4'd4:begin //tp attenuate
					if(scb_c == 7'd0) begin
						SCB_MDI <= 1'b1;
						scb_sr[34:0] <= {3'b010,SCB_TP_SEL,SCB_TP_ATT,19'd0};
						//scb_sr[34:0] <= {3'b010,7'd0,SCB_TP_ATT,19'd0};
						//scb_sr[34:0] <= {3'b010,SCB_EN_BIT,scb_tp_att_sw,20'd0};
						scb_c <= scb_c + 7'd1;
					end else if(scb_c == 7'd1) begin
						SCB_MCSn <= 1'b0;
						scb_c <= scb_c + 7'd1;
					end else if(scb_c < 7'd18) begin
						if(scb_c3 == 20'h000FF) begin
							scb_c3 <= 20'd0;
							if(scb_c2 == 7'd0) begin
								SCB_MDI <= scb_sr[34];
								scb_c2 <= scb_c2 + 7'd1;
							end else if(scb_c2 == 7'd1) begin
								SCB_MSK <= 1'b1;
								scb_c2 <= scb_c2 + 7'd1;
							end else if(scb_c2 == 7'd2) begin
								SCB_MSK <= 1'b0;
								scb_sr[34:0] <= {scb_sr[33:0],1'b0};
								scb_c2 <= 7'd0;
								scb_c <= scb_c + 7'd1;
							end
						end else begin
							scb_c3 <= scb_c3 + 20'b1;
						end
					end else if(scb_c == 7'd18) begin
						if(scb_c3 == 20'h000FF) begin
							scb_c3 <= 20'd0;
							if(scb_c2 == 7'd0) begin
								SCB_MDI <= 1'b0;
								scb_c2 <= scb_c2 + 7'd1;
							end else if(scb_c2 == 7'd1) begin
								SCB_MSK <= 1'b1;
								scb_c2 <= scb_c2 + 7'd1;
							end else if(scb_c2 == 7'd2) begin
								SCB_MSK <= 1'b0;
								scb_c2 <= 7'd0;
								scb_c <= scb_c + 7'd1;
							end
						end else begin
							scb_c3 <= scb_c3 + 20'b1;
						end
					end else begin
						SCB_MCSn <= 1'b1;
						SCB_MDI <= 1'b0;
						SCB_MSK <= 1'b0;
						scb_c <= 7'd0;
						scb_en <= 1'b1;
					end
					
					if(scb_c == 7'd19) begin
						scb_state <= 4'd10;
					end
				end
				
				4'd5: begin //done
					if(command_dacset == 1'b1 || command_monitor == 1'b1) begin
						scb_state <= 4'd6;
					end
				end
				
				4'd6: begin //reset
					SCB_MCSn <= 1'b1;
					SCB_MDI <= 1'b0;
					SCB_MSK <= 1'b0;
					SCB_MEX <= 1'b0;
					scb_c <= 7'd0;
					scb_c2 <= 7'd0;
					scb_c3 <= 20'd0;
					scb_c4 <= 3'd0;
					scb_sr <= 35'd0;
					scb_en <= 1'b0;
					scb_adc_reg <= 14'd0;
					scb_adc_sel <= 5'd0;
					scb_adc_mux <= 8'd0;
					if(command_dacset == 1'b1) begin
						scb_state <= 4'd0;
					end else if(command_monitor == 1'b1) begin
						scb_state <= 4'd7;
					end
				end
				
				4'd7: begin //ADC_SELECT
				
					if(scb_adc_sel == 5'd0) begin 
						scb_adc_mux[7:0] <= 8'b0000_0000;
						scb_adc_cfg[13:0] <= 14'b1_110_111_1_011_00_1;
					end else if(scb_adc_sel == 5'd1) begin 
						scb_adc_mux[7:0] <= 8'b0000_0001;					
						//scb_adc_cfg[13:0] <= 14'd0;
					end else if(scb_adc_sel == 5'd2) begin 
						scb_adc_mux[7:0] <= 8'b0000_0010;					
					end else if(scb_adc_sel == 5'd3) begin 
						scb_adc_mux[7:0] <= 8'b0000_0011;					
					end else if(scb_adc_sel == 5'd4) begin 
						scb_adc_mux[7:0] <= 8'b0000_0100;					
					end else if(scb_adc_sel == 5'd5) begin 
						scb_adc_mux[7:0] <= 8'b0000_0101;					
					end else if(scb_adc_sel == 5'd6) begin 
						scb_adc_mux[7:0] <= 8'b0000_0110;					
					end else if(scb_adc_sel == 5'd7) begin 
						scb_adc_mux[7:0] <= 8'b0000_0111;					
					end else if(scb_adc_sel == 5'd8) begin 
						scb_adc_mux[7:0] <= 8'b0000_1000;					
					end else if(scb_adc_sel == 5'd9) begin 
						scb_adc_mux[7:0] <= 8'b0000_1001;					
					end else if(scb_adc_sel == 5'd10) begin 
						scb_adc_mux[7:0] <= 8'b0000_1010;					
					end else if(scb_adc_sel == 5'd11) begin 
						scb_adc_mux[7:0] <= 8'b0000_1011;					
					end else if(scb_adc_sel == 5'd12) begin 
						scb_adc_mux[7:0] <= 8'b0000_1101;					
					end else if(scb_adc_sel == 5'd13) begin 
						scb_adc_mux[7:0] <= 8'b0000_1110;					
					end else if(scb_adc_sel == 5'd14) begin 
						scb_adc_mux[7:0] <= 8'b0000_1111;					
					end else if(scb_adc_sel == 5'd15) begin 
						scb_adc_mux[7:0] <= 8'b0001_1100;					
					end else if(scb_adc_sel == 5'd16) begin 
						scb_adc_mux[7:0] <= 8'b0101_1100;					
					end else if(scb_adc_sel == 5'd17) begin 
						scb_adc_mux[7:0] <= 8'b0111_1100;					
					end else if(scb_adc_sel == 5'd18) begin 
						scb_adc_mux[7:0] <= 8'b0000_0000;					
						scb_adc_cfg[13:0] <= 14'b1_111_010_1_011_00_1;
					end else if(scb_adc_sel == 5'd19) begin 
						scb_adc_mux[7:0] <= 8'b0000_0000;					
						//scb_adc_cfg[13:0] <= 14'b1_111_011_1_011_00_1;
						scb_adc_cfg[13:0] <= 14'b1_111_011_0_111_00_0;
					end
					
					scb_state <= 4'd8;
				
				end
				
				4'd8: begin //ADC_MUX

					if(scb_c == 7'd0) begin
						SCB_MCSn <= 1'b0;
						scb_sr[34:0] <= {3'b110,scb_adc_mux[7:0],24'd0};
						scb_c <= scb_c + 7'd1;
					end else if(scb_c < 7'd12) begin
						if(scb_c2 == 7'd0) begin
							SCB_MDI <= scb_sr[34];
							scb_c2 <= scb_c2 + 7'd1;
						end else if(scb_c2 == 7'd1) begin
							SCB_MSK <= 1'b1;
							SCB_MEX <= 1'b0;
							scb_c2 <= scb_c2 + 7'd1;
						end else begin
							SCB_MSK <= 1'b0;
							SCB_MEX <= 1'b1;
							scb_sr[34:0] <= {scb_sr[33:0],1'b0};
							scb_c2 <= 7'd0;
							scb_c <= scb_c + 7'd1;
						end
					end else if(scb_c == 7'd12) begin
						SCB_MEX <= 1'b0;
						scb_c <= scb_c + 7'd1;
					end else if(scb_c == 7'd13) begin
						//if(scb_c3 == {DEBUG_PARAM[15:0],4'd0}) begin
						if(scb_c3 == 20'd130_000) begin
							scb_c <= scb_c + 7'd1;
							scb_c3 <= 20'd0;
						end else begin
							scb_c3 <= scb_c3 + 20'd1;
						end
					//end else if(scb_c == 7'd13) begin
					end else if(scb_c == 7'd14) begin
						//if(DEBUG_PARAM == 16'd1) begin //debug
						SCB_MCSn <= 1'b1;
						SCB_MDI <= 1'b0;
						SCB_MSK <= 1'b0;
						SCB_MEX <= 1'b0;
						scb_c <= 7'd0;
						//end
					end
										
					//if(scb_c == 7'd13) begin
					if(scb_c == 7'd14) begin
						//if(DEBUG_PARAM == 16'd1) begin //debug
						scb_state <= 4'd9;
						//end
					end

				end
				
				4'd9: begin //ADC_SPI

					if(scb_c == 7'd0) begin
						SCB_MCSn <= 1'b0;
						scb_sr[34:0] <= {3'b100,scb_adc_cfg[13:0],18'd0};
						scb_c <= scb_c + 7'd1;
					end else if(scb_c < 7'd4 || (scb_c > 7'd4 && scb_c < 7'd19)) begin
						if(scb_c2 == 7'd0) begin
							SCB_MDI <= scb_sr[34];
							scb_c2 <= scb_c2 + 7'd1;
						end else if(scb_c2 == 7'd1) begin
							SCB_MSK <= 1'b1;
							scb_c2 <= scb_c2 + 7'd1;
						end else if(scb_c2 == 7'd2) begin
							scb_adc_reg[13:0] <= {scb_adc_reg[12:0],SCB_MDO};
							scb_c2 <= scb_c2 + 7'd1;
						end else begin
							SCB_MSK <= 1'b0;
							scb_sr[34:0] <= {scb_sr[33:0],1'b0};
							scb_c2 <= 7'd0;
							scb_c <= scb_c + 7'd1;
						end
					end else if(scb_c == 7'd4) begin
						SCB_MDI <= 1'b0;
						if(scb_c3 < 20'd10) begin
							SCB_MEX <= 1'b0;
							scb_c3 <= scb_c3 + 20'd1;
						end else if(scb_c3 < 20'd240) begin
							SCB_MEX <= 1'b1;
							scb_c3 <= scb_c3 + 20'd1;
						end else if(scb_c3 < 20'd250) begin
							SCB_MEX <= 1'b0;
							scb_c3 <= scb_c3 + 20'd1;
						end else if(scb_c3 == 20'd250) begin
							scb_c3 <= 20'd0;
							scb_c <= scb_c + 7'd1;
						end
					end else if(scb_c == 7'd19) begin
						SCB_MDI <= 1'b0;
						if(scb_c3 < 20'd70) begin
							scb_c3 <= scb_c3 + 20'd1;
						end else if(scb_c3 == 20'd70) begin
							scb_c3 <= 20'd0;
							scb_c <= scb_c + 7'd1;
						end
					end else if(scb_c == 7'd20) begin
						if(scb_c4 == 3'd2) begin
							scb_c4 <= 3'd0;
							scb_c <= scb_c + 7'd1;
						end else begin
							scb_c4 <= scb_c4 + 3'd1;
							scb_c <= 7'd4;
						end
					end else if(scb_c == 7'd21) begin
						scb_c <= scb_c + 7'd1;
					end else if(scb_c == 7'd22) begin
						//if(DEBUG_PARAM == 16'd2) begin //debug
						SCB_MCSn <= 1'b1;
						SCB_MDI <= 1'b0;
						SCB_MSK <= 1'b0;
						SCB_MEX <= 1'b0;
						scb_adc_reg <= 14'd0;
						scb_c <= 7'd0;
						//end
					end
					
					if(scb_c == 7'd21) begin
						if(scb_adc_sel == 5'd0) begin
							scb_adc_hv_moni_5_reg <= scb_adc_reg;
						end else if(scb_adc_sel == 5'd1) begin
							scb_adc_an_cur_5_reg <= scb_adc_reg;
						end else if(scb_adc_sel == 5'd2) begin
							scb_adc_hv_moni_6_reg <= scb_adc_reg;
						end else if(scb_adc_sel == 5'd3) begin
							scb_adc_an_cur_6_reg <= scb_adc_reg;
						end else if(scb_adc_sel == 5'd4) begin
							scb_adc_hv_moni_0_reg <= scb_adc_reg;
						end else if(scb_adc_sel == 5'd5) begin
							scb_adc_an_cur_0_reg <= scb_adc_reg;
						end else if(scb_adc_sel == 5'd6) begin
							scb_adc_hv_moni_4_reg <= scb_adc_reg;
						end else if(scb_adc_sel == 5'd7) begin
							scb_adc_an_cur_4_reg <= scb_adc_reg;
						end else if(scb_adc_sel == 5'd8) begin
							scb_adc_hv_moni_1_reg <= scb_adc_reg;
						end else if(scb_adc_sel == 5'd9) begin
							scb_adc_an_cur_1_reg <= scb_adc_reg;
						end else if(scb_adc_sel == 5'd10) begin
							scb_adc_hv_moni_3_reg <= scb_adc_reg;
						end else if(scb_adc_sel == 5'd11) begin
							scb_adc_an_cur_3_reg <= scb_adc_reg;
						end else if(scb_adc_sel == 5'd12) begin
							scb_adc_pmt_temp_reg <= scb_adc_reg;
						end else if(scb_adc_sel == 5'd13) begin
							scb_adc_hv_moni_2_reg <= scb_adc_reg;
						end else if(scb_adc_sel == 5'd14) begin
							scb_adc_an_cur_2_reg <= scb_adc_reg;
						end else if(scb_adc_sel == 5'd15) begin
							scb_adc_pow_5v_reg <= scb_adc_reg;
						end else if(scb_adc_sel == 5'd16) begin
							scb_adc_pow_pos3v3_reg <= scb_adc_reg;
						end else if(scb_adc_sel == 5'd17) begin
							scb_adc_pow_neg3v3_reg <= scb_adc_reg;
						end else if(scb_adc_sel == 5'd18) begin
							scb_adc_pmt_cur_reg <= scb_adc_reg;
						end else if(scb_adc_sel == 5'd19) begin
							scb_adc_ref1v5_reg <= scb_adc_reg;
						end
					end
						
					if(scb_c == 7'd22) begin
						//if(DEBUG_PARAM == 16'd2) begin //debug
						if(scb_adc_sel == 5'd19) begin
							scb_adc_sel <= 5'd0;
						end else begin
							scb_adc_sel <= scb_adc_sel + 5'd1;
						end
						//end
					end
										
					if(scb_c == 7'd22) begin
						//if(DEBUG_PARAM == 16'd2) begin //debug
						if(scb_adc_sel == 5'd19) begin
							scb_state <= 4'd11;
						end else begin
							scb_state <= 4'd7;
						end
						//end
					end

				end
				
				4'd10: begin //DAC FINISH FlAG

					if(command_dacset == 1'b1) begin
						scb_command_dac_finish <= 1'b1;
					end else begin
						scb_command_dac_finish <= 1'b0;
					end
					
					if(command_dacset == 1'b0) begin
						scb_state <= 4'd5;
					end
					
				end
				
				4'd11: begin //MONITOR FINISH FlAG

					if(command_monitor == 1'b1) begin
						command_monitor_finish <= 1'b1;
					end else begin
						command_monitor_finish <= 1'b0;
					end
					
					if(command_monitor == 1'b0) begin
						scb_state <= 4'd5;
					end
					
				end
				
			endcase
		end
	end

//SCB test pulse trigger
	reg scb_tp_trig;
	reg[2:0] scb_tp_trig_c;

	always@(posedge clk or posedge rst) begin
		if(rst) begin
			scb_tp_trig <= 1'd0;
			scb_tp_trig_c <= 3'd0;
		end else begin
			if(scb_tp_trig_c == 3'd0) begin
				if(command_tp_trig) begin
					scb_tp_trig <= 1'b1;
					scb_tp_trig_c <= scb_tp_trig_c + 3'd1;
				end
			end else if(scb_tp_trig_c == 3'd1) begin
				scb_tp_trig <= 1'b0;
				scb_tp_trig_c <= scb_tp_trig_c + 3'd1;
			end else if(scb_tp_trig_c == 3'd2) begin
				if(~command_tp_trig) begin
					scb_tp_trig_c <= 3'd0;
				end
			end
		end
	end

	assign SCB_TP_TRIG_P = scb_tp_trig;
		
endmodule
