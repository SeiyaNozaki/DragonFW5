
`define HEADER_LENGTH 10'd16
`define EVENT_HEADER 16'hAAAA
`define DATA_HEADER 16'hDDDD

module COUNTER_READ
(
	input CLK,
	input RST,

	input[3:0] DRS_STATE_COM,
	input[31:0] DRS_EVENT_COUNTER,
	input[31:0] DRS_TRIG_COUNTER,
	input[63:0] DRS_CLOCK_COUNTER,
	input[31:0]  TenMHz_COUNTER,
	input[15:0] PPS_COUNTER,

	output COUNTERREAD_DONE,

	input CFIFO_RDCLK,
	input CFIFO_RDEN,
	output[7:0] CFIFO_DOUT,
	output CFIFO_EMPTY,
	output CFIFO_VALID,
	output CFIFO_PROGFULL
);

//--------------------------------------------
	
	reg[3:0] counter_state;
	reg[7:0] counter_c;

	assign COUNTERREAD_DONE = (counter_state==4'd2 ? 1'b1 : 1'b0);

	reg[15:0] fifodin;
	reg fifowren;
	wire fifoprogfull;
	assign CFIFO_PROGFULL = fifoprogfull;

	wire[9:0] cfifo_pflthresh;
	//assign cfifo_pflthresh = 10'd512;
	assign cfifo_pflthresh = 10'd1023 - (`HEADER_LENGTH + 10'd6);
	COUNTER_FIFO counter_fifo(
		.rst(RST),
		.wr_clk(CLK),
		.rd_clk(CFIFO_RDCLK),
		.din(fifodin[15:0]),
		.wr_en(fifowren),
		.rd_en(CFIFO_RDEN),
		.prog_full_thresh(cfifo_pflthresh),
		.dout(CFIFO_DOUT[7:0]),
		.full(),
		.empty(),
		.almost_empty(CFIFO_EMPTY),
		.valid(CFIFO_VALID),
		.prog_full(fifoprogfull)
	);

//---------------------------------------
	/*
	function [15:0] changeEndian;   //transform data from the memory to little-endian form
		input [15:0] value;
		changeEndian[15:0] = {value[7:0],value[15:8]};
	endfunction
	*/
