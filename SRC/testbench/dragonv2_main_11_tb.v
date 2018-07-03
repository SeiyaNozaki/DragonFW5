`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:39:40 07/22/2012
// Design Name:   dragonv2_main_11
// Module Name:   C:/Users/KONNO/home/ise/dragonv2/dragonv2_main_11_tb.v
// Project Name:  dragonv2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: dragonv2_main_11
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module dragonv3_main_tb;

	// Inputs
	reg OSC;
	reg [7:0] DIP_SWITCH;
	reg SCB_MDO;
	reg L1_OUT_P;
	reg L1_OUT_N;
	reg L1_OUT2_P;
	reg L1_OUT2_N;
	reg TRIGL1_P;
	reg TRIGL1_N;
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
	wire [1:0] LED;
	wire SCB_MCSn;
	wire SCB_MDI;
	wire SCB_MSK;
	wire SCB_MEX;
	wire SCB_TP_TRIG_P;
	wire [7:0] L0_CTR;
	wire TRIG_A0;
	wire TRIG_A1;
	wire L1_DAC_CS;
	wire L1_DAC_SDI;
	wire L1_DAC_CLK;
	wire TRIG_BPOUT_P;
	wire TRIG_BPOUT_N;
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
	wire [7:0] DRS_WSRIN;
	wire [7:0] DRS_SRIN;
	wire [7:0] DRS_SRCLK;
	wire [3:0] DRS_A0;
	wire [3:0] DRS_A1;
	wire [3:0] DRS_A2;
	wire [3:0] DRS_A3;
	wire [3:0] DRS_A4;
	wire [3:0] DRS_A5;
	wire [3:0] DRS_A6;
	wire [3:0] DRS_A7;
	wire [7:0] DRS_RSRLOAD;
	wire [7:0] DRS_DENABLE;
	wire [7:0] DRS_DWRITE;
	wire [7:0] DRS_RESETn;
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
	dragonv3_main_12 uut (
		.OSC(OSC), 
		.DIP_SWITCH(DIP_SWITCH), 
		.LED(LED), 
		.SCB_MCSn(SCB_MCSn), 
		.SCB_MDI(SCB_MDI), 
		.SCB_MSK(SCB_MSK), 
		.SCB_MEX(SCB_MEX), 
		.SCB_MDO(SCB_MDO), 
		.SCB_TP_TRIG_P(SCB_TP_TRIG_P), 
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
		.DRS_A0(DRS_A0), 
		.DRS_A1(DRS_A1), 
		.DRS_A2(DRS_A2), 
		.DRS_A3(DRS_A3), 
		.DRS_A4(DRS_A4), 
		.DRS_A5(DRS_A5), 
		.DRS_A6(DRS_A6), 
		.DRS_A7(DRS_A7), 
		.DRS_RSRLOAD(DRS_RSRLOAD), 
		.DRS_DENABLE(DRS_DENABLE), 
		.DRS_DWRITE(DRS_DWRITE), 
		.DRS_RESETn(DRS_RESETn), 
		.DRS_WSROUT(DRS_WSROUT), 
		.DRS_SROUT(DRS_SROUT), 
		.DRS_DTAP(DRS_DTAP), 
		.DRS_PLLLCK(DRS_PLLLCK), 
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
		//OSC = 0;
		DIP_SWITCH = 0;
		SCB_MDO = 0;
		L1_OUT_P = 0;
		L1_OUT_N = 0;
		L1_OUT2_P = 0;
		L1_OUT2_N = 0;
		TRIGL1_P = 0;
		TRIGL1_N = 0;
		LED_FULL = 0;
		LED_ACT = 0;
		LED_10M = 0;
		LED_100M = 0;
		LED_1000M = 0;
		ETH_TX_CLK = 0;
		ETH_RX_CLK = 0;
		//ETH_MACCLK = 0;
		ETH_RX_ER = 0;
		ETH_RX_DV = 0;
		ETH_RX_D = 0;
		ETH_CRS = 0;
		ETH_COL = 0;
		ETH_INTn = 0;
		DRS_WSROUT = 0;
		DRS_SROUT = 0;
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
		L1_OUT_P = 0;
		L1_OUT_N = 1;
		DRS_PLLLCK = 8'b1111_1111;
	end

	always begin
		OSC = 1'b0;
		#10 OSC = 1'b1;
		#10;
	end
	
	always begin
		ETH_MACCLK = 1'b0;
		#4 ETH_MACCLK = 1'b1;
		#4;
	end
	
	always@(posedge AD9222_CLK_P) begin
		#2.3;
		AD9222_FCO_P = 1'b1;
		AD9222_FCO_N = 1'b0;
		#20;
		AD9222_FCO_P = 1'b0;
		AD9222_FCO_N = 1'b1;
	end

	always@(posedge AD9222_FCO_P) begin
		AD9222_OUT_P = 8'b1111_1111;
		AD9222_OUT_N = 8'd0;
		#3.33;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#3.33;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#3.33;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#3.33;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#3.33;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#3.33;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#3.33;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#3.33;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#3.33;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#3.33;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#3.33;
		AD9222_OUT_P = 8'd0;
		AD9222_OUT_N = ~8'd0;
		#3.33;
	end
	
	always@(posedge AD9222_FCO_P) begin
		#1.66;
		AD9222_DCO_P = 1'b1;
		AD9222_DCO_N = 1'b0;
		#3.33;
		AD9222_DCO_P = 1'b0;
		AD9222_DCO_N = 1'b1;
		#3.33;
		AD9222_DCO_P = 1'b1;
		AD9222_DCO_N = 1'b0;
		#3.33;
		AD9222_DCO_P = 1'b0;
		AD9222_DCO_N = 1'b1;
		#3.33;
		AD9222_DCO_P = 1'b1;
		AD9222_DCO_N = 1'b0;
		#3.33;
		AD9222_DCO_P = 1'b0;
		AD9222_DCO_N = 1'b1;
		#3.33;
		AD9222_DCO_P = 1'b1;
		AD9222_DCO_N = 1'b0;
		#3.33;
		AD9222_DCO_P = 1'b0;
		AD9222_DCO_N = 1'b1;
		#3.33;
		AD9222_DCO_P = 1'b1;
		AD9222_DCO_N = 1'b0;
		#3.33;
		AD9222_DCO_P = 1'b0;
		AD9222_DCO_N = 1'b1;
		#3.33;
		AD9222_DCO_P = 1'b1;
		AD9222_DCO_N = 1'b0;
		#3.33;
		AD9222_DCO_P = 1'b0;
		AD9222_DCO_N = 1'b1;
	end
	
	
		
endmodule

