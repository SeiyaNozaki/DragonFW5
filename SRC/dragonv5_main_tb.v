
`timescale 1ns / 1ps


`define ANALOG_TRIG
//`define DIGITAL_TRIG
`define TESTBP

module dragonv5_main_tb;

//Inputs-------------------------------------
	reg OSC;
	reg [7:0] DIP_SWITCH;

	reg SCB_MDI;
	reg SCB_nIRQ;

`ifdef DIGITAL_TRIG
	reg L1_SC_DOUT;
	reg [6:0] DIGITAL_TRIG_OUT_P;
	reg [6:0] DIGITAL_TRIG_OUT_N;
	reg TRGL1_P;
	reg TRGL1_N;
`endif
`ifdef ANALOG_TRIG
	reg L0_CTR3;
	reg L1_OUT_P;
	reg L1_OUT_N;
	reg L1_OUT2_P;
	reg L1_OUT2_N;
	reg L1_SC_DOUT;
	reg TRGL1_P;
	reg TRGL1_N;

	reg [6:0] DIGITAL_TRIG_OUT_P;
	reg [6:0] DIGITAL_TRIG_OUT_N;

	reg FPGA_SLOW_CTRL3;
`endif
`ifdef TESTBP
	reg TESTBP_EXTTRG;
`endif

	reg LED_ACT;
	reg LED_10M;
	reg LED_100M;
	reg LED_1000M;
	
	reg ETH_TX_CLK;
	reg ETH_RX_CLK;
	reg ETH_RX_ER;
	reg ETH_RX_DV;
	reg [7:0] ETH_RX_D;
	reg ETH_CRS;
	reg ETH_COL;
	reg ETH_IRQ;

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

	reg SPI_MISO;

	reg BP_TIMEPPS_P;
	reg BP_TIMEPPS_N;
	reg BP_EXTCLK_P;
	reg BP_EXTCLK_N;

//Outputs----------------------------------------
	wire [3:0] LED;

	wire SCB_MDO;
	wire SCB_MCSn;
	wire SCB_MSK;
	wire SCB_TP_TRIG_P;
	wire SCB_TP_TRIG_N;
	wire SCB_MEX;
	wire SCB_nCFG;

`ifdef DIGITAL_TRIG
	wire L1_SC_EN;
	wire L1_SC_DIN;
	wire L1_SC_CLK;
	wire [6:0] TRIG_BPOUT_P;
	wire [6:0] TRIG_BPOUT_N;
`endif
`ifdef ANALOG_TRIG
	wire L0_CTR7;
	wire L0_CTR6;
	wire L0_CTR5;
	wire L0_CTR4;
	wire L0_CTR2;
	wire L0_CTR1;
	wire L0_CTR0;
	wire L1_SC_CLK;
	wire L1_SC_DIN;
	wire L1_SC_EN;
	wire L1_INIT_R;
	wire [1:0] AN_TRG_OUT_P;
	wire [1:0] AN_TRG_OUT_N;

	wire [6:0] TRIG_BPOUT_P;
	wire [6:0] TRIG_BPOUT_N;

	wire FPGA_SLOW_CTRL2;
	wire FPGA_SLOW_CTRL1;
	wire FPGA_SLOW_CTRL0;
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
	wire [7:0] DRS_SRCLK;
	wire [7:0] DRS_A0;
	wire [7:0] DRS_A1;
	wire [7:0] DRS_A2;
	wire [7:0] DRS_A3;
	
	wire [3:0] DRS_A = {DRS_A3[0],DRS_A2[0],DRS_A1[0],DRS_A0[0]};
	
	wire [7:0] DRS_RSRLOAD;
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

	wire SPI_SCK;
	wire SPI_MOSI;
	wire SPI_SS;
	wire SPI_PROGRAM_B;

	wire [20:0] SRAM_A;
	wire SRAM_MODE;
	wire SRAM_ZZ;
	wire SRAM_ADVn;
	wire SRAM_ADSPn;
	wire SRAM_ADSCn;
	wire SRAM_OEn;
	wire SRAM_BWEn;
	wire SRAM_GWn;
	wire SRAM_CLK;
	wire [3:0] SRAM_BWn;
	wire SRAM_CE3n;
	wire SRAM_CE2;
	wire SRAM_CE1n;

	wire BP_BUSY_P;
	wire BP_BUSY_N;
	wire BP_FPGA_PROGRAM;

//Bidirs------------------------------------------
	wire ETH_MDIO;

	wire AD9222_SDIO;

	wire [31:0] SRAM_DQ;
	wire [3:0] SRAM_DQP;


