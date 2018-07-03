`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:56:00 08/24/2012
// Design Name:   dragonv3_main_12
// Module Name:   C:/Users/Konno/home/ise/project/dragon_v3/dragonv3_main_tb.v
// Project Name:  dragon_v3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: dragonv3_main_12
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

//`define ANALOG_TRIG
`define DIGITAL_TRIG

module dragonv3_main_tb;

	// Inputs
	reg OSC;
	reg [7:0] DIP_SWITCH;
	reg SCB_MDO;
`ifdef DIGITAL_TRIG
	reg [6:0] DIGITAL_TRIG_OUT_P;
	reg [6:0] DIGITAL_TRIG_OUT_N;
	reg DIGITAL_L1_IN;
`endif
`ifdef ANALOG_TRIG
	reg  L1_OUT_P;
	reg  L1_OUT_N;
	reg  L1_OUT2_P;
	reg  L1_OUT2_N;
	reg TRIGL1_P;
	reg TRIGL1_N;
`endif
	reg LED_FULL;
	reg LED_ACT;
	reg LED_10M;
	reg LED_100M;
	reg LED_1000M;
	reg ETH_TX_CLK;
	reg ETH_RX_CLK;
	reg ETH_MACCLK;
	reg ETH_RX_ER;
	reg ETH_RX_DV;
	reg [7:0] ETH_RX_D;
	reg ETH_CRS;
	reg ETH_COL;
	reg ETH_INTn;
	reg [7:0] DRS_WSROUT;
	reg [7:0] DRS_SROUT;
	reg [7:0] DRS_DTAP;
	reg [7:0] DRS_PLLLCK;
	reg AD9222_DCO_P;
	reg AD9222_DCO_N;
	reg AD9222_FCO_P;
	reg AD9222_FCO_N;
	reg [7:0] AD9222_OUT_P;
	reg [7:0] AD9222_OUT_N;
	reg EEPROM_DO;

	// Outputs
	wire [3:0] LED;
	wire SCB_MCSn;
	wire SCB_MDI;
	wire SCB_MSK;
	wire SCB_MEX;
	wire SCB_TP_TRIG_P;
`ifdef DIGITAL_TRIG
	wire L1_DAC_CS;
	wire L1_DAC_SDI;
	wire L1_DAC_CLK;
	wire [3:0] TRIG_EN;
	wire [6:0] TRIG_BPOUT_P;
	wire [6:0] TRIG_BPOUT_N;
`endif
`ifdef ANALOG_TRIG
	wire[7:0] L0_CTR;
	wire TRIG_A0;
	wire TRIG_A1;
	wire L1_DAC_CS;
	wire L1_DAC_SDI;
	wire L1_DAC_CLK;
	wire TRIG_BPOUT_P;
	wire TRIG_BPOUT_N;
