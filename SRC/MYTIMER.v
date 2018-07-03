//dragon_ver4_readout_board
//KONNO Yusuke
//Kyoto Univ.
//usec msec sec timer

module MYTIMER(
	rst,
	clk_66m,
	clk_133m,
	usec_66m,
	msec_66m,
	sec_66m,
	usec_133m,
	msec_133m,
	sec_133m
);

	input rst;
	input clk_66m;
	input clk_133m;
	output usec_66m;
	output msec_66m;
	output sec_66m;
	output usec_133m;
	output msec_133m;
	output sec_133m;

	reg[7:0] usec_c;
	reg[9:0] msec_c;
	reg[9:0] sec_c;

	assign usec_66m = (usec_c == 8'd65 ? 1'd1 : 1'd0);
	assign msec_66m = (msec_c == 10'd1000 ? 1'd1 : 1'd0);
	//assign msec_66m = (msec_c == 10'd10 ? 1'd1 : 1'd0);
	assign sec_66m = (sec_c == 10'd1000 ? 1'd1 : 1'd0);
	//assign sec_66m = (sec_c == 10'd10 ? 1'd1 : 1'd0);

	always@(posedge clk_66m or posedge rst) begin
		if(rst) begin
			usec_c <= 8'd0;
			msec_c <= 10'd0;
			sec_c <= 10'd0;
		end else begin
			if(usec_c == 8'd65) begin
				usec_c <= 8'd0;
			end else begin
				usec_c <= usec_c + 8'd1;
			end

			if(msec_c == 10'd1000) begin
			//if(msec_c == 10'd10) begin
				msec_c <= 10'd0;
			end else begin
				if(usec_c == 8'd64) begin
						msec_c <= msec_c + 10'd1;
				end
			end

			if(sec_c == 10'd1000) begin
			//if(sec_c == 10'd10) begin //check
				sec_c <= 10'd0;
			end else begin
				if(usec_c == 8'd64 && msec_c == 10'd999) begin
				//if(usec_c == 8'd64 && msec_c == 10'd9) begin
					sec_c <= sec_c + 10'd1;
				end
			end
		end
	end

	reg[1:0] usec_66m_check;
	reg[1:0] msec_66m_check;
	reg[1:0] sec_66m_check;

	assign usec_133m = {usec_66m_check[1] == 1'b0 && usec_66m_check[0] == 1'b1 ? 1'b1 : 1'b0};
	assign msec_133m = {msec_66m_check[1] == 1'b0 && msec_66m_check[0] == 1'b1 ? 1'b1 : 1'b0};
	assign sec_133m = {sec_66m_check[1] == 1'b0 && sec_66m_check[0] == 1'b1 ? 1'b1 : 1'b0};

	always@(posedge clk_133m or posedge rst) begin
		if(rst) begin
			usec_66m_check <= 2'd0;
			msec_66m_check <= 2'd0;
			sec_66m_check <= 2'd0;
		end else begin
			usec_66m_check[1:0] <= {usec_66m_check[0],usec_66m};
			msec_66m_check[1:0] <= {msec_66m_check[0],msec_66m};
			sec_66m_check[1:0] <= {sec_66m_check[0],sec_66m};
		end
	end

endmodule
