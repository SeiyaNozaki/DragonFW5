//dragon_ver3_readout_board
//KONNO Yusuke
//Kyoto Univ.
//DAC module

module DAC_DRS(
	 DAC_CS,
	 DAC_SDI,
	 DAC_SCK,
	 DAC_LDACn,
	 
	 DAC_ROFS,
	 DAC_OOFS,
	 DAC_BIAS,
	 DAC_CALP,
	 DAC_CALN,
	 
	 clk,
	 rst,
	 dac_en,
	 command_dacset,
	 command_dac_finish
 );
	 
//--------------------------------------------
//Port declaration
	output DAC_CS;
	output DAC_SDI;
	output DAC_SCK;
	output DAC_LDACn;
	
	input[15:0] DAC_ROFS;
	input[15:0] DAC_OOFS;
	input[15:0] DAC_BIAS;
	input[15:0] DAC_CALP;
	input[15:0] DAC_CALN;
	
	input clk;
	input rst;
	output dac_en;
	input command_dacset;
	output command_dac_finish;
//--------------------------------------------
//DRS board DAC
	reg DAC_CS;
	reg DAC_SDI;
	reg DAC_SCK;
	reg DAC_LDACn;
	reg[7:0] dac_c;
	reg[2:0] dac_out_c;
	reg[23:0] dac_sr;
	reg dac_en;
	reg[1:0] dac_state;
	reg command_dac_finish;
	
	always@(posedge clk or posedge rst)begin
		if(rst)begin
			DAC_CS <= 1'b1;
			DAC_SDI <= 1'b0;
			DAC_SCK <= 1'b0;
			DAC_LDACn <= 1'b1;
			dac_c <= 8'd0;
			dac_out_c <= 3'd0;
			dac_sr <= 24'd0;
			dac_en <= 1'b0;
			dac_state <= 2'd0;
			command_dac_finish <= 1'b0;
		end else begin
			case(dac_state)
				2'd0:begin
					if(dac_c == 8'd0)begin
						DAC_CS <= 1'b0;
						
						if(dac_out_c == 3'd0)begin
							dac_sr <= {8'b00110011,DAC_ROFS};
						end else if(dac_out_c == 3'd1)begin
							dac_sr <= {8'b00110111,DAC_OOFS};
						end else if(dac_out_c == 3'd2)begin
							dac_sr <= {8'b00110110,DAC_BIAS};
						end else if(dac_out_c == 3'd3)begin
							dac_sr <= {8'b00110010,DAC_CALP};
						end else if(dac_out_c == 3'd4)begin
							dac_sr <= {8'b00110001,DAC_CALN};
						end else if(dac_out_c == 3'd5)begin
							dac_sr <= {8'b01000000,16'd0};
						end else if(dac_out_c == 3'd6)begin
							dac_sr <= {8'b01000100,16'd0};
						end else if(dac_out_c == 3'd7)begin
							dac_sr <= {8'b01000101,16'd0};
						end
						
						dac_c <= dac_c + 8'd1;
					end else if (dac_c == 8'd1) begin
						DAC_SDI <= dac_sr[23];
						dac_c <= dac_c + 8'd1;
					end else if(dac_c < 8'd26) begin
						if(DAC_SCK == 1'b0)begin
							DAC_SCK <= 1'b1;
							dac_sr[23:0] <= {dac_sr[22:0],1'b0};
						end else begin
							DAC_SCK <= 1'b0;
							DAC_SDI <= dac_sr[23];
							dac_c <= dac_c + 8'd1;
						end
					end else if(dac_c == 8'd26) begin
						DAC_CS <= 1'b1;
						DAC_SDI <= 1'b0;
						dac_c <= 8'd0;
						dac_sr <= 24'd0;
						dac_out_c <= dac_out_c + 3'd1;
					end
					
					if(dac_c == 8'd26 && dac_out_c == 3'd7) begin
						dac_state <= 2'd3;
					end
				end
				
				2'd1: begin //done
					dac_en <= 1'b1;
					if(command_dacset)begin
						dac_state <= 2'd2;
					end
				end
				
				2'd2: begin //reset
					DAC_CS <= 1'b1;
					DAC_SDI <= 1'b0;
					DAC_SCK <= 1'b0;
					DAC_LDACn <= 1'b1;
					dac_c <= 8'd0;
					dac_out_c <= 3'd0;
					dac_sr <= 24'd0;
					dac_en <= 1'b0;

					dac_state <= 2'd0;
				end
				
				2'd3:begin //dacset finish flag
					if(command_dacset == 1'b1) begin
						command_dac_finish <= 1'b1;
					end else begin
						command_dac_finish <= 1'b0;
					end
					
					if(command_dacset == 1'b0) begin
						dac_state <= 2'd1;
					end
				end

			endcase
		end
	end

endmodule