//---------------------------------------

	always@(posedge CLK or posedge RST) begin
		if(RST) begin
			counter_state <= 4'd0;
			counter_c <= 8'd0;

			fifodin <= 16'd0;
			fifowren <= 1'b0;
		end else begin

			case(counter_state)

				4'd0: begin
					if(DRS_STATE_COM==4'd5) begin
						counter_state <= 4'd3;
					end
				end

				4'd1: begin

					if(counter_c == 8'd16) begin
						counter_state <= 4'd2;
					end

					if(counter_c == 8'd16) begin
						counter_c <= 8'd0;
					end else begin
						counter_c <= counter_c + 8'd1;
					end

					if(counter_c == 8'd16) begin
						fifowren <= 1'b0;
					end else begin
						fifowren <= 1'b1;
					end

					if(counter_c == 8'd0) begin
						fifodin <= `EVENT_HEADER;
					end else if(counter_c == 8'd1) begin
						//fifodin <= changeEndian(PPS_COUNTER[15:0]);
						//fifodin <= PPS_COUNTER[15:0];
						fifodin <= {PPS_COUNTER[7:0], PPS_COUNTER[15:8]};
					end else if(counter_c == 8'd2) begin
						//fifodin <= changeEndian(TenMHz_COUNTER[15:0]);
						//fifodin <= TenMHz_COUNTER[31:16];
						fifodin <= {TenMHz_COUNTER[7:0], TenMHz_COUNTER[15:8]};
					end else if(counter_c == 8'd3) begin
						//fifodin <= changeEndian(TenMHz_COUNTER[31:16]);
						//fifodin <= TenMHz_COUNTER[15:0];
						fifodin <= {TenMHz_COUNTER[23:16], TenMHz_COUNTER[31:24]};
					end else if(counter_c == 8'd4) begin
						//fifodin <= changeEndian(DRS_EVENT_COUNTER[15:0]);
						//fifodin <= DRS_EVENT_COUNTER[31:16];
						fifodin <= {DRS_EVENT_COUNTER[7:0], DRS_EVENT_COUNTER[15:8]};
					end else if(counter_c == 8'd5) begin
						//fifodin <= changeEndian(DRS_EVENT_COUNTER[31:16]);
						//fifodin <= DRS_EVENT_COUNTER[15:0];
						fifodin <= {DRS_EVENT_COUNTER[23:16], DRS_EVENT_COUNTER[31:24]};
					end else if(counter_c == 8'd6) begin
						//fifodin <= changeEndian(DRS_TRIG_COUNTER[15:0]);
						//fifodin <= DRS_TRIG_COUNTER[31:16];
						fifodin <= {DRS_TRIG_COUNTER[7:0], DRS_TRIG_COUNTER[15:8]};
					end else if(counter_c == 8'd7) begin
						//fifodin <= changeEndian(DRS_TRIG_COUNTER[31:16]);
						//fifodin <= DRS_TRIG_COUNTER[15:0];
						fifodin <= {DRS_TRIG_COUNTER[23:16], DRS_TRIG_COUNTER[31:24]};
					end else if(counter_c == 8'd8) begin
						//fifodin <= changeEndian(DRS_CLOCK_COUNTER[15:0]);
						//fifodin <= DRS_CLOCK_COUNTER[63:48];
						fifodin <= {DRS_CLOCK_COUNTER[7:0], DRS_CLOCK_COUNTER[15:8]};
					end else if(counter_c == 8'd9) begin
						//fifodin <= changeEndian(DRS_CLOCK_COUNTER[31:16]);
						//fifodin <= DRS_CLOCK_COUNTER[47:32];
						fifodin <= {DRS_CLOCK_COUNTER[23:16], DRS_CLOCK_COUNTER[31:24]};
					end else if(counter_c == 8'd10) begin
						//fifodin <= changeEndian(DRS_CLOCK_COUNTER[47:32]);
						//fifodin <= DRS_CLOCK_COUNTER[31:16];
						fifodin <= {DRS_CLOCK_COUNTER[39:32], DRS_CLOCK_COUNTER[47:40]};
					end else if(counter_c == 8'd11) begin
						//fifodin <= changeEndian(DRS_CLOCK_COUNTER[63:48]);
						//fifodin <= DRS_CLOCK_COUNTER[15:0];
						fifodin <= {DRS_CLOCK_COUNTER[55:48], DRS_CLOCK_COUNTER[63:56]};
					end else if(counter_c == 8'd12) begin
						fifodin <= `DATA_HEADER;
					end else if(counter_c == 8'd13) begin
						fifodin <= `DATA_HEADER;
					end else if(counter_c == 8'd14) begin
						fifodin <= `DATA_HEADER;
					end else if(counter_c == 8'd15) begin
						fifodin <= `DATA_HEADER;
					end else begin
						fifodin <= 16'd0;
					end
					/* 
					//old format
					if(counter_c == 8'd0) begin
						fifodin <= DRS_EVENT_COUNTER[31:16];
					end else if(counter_c == 8'd1) begin
						fifodin <= DRS_EVENT_COUNTER[15:0];
					end else if(counter_c == 8'd2) begin
						fifodin <= DRS_TRIG_COUNTER[31:16];
					end else if(counter_c == 8'd3) begin
						fifodin <= DRS_TRIG_COUNTER[15:0];
					end else if(counter_c == 8'd4) begin
						fifodin <= DRS_CLOCK_COUNTER[63:48];
					end else if(counter_c == 8'd5) begin
						fifodin <= DRS_CLOCK_COUNTER[47:32];
					end else if(counter_c == 8'd6) begin
						fifodin <= DRS_CLOCK_COUNTER[31:16];
					end else if(counter_c == 8'd7) begin
						fifodin <= DRS_CLOCK_COUNTER[15:0];
					end else begin
						fifodin <= 16'd0;
					end
					*/

				end

				4'd2: begin
					if(DRS_STATE_COM==4'd6) begin
						counter_state <= 4'd0;
					end

					counter_c <= 8'd0;
					fifodin <= 16'd0;
					fifowren <= 1'b0;

				end

				4'd3: begin
					//if(~fifoprogfull) begin //should be checked before accepting triggers
						counter_state <= 4'd1;
					//end
				end

			endcase

		end
	end

endmodule
