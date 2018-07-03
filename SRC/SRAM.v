//dragon readout for CTA
//SARAM module
//KONNO Yusuke
//Kyoto Univ.

module SRAM(
	input clk, //upto250MHz
	input rst,

	input command_sramwrite,
	input command_sramread,
	input[18:0] SRAM_ADDR,
	input[31:0] SRAM_WRITEDATA,
	input[3:0] SRAM_WRITEDATAP,
	input command_sramzz,
	output[31:0] SRAM_READDATA,
	output[3:0] SRAM_READDATAP,
	output sramwrite_finish,
	output sramread_finish,

	output[20:0] SRAM_A,
	output SRAM_MODE,
	output SRAM_ZZ,
	output SRAM_ADVn,
	output SRAM_ADSPn,
	output SRAM_ADSCn,
	output SRAM_OEn,
	output SRAM_BWEn,
	output SRAM_GWn,
	output SRAM_CLK,
	output[3:0] SRAM_BWn,
	output SRAM_CE3n,
	output SRAM_CE2,
	output SRAM_CE1n,
	inout[31:0] SRAM_DQ,
	inout[3:0] SRAM_DQP
);

	ODDR2 SRAM_CLK_ODDR (.Q(SRAM_CLK), .C0(clk), .C1(~clk), .CE(1'b1), .D0(1'b0), .D1(1'b1), .R(1'b0), .S(1'b0));

	reg[1:0] sramwrite_check;
	reg sramwrite_start;
	reg[1:0] sramread_check;
	reg sramread_start;
	reg[2:0] sramwrite_ir;
	reg[4:0] sramread_ir;

	reg rSRAM_ADSPn;
	assign SRAM_ADSPn = rSRAM_ADSPn;
	reg[20:0] rSRAM_A;
	assign SRAM_A = rSRAM_A;
	reg rSRAM_ZZ;
	assign SRAM_ZZ = rSRAM_ZZ;
	reg rSRAM_CE3n;
	assign SRAM_CE3n = rSRAM_CE3n;
	reg rSRAM_CE2;
	assign SRAM_CE2 = rSRAM_CE2;
	reg rSRAM_CE1n;
	assign SRAM_CE1n = rSRAM_CE1n;
	reg rSRAM_GWn;
	assign SRAM_GWn = rSRAM_GWn;
	reg rSRAM_OEn;
	assign SRAM_OEn = rSRAM_OEn; 

	reg[31:0] rSRAM_READDATA;
	assign SRAM_READDATA = rSRAM_READDATA;
	reg[3:0] rSRAM_READDATAP;
	assign SRAM_READDATAP = rSRAM_READDATAP;
	reg regsramwrite_finish;
	assign sramwrite_finish = regsramwrite_finish;
	reg regsramread_finish;
	assign sramread_finish = regsramread_finish;

	reg[31:0] sram_dq_reg;
	reg[3:0] sram_dqp_reg;

	assign SRAM_DQ[31:0] = (SRAM_OEn ? sram_dq_reg : 32'dz);
	assign SRAM_DQP[3:0] = (SRAM_OEn ? sram_dqp_reg : 4'dz);

	assign SRAM_MODE = 1'b0;
	assign SRAM_ADVn = 1'b1;
	assign SRAM_ADSCn = 1'b1;
	assign SRAM_BWEn = 1'b1;
	assign SRAM_BWn[3:0] = 4'b1111;

	always@(posedge clk) begin
		if(rst) begin
			sramwrite_check[1:0] <= 2'd0;
			sramwrite_start <= 1'b0;
			sramread_check[1:0] <= 2'd0;
			sramread_start <= 1'b0;
			sramwrite_ir <= 3'd0;
			sramread_ir <= 5'd0;
			rSRAM_ADSPn <= 1'b1;
			rSRAM_A[20:0] <= 21'd0;
			sram_dq_reg[31:0] <= 32'd0;
			sram_dqp_reg[3:0] <= 4'd0;
			rSRAM_CE3n <= 1'b1;
			rSRAM_CE2 <= 1'b0;
			rSRAM_CE1n <= 1'b1;
			rSRAM_GWn <= 1'b1;
			rSRAM_OEn <= 1'b1;
			rSRAM_READDATA[31:0] <= 32'd0;
			rSRAM_READDATAP[3:0] <= 4'd0;
			regsramwrite_finish <= 1'b0;
			regsramread_finish <= 1'b0;
		end else begin
			sramwrite_check[0] <= command_sramwrite;
			sramwrite_check[1] <= sramwrite_check[0];
			sramwrite_start <=  (~sramwrite_check[1] & sramwrite_check[0]);
			sramwrite_ir[2:0] <= {sramwrite_ir[1:0],sramwrite_start};
			sramread_check[0] <= command_sramread;
			sramread_check[1] <= sramread_check[0];
			sramread_start <=  (~sramread_check[1] & sramread_check[0]);
			sramread_ir[4:0] <= {sramread_ir[3:0],sramread_start};

			rSRAM_ADSPn <= ~(sramwrite_start | sramread_start);
			rSRAM_A[20:2] <= (sramwrite_start | sramread_start ? SRAM_ADDR[18:0] : 19'd0);
			rSRAM_CE3n <= ~(sramwrite_start | sramread_start);
			rSRAM_CE2 <= (sramwrite_start | sramread_start);
			rSRAM_CE1n <= ~(sramwrite_start | sramread_start);

			sram_dq_reg[31:0] <= (sramwrite_ir[0] ? SRAM_WRITEDATA[31:0] : 32'd0);
			sram_dqp_reg[3:0] <= (sramwrite_ir[0] ? SRAM_WRITEDATAP[3:0] : 4'd0);
			rSRAM_GWn <= ~sramwrite_ir[0];

			rSRAM_OEn <= ~(sramread_ir[1] | sramread_ir[0]);

			rSRAM_READDATA[31:0] <= (sramread_ir[2] ? SRAM_DQ[31:0] : rSRAM_READDATA[31:0]);
			rSRAM_READDATAP[3:0] <= (sramread_ir[2] ? SRAM_DQP[3:0] : rSRAM_READDATAP[3:0]);

			regsramwrite_finish <= (~regsramwrite_finish ? sramwrite_ir[2] : command_sramwrite);
			regsramread_finish <= (~regsramread_finish ? sramread_ir[4] : command_sramread);
		end
	end

	always@(posedge clk) begin
		rSRAM_ZZ <= command_sramzz;
	end
	
endmodule

