//dragon_ver4_readout_board
//KONNO Yusuke
//Kyoto Univ.
//scb v2 module

module SCBV2(
			 SCB_MCSn,
			 SCB_MDI,
			 SCB_MSK,
			 SCB_MEX,
			 SCB_MDO,
			 SCB_nCFG,
			 SCB_nIRQ,
			 SCB_TP_TRIG_P,
			 SCB_TP_TRIG_N,
			 
			 scb_tp_trig_ext,
			 trig_rst,
			 rst_refclk,

			 clk,
			 clk_133m,
			 clk_ext10m,
			 rst,
			 scb_en,
			 command_dacset,
			 command_tp_trig,
			 //command_monitor,
			 //command_monitor_finish,
			 scb_command_dac_finish,
			 
			 SCB_TP_TRIG_FREQ,
			 SCB_TP_TRIG_WIDTH,
			 SCB_TP_CLKSELECT,
			 SCB_SPICMD, // v2 test
			 SCB_SPILENGTH, //v2 test
			 SCB_SPIREAD, //v2 test

			 usec_66m
		 );
	 
//--------------------------------------------
//Port declaration
	output	SCB_MDO;
	output SCB_MCSn;
	input SCB_MDI;
	output SCB_MSK;
	output SCB_TP_TRIG_P;
	output SCB_TP_TRIG_N;
	output SCB_MEX;
	output SCB_nCFG;
	input SCB_nIRQ;
	
	output scb_tp_trig_ext;
	input trig_rst;
	input rst_refclk;

	input clk;
	input clk_133m;
	input clk_ext10m;
	input rst;
	output scb_en;
	input command_dacset;
	input command_tp_trig;
	//input command_monitor;
	//output command_monitor_finish;
	output scb_command_dac_finish;
	
	input[29:0] SCB_TP_TRIG_FREQ;
	input[15:0] SCB_TP_TRIG_WIDTH;
	input[7:0] SCB_TP_CLKSELECT;
	input[135:0] SCB_SPICMD;
	input[7:0] SCB_SPILENGTH;
	output[127:0] SCB_SPIREAD;

	input usec_66m;