`endif
	wire DAC_CS;
	wire DAC_SDI;
	wire DAC_SCK;
	wire DAC_LDACn;
	wire ETH_MDC;
	wire ETH_GTXCLK;
	wire [7:0] ETH_TX_D;
	wire ETH_TX_EN;
	wire ETH_TX_ER;
	wire ETH_RSTn;
	wire [7:0] DRS_REFCLK_P;
	wire [7:0] DRS_REFCLK_N;
	wire DRS_WSRIN;
	wire DRS_SRIN;
	wire DRS_SRCLK;
	wire [3:0] DRS_A;
	wire DRS_RSRLOAD;
	wire DRS_DENABLE;
	wire DRS_DWRITE;
	wire [7:0] DRS_RESETn;
	wire DRS_TAG_H_P;
	wire DRS_TAG_H_N;
	wire DRS_TAG_L_P;
	wire DRS_TAG_L_N;
	wire [7:0] DRS_CAL_P;
	wire [7:0] DRS_CAL_N;
	wire AD9222_CLK_P;
	wire AD9222_CLK_N;
	wire AD9222_CSBn;
	wire AD9222_SCLK;
	wire AD9222_SDIO_DIR;
	wire EEPROM_CS;
	wire EEPROM_SK;
	wire EEPROM_DI;

	// Bidirs
	wire ETH_MDIO;
	wire AD9222_SDIO;

	// Instantiate the Unit Under Test (UUT)
	dragonv3_main_11_6 uut (
		.OSC(OSC), 
		.DIP_SWITCH(DIP_SWITCH), 
		.LED(LED), 
		.SCB_MCSn(SCB_MCSn), 
		.SCB_MDI(SCB_MDI), 
		.SCB_MSK(SCB_MSK), 
		.SCB_MEX(SCB_MEX), 
		.SCB_MDO(SCB_MDO), 
		.SCB_TP_TRIG_P(SCB_TP_TRIG_P), 
`ifdef DIGITAL_TRIG
		.L1_DAC_CS(L1_DAC_CS), 
		.L1_DAC_SDI(L1_DAC_SDI), 
		.L1_DAC_CLK(L1_DAC_CLK), 
		.TRIG_EN(TRIG_EN), 
		.DIGITAL_TRIG_OUT_P(DIGITAL_TRIG_OUT_P), 
		.DIGITAL_TRIG_OUT_N(DIGITAL_TRIG_OUT_N), 
		.DIGITAL_L1_IN(DIGITAL_L1_IN), 
		.TRIG_BPOUT_P(TRIG_BPOUT_P), 
		.TRIG_BPOUT_N(TRIG_BPOUT_N), 
`endif
`ifdef ANALOG_TRIG
		.L0_CTR(L0_CTR), 
		.TRIG_A0(TRIG_A0), 
		.TRIG_A1(TRIG_A1), 
		.L1_OUT_P(L1_OUT_P), 
		.L1_OUT_N(L1_OUT_N), 
		.L1_OUT2_P(L1_OUT2_P), 
		.L1_OUT2_N(L1_OUT2_N), 
		.L1_DAC_CS(L1_DAC_CS), 
		.L1_DAC_SDI(L1_DAC_SDI), 
		.L1_DAC_CLK(L1_DAC_CLK), 
		.TRIG_BPOUT_P(TRIG_BPOUT_P), 
		.TRIG_BPOUT_N(TRIG_BPOUT_N), 
		.TRIGL1_P(TRIGL1_P), 
		.TRIGL1_N(TRIGL1_N), 
`endif
		.DAC_CS(DAC_CS), 
		.DAC_SDI(DAC_SDI), 
		.DAC_SCK(DAC_SCK), 
		.DAC_LDACn(DAC_LDACn), 
		.LED_FULL(LED_FULL), 
		.LED_ACT(LED_ACT), 
		.LED_10M(LED_10M), 
		.LED_100M(LED_100M), 
		.LED_1000M(LED_1000M), 
		.ETH_TX_CLK(ETH_TX_CLK), 
		.ETH_RX_CLK(ETH_RX_CLK), 
		.ETH_MACCLK(ETH_MACCLK), 
		.ETH_MDIO(ETH_MDIO), 
		.ETH_MDC(ETH_MDC), 
		.ETH_GTXCLK(ETH_GTXCLK), 
		.ETH_TX_D(ETH_TX_D), 
		.ETH_TX_EN(ETH_TX_EN), 
		.ETH_TX_ER(ETH_TX_ER), 
		.ETH_RSTn(ETH_RSTn), 
		.ETH_RX_ER(ETH_RX_ER), 
		.ETH_RX_DV(ETH_RX_DV), 
		.ETH_RX_D(ETH_RX_D), 
		.ETH_CRS(ETH_CRS), 
		.ETH_COL(ETH_COL), 
		.ETH_INTn(ETH_INTn), 
		.DRS_REFCLK_P(DRS_REFCLK_P), 
		.DRS_REFCLK_N(DRS_REFCLK_N), 
		.DRS_WSRIN(DRS_WSRIN), 
		.DRS_SRIN(DRS_SRIN), 
		.DRS_SRCLK(DRS_SRCLK), 
		.DRS_A(DRS_A), 
		.DRS_RSRLOAD(DRS_RSRLOAD), 
		.DRS_DENABLE(DRS_DENABLE), 
		.DRS_DWRITE(DRS_DWRITE), 
		.DRS_RESETn(DRS_RESETn), 
		.DRS_WSROUT(DRS_WSROUT), 
		.DRS_SROUT(DRS_SROUT), 
		.DRS_DTAP(DRS_DTAP), 
		.DRS_PLLLCK(DRS_PLLLCK),
		.DRS_TAG_H_P(DRS_TAG_H_P),
		.DRS_TAG_H_N(DRS_TAG_H_N),
		.DRS_TAG_L_P(DRS_TAG_L_P),
		.DRS_TAG_L_N(DRS_TAG_L_N),
		.DRS_CAL_P(DRS_CAL_P),
		.DRS_CAL_N(DRS_CAL_N),
		.AD9222_CLK_P(AD9222_CLK_P), 
		.AD9222_CLK_N(AD9222_CLK_N), 
		.AD9222_CSBn(AD9222_CSBn), 
		.AD9222_SCLK(AD9222_SCLK), 
		.AD9222_SDIO(AD9222_SDIO), 
		.AD9222_SDIO_DIR(AD9222_SDIO_DIR), 
		.AD9222_DCO_P(AD9222_DCO_P), 
		.AD9222_DCO_N(AD9222_DCO_N), 
		.AD9222_FCO_P(AD9222_FCO_P), 
		.AD9222_FCO_N(AD9222_FCO_N), 
		.AD9222_OUT_P(AD9222_OUT_P), 
		.AD9222_OUT_N(AD9222_OUT_N), 
		.EEPROM_CS(EEPROM_CS), 
		.EEPROM_SK(EEPROM_SK), 
		.EEPROM_DI(EEPROM_DI), 
		.EEPROM_DO(EEPROM_DO)
	);

	initial begin
		// Initialize Inputs
		DIP_SWITCH = 0;
		SCB_MDO = 0;
`ifdef DIGITAL_TRIG
		DIGITAL_L1_IN = 0;
