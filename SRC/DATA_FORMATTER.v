
module DATA_FORMATTER 
(
	input CLK,
	input RST,

	input[12:0] DRS_READDEPTH,

	output[7:0] DFIFO_RDCLK,
	output[7:0] DFIFO_RDEN,
	input[7:0] DFIFO_EMPTY,
	input[7:0] DFIFO_VALID,

	input[7:0] DFIFO_DOUT0,
	input[7:0] DFIFO_DOUT1,
	input[7:0] DFIFO_DOUT2,
	input[7:0] DFIFO_DOUT3,
	input[7:0] DFIFO_DOUT4,
	input[7:0] DFIFO_DOUT5,
	input[7:0] DFIFO_DOUT6,
	input[7:0] DFIFO_DOUT7,
	
	output CFIFO_RDCLK,
	output CFIFO_RDEN,
	input CFIFO_EMPTY,
	input CFIFO_VALID,

	input[7:0] CFIFO_DOUT,

	input SFIFO_RDCLK,
	input SFIFO_RDEN,
	output[7:0] SFIFO_DOUT,
	output SFIFO_EMPTY,
	output SFIFO_PROGFULL,
	output SFIFO_VALID
);

//--------------------------------------------

	reg[3:0] fmt_fifoc;
	reg[15:0] fmt_c;
	reg[15:0] fmt_c2;
	reg[15:0] fmt_c3;
	reg[7:0] sfifo_din;
	reg sfifo_wren;
	wire sfifo_progfull;
	reg cfifo_rden;
	reg[7:0] dfifo_rden;

	assign CFIFO_RDCLK = CLK;
	assign CFIFO_RDEN = cfifo_rden;
	assign DFIFO_RDCLK = {8{CLK}};
	assign DFIFO_RDEN = dfifo_rden;

	always@(posedge CLK or posedge RST) begin
		if(RST) begin
			fmt_fifoc <= 4'd0;
			fmt_c <= 16'd0;
			fmt_c2 <= 16'd0;
			fmt_c3 <= 16'd0;
			sfifo_din <= 8'd0;
			sfifo_wren <= 1'b0;
			cfifo_rden <= 1'b0;
			dfifo_rden <= 8'd0;
		end else begin

			if(fmt_fifoc == 4'd0) begin
				if(fmt_c==16'd31 && sfifo_progfull==1'b0 && CFIFO_EMPTY==1'b0) begin
					fmt_fifoc <= 4'd1;
				end
				
			end else if(fmt_fifoc == 4'd1) begin
				if(~sfifo_progfull & ~DFIFO_EMPTY[0]) begin
					//if(fmt_c2 == 16'd1) begin
					/* //stopcell + DRS4 data
					if(fmt_c2 == DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + 16'd3) begin 
						if(fmt_c2 == DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + 16'd3) begin
						//fmt_fifoc <= 4'd3;
						fmt_fifoc <= 4'd4;
						fmt_c2 <= 16'd0;
					end else begin
						fmt_c2 <= fmt_c2 + 16'd1;
					end
					*/
					
					if(fmt_c3 == 16'd0) begin
						//if(fmt_c2 == 16'd3) begin //stopcell + flag
						if(fmt_c2 == 16'd1) begin //flag
						//fmt_fifoc <= 4'd2;
							fmt_fifoc <= 4'd3;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd0;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
					end else if(fmt_c3 == 16'd1)begin
						
						if(fmt_c2 == 16'd1) begin //stopcell
						//fmt_fifoc <= 4'd2;
							fmt_fifoc <= 4'd3;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd1;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
					
					end else begin
						if(fmt_c2 == DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH - 16'd1) begin //DRS4 data
						//fmt_fifoc <= 4'd2;
							fmt_fifoc <= 4'd3;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd2;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
					end
					
				end
			end else if(fmt_fifoc == 4'd2) begin
				if(~sfifo_progfull & ~DFIFO_EMPTY[1]) begin
					//if(fmt_c2 == 16'd1) begin
					/*
					if(fmt_c2 == DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + 16'd3) begin
						//fmt_fifoc <= 4'd3;
						fmt_fifoc <= 4'd4;
						fmt_c2 <= 16'd0;
					end else begin
						fmt_c2 <= fmt_c2 + 16'd1;
					end
					*/

					if(fmt_c3 == 16'd0) begin
						//if(fmt_c2 == 16'd3) begin //stopcell + Flag
						if(fmt_c2 == 16'd1) begin //Flag
							fmt_fifoc <= 4'd4;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd0;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
					end else if(fmt_c3 == 16'd1)begin
						
						if(fmt_c2 == 16'd1) begin //stopcell
							fmt_fifoc <= 4'd4;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd1;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end

					end else begin
						if(fmt_c2 == DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH - 16'd1) begin //DRS4 data
							fmt_fifoc <= 4'd4;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd2;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
					end
				end

			end else if(fmt_fifoc == 4'd3) begin
				if(~sfifo_progfull & ~DFIFO_EMPTY[2]) begin
					//if(fmt_c2 == 16'd1) begin
					/*	
					if(fmt_c2 == DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + 16'd3) begin
						//fmt_fifoc <= 4'd4;
						fmt_fifoc <= 4'd5;
						fmt_c2 <= 16'd0;
					end else begin
						fmt_c2 <= fmt_c2 + 16'd1;
					end
					*/
					if(fmt_c3 == 16'd0) begin
						//if(fmt_c2 == 16'd3) begin //stopcell + Flag
						if(fmt_c2 == 16'd1) begin //stopcell
							fmt_fifoc <= 4'd5;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd0;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
					end else if(fmt_c3 == 16'd1)begin
						
						if(fmt_c2 == 16'd1) begin //stopcell
							fmt_fifoc <= 4'd5;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd1;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
						
					end else begin
						if(fmt_c2 == DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH - 16'd1) begin //DRS4 data
							fmt_fifoc <= 4'd5;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd2;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
					end
				end

			end else if(fmt_fifoc == 4'd4) begin
				if(~sfifo_progfull & ~DFIFO_EMPTY[3]) begin
					//if(fmt_c2 == 16'd1) begin
					/*
					if(fmt_c2 == DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + 16'd3) begin	
						//fmt_fifoc <= 4'd5;
						fmt_fifoc <= 4'd6;
						fmt_c2 <= 16'd0;
					end else begin
						fmt_c2 <= fmt_c2 + 16'd1;
					end
					*/
					if(fmt_c3 == 16'd0) begin
						//if(fmt_c2 == 16'd3) begin //stopcell + Flag
						if(fmt_c2 == 16'd1) begin //Flag
							fmt_fifoc <= 4'd6;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd0;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
					
					end else if(fmt_c3 == 16'd1)begin
					
						if(fmt_c2 == 16'd1) begin //stopcell
							fmt_fifoc <= 4'd6;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd1;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
						
					end else begin
						if(fmt_c2 == DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH - 16'd1) begin //DRS4 data
							fmt_fifoc <= 4'd6;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd2;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
					end
				end

			end else if(fmt_fifoc == 4'd5) begin
				if(~sfifo_progfull & ~DFIFO_EMPTY[4]) begin
					//if(fmt_c2 == 16'd1) begin
					/*
					if(fmt_c2 == DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + 16'd3) begin	
						//fmt_fifoc <= 4'd6;
						fmt_fifoc <= 4'd7;
						fmt_c2 <= 16'd0;
					end else begin
						fmt_c2 <= fmt_c2 + 16'd1;
					end
					*/
					if(fmt_c3 == 16'd0) begin
						//if(fmt_c2 == 16'd3) begin //stopcell + Flag
						if(fmt_c2 == 16'd1) begin //Flag
							fmt_fifoc <= 4'd7;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd0;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
						
					end else if(fmt_c3 == 16'd1)begin
						
						if(fmt_c2 == 16'd1) begin //stopcell
							fmt_fifoc <= 4'd7;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd1;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
						
					end else begin
						if(fmt_c2 == DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH - 16'd1) begin //DRS4 data
							fmt_fifoc <= 4'd7;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd2;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
					end
				end
				
			end else if(fmt_fifoc == 4'd6) begin
				if(~sfifo_progfull & ~DFIFO_EMPTY[5]) begin
					//if(fmt_c2 == 16'd1) begin
					/*
					if(fmt_c2 == DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + 16'd3) begin	
						//fmt_fifoc <= 4'd7;
						fmt_fifoc <= 4'd8;
						fmt_c2 <= 16'd0;
					end else begin
						fmt_c2 <= fmt_c2 + 16'd1;
					end
					*/
					if(fmt_c3 == 16'd0) begin
						//if(fmt_c2 == 16'd3) begin //stopcell + Flag
						if(fmt_c2 == 16'd1) begin //stopcell
							fmt_fifoc <= 4'd8;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd0;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
						
					end else if(fmt_c3 == 16'd1)begin
						
						if(fmt_c2 == 16'd1) begin //stopcell
							fmt_fifoc <= 4'd8;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd1;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
						
					end else begin
						if(fmt_c2 == DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH - 16'd1) begin //DRS4 data
							fmt_fifoc <= 4'd8;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd2;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
					end
				end

			end else if(fmt_fifoc == 4'd7) begin
				if(~sfifo_progfull & ~DFIFO_EMPTY[6]) begin
					//if(fmt_c2 == 16'd1) begin
					/*
					if(fmt_c2 == DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + 16'd3) begin	
						//fmt_fifoc <= 4'd8;
						fmt_fifoc <= 4'd2;
						fmt_c2 <= 16'd0;
					end else begin
						fmt_c2 <= fmt_c2 + 16'd1;
					end
					*/
					if(fmt_c3 == 16'd0) begin
						//if(fmt_c2 == 16'd3) begin //stopcell + Flag
						if(fmt_c2 == 16'd1) begin //Flag
							fmt_fifoc <= 4'd2;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd0;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
						
					end else if(fmt_c3 == 16'd1)begin
						
						if(fmt_c2 == 16'd1) begin //stopcell
							fmt_fifoc <= 4'd2;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd1;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
						
					end else begin
						if(fmt_c2 == DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH - 16'd1) begin //DRS4 data
							fmt_fifoc <= 4'd2;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd2;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
					end
				end
				
			end else if(fmt_fifoc == 4'd8) begin
				if(~sfifo_progfull & ~DFIFO_EMPTY[7]) begin
					//if(fmt_c == (DRS_READDEPTH + DRS_READDEPTH + 16'd1)) begin
					/*
					if(fmt_c2 == DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + 16'd3) begin	
						//if(fmt_c2 == 16'd1) begin
							fmt_fifoc <= 4'd0;
							fmt_c2 <= 16'd0;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
					end
					*/
					if(fmt_c3 == 16'd0) begin
						//if(fmt_c2 == 16'd3) begin //stopcell + Flag
						if(fmt_c2 == 16'd1) begin //stopcell
							fmt_fifoc <= 4'd1;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd1; //next
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
						
					end else if(fmt_c3 == 16'd1)begin
						
						if(fmt_c2 == 16'd1) begin //stopcell
							fmt_fifoc <= 4'd1;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd2; //next
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
						
					end else begin
						if(fmt_c2 == DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH + DRS_READDEPTH - 16'd1) begin //DRS4 data
							fmt_fifoc <= 4'd0;
							fmt_c2 <= 16'd0;
							fmt_c3 <= 16'd0;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
					end
					
					/*
					end else begin
						if(fmt_c2 == 16'd1) begin
							fmt_fifoc <= 4'd1;
							fmt_c2 <= 16'd0;
						end else begin
							fmt_c2 <= fmt_c2 + 16'd1;
						end
					end
					*/
				end
			end


			if(fmt_fifoc == 4'd0) begin
				if(fmt_c==16'd31 && sfifo_progfull==1'b0 && CFIFO_EMPTY==1'b0) begin
					fmt_c <= 16'd0;
				end else if(~sfifo_progfull & ~CFIFO_EMPTY) begin
					fmt_c <= fmt_c + 16'd1;
				end 
			end
			/*
			end else if(fmt_fifoc == 4'd8) begin
				if(fmt_c == (DRS_READDEPTH + DRS_READDEPTH + 16'd1) && fmt_c2==16'd1 && sfifo_progfull==1'b0 && DFIFO_EMPTY[7]==1'b0) begin
					fmt_c <= 16'd0;
				end else if(fmt_c2==16'd1 && sfifo_progfull==1'b0 & DFIFO_EMPTY[7]==1'b0) begin
					fmt_c <= fmt_c + 16'd1;
				end
			end
			*/

			if(fmt_fifoc == 4'd0) begin
				cfifo_rden <= ~sfifo_progfull & ~CFIFO_EMPTY;
			end else begin
				cfifo_rden <= 1'b0;
			end

			if(fmt_fifoc == 4'd1) begin
				dfifo_rden[0] <= ~sfifo_progfull & ~DFIFO_EMPTY[0];
			end else begin
				dfifo_rden[0] <= 1'b0;
			end

			if(fmt_fifoc == 4'd2) begin
				dfifo_rden[1] <= ~sfifo_progfull & ~DFIFO_EMPTY[1];
			end else begin
				dfifo_rden[1] <= 1'b0;
			end

			if(fmt_fifoc == 4'd3) begin
				dfifo_rden[2] <= ~sfifo_progfull & ~DFIFO_EMPTY[2];
			end else begin
				dfifo_rden[2] <= 1'b0;
			end

			if(fmt_fifoc == 4'd4) begin
				dfifo_rden[3] <= ~sfifo_progfull & ~DFIFO_EMPTY[3];
			end else begin
				dfifo_rden[3] <= 1'b0;
			end

			if(fmt_fifoc == 4'd5) begin
				dfifo_rden[4] <= ~sfifo_progfull & ~DFIFO_EMPTY[4];
			end else begin
				dfifo_rden[4] <= 1'b0;
			end

			if(fmt_fifoc == 4'd6) begin
				dfifo_rden[5] <= ~sfifo_progfull & ~DFIFO_EMPTY[5];
			end else begin
				dfifo_rden[5] <= 1'b0;
			end

			if(fmt_fifoc == 4'd7) begin
				dfifo_rden[6] <= ~sfifo_progfull & ~DFIFO_EMPTY[6];
			end else begin
				dfifo_rden[6] <= 1'b0;
			end

			if(fmt_fifoc == 4'd8) begin
				dfifo_rden[7] <= ~sfifo_progfull & ~DFIFO_EMPTY[7];
			end else begin
				dfifo_rden[7] <= 1'b0;
			end

			if(CFIFO_VALID) begin
				sfifo_din <= CFIFO_DOUT;
			end else if(DFIFO_VALID[0]) begin
				sfifo_din <= DFIFO_DOUT0;
			end else if(DFIFO_VALID[1]) begin
				sfifo_din <= DFIFO_DOUT1;
			end else if(DFIFO_VALID[2]) begin
				sfifo_din <= DFIFO_DOUT2;
			end else if(DFIFO_VALID[3]) begin
				sfifo_din <= DFIFO_DOUT3;
			end else if(DFIFO_VALID[4]) begin
				sfifo_din <= DFIFO_DOUT4;
			end else if(DFIFO_VALID[5]) begin
				sfifo_din <= DFIFO_DOUT5;
			end else if(DFIFO_VALID[6]) begin
				sfifo_din <= DFIFO_DOUT6;
			end else if(DFIFO_VALID[7]) begin
				sfifo_din <= DFIFO_DOUT7;
			end

			sfifo_wren <= CFIFO_VALID | DFIFO_VALID[0] | DFIFO_VALID[1] | DFIFO_VALID[2] | DFIFO_VALID[3] | DFIFO_VALID[4] | DFIFO_VALID[5] | DFIFO_VALID[6] | DFIFO_VALID[7] ;

		end
	end

	wire sfifo_wrclk;
	assign sfifo_wrclk = CLK;

	wire[13:0] sfifo_pflthresh;
	assign sfifo_pflthresh = 14'd16383 - 14'd6;
	assign SFIFO_PROGFULL = sfifo_progfull;
	
	FORMAT_FIFO format_fifo(
		.rst(RST),
		.wr_clk(sfifo_wrclk),
		.rd_clk(SFIFO_RDCLK),
		.din(sfifo_din[7:0]),
		.wr_en(sfifo_wren),
		.rd_en(SFIFO_RDEN),
		.prog_full_thresh(sfifo_pflthresh),
		.dout(SFIFO_DOUT[7:0]),
		.full(),
		.empty(SFIFO_EMPTY),
		.valid(SFIFO_VALID),
		.prog_full(sfifo_progfull)
	);

endmodule