//------------------------------------------------------------------
//Slow Control Board
	reg SCB_MCSn;
	reg SCB_MDO;
	reg SCB_MSK;
	reg SCB_MEX;
	reg[3:0] scb_state;
	reg[7:0] scb_c;
	reg[6:0] scb_c2;
	reg[6:0] scb_c3;
	reg[135:0] scb_sr;
	reg scb_en;
	reg[7:0] scb_spiread_reg;
	reg scb_command_dac_finish;
	reg[7:0] scb_spibitlength;
	reg[127:0] SCB_SPIREAD;
	
	assign SCB_nCFG = 1'b1;

	always@(posedge clk or posedge rst) begin
		if(rst) begin
			SCB_MCSn <= 1'b1;
			SCB_MDO <= 1'b0;
			SCB_MSK <= 1'b0;
			SCB_MEX <= 1'b0;
			scb_state <= 4'd1;
			scb_c <= 8'd0;
			scb_c2 <= 7'd0;
			scb_c3 <= 7'd0;
			scb_sr <= 136'd0;
			scb_en <= 1'b0;
			scb_spiread_reg <= 8'd0;
			scb_command_dac_finish <= 1'b0;
			scb_spibitlength <= 8'd0;
			SCB_SPIREAD <= 128'd0;
		end else begin
			case(scb_state)
				4'd0:begin //spi
					if(scb_c3 == 7'd10) begin
						scb_c3 <= 7'd0;
					end else begin
						scb_c3 <= scb_c3 + 7'd1;
					end

					if(scb_c3 == 7'd10) begin

						if(scb_c == 8'd0) begin
							if(SCB_SPILENGTH == 8'd0) begin
								scb_spibitlength <= 8'd8;
							end else if(SCB_SPILENGTH == 8'd1) begin
								scb_spibitlength <= 8'd16;
							end else if(SCB_SPILENGTH == 8'd2) begin
								scb_spibitlength <= 8'd24;
							end else if(SCB_SPILENGTH == 8'd3) begin
								scb_spibitlength <= 8'd32;
							end else if(SCB_SPILENGTH == 8'd4) begin
								scb_spibitlength <= 8'd40;
							end else if(SCB_SPILENGTH == 8'd5) begin
								scb_spibitlength <= 8'd48;
							end else if(SCB_SPILENGTH == 8'd6) begin
								scb_spibitlength <= 8'd56;
							end else if(SCB_SPILENGTH == 8'd7) begin
								scb_spibitlength <= 8'd64;
							end else if(SCB_SPILENGTH == 8'd8) begin
								scb_spibitlength <= 8'd72;
							end else if(SCB_SPILENGTH == 8'd9) begin
								scb_spibitlength <= 8'd80;
							end else if(SCB_SPILENGTH == 8'd10) begin
								scb_spibitlength <= 8'd88;
							end else if(SCB_SPILENGTH == 8'd11) begin
								scb_spibitlength <= 8'd96;
							end else if(SCB_SPILENGTH == 8'd12) begin
								scb_spibitlength <= 8'd104;
							end else if(SCB_SPILENGTH == 8'd13) begin
								scb_spibitlength <= 8'd112;
							end else if(SCB_SPILENGTH == 8'd14) begin
								scb_spibitlength <= 8'd120;
							end else if(SCB_SPILENGTH == 8'd15) begin
								scb_spibitlength <= 8'd128;
							end else if(SCB_SPILENGTH == 8'd16) begin
								scb_spibitlength <= 8'd136;
							end
						end

						if(scb_c == 8'd0) begin
							SCB_MCSn <= 1'b0;
							scb_sr[135:0] <= SCB_SPICMD[135:0];
							scb_c <= scb_c + 8'd1;
						end else if(scb_c < (scb_spibitlength[7:0]+8'd1) ) begin
							if(scb_c2 == 7'd0) begin
								SCB_MDO <= scb_sr[135];
								scb_c2 <= scb_c2 + 7'd1;
							end else if(scb_c2 == 7'd1) begin
								SCB_MSK <= 1'b1;
								scb_c2 <= scb_c2 + 7'd1;
							end else begin
								SCB_MSK <= 1'b0;
								scb_sr[135:0] <= {scb_sr[134:0],1'b0};
								scb_c2 <= 7'd0;
								scb_c <= scb_c + 8'd1;

								scb_spiread_reg[7:0] <= {scb_spiread_reg[6:0],SCB_MDI};

							end
						end else begin
							SCB_MCSn <= 1'b1;
							SCB_MDO <= 1'b0;
							SCB_MSK <= 1'b0;
							scb_c <= 8'd0;
						end

						if(scb_c == 8'd17) begin
							SCB_SPIREAD[127:120] <= scb_spiread_reg[7:0];
						end else if(scb_c == 8'd25) begin
							SCB_SPIREAD[119:112] <= scb_spiread_reg[7:0];
						end else if(scb_c == 8'd33) begin
							SCB_SPIREAD[111:104] <= scb_spiread_reg[7:0];
						end else if(scb_c == 8'd41) begin
							SCB_SPIREAD[103:96] <= scb_spiread_reg[7:0];
						end else if(scb_c == 8'd49) begin
							SCB_SPIREAD[95:88] <= scb_spiread_reg[7:0];
						end else if(scb_c == 8'd57) begin
							SCB_SPIREAD[87:80] <= scb_spiread_reg[7:0];
						end else if(scb_c == 8'd65) begin
							SCB_SPIREAD[79:72] <= scb_spiread_reg[7:0];
						end else if(scb_c == 8'd73) begin
							SCB_SPIREAD[71:64] <= scb_spiread_reg[7:0];
						end else if(scb_c == 8'd81) begin
							SCB_SPIREAD[63:56] <= scb_spiread_reg[7:0];
						end else if(scb_c == 8'd89) begin
							SCB_SPIREAD[55:48] <= scb_spiread_reg[7:0];
						end else if(scb_c == 8'd97) begin
							SCB_SPIREAD[47:40] <= scb_spiread_reg[7:0];
						end else if(scb_c == 8'd105) begin
							SCB_SPIREAD[39:32] <= scb_spiread_reg[7:0];
						end else if(scb_c == 8'd113) begin
							SCB_SPIREAD[31:24] <= scb_spiread_reg[7:0];
						end else if(scb_c == 8'd121) begin
							SCB_SPIREAD[23:16] <= scb_spiread_reg[7:0];
						end else if(scb_c == 8'd129) begin
							SCB_SPIREAD[15:8] <= scb_spiread_reg[7:0];
						end else if(scb_c == 8'd137) begin
							SCB_SPIREAD[7:0] <= scb_spiread_reg[7:0];
						end
						
						if(scb_c == (scb_spibitlength[7:0]+8'd1) ) begin
							scb_state <= 4'd4;
						end

					end
				end
				
				4'd1: begin //done
					scb_en <= 1'b1;
					if(command_dacset == 1'b1) begin
						scb_state <= 4'd2;
					end
				end
				
				4'd2: begin //reset
					SCB_MCSn <= 1'b1;
					SCB_MDO <= 1'b0;
					SCB_MSK <= 1'b0;
					SCB_MEX <= 1'b0;
					scb_c <= 8'd0;
					scb_c2 <= 7'd0;
					scb_sr <= 16'd0;
					scb_en <= 1'b0;
					scb_spibitlength <= 8'd0;
					SCB_SPIREAD <= 128'd0;

					scb_state <= 4'd0;
				end
				
				4'd3: begin //DAC FINISH FlAG

					if(command_dacset == 1'b1) begin
						scb_command_dac_finish <= 1'b1;
					end else begin
						scb_command_dac_finish <= 1'b0;
					end
					
					if(command_dacset == 1'b0) begin
						scb_state <= 4'd1;
					end
					
				end

				4'd4: begin //Check Busy Flag
					if(SCB_nIRQ == 1'b1) begin
						scb_state <= 4'd3;
					end
				end
				
			endcase
		end
	end

//SCB test pulse trigger
	reg scb_tp_trig;
	reg[15:0] scb_tp_width_c;
	reg[15:0] scb_tp_width_reg;
	reg[29:0] scb_tp_freq_c;
	reg[29:0] scb_tp_freq_reg;

	reg[1:0] scb_tp_trig_buf;
	assign scb_tp_trig_ext = (~scb_tp_trig_buf[1] & scb_tp_trig_buf[0]);

	reg scb_tpext_trig;
	reg[15:0] scb_tpext_width_c;
	reg[15:0] scb_tpext_width_reg;
	reg[29:0] scb_tpext_freq_c;
	reg[29:0] scb_tpext_freq_reg;

	wire rst_refclk_and;
	wire trig_rst_and;
	assign rst_refclk_and = rst_refclk & ~SCB_TP_CLKSELECT[7];
	assign trig_rst_and = trig_rst & ~SCB_TP_CLKSELECT[7];

	wire scb_tp_trig_mux;
	assign scb_tp_trig_mux = SCB_TP_CLKSELECT[0] ? scb_tpext_trig : scb_tp_trig;

	always@(posedge clk_133m or posedge rst) begin
		if(rst)begin
			scb_tp_trig_buf <= 2'd0;
		end else begin
			//scb_tp_trig_buf[1:0] <= {scb_tp_trig_buf[0],scb_tp_trig};
			scb_tp_trig_buf[1:0] <= {scb_tp_trig_buf[0],scb_tp_trig_mux};
		end
	end

	always@(posedge clk_ext10m or posedge rst_refclk_and) begin
		if(rst_refclk_and) begin
			scb_tpext_trig <= 1'd0;
			scb_tpext_width_c <= 16'd0;
			scb_tpext_width_reg <= 16'd0;
			scb_tpext_freq_c <= 30'd0;
			scb_tpext_freq_reg <= 30'd0;
		end else begin

			if(scb_tpext_freq_c == scb_tpext_freq_reg) begin
				if(command_tp_trig) begin
					scb_tpext_trig <= 1'b1;
				end
			end else if(scb_tpext_width_c == scb_tpext_width_reg) begin
					scb_tpext_trig <= 1'b0;
			end

			if(scb_tpext_width_c == scb_tpext_width_reg) begin
				scb_tpext_width_c <= 16'd0;
			end else if(scb_tpext_trig) begin
				scb_tpext_width_c <= scb_tpext_width_c + 16'd1;
			end

			if(scb_tpext_freq_c == scb_tpext_freq_reg) begin
				scb_tpext_freq_c <= 30'd0;
			end else begin
				scb_tpext_freq_c <= scb_tpext_freq_c + 30'd1;
			end

			if(scb_tpext_freq_c == scb_tpext_freq_reg) begin
				scb_tpext_freq_reg <= SCB_TP_TRIG_FREQ;
			end

			if(scb_tpext_width_c == scb_tpext_width_reg) begin
				scb_tpext_width_reg <= SCB_TP_TRIG_WIDTH;
			end

		end
	end

	always@(posedge clk_133m or posedge trig_rst_and) begin
		if(trig_rst_and) begin
			scb_tp_trig <= 1'd0;
			scb_tp_width_c <= 16'd0;
			scb_tp_width_reg <= 16'd0;
			scb_tp_freq_c <= 30'd0;
			scb_tp_freq_reg <= 30'd0;
		end else begin

			if(scb_tp_freq_c == scb_tp_freq_reg) begin
				if(command_tp_trig) begin
					scb_tp_trig <= 1'b1;
				end
			end else if(scb_tp_width_c == scb_tp_width_reg) begin
					scb_tp_trig <= 1'b0;
			end

			if(scb_tp_width_c == scb_tp_width_reg) begin
				scb_tp_width_c <= 16'd0;
			end else if(scb_tp_trig) begin
				scb_tp_width_c <= scb_tp_width_c + 16'd1;
			end

			if(scb_tp_freq_c == scb_tp_freq_reg) begin
				scb_tp_freq_c <= 30'd0;
			end else begin
				scb_tp_freq_c <= scb_tp_freq_c + 30'd1;
			end

			if(scb_tp_freq_c == scb_tp_freq_reg) begin
				scb_tp_freq_reg <= SCB_TP_TRIG_FREQ;
			end

			if(scb_tp_width_c == scb_tp_width_reg) begin
				scb_tp_width_reg <= SCB_TP_TRIG_WIDTH;
			end

		end
	end

	OBUFDS #(
		.IOSTANDARD("LVDS_25")
		) OBUFDS_SCB_TP_TRIG (
		.O(SCB_TP_TRIG_P),
		.OB(SCB_TP_TRIG_N),
		.I(scb_tp_trig_mux)
	);
		
endmodule