`endif
`ifdef ANALOG_TRIG
		L1_OUT2_P = 0;
		L1_OUT2_N = 0;
		TRIGL1_P = 0;
		TRIGL1_N = 0;
`endif
		LED_FULL = 0;
		LED_ACT = 0;
		LED_10M = 0;
		LED_100M = 0;
		LED_1000M = 0;
		ETH_TX_CLK = 0;
		ETH_RX_CLK = 0;
		ETH_RX_ER = 0;
		ETH_RX_DV = 0;
		ETH_RX_D = 0;
		ETH_CRS = 0;
		ETH_COL = 0;
		ETH_INTn = 0;
		DRS_WSROUT = 0;
		DRS_DTAP = 0;
		DRS_PLLLCK = 0;
		AD9222_DCO_P = 0;
		AD9222_DCO_N = 0;
		AD9222_FCO_P = 0;
		AD9222_FCO_N = 0;
		AD9222_OUT_P = 0;
		AD9222_OUT_N = 8'b1111_1111;
		EEPROM_DO = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		DIP_SWITCH[7] = 1'b1;
		#100 DIP_SWITCH[7] = 1'b0;
		DRS_PLLLCK = 8'b1111_1111;
	end

`ifdef DIGITAL_TRIG
	always begin
		DIGITAL_TRIG_OUT_P = 0;
		DIGITAL_TRIG_OUT_N = 8'b1111_1111;
		#1000;
		DIGITAL_TRIG_OUT_P[0] = 1;
		DIGITAL_TRIG_OUT_N[0] = 0;
		#10;
	end
`endif
`ifdef ANALOG_TRIG
	always begin
		L1_OUT_P = 0;
		L1_OUT_N = 1;
		#1000;
		L1_OUT_P = 1;
		L1_OUT_N = 0;
		#10;
	end