//Instantiate the Unit Under Test (UUT)-----------
	dragonv5_main uut (
		.OSC(OSC), 
		.DIP_SWITCH(DIP_SWITCH), 
		.LED(LED), 

		.SCB_MCSn(SCB_MCSn), 
		.SCB_MDI(SCB_MDI), 
		.SCB_MSK(SCB_MSK), 
		.SCB_MEX(SCB_MEX), 
		.SCB_MDO(SCB_MDO),
		.SCB_nCFG(SCB_nCFG),
		.SCB_nIRQ(SCB_nIRQ),
		.SCB_TP_TRIG_P(SCB_TP_TRIG_P), 
		.SCB_TP_TRIG_N(SCB_TP_TRIG_N), 

`ifdef DIGITAL_TRIG
		.L1_SC_EN(L1_SC_EN), 
		.L1_SC_DIN(L1_SC_DIN), 
		.L1_SC_CLK(L1_SC_CLK), 
		.L1_SC_DOUT(L1_SC_DOUT), 
		.DIGITAL_TRIG_OUT_P(DIGITAL_TRIG_OUT_P), 
		.DIGITAL_TRIG_OUT_N(DIGITAL_TRIG_OUT_N), 
		.TRGL1_P(TRGL1_P), 
		.TRGL1_N(TRGL1_N), 
		.TRIG_BPOUT_P(TRIG_BPOUT_P), 
		.TRIG_BPOUT_N(TRIG_BPOUT_N), 
`endif
`ifdef ANALOG_TRIG
		.L0_CTR7(L0_CTR7), 
		.L0_CTR6(L0_CTR6), 
		.L0_CTR5(L0_CTR5), 
		.L0_CTR4(L0_CTR4), 
		.L0_CTR3(L0_CTR3), 
		.L0_CTR2(L0_CTR2), 
		.L0_CTR1(L0_CTR1), 
		.L0_CTR0(L0_CTR0), 
		.L1_OUT_P(L1_OUT_P), 
		.L1_OUT_N(L1_OUT_N), 
		.L1_OUT2_P(L1_OUT2_P), 
		.L1_OUT2_N(L1_OUT2_N), 
		.L1_SC_EN(L1_SC_EN), 
		.L1_SC_DIN(L1_SC_DIN), 
		.L1_SC_CLK(L1_SC_CLK), 
		.L1_SC_DOUT(L1_SC_DOUT), 
		.L1_INIT_R(L1_INIT_R), 
		.AN_TRG_OUT_P(AN_TRG_OUT_P), 
		.AN_TRG_OUT_N(AN_TRG_OUT_N), 
		.TRGL1_P(TRGL1_P), 
		.TRGL1_N(TRGL1_N), 

		.TRIG_BPOUT_P(TRIG_BPOUT_P), 
		.TRIG_BPOUT_N(TRIG_BPOUT_N), 
		.DIGITAL_TRIG_OUT_P(DIGITAL_TRIG_OUT_P), 
		.DIGITAL_TRIG_OUT_N(DIGITAL_TRIG_OUT_N), 

		.FPGA_SLOW_CTRL3(FPGA_SLOW_CTRL3),
		.FPGA_SLOW_CTRL2(FPGA_SLOW_CTRL2),
		.FPGA_SLOW_CTRL1(FPGA_SLOW_CTRL1),
		.FPGA_SLOW_CTRL0(FPGA_SLOW_CTRL0),
`endif
`ifdef TESTBP
		.TESTBP_EXTTRG(TESTBP_EXTTRG),
`endif

		.DAC_CS(DAC_CS), 
		.DAC_SDI(DAC_SDI), 
		.DAC_SCK(DAC_SCK), 
		.DAC_LDACn(DAC_LDACn), 

		.LED_ACT(LED_ACT), 
		.LED_10M(LED_10M), 
		.LED_100M(LED_100M), 
		.LED_1000M(LED_1000M), 

		.ETH_TX_CLK(ETH_TX_CLK), 
		.ETH_RX_CLK(ETH_RX_CLK), 
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
		.ETH_IRQ(ETH_IRQ), 

		.DRS_REFCLK_P(DRS_REFCLK_P), 
		.DRS_REFCLK_N(DRS_REFCLK_N), 
		.DRS_WSRIN(DRS_WSRIN), 
		.DRS_SRIN(DRS_SRIN), 
		.DRS_SRCLK(DRS_SRCLK), 
		.DRS_A0(DRS_A0), 
		.DRS_A1(DRS_A1), 
		.DRS_A2(DRS_A2), 
		.DRS_A3(DRS_A3), 
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
		.EEPROM_DO(EEPROM_DO),

		.SPI_SCK(SPI_SCK),
		.SPI_MOSI(SPI_MOSI),
		.SPI_SS(SPI_SS),
		.SPI_MISO(SPI_MISO),
		.SPI_PROGRAM_B(SPI_PROGRAM_B),

		.SRAM_A(SRAM_A),
		.SRAM_MODE(SRAM_MODE),
		.SRAM_ZZ(SRAM_ZZ),
		.SRAM_ADVn(SRAM_ADVn),
		.SRAM_ADSPn(SRAM_ADSPn),
		.SRAM_ADSCn(SRAM_ADSCn),
		.SRAM_OEn(SRAM_OEn),
		.SRAM_BWEn(SRAM_BWEn),
		.SRAM_GWn(SRAM_GWn),
		.SRAM_CLK(SRAM_CLK),
		.SRAM_BWn(SRAM_BWn),
		.SRAM_DQ(SRAM_DQ),
		.SRAM_DQP(SRAM_DQP),
		.SRAM_CE3n(SRAM_CE3n),
		.SRAM_CE2(SRAM_CE2),
		.SRAM_CE1n(SRAM_CE1n),
		
		.BP_TIMEPPS_P(BP_TIMEPPS_P),
		.BP_TIMEPPS_N(BP_TIMEPPS_N),
		.BP_EXTCLK_P(BP_EXTCLK_P),
		.BP_EXTCLK_N(BP_EXTCLK_N),
		.BP_BUSY_P(BP_BUSY_P),
		.BP_BUSY_N(BP_BUSY_N),
		.BP_FPGA_PROGRAM(BP_FPGA_PROGRAM)
	);

//Simulation Input--------------------------------

//Initialize Inputs------------------------------
	initial begin
		DIP_SWITCH = 0;

		SCB_MDI = 0;
		SCB_nIRQ = 0;

`ifdef DIGITAL_TRIG
		L1_SC_DOUT = 0;
`endif
`ifdef ANALOG_TRIG
		L0_CTR3 = 0;
		L1_SC_DOUT = 0;
		FPGA_SLOW_CTRL3 = 0;
`endif
`ifdef TESTBP
		TESTBP_EXTTRG = 0;
`endif

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
		ETH_IRQ = 0;

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

		SPI_MISO = 0;

		// DRS
		DRS_PLLLCK = 8'b1111_1111;

		BP_TIMEPPS_P = 0;
		BP_TIMEPPS_N = 0;
		BP_EXTCLK_P = 0;
		BP_EXTCLK_N = 0;

		// Wait 100 ns for global reset to finish
		#100;
		DIP_SWITCH[7] = 1'b1; //reset
		#100;
		DIP_SWITCH[7] = 1'b0;

	end

//TRIGGER------------------------------------------

	always begin
		DIGITAL_TRIG_OUT_P = 7'h00;
		DIGITAL_TRIG_OUT_N = 7'h7F;
		#1000;
		DIGITAL_TRIG_OUT_P = 7'h7F;
		DIGITAL_TRIG_OUT_N = 7'h00;
		#10;
	end

`ifdef ANALOG_TRIG
	always begin
		L1_OUT_P = 0;
		L1_OUT_N = 1;
		L1_OUT2_P = 0;
		L1_OUT2_N = 1;
		TRGL1_P = 0;
		TRGL1_N = 1;
		
		#20000; //20 us
		
		L1_OUT_P = 1;
		L1_OUT_N = 0;
		L1_OUT2_P = 1;
		L1_OUT2_N = 0;
		TRGL1_P = 1;
		TRGL1_N = 0;
		
		#10;
		
		end
`endif
`ifdef TESTBP
	always begin
		TESTBP_EXTTRG = 0;
		#1000;
		TESTBP_EXTTRG = 1;
		#10;
	end
`endif

//OSC--------------------------------------------
	always begin
		OSC = 1'b0;
		#4 OSC = 1'b1;
		#4;
	end

	always begin
		#2.2
		BP_EXTCLK_P = 1'b0;
		BP_EXTCLK_N = 1'b1;
		#50;
		BP_EXTCLK_P = 1'b1;
		BP_EXTCLK_N = 1'b0;
		#47.8;
	end

	always begin
		#2.3
		BP_TIMEPPS_P = 1'b0;
		BP_TIMEPPS_N = 1'b1;
		#500;
		BP_TIMEPPS_P = 1'b1;
		BP_TIMEPPS_N = 1'b0;
		#497.7;
	end

//DRS--------------------------------------------	
	/*
	//parameter[9:0] sim_stpcell0 = 10'd100;
	parameter[9:0] sim_stpcell1 = 10'd101;
	parameter[9:0] sim_stpcell2 = 10'd102;
	parameter[9:0] sim_stpcell3 = 10'd103;
	parameter[9:0] sim_stpcell4 = 10'd104;
	parameter[9:0] sim_stpcell5 = 10'd105;
	parameter[9:0] sim_stpcell6 = 10'd106;
	parameter[9:0] sim_stpcell7 = 10'd107;
	*/
	parameter[9:0] sim_stpcell0 = 10'd1020;
	parameter[9:0] sim_stpcell1 = 10'd100;
	parameter[9:0] sim_stpcell2 = 10'd100;
	parameter[9:0] sim_stpcell3 = 10'd100;
	parameter[9:0] sim_stpcell4 = 10'd100;
	parameter[9:0] sim_stpcell5 = 10'd100;
	parameter[9:0] sim_stpcell6 = 10'd100;
	parameter[9:0] sim_stpcell7 = 10'd100;
