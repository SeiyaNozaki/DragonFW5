
`define BASE_TIMING_SHIFT 25

module DRS_READ
(
	input CLK,
	input RST,

	input[3:0] DRS_STATE_COM,
	output DRS_READ_DONE_OUT,

	input DRS_CALREAD,
	input[7:0] DRS_CASCADENUM,
	input[12:0] DRS_READDEPTH,
	input[7:0] DRS_WSRCHECK,
	input[1:0] DRS_STOPCH,
	input DRS_STOPCH_FLAG,
	input INT_CLK_33M_90_TGL,

	output DRS_SRCLK,
	output[3:0] DRS_A,
	output DRS_RSRLOAD,
	input DRS_SROUT,

	input[11:0] ADC_OUT,
	input ADC_OUT_VALID,

	input DFIFO_RD_CLK,
	input DFIFO_RD_EN,
	output[7:0] DFIFO_DOUT,
	output DFIFO_EMPTY,
	output DFIFO_VALID,
	output DFIFO_PROGFULLOUT

	//output[3:0] drs_state,
	//output[13:0] drs_c
);

//--------------------------------------------

	reg[15:0] dfifo_din;
	reg dfifo_wr_en_cell;
	reg dfifo_wr_en_adc;
	reg dfifo_wr_clk;
	reg adc_valid_ir;
	reg adc_valid_ir2;
	reg adc_valid_ir3;
	reg adc_valid_ir4;
	reg[11:0] adc_out_ir;
	reg[11:0] adc_out_ir2;
	reg[11:0] adc_out_ir3;
	reg[11:0] adc_out_ir4;
	wire adc_valid_int;
	assign adc_valid_int = adc_valid_ir4;
	wire[11:0] adc_out_int;
	assign adc_out_int = adc_out_ir4;
	wire dfifo_wr_en;
	wire dfifo_progfull;
	//assign dfifo_wr_en = dfifo_wr_en_cell | dfifo_wr_en_adc;
	assign dfifo_wr_en = (dfifo_wr_en_cell | dfifo_wr_en_adc) & adc_valid_int;
	//assign dfifo_wr_en = ADC_OUT_VALID; //fifo connection test
	
	//---------------------------------------
	/*function [15:0] changeEndian;   //transform data from the memory to little-endian form
		input [15:0] value;
		changeEndian[15:0] = {value[7:0],value[15:8]};
	endfunction
	*/
	//---------------------------------------


	always@(posedge CLK or posedge RST) begin
		if(RST) begin
			adc_valid_ir <= 1'b0;
			adc_valid_ir2 <= 1'b0;
			adc_valid_ir3 <= 1'b0;
			adc_valid_ir4 <= 1'b0;
			adc_out_ir <= 12'd0;
			adc_out_ir2 <= 12'd0;
			adc_out_ir3 <= 12'd0;
			adc_out_ir4 <= 12'd0;
		end else begin
			adc_valid_ir <= ADC_OUT_VALID;
			adc_valid_ir2 <= adc_valid_ir;
			adc_valid_ir3 <= adc_valid_ir2;
			adc_valid_ir4 <= adc_valid_ir3;
			adc_out_ir <= ADC_OUT[11:0];
			adc_out_ir2 <= adc_out_ir;
			adc_out_ir3 <= adc_out_ir2;
			adc_out_ir4 <= adc_out_ir3;
		end
	end

	wire[12:0] dfifo_pflthresh;
	//assign dfifo_pflthresh = 13'd4095;
	assign dfifo_pflthresh = 13'd8191 - (13'd2 + DRS_READDEPTH + DRS_READDEPTH + 13'd6);
	DRS_FIFO drs_fifo(
		.rst(RST),
		//.wr_clk(dfifo_wr_clk),
		.wr_clk(CLK), //fifo connection test
		.rd_clk(DFIFO_RD_CLK),
		.din(dfifo_din[15:0]),
		//.din({4'd0,ADC_OUT[11:0]}), //fifo connection test
		.wr_en(dfifo_wr_en),
		.rd_en(DFIFO_RD_EN),
		.prog_full_thresh(dfifo_pflthresh),
		.dout(DFIFO_DOUT[7:0]),
		.full(),
		.empty(),
		.almost_empty(DFIFO_EMPTY),
		.valid(DFIFO_VALID),
		.prog_full(DFIFO_PROGFULLOUT)
	);
	assign dfifo_progfull = DFIFO_PROGFULLOUT;
	//assign dfifo_progfull = 1'b0; //fifo connection test

//--------------------------------------------

	reg[3:0] drs_state;
	reg[13:0] drs_c;
	reg rDRS_SRCLK;
	reg[3:0] rDRS_A;
	reg rDRS_RSRLOAD;
	reg[3:0] drs_rdaddr;
	reg[9:0] drs_stopcell;
	reg[12:0] drs_samp_c;
	reg drs_samp_end;
	reg[3:0] drs_rdchannel_c;
	reg drs_read_done;

	reg[3:0] cascade_c;
	reg cascade_tag;

	reg dummy_rsrload;
	reg dummy_srclk;

	wire drs_stoppos_flagA;
	wire drs_stoppos_flagB;
	wire[1:0] drs_stopch_corr;

	assign DRS_READ_DONE_OUT = drs_read_done;
	assign DRS_SRCLK = rDRS_SRCLK;
	assign DRS_A = rDRS_A;
	assign DRS_RSRLOAD = rDRS_RSRLOAD;

	assign drs_stoppos_flagA = ( {3'd0,drs_stopcell[9:0]}<13'd767 ? 1'b0 : 1'b1 );
	assign drs_stoppos_flagB = ( {3'd0,drs_stopcell[9:0]}+DRS_READDEPTH[12:0]-13'd1<13'd1024 ? 1'b0 : 1'b1 );
	//assign drs_stoppos_flagA = 1'b0; //debug
	//assign drs_stoppos_flagB = 1'b0; //debug

	assign drs_stopch_corr = 
		(drs_stoppos_flagA==1'b1 ? 
			(DRS_CASCADENUM[3:0]==4'd1 ? 
				DRS_STOPCH : 
				(DRS_CASCADENUM[3:0]==4'd2 ? 
					{DRS_STOPCH[1],(DRS_STOPCH[0]-1'b1)} : 
					(DRS_STOPCH-2'd1) )
			) :
			DRS_STOPCH);

	always@(posedge CLK or posedge RST)begin
		if(RST)begin
			drs_state <= 4'd0;
			drs_c <= 14'd0;
			rDRS_SRCLK <= 1'b0;
			rDRS_A <= 4'b1011; //Address Read Shift Register
			rDRS_RSRLOAD <= 1'b0;
			drs_rdaddr <= 4'd0;
			drs_stopcell <= 10'd0;
			drs_samp_c <= 13'd0;
			drs_samp_end <= 1'b0;
			drs_rdchannel_c <= 4'd0;
			drs_read_done <= 1'b0;
			cascade_c <= 4'd0;
			cascade_tag <= 1'b0;
			dummy_rsrload <= 1'b0;
			dummy_srclk <= 1'b0;
		end else begin

			case(drs_state)

				4'd0: begin //wait
					rDRS_SRCLK <= 1'b0;
					rDRS_A <= 4'b1011; //Address Read Shift Register
					rDRS_RSRLOAD <= 1'b0;
					if(DRS_STATE_COM==4'd5)begin
						drs_state <= 4'd1;
					end
				end
				
				4'd1: begin //set address
					rDRS_SRCLK <= 1'b0;
					rDRS_A <= rDRS_A; 
					rDRS_RSRLOAD <= 1'b0;

					if(drs_rdchannel_c == 4'd0) begin
						drs_rdaddr[3:0] <= {1'b0,1'b0,DRS_STOPCH[1:0]};
					end else if(drs_rdchannel_c == 4'd1) begin
						//drs_rdaddr[3:0] <= {1'b0,1'b0,drs_stopch_corr[1:0]};
						drs_rdaddr[3:0] <= (DRS_CALREAD ? 4'b1000 : {1'b0,1'b0,drs_stopch_corr[1:0]});
					end else if(drs_rdchannel_c == 4'd5) begin
						drs_rdaddr[3:0] <= {1'b0,1'b1,drs_stopch_corr[1:0]};
					end
					
					//if(~dfifo_progfull) begin //should be checked before accepting triggers
						if(INT_CLK_33M_90_TGL) begin
							drs_state <= 4'd3;
						end
					//end
				end

				4'd2: begin //finish
					if(DRS_STATE_COM == 4'd6) begin
						drs_state <= 4'd0;
						drs_read_done <= 1'b0;
					end 
					drs_c <= 14'd0;
					rDRS_RSRLOAD <= 1'b0;
					rDRS_SRCLK <= 1'b0;
					rDRS_A <= 4'b1011;//Address Read Shift Register
					drs_rdaddr <= 4'd0;
					drs_stopcell <= 10'd0;
					drs_samp_c <= 13'd0;
					drs_samp_end <= 1'b0;
					drs_rdchannel_c <= 4'd0;
					cascade_c <= 4'd0;
					cascade_tag <= 1'b0;
					dummy_rsrload <= 1'b0;
					dummy_srclk <= 1'b0;
				end

				4'd3: begin //readout

					if(drs_c == 14'd0) begin
						if(INT_CLK_33M_90_TGL) begin
							rDRS_A <= drs_rdaddr;
						end
					end else if(drs_rdchannel_c == 4'd1 || drs_rdchannel_c == 4'd5) begin
						if(drs_stoppos_flagB) begin
							//if(drs_samp_c == 13'd1023-{3'd0,drs_stopcell[9:0]}+13'd1) begin
							//if(drs_samp_c == 13'd1023-{3'd0,drs_stopcell[9:0]}+13'd2) begin
							if(drs_samp_c == 13'd1023-{3'd0,drs_stopcell[9:0]}+13'd1 && cascade_c==4'd4) begin
								rDRS_A <= {drs_rdaddr[3:2],drs_rdaddr[1:0]+2'd1};
							end

							if(drs_samp_c == 13'd1023-{3'd0,drs_stopcell[9:0]}+13'd1 && cascade_c==4'd6) begin
								dummy_rsrload <= 1'b1;
							end else begin
								dummy_rsrload <= 1'b0;
							end
						end
					end
				
					if(drs_c == 14'd0) begin
						if(INT_CLK_33M_90_TGL) begin
							drs_c <= drs_c + 14'd1;
						end
					end else if(drs_samp_end) begin
						drs_c <= 14'd0;
					end else begin
						drs_c <= drs_c + 14'd1;
					end
														
					if(drs_c == 14'd1) begin
						rDRS_RSRLOAD <= 1'b1;
					end else begin
						rDRS_RSRLOAD <= 1'b0;
					end
					
					if(drs_samp_end) begin
						rDRS_SRCLK <= 1'b0;
						cascade_tag<=1'b0;
						cascade_c<=4'd0;
						dummy_srclk<=1'b0;
					end else if(drs_c > 14'd2) begin
						//if(drs_stoppos_flagB==1'b1 &&  drs_samp_c == 13'd1023-{3'd0,drs_stopcell[9:0]}+13'd1) begin //saisho ni tameshita
						//if(drs_stoppos_flagB==1'b1 && drs_samp_c == 13'd1023-{3'd0,drs_stopcell[9:0]}+13'd2) begin //honmei
						if(drs_stoppos_flagB==1'b1 && ( drs_samp_c==13'd1023-{3'd0,drs_stopcell[9:0]}+13'd1 || drs_samp_c == 13'd1023-{3'd0,drs_stopcell[9:0]}+13'd2 ) ) begin //yoyuu motase
							if(cascade_c==4'd0 || cascade_c==4'd1) begin
								rDRS_SRCLK <= 1'b0;
								cascade_tag <= ~cascade_tag;
								cascade_c <= cascade_c + 4'd1;
								dummy_srclk <= 1'b0;
							end else if(cascade_c==4'd2 || cascade_c==4'd3) begin
								rDRS_SRCLK <= ~rDRS_SRCLK;
								cascade_tag <= 1'b0;
								cascade_c <= cascade_c + 4'd1;
								dummy_srclk <= ~dummy_srclk;
							end else if(cascade_c==4'd4 || cascade_c==4'd5 || cascade_c==4'd6 || cascade_c==4'd7) begin
								rDRS_SRCLK <= 1'b0;
								cascade_tag <= 1'b0;
								cascade_c <= cascade_c + 4'd1;
								dummy_srclk <= 1'b0;
							end else if(cascade_c==4'd8 || cascade_c==4'd9) begin
								rDRS_SRCLK <= ~rDRS_SRCLK;
								cascade_tag <= 1'b0;
								cascade_c <= cascade_c + 4'd1;
								dummy_srclk <= 1'b0;
							end
						end else begin
							rDRS_SRCLK <= ~rDRS_SRCLK;
							cascade_c<=4'd0;
						end
					end else begin
						rDRS_SRCLK <= 1'b0;
					end
					
					if(drs_samp_end) begin
						drs_samp_c <= 13'd0;
					end else if( (rDRS_SRCLK & ~dummy_srclk) | rDRS_RSRLOAD | dummy_rsrload ) begin
						drs_samp_c <= drs_samp_c + 13'd1;
					end

					if(drs_rdchannel_c == 4'd0 && drs_samp_c < 13'd11) begin
						if(DRS_SRCLK) begin
							drs_stopcell[9:0] <= {drs_stopcell[8:0], DRS_SROUT};
						end
					end
							
					if(drs_samp_end) begin
						drs_samp_end <= 1'b0;
					end else begin

						if(drs_rdchannel_c == 4'd0) begin
								if(drs_samp_c == 13'd11) begin
									drs_samp_end <= 1'b1;
								end
						end else begin
							if(drs_samp_c==DRS_READDEPTH-13'd1 && ( (rDRS_SRCLK & ~dummy_srclk) | rDRS_RSRLOAD | dummy_rsrload )) begin
								drs_samp_end <= 1'b1;
							end
						end

					end

					if(drs_samp_end) begin
						if(drs_rdchannel_c == 4'd5) begin
							drs_state <= 4'd2;
							drs_read_done <= 1'b1;
						end else begin
							drs_state <= 4'd1;
						end
					end

					if(drs_samp_end) begin
						if(drs_rdchannel_c == 4'd0) begin
							drs_rdchannel_c <= 4'd1;
						end else if(drs_rdchannel_c == 4'd1) begin
							drs_rdchannel_c <= 4'd5;
						end else if(drs_rdchannel_c == 4'd5) begin
							drs_rdchannel_c <= 4'd0;
						end
					end

				end
					
			endcase
		end
	end

//--------------------------------------------

	reg drs_sampfirst;
	reg drs_sampfirst_ir;
	reg drs_sampstart;
	reg drs_sampstart_ir;
	reg[31:0] drs_sampfirst_buf;
	reg[31:0] drs_sampstart_buf;
	reg[31:0] drs_sampend_buf;
	reg drs_sampend_ir;
	reg[31:0] cascade_tag_buf;
	reg cascade_tag_ir;

	always@(posedge CLK or posedge RST) begin
		if(RST)begin
			drs_sampfirst <= 1'b0;
			drs_sampfirst_ir <= 1'b0;
			drs_sampstart <= 1'b0;
			drs_sampstart_ir <= 1'b0;
			drs_sampfirst_buf <= 32'd0;
			drs_sampstart_buf <= 32'd0;
			drs_sampend_buf <= 32'd0;
			drs_sampend_ir <= 1'b0;
			cascade_tag_buf <= 32'd0;
			cascade_tag_ir <= 1'b0;
		end else begin

			if(DRS_RSRLOAD == 1'b1 && drs_rdchannel_c == 4'd0) begin
				drs_sampfirst <= 1'b1;
			end else begin
				drs_sampfirst <= 1'b0;
			end

			if(DRS_RSRLOAD == 1'b1) begin
				drs_sampstart <= 1'b1;
			end else begin
				drs_sampstart <= 1'b0;
			end

			drs_sampfirst_ir <= drs_sampfirst;
			drs_sampstart_ir <= drs_sampstart;
			drs_sampend_ir <= drs_samp_end;
			cascade_tag_ir <= cascade_tag;

			//if(~INT_CLK_33M_90_TGL) begin
			//if(ADC_OUT_VALID) begin
			if(adc_valid_ir3) begin
				//drs_sampfirst_buf[31:0] <= {drs_sampfirst_buf[30:0],drs_sampfirst};
				drs_sampfirst_buf[31:0] <= {drs_sampfirst_buf[30:0],(drs_sampfirst|drs_sampfirst_ir)};
				//drs_sampstart_buf[31:0] <= {drs_sampstart_buf[30:0],drs_sampstart};
				drs_sampstart_buf[31:0] <= {drs_sampstart_buf[30:0],(drs_sampstart|drs_sampstart_ir)};
				//drs_sampend_buf[31:0] <= {drs_sampend_buf[30:0],drs_sampend_ir};
				//drs_sampend_buf[31:0] <= {drs_sampend_buf[30:0],drs_samp_end};
				drs_sampend_buf[31:0] <= {drs_sampend_buf[30:0],(drs_samp_end|drs_sampend_ir)};
				//cascade_tag_buf[31:0] <= {cascade_tag_buf[30:0],cascade_tag_ir};
				cascade_tag_buf[31:0] <= {cascade_tag_buf[30:0],(cascade_tag|cascade_tag_ir)};
			end

		end
	end

//--------------------------------------------
//
	reg[11:0] adc_outbuf;

	always@(posedge CLK or posedge RST) begin
		if(RST) begin
			dfifo_wr_en_cell <= 1'b0;
			dfifo_wr_en_adc <= 1'b0;
			dfifo_wr_clk <= 1'b0;
			dfifo_din <= 16'd0;
			adc_outbuf <= 12'd0;
		end else begin 

			dfifo_wr_clk <= ~INT_CLK_33M_90_TGL;

			if(drs_sampfirst_buf[10]) begin
				dfifo_wr_en_cell <= 1'b1;
			end else if(drs_sampfirst_buf[12]) begin
			//end else if(drs_sampfirst_buf[11]) begin
				dfifo_wr_en_cell <= 1'b0;
			/*
			end else if(cascade_tag_buf[17]) begin //saisho ni tameshita honmei
				dfifo_wr_en <= 1'b0;
			end else if(cascade_tag_buf[18]) begin
				dfifo_wr_en <= 1'b1;
			end else if(drs_sampstart_buf[18] & ~drs_sampfirst_buf[18]) begin
				dfifo_wr_en <= 1'b1;
			end else if(drs_sampend_buf[19]) begin
				dfifo_wr_en <= 1'b0;
			end
			*/
			/*
			end else if(cascade_tag_buf[16]) begin // ikko hayame
				dfifo_wr_en <= 1'b0;
			end else if(cascade_tag_buf[17]) begin
				dfifo_wr_en <= 1'b1;
			end else if(drs_sampstart_buf[17] & ~drs_sampfirst_buf[17]) begin
				dfifo_wr_en <= 1'b1;
			end else if(drs_sampend_buf[18]) begin
				dfifo_wr_en <= 1'b0;
			end
			*/
			//end else if(cascade_tag_buf[18]) begin // tsunagime yoyuumotase
			//end else if(cascade_tag_buf[25]) begin // tsunagime yoyuumotase
			end else if(cascade_tag_buf[`BASE_TIMING_SHIFT+1]) begin // tsunagime yoyuumotase
				dfifo_wr_en_adc <= 1'b0;
			//end else if(cascade_tag_buf[21]) begin
			//end else if(cascade_tag_buf[28]) begin
			end else if(cascade_tag_buf[`BASE_TIMING_SHIFT+4]) begin
				dfifo_wr_en_adc <= 1'b1;
			//end else if(drs_sampstart_buf[18] & ~drs_sampfirst_buf[18]) begin
			//end else if(drs_sampstart_buf[24] & ~drs_sampfirst_buf[24]) begin
			end else if(drs_sampstart_buf[`BASE_TIMING_SHIFT] & ~drs_sampfirst_buf[`BASE_TIMING_SHIFT]) begin
				dfifo_wr_en_adc <= 1'b1;
			//end else if(drs_sampend_buf[19]) begin
			//end else if(drs_sampend_buf[25]) begin
			end else if(drs_sampend_buf[`BASE_TIMING_SHIFT+1]) begin
				dfifo_wr_en_adc <= 1'b0;
			end

			//adc_outbuf <= ADC_OUT[11:0];
			//if(ADC_OUT_VALID) begin
			if(adc_valid_ir3) begin
				//adc_outbuf <= ADC_OUT[11:0];
				adc_outbuf <= adc_out_int[11:0];
			end

			if(drs_sampfirst_buf[10]) begin
			
				//dfifo_din <= changeEndian({12'hF00, 2'b00, drs_stoppos_flagB, drs_stoppos_flagA});
				//dfifo_din <= {12'hF00, 2'b00, drs_stoppos_flagB, drs_stoppos_flagA};
				//dfifo_din <= {6'd0, drs_stoppos_flagB, drs_stoppos_flagA, 8'hF0};
				//dfifo_din <= {DRS_WSRCHECK[7:0], 8'd0};
				dfifo_din <= {7'd0, DRS_STOPCH_FLAG, 8'd0};
			end else if(drs_sampfirst_buf[11]) begin
			
				//dfifo_din <= changeEndian({4'd0,drs_stopch_corr[1:0],drs_stopcell[9:0]});
				//dfifo_din <= {4'd0,drs_stopch_corr[1:0],drs_stopcell[9:0]};
				//dfifo_din <= {drs_stopcell[7:0], DRS_STOPCH_FLAG, 3'd0, drs_stopch_corr[1:0], drs_stopcell[9:8]};
				dfifo_din <= {drs_stopcell[7:0], 4'd0, drs_stopch_corr[1:0], drs_stopcell[9:8]};
			end else begin
				//dfifo_din <= changeEndian({4'd0,adc_outbuf[11:0]});
				//dfifo_din <= {4'd0,adc_outbuf[11:0]};
				dfifo_din <= {adc_outbuf[7:0], 4'd0, adc_outbuf[11:8]};
			end

		end
	end

endmodule