`endif

	always begin
		OSC = 1'b0;
		#15 OSC = 1'b1;
		#15;
	end
	
	always begin
		ETH_MACCLK = 1'b0;
		#4 ETH_MACCLK = 1'b1;
		#4;
	end


	parameter[9:0] sim_stpcell0 = 10'd100;
	parameter[9:0] sim_stpcell1 = 10'd101;
	parameter[9:0] sim_stpcell2 = 10'd102;
	parameter[9:0] sim_stpcell3 = 10'd103;
	parameter[9:0] sim_stpcell4 = 10'd104;
	parameter[9:0] sim_stpcell5 = 10'd105;
	parameter[9:0] sim_stpcell6 = 10'd106;
	parameter[9:0] sim_stpcell7 = 10'd107;

	parameter[3:0] sim_stpch0 = 4'b0100;
	parameter[3:0] sim_stpch1 = 4'b0100;
	parameter[3:0] sim_stpch2 = 4'b0100;
	parameter[3:0] sim_stpch3 = 4'b0100;
	parameter[3:0] sim_stpch4 = 4'b0100;
	parameter[3:0] sim_stpch5 = 4'b0100;
	parameter[3:0] sim_stpch6 = 4'b0100;
	parameter[3:0] sim_stpch7 = 4'b0100;
	

	always@(posedge DRS_RSRLOAD) begin
		if(DRS_RSRLOAD) begin
			DRS_SROUT <= {sim_stpcell7[9],sim_stpcell6[9],sim_stpcell5[9],sim_stpcell4[9],sim_stpcell3[9],sim_stpcell2[9],sim_stpcell1[9],sim_stpcell0[9]};
			#46;
			DRS_SROUT <= {sim_stpcell7[8],sim_stpcell6[8],sim_stpcell5[8],sim_stpcell4[8],sim_stpcell3[8],sim_stpcell2[8],sim_stpcell1[8],sim_stpcell0[8]};
			#30;
			DRS_SROUT <= {sim_stpcell7[7],sim_stpcell6[7],sim_stpcell5[7],sim_stpcell4[7],sim_stpcell3[7],sim_stpcell2[7],sim_stpcell1[7],sim_stpcell0[7]};
			#30;
			DRS_SROUT <= {sim_stpcell7[6],sim_stpcell6[6],sim_stpcell5[6],sim_stpcell4[6],sim_stpcell3[6],sim_stpcell2[6],sim_stpcell1[6],sim_stpcell0[6]};
			#30;
			DRS_SROUT <= {sim_stpcell7[5],sim_stpcell6[5],sim_stpcell5[5],sim_stpcell4[5],sim_stpcell3[5],sim_stpcell2[5],sim_stpcell1[5],sim_stpcell0[5]};
			#30;
			DRS_SROUT <= {sim_stpcell7[4],sim_stpcell6[4],sim_stpcell5[4],sim_stpcell4[4],sim_stpcell3[4],sim_stpcell2[4],sim_stpcell1[4],sim_stpcell0[4]};
			#30;
			DRS_SROUT <= {sim_stpcell7[3],sim_stpcell6[3],sim_stpcell5[3],sim_stpcell4[3],sim_stpcell3[3],sim_stpcell2[3],sim_stpcell1[3],sim_stpcell0[3]};
			#30;
			DRS_SROUT <= {sim_stpcell7[2],sim_stpcell6[2],sim_stpcell5[2],sim_stpcell4[2],sim_stpcell3[2],sim_stpcell2[2],sim_stpcell1[2],sim_stpcell0[2]};
			#30;
			DRS_SROUT <= {sim_stpcell7[1],sim_stpcell6[1],sim_stpcell5[1],sim_stpcell4[1],sim_stpcell3[1],sim_stpcell2[1],sim_stpcell1[1],sim_stpcell0[1]};
			#30;
			DRS_SROUT <= {sim_stpcell7[0],sim_stpcell6[0],sim_stpcell5[0],sim_stpcell4[0],sim_stpcell3[0],sim_stpcell2[0],sim_stpcell1[0],sim_stpcell0[0]};
		end
	end
	always@(DRS_A) begin
		if(DRS_A == 4'b1101) begin
			#16;
			DRS_SROUT <= {sim_stpch7[3],sim_stpch6[3],sim_stpch5[3],sim_stpch4[3],sim_stpch3[3],sim_stpch2[3],sim_stpch1[3],sim_stpch0[3]};
			#30;
			DRS_SROUT <= {sim_stpch7[2],sim_stpch6[2],sim_stpch5[2],sim_stpch4[2],sim_stpch3[2],sim_stpch2[2],sim_stpch1[2],sim_stpch0[2]};
			#30;
			DRS_SROUT <= {sim_stpch7[1],sim_stpch6[1],sim_stpch5[1],sim_stpch4[1],sim_stpch3[1],sim_stpch2[1],sim_stpch1[1],sim_stpch0[1]};
			#30;
			DRS_SROUT <= {sim_stpch7[0],sim_stpch6[0],sim_stpch5[0],sim_stpch4[0],sim_stpch3[0],sim_stpch2[0],sim_stpch1[0],sim_stpch0[0]};
			#30;
			DRS_SROUT <= {sim_stpch7[3],sim_stpch6[3],sim_stpch5[3],sim_stpch4[3],sim_stpch3[3],sim_stpch2[3],sim_stpch1[3],sim_stpch0[3]};
			#30;
			DRS_SROUT <= {sim_stpch7[2],sim_stpch6[2],sim_stpch5[2],sim_stpch4[2],sim_stpch3[2],sim_stpch2[2],sim_stpch1[2],sim_stpch0[2]};
			#30;
			DRS_SROUT <= {sim_stpch7[1],sim_stpch6[1],sim_stpch5[1],sim_stpch4[1],sim_stpch3[1],sim_stpch2[1],sim_stpch1[1],sim_stpch0[1]};
			#30;
			DRS_SROUT <= {sim_stpch7[0],sim_stpch6[0],sim_stpch5[0],sim_stpch4[0],sim_stpch3[0],sim_stpch2[0],sim_stpch1[0],sim_stpch0[0]};
		end
	end
	
	always@(posedge AD9222_CLK_P) begin
		#2.3;
		AD9222_FCO_P = 1'b1;
		AD9222_FCO_N = 1'b0;
		#15;
		AD9222_FCO_P = 1'b0;
		AD9222_FCO_N = 1'b1;
	end

	reg[11:0] adc_dat0;
	reg[11:0] adc_dat1;
	reg[11:0] adc_dat2;
	reg[11:0] adc_dat3;
	reg[11:0] adc_dat4;
	reg[11:0] adc_dat5;
	reg[11:0] adc_dat6;
	reg[11:0] adc_dat7;

	always@(posedge AD9222_FCO_P or posedge DRS_RSRLOAD) begin
		if(DRS_RSRLOAD) begin
			adc_dat0 <= 12'd4087;
			adc_dat1 <= 12'd4087 + 12'd100;
			adc_dat2 <= 12'd4087 + 12'd200;
			adc_dat3 <= 12'd4087 + 12'd300;
			adc_dat4 <= 12'd4087 + 12'd400;
			adc_dat5 <= 12'd4087 + 12'd500;
			adc_dat6 <= 12'd4087 + 12'd600;
			adc_dat7 <= 12'd4087 + 12'd700;
		end else begin
			adc_dat0 <= adc_dat0 +12'd1;
			adc_dat1 <= adc_dat1 +12'd1;
			adc_dat2 <= adc_dat2 +12'd1;
			adc_dat3 <= adc_dat3 +12'd1;
			adc_dat4 <= adc_dat4 +12'd1;
			adc_dat5 <= adc_dat5 +12'd1;
			adc_dat6 <= adc_dat6 +12'd1;
			adc_dat7 <= adc_dat7 +12'd1;
		end
	end
/*
	always@(posedge AD9222_FCO_P) begin
		AD9222_OUT_P = ~8'd0;
		AD9222_OUT_N = 8'd0;
		#2.5;
		AD9222_OUT_P = ~8'd0;
		AD9222_OUT_N = 8'd0;
		#2.5;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#2.5;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#2.5;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#2.5;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#2.5;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#2.5;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#2.5;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#2.5;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#2.5;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#2.5;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#2.5;
	end
*/

	always@(posedge AD9222_FCO_P) begin
		AD9222_OUT_P = {adc_dat7[11],adc_dat6[11],adc_dat5[11],adc_dat4[11],adc_dat3[11],adc_dat2[11],adc_dat1[11],adc_dat0[11]};
		AD9222_OUT_N = ~{adc_dat7[11],adc_dat6[11],adc_dat5[11],adc_dat4[11],adc_dat3[11],adc_dat2[11],adc_dat1[11],adc_dat0[11]};
		#2.5;
		AD9222_OUT_P = {adc_dat7[10],adc_dat6[10],adc_dat5[10],adc_dat4[10],adc_dat3[10],adc_dat2[10],adc_dat1[10],adc_dat0[10]};
		AD9222_OUT_N = ~{adc_dat7[10],adc_dat6[10],adc_dat5[10],adc_dat4[10],adc_dat3[10],adc_dat2[10],adc_dat1[10],adc_dat0[10]};
		#2.5;
		AD9222_OUT_P = {adc_dat7[9],adc_dat6[9],adc_dat5[9],adc_dat4[9],adc_dat3[9],adc_dat2[9],adc_dat1[9],adc_dat0[9]};
		AD9222_OUT_N = ~{adc_dat7[9],adc_dat6[9],adc_dat5[9],adc_dat4[9],adc_dat3[9],adc_dat2[9],adc_dat1[9],adc_dat0[9]};
		#2.5;
		AD9222_OUT_P = {adc_dat7[8],adc_dat6[8],adc_dat5[8],adc_dat4[8],adc_dat3[8],adc_dat2[8],adc_dat1[8],adc_dat0[8]};
		AD9222_OUT_N = ~{adc_dat7[8],adc_dat6[8],adc_dat5[8],adc_dat4[8],adc_dat3[8],adc_dat2[8],adc_dat1[8],adc_dat0[8]};
		#2.5;
		AD9222_OUT_P = {adc_dat7[7],adc_dat6[7],adc_dat5[7],adc_dat4[7],adc_dat3[7],adc_dat2[7],adc_dat1[7],adc_dat0[7]};
		AD9222_OUT_N = ~{adc_dat7[7],adc_dat6[7],adc_dat5[7],adc_dat4[7],adc_dat3[7],adc_dat2[7],adc_dat1[7],adc_dat0[7]};
		#2.5;
		AD9222_OUT_P = {adc_dat7[6],adc_dat6[6],adc_dat5[6],adc_dat4[6],adc_dat3[6],adc_dat2[6],adc_dat1[6],adc_dat0[6]};
		AD9222_OUT_N = ~{adc_dat7[6],adc_dat6[6],adc_dat5[6],adc_dat4[6],adc_dat3[6],adc_dat2[6],adc_dat1[6],adc_dat0[6]};
		#2.5;
		AD9222_OUT_P = {adc_dat7[5],adc_dat6[5],adc_dat5[5],adc_dat4[5],adc_dat3[5],adc_dat2[5],adc_dat1[5],adc_dat0[5]};
		AD9222_OUT_N = ~{adc_dat7[5],adc_dat6[5],adc_dat5[5],adc_dat4[5],adc_dat3[5],adc_dat2[5],adc_dat1[5],adc_dat0[5]};
		#2.5;
		AD9222_OUT_P = {adc_dat7[4],adc_dat6[4],adc_dat5[4],adc_dat4[4],adc_dat3[4],adc_dat2[4],adc_dat1[4],adc_dat0[4]};
		AD9222_OUT_N = ~{adc_dat7[4],adc_dat6[4],adc_dat5[4],adc_dat4[4],adc_dat3[4],adc_dat2[4],adc_dat1[4],adc_dat0[4]};
		#2.5;
		AD9222_OUT_P = {adc_dat7[3],adc_dat6[3],adc_dat5[3],adc_dat4[3],adc_dat3[3],adc_dat2[3],adc_dat1[3],adc_dat0[3]};
		AD9222_OUT_N = ~{adc_dat7[3],adc_dat6[3],adc_dat5[3],adc_dat4[3],adc_dat3[3],adc_dat2[3],adc_dat1[3],adc_dat0[3]};
		#2.5;
		AD9222_OUT_P = {adc_dat7[2],adc_dat6[2],adc_dat5[2],adc_dat4[2],adc_dat3[2],adc_dat2[2],adc_dat1[2],adc_dat0[2]};
		AD9222_OUT_N = ~{adc_dat7[2],adc_dat6[2],adc_dat5[2],adc_dat4[2],adc_dat3[2],adc_dat2[2],adc_dat1[2],adc_dat0[2]};
		#2.5;
		AD9222_OUT_P = {adc_dat7[1],adc_dat6[1],adc_dat5[1],adc_dat4[1],adc_dat3[1],adc_dat2[1],adc_dat1[1],adc_dat0[1]};
		AD9222_OUT_N = ~{adc_dat7[1],adc_dat6[1],adc_dat5[1],adc_dat4[1],adc_dat3[1],adc_dat2[1],adc_dat1[1],adc_dat0[1]};
		#2.5;
		AD9222_OUT_P = {adc_dat7[0],adc_dat6[0],adc_dat5[0],adc_dat4[0],adc_dat3[0],adc_dat2[0],adc_dat1[0],adc_dat0[0]};
		AD9222_OUT_N = ~{adc_dat7[0],adc_dat6[0],adc_dat5[0],adc_dat4[0],adc_dat3[0],adc_dat2[0],adc_dat1[0],adc_dat0[0]};
	end

	always@(posedge AD9222_FCO_P) begin
		#1.25;
		AD9222_DCO_P = 1'b1;
		AD9222_DCO_N = 1'b0;
		#2.5;
		AD9222_DCO_P = 1'b0;
		AD9222_DCO_N = 1'b1;
		#2.5;
		AD9222_DCO_P = 1'b1;
		AD9222_DCO_N = 1'b0;
		#2.5;
		AD9222_DCO_P = 1'b0;
		AD9222_DCO_N = 1'b1;
		#2.5;
		AD9222_DCO_P = 1'b1;
		AD9222_DCO_N = 1'b0;
		#2.5;
		AD9222_DCO_P = 1'b0;
		AD9222_DCO_N = 1'b1;
		#2.5;
		AD9222_DCO_P = 1'b1;
		AD9222_DCO_N = 1'b0;
		#2.5;
		AD9222_DCO_P = 1'b0;
		AD9222_DCO_N = 1'b1;
		#2.5;
		AD9222_DCO_P = 1'b1;
		AD9222_DCO_N = 1'b0;
		#2.5;
		AD9222_DCO_P = 1'b0;
		AD9222_DCO_N = 1'b1;
		#2.5;
		AD9222_DCO_P = 1'b1;
		AD9222_DCO_N = 1'b0;
		#2.5;
		AD9222_DCO_P = 1'b0;
		AD9222_DCO_N = 1'b1;
	end
	/*
	parameter[9:0] STOP0 = 10'd1020;
	reg[9:0] stop;
	
	always@(RSRLO or posedge RSRLOAD or posedge DRS_A) begin
		if(RSRLOAD) begin
			stop <= STOP0;
		end else begin
			DRS_SROUT[0] <= stop[9];
			stop[9:0] <= {stop[8:0],1'b0};
		end
	end
     */ 
	  
	  
//SCB monitor function
	parameter[13:0] SCB_ADC_INIT = 14'd4000;
	reg[13:0] scb_adc_dat;
	reg[13:0] scb_adc_reg;
	reg[7:0] scb_adc_c;
	
	initial begin
		scb_adc_reg <= 14'd0;
		scb_adc_dat <= SCB_ADC_INIT;
		scb_adc_c <= 8'd0;
	end
	
	always@(negedge SCB_MEX or negedge SCB_MSK or posedge SCB_MEX) begin
		if(SCB_MEX == 1'b1) begin
			scb_adc_reg <= scb_adc_dat;
			scb_adc_c <= 8'd0;
		end else begin
			if(scb_adc_c == 8'd13) begin
				scb_adc_dat[13:0] <= scb_adc_dat + 14'd1;
			end
			scb_adc_reg[13:0] <= {scb_adc_reg[12:0],1'b0};
			SCB_MDO <= scb_adc_reg[13];
			scb_adc_c <= scb_adc_c + 8'd1;
		end
				
	end
	 
endmodule