/*
	reg[9:0] sim_stpcell0;
	reg[9:0] sim_stpcellbuf0_1;
	reg[9:0] sim_stpcellbuf0_2;
	reg[9:0] sim_stpcellbuf0_3;
	initial begin
		sim_stpcell0 <= 10'd0;
		sim_stpcellbuf0_1 <= 10'd100;
		sim_stpcellbuf0_2 <= 10'd800;
		sim_stpcellbuf0_3 <= 10'd1000;
		while(1) begin
			@({DRS_A3[0],DRS_A2[0],DRS_A1[0],DRS_A0[0]});
			if({DRS_A3[0],DRS_A2[0],DRS_A1[0],DRS_A0[0]}==4'b1101)begin
				sim_stpcell0 <= sim_stpcellbuf0_1;
				sim_stpcellbuf0_1 <= sim_stpcellbuf0_2;
				sim_stpcellbuf0_2 <= sim_stpcellbuf0_3;
				sim_stpcellbuf0_3 <= sim_stpcellbuf0_1;
			end
		end
	end
*/	

	parameter[3:0] sim_stpch0 = 4'b0100;
	parameter[3:0] sim_stpch1 = 4'b0100;
	parameter[3:0] sim_stpch2 = 4'b0100;
	parameter[3:0] sim_stpch3 = 4'b0100;
	parameter[3:0] sim_stpch4 = 4'b0100;
	parameter[3:0] sim_stpch5 = 4'b0100;
	parameter[3:0] sim_stpch6 = 4'b0100;
	parameter[3:0] sim_stpch7 = 4'b0100;

//stop cell
	always@(posedge DRS_RSRLOAD[0]) begin
		DRS_SROUT[7:0] <= {sim_stpcell7[9],sim_stpcell6[9],sim_stpcell5[9],sim_stpcell4[9],sim_stpcell3[9],sim_stpcell2[9],sim_stpcell1[9],sim_stpcell0[9]};
		@(negedge DRS_SRCLK[0]);
		DRS_SROUT[7:0] <= {sim_stpcell7[8],sim_stpcell6[8],sim_stpcell5[8],sim_stpcell4[8],sim_stpcell3[8],sim_stpcell2[8],sim_stpcell1[8],sim_stpcell0[8]};
		@(negedge DRS_SRCLK[0]);
		DRS_SROUT[7:0] <= {sim_stpcell7[7],sim_stpcell6[7],sim_stpcell5[7],sim_stpcell4[7],sim_stpcell3[7],sim_stpcell2[7],sim_stpcell1[7],sim_stpcell0[7]};
		@(negedge DRS_SRCLK[0]);
		DRS_SROUT[7:0] <= {sim_stpcell7[6],sim_stpcell6[6],sim_stpcell5[6],sim_stpcell4[6],sim_stpcell3[6],sim_stpcell2[6],sim_stpcell1[6],sim_stpcell0[6]};
		@(negedge DRS_SRCLK[0]);
		DRS_SROUT[7:0] <= {sim_stpcell7[5],sim_stpcell6[5],sim_stpcell5[5],sim_stpcell4[5],sim_stpcell3[5],sim_stpcell2[5],sim_stpcell1[5],sim_stpcell0[5]};
		@(negedge DRS_SRCLK[0]);
		DRS_SROUT[7:0] <= {sim_stpcell7[4],sim_stpcell6[4],sim_stpcell5[4],sim_stpcell4[4],sim_stpcell3[4],sim_stpcell2[4],sim_stpcell1[4],sim_stpcell0[4]};
		@(negedge DRS_SRCLK[0]);
		DRS_SROUT[7:0] <= {sim_stpcell7[3],sim_stpcell6[3],sim_stpcell5[3],sim_stpcell4[3],sim_stpcell3[3],sim_stpcell2[3],sim_stpcell1[3],sim_stpcell0[3]};
		@(negedge DRS_SRCLK[0]);
		DRS_SROUT[7:0] <= {sim_stpcell7[2],sim_stpcell6[2],sim_stpcell5[2],sim_stpcell4[2],sim_stpcell3[2],sim_stpcell2[2],sim_stpcell1[2],sim_stpcell0[2]};
		@(negedge DRS_SRCLK[0]);
		DRS_SROUT[7:0] <= {sim_stpcell7[1],sim_stpcell6[1],sim_stpcell5[1],sim_stpcell4[1],sim_stpcell3[1],sim_stpcell2[1],sim_stpcell1[1],sim_stpcell0[1]};
		@(negedge DRS_SRCLK[0]);
		DRS_SROUT[7:0] <= {sim_stpcell7[0],sim_stpcell6[0],sim_stpcell5[0],sim_stpcell4[0],sim_stpcell3[0],sim_stpcell2[0],sim_stpcell1[0],sim_stpcell0[0]};
	end

//stop channel
	/* //default
	always@({DRS_A0[0],DRS_A1[0],DRS_A2[0],DRS_A3[0]}) begin
		if({DRS_A3[0],DRS_A2[0],DRS_A1[0],DRS_A0[0]} == 4'b1101) begin
			DRS_SROUT[7:0] <= {sim_stpch7[3],sim_stpch6[3],sim_stpch5[3],sim_stpch4[3],sim_stpch3[3],sim_stpch2[3],sim_stpch1[3],sim_stpch0[3]};
			@(negedge DRS_SRCLK[0]);
			DRS_SROUT[7:0] <= {sim_stpch7[2],sim_stpch6[2],sim_stpch5[2],sim_stpch4[2],sim_stpch3[2],sim_stpch2[2],sim_stpch1[2],sim_stpch0[2]};
			@(negedge DRS_SRCLK[0]);
			DRS_SROUT[7:0] <= {sim_stpch7[1],sim_stpch6[1],sim_stpch5[1],sim_stpch4[1],sim_stpch3[1],sim_stpch2[1],sim_stpch1[1],sim_stpch0[1]};
			@(negedge DRS_SRCLK[0]);
			DRS_SROUT[7:0] <= {sim_stpch7[0],sim_stpch6[0],sim_stpch5[0],sim_stpch4[0],sim_stpch3[0],sim_stpch2[0],sim_stpch1[0],sim_stpch0[0]};
			@(negedge DRS_SRCLK[0]);
			DRS_SROUT[7:0] <= {sim_stpch7[3],sim_stpch6[3],sim_stpch5[3],sim_stpch4[3],sim_stpch3[3],sim_stpch2[3],sim_stpch1[3],sim_stpch0[3]};
			@(negedge DRS_SRCLK[0]);
			DRS_SROUT[7:0] <= {sim_stpch7[2],sim_stpch6[2],sim_stpch5[2],sim_stpch4[2],sim_stpch3[2],sim_stpch2[2],sim_stpch1[2],sim_stpch0[2]};
			@(negedge DRS_SRCLK[0]);
			DRS_SROUT[7:0] <= {sim_stpch7[1],sim_stpch6[1],sim_stpch5[1],sim_stpch4[1],sim_stpch3[1],sim_stpch2[1],sim_stpch1[1],sim_stpch0[1]};
			@(negedge DRS_SRCLK[0]);
			DRS_SROUT[7:0] <= {sim_stpch7[0],sim_stpch6[0],sim_stpch5[0],sim_stpch4[0],sim_stpch3[0],sim_stpch2[0],sim_stpch1[0],sim_stpch0[0]};
		end
	end
	*/	
	
	wire[3:0] wiresim_stpch0 = 4'b0100;
	wire[3:0] wiresim_stpch1 = 4'b0100;
	wire[3:0] wiresim_stpch2 = 4'b0100;
	wire[3:0] wiresim_stpch3 = 4'b0100;
	wire[3:0] wiresim_stpch4 = 4'b0100;
	wire[3:0] wiresim_stpch5 = 4'b0100;
	wire[3:0] wiresim_stpch6 = 4'b0100;
	wire[3:0] wiresim_stpch7 = 4'b0100;
	
	
	always@({DRS_A0[0],DRS_A1[0],DRS_A2[0],DRS_A3[0]}) begin
		if({DRS_A3[0],DRS_A2[0],DRS_A1[0],DRS_A0[0]} == 4'b1101) begin
			DRS_SROUT[7:0] <= {wiresim_stpch7[3],wiresim_stpch6[3],wiresim_stpch5[3],wiresim_stpch4[3],wiresim_stpch3[3],wiresim_stpch2[3],wiresim_stpch1[3],wiresim_stpch0[3]};
			@(negedge DRS_SRCLK[0]);
			DRS_SROUT[7:0] <= {wiresim_stpch7[2],wiresim_stpch6[2],wiresim_stpch5[2],wiresim_stpch4[2],wiresim_stpch3[2],wiresim_stpch2[2],wiresim_stpch1[2],wiresim_stpch0[2]};
			@(negedge DRS_SRCLK[0]);
			DRS_SROUT[7:0] <= {wiresim_stpch7[1],wiresim_stpch6[1],wiresim_stpch5[1],wiresim_stpch4[1],wiresim_stpch3[1],wiresim_stpch2[1],wiresim_stpch1[1],wiresim_stpch0[1]};
			@(negedge DRS_SRCLK[0]);
			DRS_SROUT[7:0] <= {wiresim_stpch7[0],wiresim_stpch6[0],wiresim_stpch5[0],wiresim_stpch4[0],wiresim_stpch3[0],wiresim_stpch2[0],wiresim_stpch1[0],wiresim_stpch0[0]};	
			@(negedge DRS_SRCLK[0]);
			DRS_SROUT[7:0] <= {wiresim_stpch7[3],wiresim_stpch6[3],wiresim_stpch5[3],wiresim_stpch4[3],wiresim_stpch3[3],wiresim_stpch2[3],wiresim_stpch1[3],wiresim_stpch0[3]};
			@(negedge DRS_SRCLK[0]);
			DRS_SROUT[7:0] <= {wiresim_stpch7[2],wiresim_stpch6[2],wiresim_stpch5[2],wiresim_stpch4[2],wiresim_stpch3[2],wiresim_stpch2[2],wiresim_stpch1[2],wiresim_stpch0[2]};
			@(negedge DRS_SRCLK[0]);
			DRS_SROUT[7:0] <= {wiresim_stpch7[1],wiresim_stpch6[1],wiresim_stpch5[1],wiresim_stpch4[1],wiresim_stpch3[1],wiresim_stpch2[1],wiresim_stpch1[1],wiresim_stpch0[1]};
			@(negedge DRS_SRCLK[0]);
			DRS_SROUT[7:0] <= {wiresim_stpch7[0],wiresim_stpch6[0],wiresim_stpch5[0],wiresim_stpch4[0],wiresim_stpch3[0],wiresim_stpch2[0],wiresim_stpch1[0],wiresim_stpch0[0]};	
			
		end
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

//DTAP

	always begin
		@(DRS_REFCLK_P);
		DRS_DTAP[7:0] = {8{DRS_REFCLK_P}} & {8{DRS_DENABLE}};
	end

	always begin
		@(DRS_REFCLK_P);
		DRS_WSROUT[7:0] = 0;
		@(DRS_REFCLK_P);
		DRS_WSROUT[7:0] = 0;
		@(DRS_REFCLK_P);
		DRS_WSROUT[7:0] = 0;
		@(DRS_REFCLK_P);
		DRS_WSROUT[7:0] = ~0;
	end
	  
//ADC------------------------------------------------	

	wire adc_pattern;
	assign adc_pattern = 0; //0:incremented by SRCLK, 1:xfff->x000->


//fco
	always@(AD9222_CLK_P) begin
		#2.3;
		AD9222_FCO_P = AD9222_CLK_P;
		AD9222_FCO_N = AD9222_CLK_N;
	end

//dco
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

//data
	reg[11:0] adc_dat0;
	reg[11:0] adc_dat1;
	reg[11:0] adc_dat2;
	reg[11:0] adc_dat3;
	reg[11:0] adc_dat4;
	reg[11:0] adc_dat5;
	reg[11:0] adc_dat6;
	reg[11:0] adc_dat7;

	reg[11:0] adc_datbuf0;
	reg[11:0] adc_datbuf1;
	reg[11:0] adc_datbuf2;
	reg[11:0] adc_datbuf3;
	reg[11:0] adc_datbuf4;
	reg[11:0] adc_datbuf5;
	reg[11:0] adc_datbuf6;
	reg[11:0] adc_datbuf7;

	reg[11:0] adc_datbuf0_1;
	reg[11:0] adc_datbuf0_2;
	reg[11:0] adc_datbuf0_3;
	reg[11:0] adc_datbuf0_4;
	reg[11:0] adc_datbuf0_5;
	reg[11:0] adc_datbuf0_6;
	reg[11:0] adc_datbuf0_7;
	reg[11:0] adc_datbuf0_8;
	reg[11:0] adc_datbuf0_9;
	reg[11:0] adc_datbuf0_10;
	reg[11:0] adc_datbuf0_11;
	reg[11:0] adc_datbuf0_12;
	reg[11:0] adc_datbuf0_13;
	reg[11:0] adc_datbuf0_14;
	reg[11:0] adc_datbuf0_15;
	reg[11:0] adc_datbuf0_16;
	reg[11:0] adc_datbuf0_17;

	reg[11:0] adc_datbuf1_1;
	reg[11:0] adc_datbuf1_2;
	reg[11:0] adc_datbuf1_3;
	reg[11:0] adc_datbuf1_4;
	reg[11:0] adc_datbuf1_5;
	reg[11:0] adc_datbuf1_6;
	reg[11:0] adc_datbuf1_7;
	reg[11:0] adc_datbuf1_8;
	reg[11:0] adc_datbuf1_9;
	reg[11:0] adc_datbuf1_10;
	reg[11:0] adc_datbuf1_11;
	reg[11:0] adc_datbuf1_12;
	reg[11:0] adc_datbuf1_13;
	reg[11:0] adc_datbuf1_14;
	reg[11:0] adc_datbuf1_15;
	reg[11:0] adc_datbuf1_16;
	reg[11:0] adc_datbuf1_17;

	reg[11:0] adc_datbuf2_1;
	reg[11:0] adc_datbuf2_2;
	reg[11:0] adc_datbuf2_3;
	reg[11:0] adc_datbuf2_4;
	reg[11:0] adc_datbuf2_5;
	reg[11:0] adc_datbuf2_6;
	reg[11:0] adc_datbuf2_7;
	reg[11:0] adc_datbuf2_8;
	reg[11:0] adc_datbuf2_9;
	reg[11:0] adc_datbuf2_10;
	reg[11:0] adc_datbuf2_11;
	reg[11:0] adc_datbuf2_12;
	reg[11:0] adc_datbuf2_13;
	reg[11:0] adc_datbuf2_14;
	reg[11:0] adc_datbuf2_15;
	reg[11:0] adc_datbuf2_16;
	reg[11:0] adc_datbuf2_17;

	reg[11:0] adc_datbuf3_1;
	reg[11:0] adc_datbuf3_2;
	reg[11:0] adc_datbuf3_3;
	reg[11:0] adc_datbuf3_4;
	reg[11:0] adc_datbuf3_5;
	reg[11:0] adc_datbuf3_6;
	reg[11:0] adc_datbuf3_7;
	reg[11:0] adc_datbuf3_8;
	reg[11:0] adc_datbuf3_9;
	reg[11:0] adc_datbuf3_10;
	reg[11:0] adc_datbuf3_11;
	reg[11:0] adc_datbuf3_12;
	reg[11:0] adc_datbuf3_13;
	reg[11:0] adc_datbuf3_14;
	reg[11:0] adc_datbuf3_15;
	reg[11:0] adc_datbuf3_16;
	reg[11:0] adc_datbuf3_17;

	reg[11:0] adc_datbuf4_1;
	reg[11:0] adc_datbuf4_2;
	reg[11:0] adc_datbuf4_3;
	reg[11:0] adc_datbuf4_4;
	reg[11:0] adc_datbuf4_5;
	reg[11:0] adc_datbuf4_6;
	reg[11:0] adc_datbuf4_7;
	reg[11:0] adc_datbuf4_8;
	reg[11:0] adc_datbuf4_9;
	reg[11:0] adc_datbuf4_10;
	reg[11:0] adc_datbuf4_11;
	reg[11:0] adc_datbuf4_12;
	reg[11:0] adc_datbuf4_13;
	reg[11:0] adc_datbuf4_14;
	reg[11:0] adc_datbuf4_15;
	reg[11:0] adc_datbuf4_16;
	reg[11:0] adc_datbuf4_17;

	reg[11:0] adc_datbuf5_1;
	reg[11:0] adc_datbuf5_2;
	reg[11:0] adc_datbuf5_3;
	reg[11:0] adc_datbuf5_4;
	reg[11:0] adc_datbuf5_5;
	reg[11:0] adc_datbuf5_6;
	reg[11:0] adc_datbuf5_7;
	reg[11:0] adc_datbuf5_8;
	reg[11:0] adc_datbuf5_9;
	reg[11:0] adc_datbuf5_10;
	reg[11:0] adc_datbuf5_11;
	reg[11:0] adc_datbuf5_12;
	reg[11:0] adc_datbuf5_13;
	reg[11:0] adc_datbuf5_14;
	reg[11:0] adc_datbuf5_15;
	reg[11:0] adc_datbuf5_16;
	reg[11:0] adc_datbuf5_17;

	reg[11:0] adc_datbuf6_1;
	reg[11:0] adc_datbuf6_2;
	reg[11:0] adc_datbuf6_3;
	reg[11:0] adc_datbuf6_4;
	reg[11:0] adc_datbuf6_5;
	reg[11:0] adc_datbuf6_6;
	reg[11:0] adc_datbuf6_7;
	reg[11:0] adc_datbuf6_8;
	reg[11:0] adc_datbuf6_9;
	reg[11:0] adc_datbuf6_10;
	reg[11:0] adc_datbuf6_11;
	reg[11:0] adc_datbuf6_12;
	reg[11:0] adc_datbuf6_13;
	reg[11:0] adc_datbuf6_14;
	reg[11:0] adc_datbuf6_15;
	reg[11:0] adc_datbuf6_16;
	reg[11:0] adc_datbuf6_17;

	reg[11:0] adc_datbuf7_1;
	reg[11:0] adc_datbuf7_2;
	reg[11:0] adc_datbuf7_3;
	reg[11:0] adc_datbuf7_4;
	reg[11:0] adc_datbuf7_5;
	reg[11:0] adc_datbuf7_6;
	reg[11:0] adc_datbuf7_7;
	reg[11:0] adc_datbuf7_8;
	reg[11:0] adc_datbuf7_9;
	reg[11:0] adc_datbuf7_10;
	reg[11:0] adc_datbuf7_11;
	reg[11:0] adc_datbuf7_12;
	reg[11:0] adc_datbuf7_13;
	reg[11:0] adc_datbuf7_14;
	reg[11:0] adc_datbuf7_15;
	reg[11:0] adc_datbuf7_16;
	reg[11:0] adc_datbuf7_17;

	initial begin
		adc_dat0 <= 12'd0;
		adc_dat1 <= 12'd0;
		adc_dat2 <= 12'd0;
		adc_dat3 <= 12'd0;
		adc_dat4 <= 12'd0;
		adc_dat5 <= 12'd0;
		adc_dat6 <= 12'd0;
		adc_dat7 <= 12'd0;
		while(1) begin
			@(posedge AD9222_FCO_P);
			adc_dat0 <= adc_datbuf0_17;
			adc_dat1 <= adc_datbuf1_17;
			adc_dat2 <= adc_datbuf2_17;
			adc_dat3 <= adc_datbuf3_17;
			adc_dat4 <= adc_datbuf4_17;
			adc_dat5 <= adc_datbuf5_17;
			adc_dat6 <= adc_datbuf6_17;
			adc_dat7 <= adc_datbuf7_17;

			adc_datbuf0_1 <= adc_datbuf0;
			adc_datbuf0_2 <= adc_datbuf0_1;
			adc_datbuf0_3 <= adc_datbuf0_2;
			adc_datbuf0_4 <= adc_datbuf0_3;
			adc_datbuf0_5 <= adc_datbuf0_4;
			adc_datbuf0_6 <= adc_datbuf0_5;
			adc_datbuf0_7 <= adc_datbuf0_6;
			adc_datbuf0_8 <= adc_datbuf0_7;
			adc_datbuf0_9 <= adc_datbuf0_8;
			adc_datbuf0_10 <= adc_datbuf0_9;
			adc_datbuf0_11 <= adc_datbuf0_10;
			adc_datbuf0_12 <= adc_datbuf0_11;
			adc_datbuf0_13 <= adc_datbuf0_12;
			adc_datbuf0_14 <= adc_datbuf0_13;
			adc_datbuf0_15 <= adc_datbuf0_14;
			adc_datbuf0_16 <= adc_datbuf0_15;
			adc_datbuf0_17 <= adc_datbuf0_16;

			adc_datbuf1_1 <= adc_datbuf1;
			adc_datbuf1_2 <= adc_datbuf1_1;
			adc_datbuf1_3 <= adc_datbuf1_2;
			adc_datbuf1_4 <= adc_datbuf1_3;
			adc_datbuf1_5 <= adc_datbuf1_4;
			adc_datbuf1_6 <= adc_datbuf1_5;
			adc_datbuf1_7 <= adc_datbuf1_6;
			adc_datbuf1_8 <= adc_datbuf1_7;
			adc_datbuf1_9 <= adc_datbuf1_8;
			adc_datbuf1_10 <= adc_datbuf1_9;
			adc_datbuf1_11 <= adc_datbuf1_10;
			adc_datbuf1_12 <= adc_datbuf1_11;
			adc_datbuf1_13 <= adc_datbuf1_12;
			adc_datbuf1_14 <= adc_datbuf1_13;
			adc_datbuf1_15 <= adc_datbuf1_14;
			adc_datbuf1_16 <= adc_datbuf1_15;
			adc_datbuf1_17 <= adc_datbuf1_16;

			adc_datbuf2_1 <= adc_datbuf2;
			adc_datbuf2_2 <= adc_datbuf2_1;
			adc_datbuf2_3 <= adc_datbuf2_2;
			adc_datbuf2_4 <= adc_datbuf2_3;
			adc_datbuf2_5 <= adc_datbuf2_4;
			adc_datbuf2_6 <= adc_datbuf2_5;
			adc_datbuf2_7 <= adc_datbuf2_6;
			adc_datbuf2_8 <= adc_datbuf2_7;
			adc_datbuf2_9 <= adc_datbuf2_8;
			adc_datbuf2_10 <= adc_datbuf2_9;
			adc_datbuf2_11 <= adc_datbuf2_10;
			adc_datbuf2_12 <= adc_datbuf2_11;
			adc_datbuf2_13 <= adc_datbuf2_12;
			adc_datbuf2_14 <= adc_datbuf2_13;
			adc_datbuf2_15 <= adc_datbuf2_14;
			adc_datbuf2_16 <= adc_datbuf2_15;
			adc_datbuf2_17 <= adc_datbuf2_16;

			adc_datbuf3_1 <= adc_datbuf3;
			adc_datbuf3_2 <= adc_datbuf3_1;
			adc_datbuf3_3 <= adc_datbuf3_2;
			adc_datbuf3_4 <= adc_datbuf3_3;
			adc_datbuf3_5 <= adc_datbuf3_4;
			adc_datbuf3_6 <= adc_datbuf3_5;
			adc_datbuf3_7 <= adc_datbuf3_6;
			adc_datbuf3_8 <= adc_datbuf3_7;
			adc_datbuf3_9 <= adc_datbuf3_8;
			adc_datbuf3_10 <= adc_datbuf3_9;
			adc_datbuf3_11 <= adc_datbuf3_10;
			adc_datbuf3_12 <= adc_datbuf3_11;
			adc_datbuf3_13 <= adc_datbuf3_12;
			adc_datbuf3_14 <= adc_datbuf3_13;
			adc_datbuf3_15 <= adc_datbuf3_14;
			adc_datbuf3_16 <= adc_datbuf3_15;
			adc_datbuf3_17 <= adc_datbuf3_16;

			adc_datbuf4_1 <= adc_datbuf4;
			adc_datbuf4_2 <= adc_datbuf4_1;
			adc_datbuf4_3 <= adc_datbuf4_2;
			adc_datbuf4_4 <= adc_datbuf4_3;
			adc_datbuf4_5 <= adc_datbuf4_4;
			adc_datbuf4_6 <= adc_datbuf4_5;
			adc_datbuf4_7 <= adc_datbuf4_6;
			adc_datbuf4_8 <= adc_datbuf4_7;
			adc_datbuf4_9 <= adc_datbuf4_8;
			adc_datbuf4_10 <= adc_datbuf4_9;
			adc_datbuf4_11 <= adc_datbuf4_10;
			adc_datbuf4_12 <= adc_datbuf4_11;
			adc_datbuf4_13 <= adc_datbuf4_12;
			adc_datbuf4_14 <= adc_datbuf4_13;
			adc_datbuf4_15 <= adc_datbuf4_14;
			adc_datbuf4_16 <= adc_datbuf4_15;
			adc_datbuf4_17 <= adc_datbuf4_16;

			adc_datbuf5_1 <= adc_datbuf5;
			adc_datbuf5_2 <= adc_datbuf5_1;
			adc_datbuf5_3 <= adc_datbuf5_2;
			adc_datbuf5_4 <= adc_datbuf5_3;
			adc_datbuf5_5 <= adc_datbuf5_4;
			adc_datbuf5_6 <= adc_datbuf5_5;
			adc_datbuf5_7 <= adc_datbuf5_6;
			adc_datbuf5_8 <= adc_datbuf5_7;
			adc_datbuf5_9 <= adc_datbuf5_8;
			adc_datbuf5_10 <= adc_datbuf5_9;
			adc_datbuf5_11 <= adc_datbuf5_10;
			adc_datbuf5_12 <= adc_datbuf5_11;
			adc_datbuf5_13 <= adc_datbuf5_12;
			adc_datbuf5_14 <= adc_datbuf5_13;
			adc_datbuf5_15 <= adc_datbuf5_14;
			adc_datbuf5_16 <= adc_datbuf5_15;
			adc_datbuf5_17 <= adc_datbuf5_16;

			adc_datbuf6_1 <= adc_datbuf6;
			adc_datbuf6_2 <= adc_datbuf6_1;
			adc_datbuf6_3 <= adc_datbuf6_2;
			adc_datbuf6_4 <= adc_datbuf6_3;
			adc_datbuf6_5 <= adc_datbuf6_4;
			adc_datbuf6_6 <= adc_datbuf6_5;
			adc_datbuf6_7 <= adc_datbuf6_6;
			adc_datbuf6_8 <= adc_datbuf6_7;
			adc_datbuf6_9 <= adc_datbuf6_8;
			adc_datbuf6_10 <= adc_datbuf6_9;
			adc_datbuf6_11 <= adc_datbuf6_10;
			adc_datbuf6_12 <= adc_datbuf6_11;
			adc_datbuf6_13 <= adc_datbuf6_12;
			adc_datbuf6_14 <= adc_datbuf6_13;
			adc_datbuf6_15 <= adc_datbuf6_14;
			adc_datbuf6_16 <= adc_datbuf6_15;
			adc_datbuf6_17 <= adc_datbuf6_16;

			adc_datbuf7_1 <= adc_datbuf7;
			adc_datbuf7_2 <= adc_datbuf7_1;
			adc_datbuf7_3 <= adc_datbuf7_2;
			adc_datbuf7_4 <= adc_datbuf7_3;
			adc_datbuf7_5 <= adc_datbuf7_4;
			adc_datbuf7_6 <= adc_datbuf7_5;
			adc_datbuf7_7 <= adc_datbuf7_6;
			adc_datbuf7_8 <= adc_datbuf7_7;
			adc_datbuf7_9 <= adc_datbuf7_8;
			adc_datbuf7_10 <= adc_datbuf7_9;
			adc_datbuf7_11 <= adc_datbuf7_10;
			adc_datbuf7_12 <= adc_datbuf7_11;
			adc_datbuf7_13 <= adc_datbuf7_12;
			adc_datbuf7_14 <= adc_datbuf7_13;
			adc_datbuf7_15 <= adc_datbuf7_14;
			adc_datbuf7_16 <= adc_datbuf7_15;
			adc_datbuf7_17 <= adc_datbuf7_16;

		end
	end

	initial begin
		adc_datbuf0 <= 12'd0;
		while(1) begin
			if(adc_pattern==0) begin
				@(posedge DRS_RSRLOAD[0] or posedge DRS_SRCLK[0]);
				if(DRS_RSRLOAD[0]) begin // 1 ga window no saisho dayo :)
					adc_datbuf0 <= 12'd1;
				end else if(DRS_SRCLK[0]) begin
					adc_datbuf0 <= adc_datbuf0 + 12'd1;
				end
			end else if(adc_pattern==1) begin
				@(posedge AD9222_FCO_P);
				adc_datbuf0 <= 12'hFFF;
				@(posedge AD9222_FCO_P);
				adc_datbuf0 <= 12'h000;
			end
		end
	end

	initial begin
		adc_datbuf1 <= 12'd0;
		while(1) begin
			if(adc_pattern==0) begin
				@(posedge DRS_RSRLOAD[1] or posedge DRS_SRCLK[1]);
				if(DRS_RSRLOAD[1]) begin // 1 ga window no saisho dayo :)
					adc_datbuf1 <= 12'd1 + 12'h100;
				end else if(DRS_SRCLK[1]) begin
					adc_datbuf1 <= adc_datbuf1 + 12'd1;
				end
			end else if(adc_pattern==1) begin
				@(posedge AD9222_FCO_P);
				adc_datbuf1 <= 12'hFFF;
				@(posedge AD9222_FCO_P);
				adc_datbuf1 <= 12'h000;
			end
		end
	end

	initial begin
		adc_datbuf2 <= 12'd0;
		while(1) begin
			if(adc_pattern==0) begin
				@(posedge DRS_RSRLOAD[2] or posedge DRS_SRCLK[2]);
				if(DRS_RSRLOAD[2]) begin // 1 ga window no saisho dayo :)
					adc_datbuf2 <= 12'd1 + 12'h200;
				end else if(DRS_SRCLK[2]) begin
					adc_datbuf2 <= adc_datbuf2 + 12'd1;
				end
			end else if(adc_pattern==1) begin
				@(posedge AD9222_FCO_P);
				adc_datbuf2 <= 12'hFFF;
				@(posedge AD9222_FCO_P);
				adc_datbuf2 <= 12'h000;
			end
		end
	end

	initial begin
		adc_datbuf3 <= 12'd0;
		while(1) begin
			if(adc_pattern==0) begin
				@(posedge DRS_RSRLOAD[3] or posedge DRS_SRCLK[3]);
				if(DRS_RSRLOAD[3]) begin // 1 ga window no saisho dayo :)
					adc_datbuf3 <= 12'd1 + 12'h300;
				end else if(DRS_SRCLK[3]) begin
					adc_datbuf3 <= adc_datbuf3 + 12'd1;
				end
			end else if(adc_pattern==1) begin
				@(posedge AD9222_FCO_P);
				adc_datbuf3 <= 12'hFFF;
				@(posedge AD9222_FCO_P);
				adc_datbuf3 <= 12'h000;
			end
		end
	end

	initial begin
		adc_datbuf4 <= 12'd0;
		while(1) begin
			if(adc_pattern==0) begin
				@(posedge DRS_RSRLOAD[4] or posedge DRS_SRCLK[4]);
				if(DRS_RSRLOAD[4]) begin // 1 ga window no saisho dayo :)
					adc_datbuf4 <= 12'd1 + 12'h400;
				end else if(DRS_SRCLK[4]) begin
					adc_datbuf4 <= adc_datbuf4 + 12'd1;
				end
			end else if(adc_pattern==1) begin
				@(posedge AD9222_FCO_P);
				adc_datbuf4 <= 12'hFFF;
				@(posedge AD9222_FCO_P);
				adc_datbuf4 <= 12'h000;
			end
		end
	end

	initial begin
		adc_datbuf5 <= 12'd0;
		while(1) begin
			if(adc_pattern==0) begin
				@(posedge DRS_RSRLOAD[5] or posedge DRS_SRCLK[5]);
				if(DRS_RSRLOAD[5]) begin // 1 ga window no saisho dayo :)
					adc_datbuf5 <= 12'd1 + 12'h500;
				end else if(DRS_SRCLK[5]) begin
					adc_datbuf5 <= adc_datbuf5 + 12'd1;
				end
			end else if(adc_pattern==1) begin
				@(posedge AD9222_FCO_P);
				adc_datbuf5 <= 12'hFFF;
				@(posedge AD9222_FCO_P);
				adc_datbuf5 <= 12'h000;
			end
		end
	end

	initial begin
		adc_datbuf6 <= 12'd0;
		while(1) begin
			if(adc_pattern==0) begin
				@(posedge DRS_RSRLOAD[6] or posedge DRS_SRCLK[6]);
				if(DRS_RSRLOAD[6]) begin // 1 ga window no saisho dayo :)
					adc_datbuf6 <= 12'd1 + 12'h600;
				end else if(DRS_SRCLK[6]) begin
					adc_datbuf6 <= adc_datbuf6 + 12'd1;
				end
			end else if(adc_pattern==1) begin
				@(posedge AD9222_FCO_P);
				adc_datbuf6 <= 12'hFFF;
				@(posedge AD9222_FCO_P);
				adc_datbuf6 <= 12'h000;
			end
		end
	end

	initial begin
		adc_datbuf7 <= 12'd0;
		while(1) begin
			if(adc_pattern==0) begin
				@(posedge DRS_RSRLOAD[7] or posedge DRS_SRCLK[7]);
				if(DRS_RSRLOAD[7]) begin // 1 ga window no saisho dayo :)
					adc_datbuf7 <= 12'd1 + 12'h700;
				end else if(DRS_SRCLK[7]) begin
					adc_datbuf7 <= adc_datbuf7 + 12'd1;
				end
			end else if(adc_pattern==1) begin
				@(posedge AD9222_FCO_P);
				adc_datbuf7 <= 12'hFFF;
				@(posedge AD9222_FCO_P);
				adc_datbuf7 <= 12'h000;
			end
		end
	end


	always@(posedge AD9222_FCO_P) begin
		#0.5
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

	reg[127:0] tcp_data_stored;
	reg[127:0] tcp_data_buf;
	reg[7:0] tcp_data_c;
	initial begin
		tcp_data_stored = 128'd0;
		tcp_data_buf = 128'd0;
		tcp_data_c = 8'd0;
	end
	always@(posedge uut.SiTCP.CLK) begin
		//if(uut.TCP_TX_WR & ~uut.TCP_TX_FULL) begin
		if(uut.TCP_TX_WR) begin
			tcp_data_buf[127:0] <= {tcp_data_buf[119:0],uut.TCP_TX_DATA[7:0]};

			if(tcp_data_c == 8'd0) begin
				tcp_data_stored[127:0] <= tcp_data_buf[127:0];
			end

			if(tcp_data_c == 8'd15) begin
				tcp_data_c <= 8'd0;
			end else begin
				tcp_data_c <= tcp_data_c + 8'd1;
			end
		end
	end

//SCB monitor function----------------------------
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
			SCB_MDI <= scb_adc_reg[13];
			scb_adc_c <= scb_adc_c + 8'd1;
		end
	end
	
//SLOW CONTROL - force internal signal

	parameter[12:0] simREADDEPTH=13'd30;
	//parameter[12:0] simREADDEPTH=13'd1000;

//TCP
	initial begin
		#1000;
		force uut.TCP_OPEN = 1'b1;
		force uut.SiTCP_RST = 1'b0;
		//force uut.TCP_TX_FULL = 1'b0;
		//#1010;
		//force uut.TCP_OPEN = 1'b0;
		//force uut.SiTCP_RST = 1'b1;
	end

//FIFOs
	wire sfifo_rst;
	wire sfifo_progfull;
	wire sfifo_wrclk;
	wire sfifo_wren;
	wire sfifo_rdclk;
	wire sfifo_rden;
	wire[7:0] sfifo_din;
	wire[7:0] sfifo_dout;
	wire cfifo_rst;
	wire cfifo_progfull;
	wire cfifo_wrclk;
	wire cfifo_wren;
	wire cfifo_rdclk;
	wire cfifo_rden;
	wire[15:0] cfifo_din;
	wire[7:0] cfifo_dout;
	wire[7:0] dfifo_rst;
	wire[7:0] dfifo_progfull;
	wire[7:0] dfifo_wrclk;
	wire[7:0] dfifo_wren;
	wire[7:0] dfifo_rdclk;
	wire[7:0] dfifo_rden;
	//wire[7:0][15:0] dfifo_din;
	//wire[7:0][7:0] dfifo_dout;
	assign sfifo_rst=uut.data_formatter.format_fifo.rst;
	assign sfifo_progfull=uut.data_formatter.format_fifo.prog_full;
	assign sfifo_wrclk=uut.data_formatter.format_fifo.wr_clk;
	assign sfifo_wren=uut.data_formatter.format_fifo.wr_en;
	assign sfifo_rdclk=uut.data_formatter.format_fifo.rd_clk;
	assign sfifo_rden=uut.data_formatter.format_fifo.rd_en;
	assign sfifo_din=uut.data_formatter.format_fifo.din;
	assign sfifo_dout=uut.data_formatter.format_fifo.dout;
	assign cfifo_rst=uut.counter_read.counter_fifo.rst;
	assign cfifo_progfull=uut.counter_read.counter_fifo.prog_full;
	assign cfifo_wrclk=uut.counter_read.counter_fifo.wr_clk;
	assign cfifo_wren=uut.counter_read.counter_fifo.wr_en;
	assign cfifo_rdclk=uut.counter_read.counter_fifo.rd_clk;
	assign cfifo_rden=uut.counter_read.counter_fifo.rd_en;
	assign cfifo_din=uut.counter_read.counter_fifo.din;
	assign cfifo_dout=uut.counter_read.counter_fifo.dout;
	generate
		genvar i;
		for(i=0;i<8;i=i+1) begin: MONIDFIFO_GEN
			assign dfifo_rst[i]=uut.DRS_READ_GEN[i].drs_read_i.drs_fifo.rst;
			assign dfifo_progfull[i]=uut.DRS_READ_GEN[i].drs_read_i.drs_fifo.prog_full;
			assign dfifo_wrclk[i]=uut.DRS_READ_GEN[i].drs_read_i.drs_fifo.wr_clk;
			assign dfifo_wren[i]=uut.DRS_READ_GEN[i].drs_read_i.drs_fifo.wr_en;
			assign dfifo_rdclk[i]=uut.DRS_READ_GEN[i].drs_read_i.drs_fifo.rd_clk;
			assign dfifo_rden[i]=uut.DRS_READ_GEN[i].drs_read_i.drs_fifo.rd_en;
			/*
			assign dfifo_din=uut..din;
			assign dfifo_dout=uut..dout;
			*/
		end
	endgenerate

	initial begin
		force uut.TCP_TX_FULL = 1'b0;
		#10000;
		force uut.TCP_TX_FULL = 1'b1;
		#1000;
		//@(posedge uut.data_formatter.sfifo_progfull);
		@(posedge uut.data_formatter.sfifo_progfull & ( (|(uut.dfifo_progfull[7:0])) | uut.counter_read.fifoprogfull) );
		#10000;
		force uut.TCP_TX_FULL = 1'b0;
		/*
		while(1) begin
			repeat(20) @(posedge uut.clk_133m);
			#0.5;
			force uut.TCP_TX_FULL = 1'b0;
			repeat(10) @(posedge uut.clk_133m);
			#0.5;
			force uut.TCP_TX_FULL = 1'b1;
		end
		*/
	end

	reg[15:0] simDataCheck_c;
	reg simDataKugiri;
	reg simDataKugiri2;
	reg simDataError;
	reg[15:0] simDataBuf;
	reg[15:0] simDataCmp;
	reg[15:0] simDataCmpBuf;
	parameter[15:0] simEventLen = 16*2*{3'd0,simREADDEPTH}+16+16+16;

	initial begin
		simDataCheck_c = 16'd0;
		simDataKugiri = 1'b0;
		simDataKugiri2 = 1'b0;
		simDataError = 1'b0;
		simDataBuf = 16'd0;
		simDataCmp = 16'd0;
		simDataCmpBuf = 16'd0;
		while(1) begin
			@(posedge uut.data_formatter.SFIFO_RDCLK);
			if(uut.data_formatter.SFIFO_VALID) begin
				if(simDataCheck_c == simEventLen - 16'd1) begin
					simDataCheck_c = 16'd0;
					simDataKugiri = 1'b1;
				end else begin
					simDataCheck_c = simDataCheck_c + 16'd1;
					simDataKugiri = 1'b0;
				end

				if(simDataCheck_c == simEventLen - 16'd1 - 16*simREADDEPTH) begin
					simDataKugiri2 = 1'b1;
				end else begin
					simDataKugiri2 = 1'b0;
				end

				if(simDataCheck_c>=16+16+16 && simDataCheck_c[0]==1'b0) begin
					simDataCmp <= (256*simDataCheck_c[3:1])+(simDataCheck_c[15:4]-3)%simREADDEPTH+1;
					simDataCmpBuf <= simDataCmp;
				end

				if(simDataCheck_c>16+16+16+1 && simDataCheck_c[0]==1'b1) begin
					simDataError <= (simDataBuf==simDataCmpBuf ? 1'b0 : 1'b1);
				end

				simDataBuf <= {simDataBuf[7:0],uut.TCP_TX_DATA[7:0]};

			end else begin
					simDataKugiri = 1'b0;
					simDataKugiri2 = 1'b0;
					simDataError = 1'b0;
			end
		end
	end

//FIFO

/*
	genvar i;
	generate
		for(i=1;i<8;i=i+1) begin : dfifoforce_gen
			initial begin
				force uut.DRS_READ_GEN[i].drs_read_i.dfifo_progfull = 1'b0;
				force uut.DRS_READ_GEN[i].drs_read_i.DFIFO_EMPTY = 1'b0;
				force uut.DRS_READ_GEN[i].drs_read_i.DFIFO_VALID = 1'b1;
			end
		end
	endgenerate
*/

/*
	initial begin
		force uut.counter_read.fifoprogfull = 1'b0;
		force uut.counter_read.CFIFO_EMPTY = 1'b0;
		force uut.data_formatter.sfifo_progfull = 1'b0;
	end
*/

//RBCP_REG
	initial begin
		//force {uut.TRIGGER_SELECT,uut.TRIGGER_SELECT2} = 2'd1;
		//force {uut.TRIGGER_SELECT,uut.TRIGGER_SELECT2} = 2'd2;
		force uut.TRIGGER_SELECT = 8'd0;
		//force uut.TRIGGER_SELECT = 8'd2;
		//force uut.TRIGGER_SELECT = 8'd3;
		//force uut.TRIGGER_SELECT = 8'd4;
		//force uut.TRIGGER_SELECT = 8'd8;
		force uut.DRS_READDEPTH = simREADDEPTH;
		force uut.TRIGGER_FREQ = 30'd1000;
		force uut.SCB_TP_TRIG_FREQ = 30'd100;
		force uut.SCB_TP_CLKSELECT = 1'b1;
		force uut.command_tp_trig = 8'hFF;
	end
	
	/*
	initial begin
		#2000
		force uut.DRS_REFCLK_RESET = 1'b1;
		#30
		force uut.DRS_REFCLK_RESET = 1'b0;
	end
	*/

//BP FPGA Reboot
	/*
	initial begin
		#2000
		force uut.rbcp_reg.regX69Data = 8'hFF;
		#30
		release uut.rbcp_reg.regX69Data;
	end
	*/
//timer
	always begin //because this takes too long
		force uut.sec_66m = 1'b0;
		force uut.msec_66m = 1'b0;
		#7.5;
		force uut.sec_66m = 1'b1;
		force uut.msec_66m = 1'b1;
		#7.5;
	end

endmodule

