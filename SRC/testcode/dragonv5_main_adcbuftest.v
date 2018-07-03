//dragon_ver5_readout_board
//KONNO Yusuke
//Kyoto Univ.
//main module
//waveform readout
//ROI
//v0 developped from dv4_v2_6

`define ANALOG_TRIG
//`define DIGITAL_TRIG

`define TESTBP

	`define FIRMWARE_VER 16'h51_0a
`ifdef ANALOG_TRIG
	`define FIRMWARE_TRIGGER 8'h01
`endif
`ifdef DIGITAL_TRIG
	`define FIRMWARE_TRIGGER 8'h10
`endif

module dragonv5_main(
			 OSC,
			 DIP_SWITCH,
			 LED,
			 
			 SCB_MCSn,
			 SCB_MDI,
			 SCB_MSK,
			 SCB_MEX,
			 SCB_MDO,
			 SCB_nCFG,
			 SCB_nIRQ,
			 SCB_TP_TRIG_P,
			 SCB_TP_TRIG_N,
			 
`ifdef DIGITAL_TRIG
			 L1_SC_EN,
			 L1_SC_DIN,
			 L1_SC_CLK,
			 L1_SC_DOUT,
			 DIGITAL_TRIG_OUT_P,
			 DIGITAL_TRIG_OUT_N,
			 TRGL1_P,
			 TRGL1_N,
			 TRIG_BPOUT_P,
			 TRIG_BPOUT_N,
`endif
`ifdef ANALOG_TRIG
			 L0_CTR7,
			 L0_CTR6,
			 L0_CTR5,
			 L0_CTR4,
			 L0_CTR3,
			 L0_CTR2,
			 L0_CTR1,
			 L0_CTR0,
			 L1_OUT_P,
			 L1_OUT_N,
			 L1_OUT2_P,
			 L1_OUT2_N,
			 L1_SC_EN,
			 L1_SC_DIN,
			 L1_SC_CLK,
			 L1_SC_DOUT,
			 L1_INIT_R,
			 AN_TRG_OUT_P,
			 AN_TRG_OUT_N,
			 TRGL1_P,
			 TRGL1_N,

			 TRIG_BPOUT_P,
			 TRIG_BPOUT_N,
			 DIGITAL_TRIG_OUT_P,
			 DIGITAL_TRIG_OUT_N,

			 FPGA_SLOW_CTRL3,
			 FPGA_SLOW_CTRL2,
			 FPGA_SLOW_CTRL1,
			 FPGA_SLOW_CTRL0,
`endif
`ifdef TESTBP
			 TESTBP_EXTTRG,
`endif

			 DAC_CS,
			 DAC_SDI,
			 DAC_SCK,
			 DAC_LDACn,

			 LED_ACT,
			 LED_10M,
			 LED_100M,
			 LED_1000M,
			
			 ETH_TX_CLK,
			 ETH_RX_CLK,
			 ETH_MDIO,
			 ETH_MDC,
			 ETH_GTXCLK,
			 ETH_TX_D,
			 ETH_TX_EN,
			 ETH_TX_ER,
			 ETH_RSTn,
			 ETH_RX_ER,
			 ETH_RX_DV,
			 ETH_RX_D,
			 ETH_CRS,
			 ETH_COL,
			 ETH_IRQ,
			 //ETH_HPD,
			 
			 DRS_REFCLK_P,
			 DRS_REFCLK_N,
			 DRS_WSRIN,
			 DRS_SRIN,
			 DRS_SRCLK,
			 DRS_A0,
			 DRS_A1,
			 DRS_A2,
			 DRS_A3,
			 DRS_RSRLOAD,
			 DRS_DENABLE,
			 DRS_DWRITE,
			 DRS_RESETn,
			 DRS_WSROUT,
			 DRS_SROUT,
			 DRS_DTAP,
			 DRS_PLLLCK,
			 DRS_TAG_H_P,
			 DRS_TAG_H_N,
			 DRS_TAG_L_P,
			 DRS_TAG_L_N,
			 DRS_CAL_P,
			 DRS_CAL_N,
			
			 AD9222_CLK_P,
			 AD9222_CLK_N,
			 AD9222_CSBn,
			 AD9222_SCLK,
			 AD9222_SDIO,
			 AD9222_SDIO_DIR,
			 AD9222_DCO_P,
			 AD9222_DCO_N,
			 AD9222_FCO_P,
			 AD9222_FCO_N,
			 AD9222_OUT_P,
			 AD9222_OUT_N,
			 
			 EEPROM_CS,
			 EEPROM_SK,
			 EEPROM_DI,
			 EEPROM_DO,
			 
			 SPI_SCK,
			 SPI_MOSI,
			 SPI_SS,
			 SPI_MISO,
			 SPI_PROGRAM_B,

			 SRAM_A,
			 SRAM_MODE,
			 SRAM_ZZ,
			 SRAM_ADVn,
			 SRAM_ADSPn,
			 SRAM_ADSCn,
			 SRAM_OEn,
			 SRAM_BWEn,
			 SRAM_GWn,
			 SRAM_CLK,
			 SRAM_BWn,
			 SRAM_DQ,
			 SRAM_DQP,
			 SRAM_CE3n,
			 SRAM_CE2,
			 SRAM_CE1n,

			 BP_TIMEPPS_P,
			 BP_TIMEPPS_N,
			 BP_EXTCLK_P,
			 BP_EXTCLK_N,
			 BP_BUSY_P,
			 BP_BUSY_N,
			 BP_FPGA_PROGRAM
			 
		 );
	 
//--------------------------------------------
//Port declaration
	input OSC;
	input[7:0] DIP_SWITCH;
	output[3:0] LED;
	
	output SCB_MDO;
	output SCB_MCSn;
	input SCB_MDI;
	output SCB_MSK;
	output SCB_TP_TRIG_P;
	output SCB_TP_TRIG_N;
	output SCB_MEX;
	output SCB_nCFG;
	input SCB_nIRQ;
	
`ifdef DIGITAL_TRIG	
	output L1_SC_EN;
	output L1_SC_DIN;
	output L1_SC_CLK;
	input L1_SC_DOUT;
	input[6:0] DIGITAL_TRIG_OUT_P;
	input[6:0] DIGITAL_TRIG_OUT_N;
	input TRGL1_P;
	input TRGL1_N;
	output[6:0] TRIG_BPOUT_P;
	output[6:0] TRIG_BPOUT_N;
`endif
`ifdef ANALOG_TRIG
	output L0_CTR7;
	output L0_CTR6;
	output L0_CTR5;
	output L0_CTR4;
	input L0_CTR3;
	output L0_CTR2;
	output L0_CTR1;
	output L0_CTR0;
	input  L1_OUT_P;
	input  L1_OUT_N;
	input  L1_OUT2_P;
	input  L1_OUT2_N;
	input  L1_SC_DOUT;
	output L1_SC_CLK;
	output L1_SC_DIN;
	output L1_SC_EN;
	output L1_INIT_R;
	input TRGL1_P;
	input TRGL1_N;
	output[1:0] AN_TRG_OUT_P;
	output[1:0] AN_TRG_OUT_N;

	output[6:0] TRIG_BPOUT_P;
	output[6:0] TRIG_BPOUT_N;
	input[6:0] DIGITAL_TRIG_OUT_P;
	input[6:0] DIGITAL_TRIG_OUT_N;
	
	input FPGA_SLOW_CTRL3;
	output FPGA_SLOW_CTRL2;
	output FPGA_SLOW_CTRL1;
	output FPGA_SLOW_CTRL0;
`endif
`ifdef TESTBP
	input TESTBP_EXTTRG;
`endif
	
	output DAC_CS;
	output DAC_SDI;
	output DAC_SCK;
	output DAC_LDACn;
	
	input LED_ACT;
	input LED_10M;
	input LED_100M;
	input LED_1000M;
	
	input ETH_TX_CLK;
	input ETH_RX_CLK;
	inout ETH_MDIO;
	output ETH_MDC;
	output ETH_GTXCLK;
	output[7:0] ETH_TX_D;
	output ETH_TX_EN;
	output ETH_TX_ER;
	output ETH_RSTn;
	input ETH_RX_ER;
	input ETH_RX_DV;
	input[7:0] ETH_RX_D;
	input ETH_CRS;
	input ETH_COL;
	input ETH_IRQ;
	//output ETH_HPD; //PULL_DOWN: HPD disabled
	
	output[7:0] DRS_REFCLK_P;
	output[7:0] DRS_REFCLK_N;
	output DRS_WSRIN;
	output DRS_SRIN;
	output[7:0] DRS_SRCLK;
	output[7:0] DRS_A0;
	output[7:0] DRS_A1;
	output[7:0] DRS_A2;
	output[7:0] DRS_A3;
	output[7:0] DRS_RSRLOAD;
	output DRS_DENABLE;
	output DRS_DWRITE;
	output[7:0] DRS_RESETn;
	input[7:0] DRS_WSROUT;
	input[7:0] DRS_SROUT;
	input[7:0] DRS_DTAP;
	input[7:0] DRS_PLLLCK;
	output DRS_TAG_H_P;
	output DRS_TAG_H_N;
	output DRS_TAG_L_P;
	output DRS_TAG_L_N;
	output[7:0] DRS_CAL_P;
	output[7:0] DRS_CAL_N;
	
	output AD9222_CLK_P;
	output AD9222_CLK_N;
	output AD9222_CSBn;
	output AD9222_SCLK;
	inout AD9222_SDIO;
	output AD9222_SDIO_DIR;
	input AD9222_DCO_P;
	input AD9222_DCO_N;
	input AD9222_FCO_P;
	input AD9222_FCO_N;
	input[7:0] AD9222_OUT_P;
	input[7:0] AD9222_OUT_N;

	output EEPROM_CS;
	output EEPROM_SK;
	output EEPROM_DI;
	input EEPROM_DO;

	output SPI_SCK;
	output SPI_MOSI;
	output SPI_SS;
	input SPI_MISO;
	output SPI_PROGRAM_B;
	
	output[20:0] SRAM_A;
	output SRAM_MODE;
	output SRAM_ZZ;
	output SRAM_ADVn;
	output SRAM_ADSPn;
	output SRAM_ADSCn;
	output SRAM_OEn;
	output SRAM_BWEn;
	output SRAM_GWn;
	output SRAM_CLK;
	output[3:0] SRAM_BWn;
	output SRAM_CE3n;
	output SRAM_CE2;
	output SRAM_CE1n;
	inout[31:0] SRAM_DQ;
	inout[3:0] SRAM_DQP;
	
	input BP_TIMEPPS_P;
	input BP_TIMEPPS_N;
	input BP_EXTCLK_P;
	input BP_EXTCLK_N;
	output BP_BUSY_P;
	output BP_BUSY_N;
	output BP_FPGA_PROGRAM;
	
//--------------------------------------------
//genvar 

	genvar i, j, k, l, m, n; 

//--------------------------------------------

//command
	wire command_rst;

//DAC
	wire command_dacset;
	wire dacset_finish;
	
//SCB
	wire command_scb_spisend;
	wire scb_spisend_finish;
	wire command_tp_trig;

//DIGITAL TRIGGER
	wire command_dtrigset;
	wire dtrigset_finish;
`ifdef ANALOG_TRIG
	assign dtrigset_finish = 1'b0;
`endif

//ANALOG TRIGGER
	wire command_l0_sc_write;
	wire command_l0_sc_read;
	wire command_l0_reset;
	wire command_l0dela_set;
	wire command_l0dela_reset;
	wire l0_sc_write_done;
	wire l0_sc_read_done;
	wire l0_reset_done;
	wire l0dela_set_done;
	wire l0dela_reset_done;
	wire command_l1_sc_write;
	wire command_l1_sc_read;
	wire command_l1_reset;
	wire l1_sc_write_done;
	wire l1_sc_read_done;
	wire l1_reset_done;
	wire command_bp_sc_write;
	wire bp_sc_write_done;
	wire command_bp_fpgaprogram;
	wire bp_fpgaprogram_done;
`ifdef DIGITAL_TRIG
	assign l0_sc_write_done = 1'b0;
	assign l0_sc_read_done = 1'b0;
	assign l0_reset_done = 1'b0;
	assign l0dela_reset_done = 1'b0;
	assign l1_sc_write_done = 1'b0;
	assign l1_sc_read_done = 1'b0;
	assign l1_reset_done = 1'b0;
	assign bp_sc_write_done = 1'b0;
	assign bp_fpgaprogram_done = 1'b0;
`endif

//SRAM
	wire command_sramwrite;
	wire command_sramread;
	wire command_sramzz;
	wire sramwrite_finish;
	wire sramread_finish;

//ADC
	wire command_adcspi;
	wire adcspi_finish;

//--------------------------------------------
//RBCP parameter

//HARDWARE/FIRMWARE INFOMATION
	wire[15:0] FIRMWARE_VER;
	assign FIRMWARE_VER = `FIRMWARE_VER;
	wire[7:0] FIRMWARE_TRIGGER;
	assign FIRMWARE_TRIGGER = `FIRMWARE_TRIGGER;
	wire[7:0] DIP_SWITCH_READ;
	assign DIP_SWITCH_READ = DIP_SWITCH;
	wire[31:0] DEBUG_IN;
	wire[15:0] DEBUG_PARAM;

//TRIGGER
	wire[7:0] TRIGGER_SELECT;
	wire[29:0] TRIGGER_FREQ; // trigger frequency for pedestal run
	wire[15:0] TRIGGER_FREQ_OFFSET;

//SCB
	wire[135:0] SCB_SPICMD; //v2 test
	wire[7:0] SCB_SPILENGTH; //v2 test 
	wire[127:0] SCB_SPIREAD; //v2 test
	wire[29:0] SCB_TP_TRIG_FREQ;
	wire[15:0] SCB_TP_TRIG_WIDTH;

//DIGITAL TRIGGER
// 2.5V 12bit
	wire[7:0] DTRIG_THRESHOLD_0;
	wire[7:0] DTRIG_THRESHOLD_1;
	wire[7:0] DTRIG_THRESHOLD_2;
	wire[7:0] DTRIG_THRESHOLD_3;
	wire[7:0] DTRIG_THRESHOLD_4;
	wire[7:0] DTRIG_THRESHOLD_5;
	wire[7:0] DTRIG_THRESHOLD_6;
	wire[15:0] IPR_0;
	wire[15:0] IPR_1;
	wire[15:0] IPR_2;
	wire[15:0] IPR_3;
	wire[15:0] IPR_4;
	wire[15:0] IPR_5;
	wire[15:0] IPR_6;

//ANALOG TRIGGER
	wire[15:0] RATE_WINDOW;
	wire[15:0] RATE_L1OUT;
	wire[15:0] RATE_L1OUT2;
	wire[15:0] RATE_TRIGL1;
	wire[6:0] L0_SC_ADDRESS;
	wire[15:0] L0_SC_DATA;
	wire[23:0] L0_SC_READ;
	wire[23:0] L0_DELAYEXPAND_DATA;
	wire[6:0] L1_SC_ADDRESS;
	wire[15:0] L1_SC_DATA;
	wire[23:0] L1_SC_READ;
//BP SlowControl
	wire[31:0] BP_SC_SENDDATA;
	wire[31:0] BP_SC_READ;

`ifdef DIGITAL_TRIG
	assign RATE_L1OUT = 16'd0;
	assign RATE_L1OUT2 = 16'd0;
	assign L0_SC_READ = 24'd0;
	assign L1_SC_READ = 24'd0;
	assign BP_SC_READ = 32'd0;
`endif

//DRS BOARD DAC 16bit 2.5V
	wire[15:0] DAC_ROFS;//16'd28835=1.1V for input range -0.05V to 0.95V
	wire[15:0] DAC_OOFS;//16'd34078=1.3V for ADC differential input range -1V to 1V 
	wire[15:0] DAC_BIAS;//16'd18350=0.7V from datasheet
	wire[15:0] DAC_CALP;//16'd20971=0.8V : between 0.575V and 1.025V for input signals range 0.1V to 1.5V
	wire[15:0] DAC_CALN;//16'd20971

//DRS4
	wire[12:0] DRS_READDEPTH;
	wire[10:0] DRS_STOP_FROM_TRIG;
	wire[7:0] DRS_SAMP_FREQ;
	wire[31:0] DRS_READ_FROM_STOP; //for the study of charge leakage
	wire[1:0] DRS_CLKOUT_ENABLE;
	wire[7:0] DRS_PLLLCK_CHECK;
	wire DRS_CALREAD;
	wire[7:0] DRS_CASCADENUM;
	wire DRS_REFCLK_RESET;
	wire[7:0] DRS_REFCLK_SELECT;
	wire EXTCLK_ISLOCKED;

//AD9222
	wire[7:0] ADC_SPI_DATA;
	wire[12:0] ADC_SPI_ADDR;

//SRAM
	wire[18:0] SRAM_ADDR;
	wire[31:0] SRAM_WRITEDATA;
	wire[3:0] SRAM_WRITEDATAP;
	wire[31:0] SRAM_READDATA;
	wire[3:0] SRAM_READDATAP;
	
//--------------------------------------------
//RESET and CLOCK
	wire rst_sw;//reset for system clock
	reg command_rstgo;
	
	wire clk;//system clock 66.666MHz
	wire clk_133m;//clock for SiTCP 133.333MHz
	wire clk_33m_90;//AD9222 input clock
	wire dcm_locked;

	wire clk_gmii;//eth_gtxclk 125MHz
	wire dcm_gmii_locked;

	wire dcm_all_locked;
	assign dcm_all_locked = dcm_locked & dcm_gmii_locked;

	wire osc_buf;

	IBUFG IBUFG_OSC(
		.O(osc_buf),
		.I(OSC)
	);

	DCM_V5 dcm_v5(
		.CLK_IN1(osc_buf),
		.CLK_OUT1(clk_133m),
		.CLK_OUT2(clk),
		.CLK_OUT3(clk_33m_90),
		.RESET(command_rstgo),
		.LOCKED(dcm_locked)
	);

	DCM_GMII dcm_gmii(
		.CLK_IN1(osc_buf),
		.CLK_OUT1(clk_gmii),
		.RESET(command_rstgo),
		.LOCKED(dcm_gmii_locked)
	);

	wire clk_ext10m;
	wire clk_ext40m;
	wire clk_extbufo;
	wire extclk_locked;
	wire extclk_en;
	assign extclk_en = DRS_REFCLK_SELECT==8'h01;

	IBUFGDS #(
		.DIFF_TERM("TRUE"),
		.IOSTANDARD("LVDS_33")
	)IBUFGDS_EXTCLK(
		.O  (clk_extbufo),
		.I  (BP_EXTCLK_P),
		.IB (BP_EXTCLK_N)
	);

	DCM_EXTCLK dcm_extclk(
		.CLK_IN1 (clk_extbufo),
		.CLK_OUT1 (clk_ext10m),
		.CLK_OUT2 (clk_ext40m),
		.RESET (command_rstgo),
		.LOCKED (extclk_locked)
	);

	wire pps;
	IBUFGDS #(
		.DIFF_TERM("TRUE"),
		.IOSTANDARD("LVDS_33")
	)IBUFGDS_TIMEPPS(
		.O  (pps),
		.I  (BP_TIMEPPS_P),
		.IB (BP_TIMEPPS_N)
	);
	
//IOCLOCK
	wire adc_dco_ibufo;
	wire adc_divclk;
	wire adc_ioclk;
	wire adc_ioclk_inv;
	wire adc_ioclk2;
	wire adc_ioclk_inv2;
	wire adc_dco; //adc data clock 199.998MHz

	IBUFGDS #(
		.DIFF_TERM("TRUE"),
		.IOSTANDARD("LVDS_25")
	)IBUFGDS_ADC_DCO(
		.O  (adc_dco_ibufout),
		.I  (AD9222_DCO_P),
		.IB (AD9222_DCO_N)
	);
	
	//BUFIO2 Region TR
	BUFIO2 #(
		.DIVIDE(1), // DIVCLK divider (1-8)
		.DIVIDE_BYPASS("TRUE"), // Bypass the divider circuitry (TRUE/FALSE)
		.I_INVERT("FALSE"), // Invert clock (TRUE/FALSE)
		.USE_DOUBLER("FALSE") // Use doubler circuitry (TRUE/FALSE)
	)
	BUFIO2_ADC_TR (
		.DIVCLK(adc_divclk), // 1-bit output Divided clock output
		.IOCLK(adc_ioclk), // 1-bit output I/O output clock
		.SERDESSTROBE(), // 1-bit output Output SERDES strobe (connect to ISERDES2/OSERDES2)
		.I(adc_dco_ibufout) // 1-bit input Clock input (connect to IBUFG)
	);

	BUFIO2 #(
		.DIVIDE(1), // DIVCLK divider (1-8)
		.DIVIDE_BYPASS("TRUE"), // Bypass the divider circuitry (TRUE/FALSE)
		.I_INVERT("TRUE"), // Invert clock (TRUE/FALSE)
		.USE_DOUBLER("FALSE") // Use doubler circuitry (TRUE/FALSE)
	)
	BUFIO2_ADC_INV_TR (
		.DIVCLK(), // 1-bit output Divided clock output
		.IOCLK(adc_ioclk_inv), // 1-bit output I/O output clock
		.SERDESSTROBE(), // 1-bit output Output SERDES strobe (connect to ISERDES2/OSERDES2)
		.I(adc_dco_ibufout) // 1-bit input Clock input (connect to IBUFG)
	);
	
	//BUFIO2 Region TL
	BUFIO2 #(
		.DIVIDE(1), // DIVCLK divider (1-8)
		.DIVIDE_BYPASS("TRUE"), // Bypass the divider circuitry (TRUE/FALSE)
		.I_INVERT("FALSE"), // Invert clock (TRUE/FALSE)
		.USE_DOUBLER("FALSE") // Use doubler circuitry (TRUE/FALSE)
	)
	BUFIO2_ADC_TL (
		.DIVCLK(), // 1-bit output Divided clock output
		.IOCLK(adc_ioclk2), // 1-bit output I/O output clock
		.SERDESSTROBE(), // 1-bit output Output SERDES strobe (connect to ISERDES2/OSERDES2)
		.I(adc_dco_ibufout) // 1-bit input Clock input (connect to IBUFG)
	);
	
	BUFIO2 #(
		.DIVIDE(1), // DIVCLK divider (1-8)
		.DIVIDE_BYPASS("TRUE"), // Bypass the divider circuitry (TRUE/FALSE)
		.I_INVERT("TRUE"), // Invert clock (TRUE/FALSE)
		.USE_DOUBLER("FALSE") // Use doubler circuitry (TRUE/FALSE)
	)
	BUFIO2_ADC_INV_TL (
		.DIVCLK(), // 1-bit output Divided clock output
		.IOCLK(adc_ioclk_inv2), // 1-bit output I/O output clock
		.SERDESSTROBE(), // 1-bit output Output SERDES strobe (connect to ISERDES2/OSERDES2)
		.I(adc_dco_ibufout) // 1-bit input Clock input (connect to IBUFG)
	);

	BUFG adc_dco_bufg
	(.O   (adc_dco),
	 .I   (adc_divclk));
	
//RESET
	wire rst;//system reset
	reg[9:0] command_rst_c;
	reg trig_rst;
	reg rst_sync;
	reg rst_sw_ir1;
	reg rst_sw_ir2;

	wire rst_fromlocked;
	wire rst_fromextclklocked;
	wire rst_logic;
	assign rst_fromlocked = ~dcm_all_locked;
	assign rst_fromextclklocked = extclk_en & ~extclk_locked;
	assign rst_logic = rst_fromlocked | rst_sw_ir2 | command_rstgo;
	assign rst = rst_sync;
	assign EXTCLK_ISLOCKED = extclk_locked;
	
	always@(posedge clk or posedge rst_fromlocked) begin
		if(rst_fromlocked) begin
			rst_sw_ir1 <= 1'b1;
			rst_sw_ir2 <= 1'b1;
		end else begin
			rst_sw_ir1 <= rst_sw;
			rst_sw_ir2 <= rst_sw_ir1;
		end
	end

	always@(posedge clk or posedge rst_fromlocked) begin
		if(rst_fromlocked) begin
			rst_sync <= 1'b1;
		end else begin
			rst_sync <= rst_logic;
		end
	end

	always@(posedge clk or posedge rst_fromlocked) begin
		if(rst_fromlocked) begin
			command_rst_c <= 10'd0;
			command_rstgo <= 1'b0;
		end else begin
			if(command_rst_c == 10'd0) begin
				if(command_rst) begin
					command_rst_c <= command_rst_c + 10'd1;
				end
			end else if(command_rst_c == 10'd1000) begin
				command_rstgo <= 1'b1;
			end else begin
				command_rst_c <= command_rst_c + 10'd1;
			end
		end
	end
	
//------------------------------------------------------------------
//Timer

	wire usec_66m;
	wire msec_66m;
	wire sec_66m;
	wire usec_133m;
	wire msec_133m;
	wire sec_133m;

	MYTIMER mytimer(
		.rst(rst),
		.clk_66m(clk),
		.clk_133m(clk_133m),
		.usec_66m(usec_66m),
		.msec_66m(msec_66m),
		.sec_66m(sec_66m),
		.usec_133m(usec_133m),
		.msec_133m(msec_133m),
		.sec_133m(sec_133m)
	);

//------------------------------------------------------------------
//Slow Control Board

	wire scb_en;
	wire scb_tp_trig_ext;
	SCBV2 scb (
		 .SCB_MCSn(SCB_MCSn), 
		 .SCB_MDO(SCB_MDO), 
		 .SCB_MSK(SCB_MSK), 
		 .SCB_MEX(SCB_MEX), 
		 .SCB_MDI(SCB_MDI),
		 .SCB_nCFG(SCB_nCFG),
		 .SCB_nIRQ(SCB_nIRQ),
		 .SCB_TP_TRIG_P(SCB_TP_TRIG_P), 
		 .SCB_TP_TRIG_N(SCB_TP_TRIG_N), 
		 .scb_tp_trig_ext(scb_tp_trig_ext),
		 .trig_rst(trig_rst),
		 .clk(clk), 
		 .clk_133m(clk_133m),
		 .rst(rst), 
		 .scb_en(scb_en), 
		 .command_dacset(command_scb_spisend), 
		 .command_tp_trig(command_tp_trig),
		 .scb_command_dac_finish(scb_spisend_finish),
		 .SCB_TP_TRIG_FREQ(SCB_TP_TRIG_FREQ),
		 .SCB_TP_TRIG_WIDTH(SCB_TP_TRIG_WIDTH),
		 .SCB_SPICMD(SCB_SPICMD),
		 .SCB_SPILENGTH(SCB_SPILENGTH),
		 .SCB_SPIREAD(SCB_SPIREAD),
		 .usec_66m(usec_66m)
	 );

//--------------------------------------------
//digital trigger

`ifdef DIGITAL_TRIG
	wire dtrig_en;
	wire trigl1;
	wire[6:0] dtrig_trig;
	wire TRIGL1_async;
	DIGITAL_TRIGGER digital_trigger (
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
		 .clk(clk),
		 .clk_133m(clk_133m),
		 .rst(rst), 
		 .dtrig_en(dtrig_en), 
		 .command_dacset(command_dtrigset), 
		 .command_dacset_finish(dtrigset_finish), 
		 .DTRIG_THRESHOLD_0(DTRIG_THRESHOLD_0), 
		 .DTRIG_THRESHOLD_1(DTRIG_THRESHOLD_1), 
		 .DTRIG_THRESHOLD_2(DTRIG_THRESHOLD_2), 
		 .DTRIG_THRESHOLD_3(DTRIG_THRESHOLD_3), 
		 .DTRIG_THRESHOLD_4(DTRIG_THRESHOLD_4), 
		 .DTRIG_THRESHOLD_5(DTRIG_THRESHOLD_5), 
		 .DTRIG_THRESHOLD_6(DTRIG_THRESHOLD_6), 
		 .dtrig_trig(dtrig_trig), 
		 .trigl1(trigl1),
		 .TRIGL1_async(TRIGL1_async),
		 .IPR_0(IPR_0),
		 .IPR_1(IPR_1),
		 .IPR_2(IPR_2),
		 .IPR_3(IPR_3),
		 .IPR_4(IPR_4),
		 .IPR_5(IPR_5),
		 .IPR_6(IPR_6),
		 .RATE_TRIGL1(RATE_TRIGL1),
		 .RATE_WINDOW(RATE_WINDOW),
		 .msec_133m(msec_133m)
		 );
`endif

//--------------------------------------------
//analog trigger

`ifdef ANALOG_TRIG
	wire l1_out;
	wire l1_out2;
	wire trigl1;
	wire TRIGL1_async;
	ANALOG_TRIGGER_ASICMEZZ analog_trigger (
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
		 .L1_SC_DOUT(L1_SC_DOUT), 
		 .L1_SC_CLK(L1_SC_CLK), 
		 .L1_SC_DIN(L1_SC_DIN), 
		 .L1_SC_EN(L1_SC_EN),
		 .L1_INIT_R(L1_INIT_R),
		 .TRIG_BPOUT_P(AN_TRG_OUT_P), 
		 .TRIG_BPOUT_N(AN_TRG_OUT_N), 
		 .TRIGL1_P(TRGL1_P), 
		 .TRIGL1_N(TRGL1_N),
		 .TRIGL1_async(TRIGL1_async),

		 .clk_133m(clk_133m),
		 .clk_66m(clk),
		 .rst(rst), 
		 .l1_out(l1_out), 
		 .l1_out2(l1_out2), 
		 .trigl1(trigl1), 
		 .command_l0_sc_write(command_l0_sc_write),
		 .command_l0_sc_read(command_l0_sc_read),
		 .command_l0_reset(command_l0_reset),
		 .command_l0dela_reset(command_l0dela_reset),
		 .command_l0dela_set(command_l0dela_set),
		 .l0_sc_write_done(l0_sc_write_done),
		 .l0_sc_read_done(l0_sc_read_done),
		 .l0_reset_done(l0_reset_done),
		 .l0dela_reset_done(l0dela_reset_done),
		 .l0dela_set_done(l0dela_set_done),
		 .command_l1_sc_write(command_l1_sc_write),
		 .command_l1_sc_read(command_l1_sc_read),
		 .command_l1_reset(command_l1_reset),
		 .l1_sc_write_done(l1_sc_write_done),
		 .l1_sc_read_done(l1_sc_read_done),
		 .l1_reset_done(l1_reset_done),
		 
		 .DIGITAL_TRIG_BPOUT_P(TRIG_BPOUT_P), 
		 .DIGITAL_TRIG_BPOUT_N(TRIG_BPOUT_N), 
		 .DIGITAL_TRIG_OUT_P(DIGITAL_TRIG_OUT_P), 
		 .DIGITAL_TRIG_OUT_N(DIGITAL_TRIG_OUT_N), 
		 .IPR_0(IPR_0),
		 .IPR_1(IPR_1),
		 .IPR_2(IPR_2),
		 .IPR_3(IPR_3),
		 .IPR_4(IPR_4),
		 .IPR_5(IPR_5),
		 .IPR_6(IPR_6),
		 
		 .RATE_WINDOW(RATE_WINDOW),
		 .RATE_L1OUT(RATE_L1OUT),
		 .RATE_L1OUT2(RATE_L1OUT2),
		 .RATE_TRIGL1(RATE_TRIGL1),
		 .L0_SC_ADDRESS(L0_SC_ADDRESS),
		 .L0_SC_DATA(L0_SC_DATA),
		 .L0_SC_READ(L0_SC_READ),
		 .L0_DELAYEXPAND_DATA(L0_DELAYEXPAND_DATA),
		 .L1_SC_ADDRESS(L1_SC_ADDRESS),
		 .L1_SC_DATA(L1_SC_DATA),
		 .L1_SC_READ(L1_SC_READ),
		 .msec_133m(msec_133m)
		 //.DEBUG(X6F[7:0]) //debug
	);

	ANALOG_BACKPLANE analog_backplane(
		.FPGA_SLOW_CTRL3(FPGA_SLOW_CTRL3),
		.FPGA_SLOW_CTRL2(FPGA_SLOW_CTRL2),
		.FPGA_SLOW_CTRL1(FPGA_SLOW_CTRL1),
		.FPGA_SLOW_CTRL0(FPGA_SLOW_CTRL0),
		.clk_66m(clk),
		.rst(rst),
		.command_bp_sc_write(command_bp_sc_write),
		.bp_sc_write_done(bp_sc_write_done),
		.BP_SC_SENDDATA(BP_SC_SENDDATA),
		.BP_SC_READ(BP_SC_READ),
		.command_bp_fpgaprogram(command_bp_fpgaprogram),
		.bp_fpgaprogram_done(bp_fpgaprogram_done),
		.BP_FPGA_PROGRAM(BP_FPGA_PROGRAM)
	);
`endif

//--------------------------------------------
//Test Backplane

`ifdef TESTBP
	wire testbp_exttrg_bufo;
	wire TESTBP_EXTTRG_async;
	assign TESTBP_EXTTRG_async = TESTBP_EXTTRG;
	TEST_BACKPLANE test_backplane(
		.clk_133m(clk_133m),
		.TESTBP_EXTTRG(TESTBP_EXTTRG),
		.testbp_exttrg_bufo(testbp_exttrg_bufo)
	);
`endif

//--------------------------------------------
//DRS board DAC

	wire dac_en;
	DAC_DRS dac_drs (
		 .DAC_CS(DAC_CS), 
		 .DAC_SDI(DAC_SDI), 
		 .DAC_SCK(DAC_SCK), 
		 .DAC_LDACn(DAC_LDACn), 
		 .DAC_ROFS(DAC_ROFS), 
		 .DAC_OOFS(DAC_OOFS), 
		 .DAC_BIAS(DAC_BIAS), 
		 .DAC_CALP(DAC_CALP), 
		 .DAC_CALN(DAC_CALN), 
		 .clk(clk), 
		 .rst(rst), 
		 .dac_en(dac_en), 
		 .command_dacset(command_dacset),
		 .command_dac_finish(dacset_finish)
	);

//--------------------------------------------
//SRAM

	SRAM sram (
		//.clk(clk_133m),
		.clk(clk),
		.rst(rst),
		.command_sramwrite(command_sramwrite),
		.command_sramread(command_sramread),
		.SRAM_ADDR(SRAM_ADDR),
		.SRAM_WRITEDATA(SRAM_WRITEDATA),
		.SRAM_WRITEDATAP(SRAM_WRITEDATAP),
		.command_sramzz(command_sramzz),
		.SRAM_READDATA(SRAM_READDATA),
		.SRAM_READDATAP(SRAM_READDATAP),
		.sramwrite_finish(sramwrite_finish),
		.sramread_finish(sramread_finish),

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
		.SRAM_CE3n(SRAM_CE3n),
		.SRAM_CE2(SRAM_CE2),
		.SRAM_CE1n(SRAM_CE1n),
		.SRAM_DQ(SRAM_DQ),
		.SRAM_DQP(SRAM_DQP)
	);

//--------------------------------------------
//ADC SPI

	wire adcspi_en;
	ADC_SPI adc_spi (
		 .AD9222_CSBn(AD9222_CSBn), 
		 .AD9222_SCLK(AD9222_SCLK), 
		 .AD9222_SDIO(AD9222_SDIO), 
		 .AD9222_SDIO_DIR(AD9222_SDIO_DIR), 
		 .clk(clk), 
		 .rst(rst), 
		 .adcspi_en(adcspi_en), 
		 .ADC_SPI_DATA(ADC_SPI_DATA), 
		 .ADC_SPI_ADDR(ADC_SPI_ADDR), 
		 .command_dacset(command_adcspi),
		 .adcspi_finish(adcspi_finish)
	);
		 
//--------------------------------------------
//SiTCP

	wire ETH_MDIO_OE;
	wire ETH_MDIO_OUT;
	assign ETH_MDIO = (ETH_MDIO_OE ? ETH_MDIO_OUT : 1'bz);
	
	wire GMII_1000M;
	wire int_ETH_TX_CLK;
	wire int_ETH_RX_CLK;

	//assign int_ETH_TX_CLK = clk_gmii;
	//assign int_ETH_RX_CLK = ETH_RX_CLK;
	//assign GMII_1000M = 1'b1;
	
	wire eth_txclk_buf;
	IBUFG IBUFG_ETH_TX_CLK(
		.O (eth_txclk_buf),
		.I (ETH_TX_CLK)
	);
	BUFGMUX GMIIMUX(.O(int_ETH_TX_CLK), .I0(eth_txclk_buf), .I1(clk_gmii), .S(GMII_1000M));		

	wire int_ETH_RX_CLK_buf;
	IBUFG IBUFG_ETH_RX_CLK(
		.O (int_ETH_RX_CLK_buf),
		.I (ETH_RX_CLK)
	);
	BUFG BUFG_ETH_RX_CLK(
		.O (int_ETH_RX_CLK),
		.I (int_ETH_RX_CLK_buf)
	);

	ODDR2 ETH_GTXCLK_BUF (.Q(ETH_GTXCLK), .C0(clk_gmii), .C1(~clk_gmii), .CE(1'b1), .D0(1'b1), .D1(1'b0), .R(1'b0), .S(1'b0));

//GMII SELECTOR
	reg[6:0] RSTCNT;
	reg RX_RST200NS;
	reg RX_RST_2ND;
	reg[4:0] RX_COUNT;
	reg RX_SELECT;
	assign GMII_1000M = RX_SELECT;

	always@ (posedge clk_133m or posedge rst) begin
		if(rst)begin
			RSTCNT[6:0] <= 7'd0;
			RX_RST200NS <= 1'b0;
			RX_RST_2ND  <= 1'b0;
		end else begin
			RSTCNT[6:0] <= RSTCNT[6] ? 7'd25 : (RSTCNT[6:0] - 7'd1); // 25 = 27 - 2 , 27 * 7.5ns = 202.5ns
			RX_RST200NS <= RSTCNT[6];
			RX_RST_2ND  <= RX_RST200NS;
		end
	end

	always@ (posedge int_ETH_RX_CLK or posedge RX_RST_2ND) begin
		if(RX_RST_2ND) begin
			RX_COUNT[4:0] <= 5'd0;
		end else begin
			RX_COUNT[4:0] <= RX_COUNT[4:0] + (RX_COUNT[4] ? 5'd0 : 5'd1);
		end
	end

	always@ (posedge clk_133m) begin
		RX_SELECT <= RX_RST200NS ? RX_COUNT[4] : RX_SELECT; //1:125M    0:25M/2.5M
	end

//SiTCP module
	wire SiTCP_RST; //reset out from SiTCP
	wire force_default_sw;

	wire TCP_OPEN;
	wire TCP_CLOSE;
	wire TCP_TX_FULL;
	wire TCP_TX_WR;
	wire[7:0] TCP_TX_DATA;
	
	wire RBCP_ACT;
	wire[31:0] RBCP_ADDR;
	wire[7:0] RBCP_WD;
	wire RBCP_WE;
	wire RBCP_RE;
	wire RBCP_ACK;
	wire[7:0] RBCP_RD;

	WRAP_SiTCP_GMII_XC6S_16K
		#(134) // = System clock frequency(MHz)
	SiTCP(
		.CLK(clk_133m),	// in	: System Clock >129MHz
		.RST(rst),	// in	: System reset
	// Configuration parameters
		.FORCE_DEFAULTn(force_default_sw),	// in	: Load default parameters
		.EXT_IP_ADDR(32'd0),	// in	: IP address[31:0]
		//.EXT_IP_ADDR({8'd192,8'd168,8'd10,8'd17}),	// in	: IP address[31:0]
		.EXT_TCP_PORT(16'd24),	// in	: TCP port #[15:0]
		.EXT_RBCP_PORT(16'd4660),	// in	: RBCP port #[15:0]
		.PHY_ADDR(5'b00111),	// in	: PHY-device MIF address[4:0]
	// EEPROM
		.EEPROM_CS(EEPROM_CS),	// out	: Chip select
		.EEPROM_SK(EEPROM_SK),	// out	: Serial data clock
		.EEPROM_DI(EEPROM_DI),	// out	: Serial write data
		.EEPROM_DO(EEPROM_DO),	// in	: Serial read data
		// user data, intial values are stored in the EEPROM, 0xFFFF_FC3C-3F
		.USR_REG_X3C(),	// out	: Stored at 0xFFFF_FF3C
		.USR_REG_X3D(),	// out	: Stored at 0xFFFF_FF3D
		.USR_REG_X3E(),	// out	: Stored at 0xFFFF_FF3E
		.USR_REG_X3F(),	// out	: Stored at 0xFFFF_FF3F
	// MII interface
		.GMII_RSTn(ETH_RSTn),	// out	: PHY reset
		.GMII_1000M(GMII_1000M),	// in	: GMII mode (0:MII, 1:GMII)
		// TX
		.GMII_TX_CLK(int_ETH_TX_CLK),	// in	: Tx clock
		.GMII_TX_EN(ETH_TX_EN),	// out	: Tx enable
		.GMII_TXD(ETH_TX_D[7:0]),	// out	: Tx data[7:0]
		.GMII_TX_ER(ETH_TX_ER),	// out	: TX error
		// RX
		//.GMII_RX_CLK(ETH_RX_CLK),	// in	: Rx clock
		.GMII_RX_CLK(int_ETH_RX_CLK),	// in	: Rx clock
		.GMII_RX_DV(ETH_RX_DV),	// in	: Rx data valid
		.GMII_RXD(ETH_RX_D[7:0]),	// in	: Rx data[7:0]
		.GMII_RX_ER(ETH_RX_ER),	// in	: Rx error
		.GMII_CRS(ETH_CRS),	// in	: Carrier sense
		.GMII_COL(ETH_COL),	// in	: Collision detected
		// Management IF
		.GMII_MDC(ETH_MDC),	// out	: Clock for MDIO
		.GMII_MDIO_IN(ETH_MDIO),	// in	: Data
		.GMII_MDIO_OUT(ETH_MDIO_OUT),	// out	: Data
		.GMII_MDIO_OE(ETH_MDIO_OE),	// out	: MDIO output enable
	// User I/F
		.SiTCP_RST(SiTCP_RST),	// out	: Reset for SiTCP and related circuits
		// TCP connection control
		.TCP_OPEN_REQ(1'b0),	// in	: Reserved input, shoud be 0
		.TCP_OPEN_ACK(TCP_OPEN),	// out	: Acknowledge for open (=Socket busy)
		.TCP_ERROR(),	// out	: TCP error, its active period is equal to MSL
		.TCP_CLOSE_REQ(TCP_CLOSE),	// out	: Connection close request
		.TCP_CLOSE_ACK(TCP_CLOSE),	// in	: Acknowledge for closing
		// FIFO I/F
		.TCP_RX_WC(16'd0),	// in	: Rx FIFO write count[15:0] (Unused bits should be set 1)
		.TCP_RX_WR(),	// out	: Write enable
		.TCP_RX_DATA(),	// out	: Write data[7:0]
		.TCP_TX_FULL(TCP_TX_FULL),	// out	: Almost full flag
		.TCP_TX_WR(TCP_TX_WR),	// in	: Write enable
		.TCP_TX_DATA(TCP_TX_DATA[7:0]),	// in	: Write data[7:0]
		// RBCP
		.RBCP_ACT(RBCP_ACT),	// out	: RBCP active
		.RBCP_ADDR(RBCP_ADDR[31:0]),	// out	: Address[31:0]
		.RBCP_WD(RBCP_WD[7:0]),	// out	: Data[7:0]
		.RBCP_WE(RBCP_WE),	// out	: Write enable
		.RBCP_RE(RBCP_RE),	// out	: Read enable
		.RBCP_ACK(RBCP_ACK),	// in	: Access acknowledge
		.RBCP_RD(RBCP_RD[7:0])	// in	: Read data[7:0]
	);

//readout reset
	wire rst_read;//readout reset
	reg rst_read_sync;
	//assign rst_read = rst | ~TCP_OPEN | SiTCP_RST;
	assign rst_read = rst_read_sync;
	always@(posedge clk or posedge rst) begin
		if(rst) begin
			rst_read_sync <= 1'b1;
		end else begin
			rst_read_sync <= rst | ~TCP_OPEN | SiTCP_RST | rst_fromextclklocked;
		end
	end
	
//--------------------------------------------
//DRS4

//clk_33m_90 edge detector
	reg int_clk_33m_90;
	reg int_clk_33m_90_buf;
	//wire int_clk_33m_90_tgl;
	reg int_clk_33m_90_tgl;
	
	always@(posedge clk_33m_90 or posedge rst) begin
		if(rst) begin
			int_clk_33m_90 <= 1'b0;
		end else begin
			int_clk_33m_90 <= ~int_clk_33m_90;
		end
	end

	always@(posedge clk) begin
		int_clk_33m_90_buf <= int_clk_33m_90;
	end

	always@(posedge clk or posedge rst) begin
		if(rst) begin
			int_clk_33m_90_tgl <= 1'b0;
		end else begin
			int_clk_33m_90_tgl <= (int_clk_33m_90_buf ^ int_clk_33m_90);
		end
	end

	//assign int_clk_33m_90_tgl = (int_clk_33m_90_buf ^ int_clk_33m_90);

//DRS_REFCLK 33.333/33 MHz : 2.068GSPS
	wire drs_refclk_mux;
	reg drs_refclk;
	reg[7:0] drs_refclk_c;
	reg[7:0] drs_sampfreq_reg;
	reg drs_refclkTenM;
	reg[7:0] drs_refclkTenM_c;
	reg[7:0] drs_sampfreq_TenMreg;

	reg rst_refclk;

	assign drs_refclk_mux = DRS_REFCLK_SELECT==8'h01 ? drs_refclkTenM : drs_refclk ;

	always@(posedge clk or posedge rst) begin
		if(rst) begin
			drs_refclk <= 1'b0;
			drs_refclk_c <= 8'd0;
			drs_sampfreq_reg <= DRS_SAMP_FREQ;
		end else begin
			/*
			//if(drs_refclk_c == 8'd32) begin
			if(drs_refclk_c == drs_sampfreq_reg) begin
				drs_refclk <= ~drs_refclk;
				drs_refclk_c <= 8'd0;
				drs_sampfreq_reg <= DRS_SAMP_FREQ;
			end else begin
				drs_refclk_c <= drs_refclk_c + 8'd1;
			end
			*/
		    drs_refclk <= (drs_refclk_c==drs_sampfreq_reg ? ~drs_refclk : drs_refclk);
		    drs_sampfreq_reg <= (drs_refclk_c==drs_sampfreq_reg ? DRS_SAMP_FREQ : drs_sampfreq_reg);
			drs_refclk_c <= (drs_refclk_c==drs_sampfreq_reg ? 8'd0 : drs_refclk_c + 8'd1);
		end
	end

	always@(posedge pps or posedge DRS_REFCLK_RESET) begin
		if(DRS_REFCLK_RESET) begin
			rst_refclk <= 1'b1;
		end else begin
			rst_refclk <= 1'b0;
		end
	end

	always@(posedge clk_ext10m or posedge rst_refclk) begin
		if(rst_refclk) begin
			drs_refclkTenM <= 1'b0;
			drs_refclkTenM_c <= 8'd0;
			drs_sampfreq_TenMreg <= DRS_SAMP_FREQ;
		end else begin
			if(drs_refclkTenM_c == drs_sampfreq_TenMreg) begin
				drs_refclkTenM <= ~drs_refclkTenM;
				drs_refclkTenM_c <= 8'd0;
				drs_sampfreq_TenMreg <= DRS_SAMP_FREQ;
			end else begin
				drs_refclkTenM_c <= drs_refclkTenM_c + 8'd1;
			end
		end
	end

	generate
		for(j=0;j<8;j=j+1) begin : DRS_REFCLK_GEN
			OBUFDS #(
				.IOSTANDARD("LVDS_25")
				) OBUFDS_DRSREFCLK (
				.O(DRS_REFCLK_P[j]),
				.OB(DRS_REFCLK_N[j]),
				.I(drs_refclk_mux)
			);
		end
	endgenerate

//DRS_TAG 33MHz arrival time reference
	wire drs_tag_h;
	wire drs_tag_l;

	//ODDR2	ODDR2_DRS_TAG_H (.Q(drs_tag_h), .C0(clk_33m_90), .C1(~clk_33m_90), .CE(1'b1), .D0(~DRS_CLKOUT_ENABLE[0]), .D1(1'b1), .R(1'b0), .S(1'b0));
	//ODDR2	ODDR2_DRS_TAG_L (.Q(drs_tag_l), .C0(clk_33m_90), .C1(~clk_33m_90), .CE(1'b1), .D0(~DRS_CLKOUT_ENABLE[0]), .D1(1'b1), .R(1'b0), .S(1'b0));
	ODDR2	ODDR2_DRS_TAG_H (.Q(drs_tag_h), .C0(clk_ext40m), .C1(~clk_ext40m), .CE(1'b1), .D0(~DRS_CLKOUT_ENABLE[0]), .D1(1'b1), .R(1'b0), .S(1'b0));
	ODDR2	ODDR2_DRS_TAG_L (.Q(drs_tag_l), .C0(clk_ext40m), .C1(~clk_ext40m), .CE(1'b1), .D0(~DRS_CLKOUT_ENABLE[0]), .D1(1'b1), .R(1'b0), .S(1'b0));

	OBUFDS #(
		.IOSTANDARD("LVDS_25")
		) OBUFDS_DRSTAGH (
		.O(DRS_TAG_H_P),
		.OB(DRS_TAG_H_N),
		.I(drs_tag_h)
	);
	OBUFDS #(
		.IOSTANDARD("LVDS_25")
		) OBUFDS_DRSTAGL (
		.O(DRS_TAG_L_P),
		.OB(DRS_TAG_L_N),
		.I(drs_tag_l)
	);
	
//DRS_CAL timing calibration
	wire drs_cal[7:0];

	generate
		for(n=0;n<8;n=n+1) begin : DRS_CAL_GEN		
			ODDR2	ODDR2_DRS_CAL (.Q(drs_cal[n]), .C0(clk), .C1(~clk), .CE(1'b1), .D0(~DRS_CLKOUT_ENABLE[1]), .D1(1'b1), .R(1'b0), .S(1'b0));
			//ODDR2	ODDR2_DRA_CAL_T (.Q(drs_cal_t[n]), .C0(clk_133m), .C1(~clk_133m), .CE(1'b1), .D0(~DRS_CLKOUT_ENABLE[1]), .D1(~DRS_CLKOUT_ENABLE[1]), .R(1'b0), .S(1'b0));

			//OBUFTDS #(
			OBUFDS #(
				.IOSTANDARD("LVDS_25")
				) OBUFDS_DRSCAL (
				.O(DRS_CAL_P[n]),
				.OB(DRS_CAL_N[n]),
				.I(drs_cal[n])
				//.T(drs_cal_t[n])
			);
		end
	endgenerate


//TRIGGER Check--------------------------------
	wire drs_trig;
	wire drs_trigl0;
	wire drs_trigl1;
	wire drs_trigl1out;
	wire drs_trigl1out2;
`ifdef DIGITAL_TRIG
	assign drs_trigl0 = |dtrig_trig;
`else
	assign drs_trigl0 = 1'b0;
`endif
	assign drs_trigl1 = trigl1;
`ifdef ANALOG_TRIG
	assign drs_trigl1out = l1_out;
	assign drs_trigl1out2 = l1_out2;
`else
	assign drs_trigl1out = 1'b0;
	assign drs_trigl1out2 = 1'b0;
`endif

	wire drs_trig_ext;
`ifdef TESTBP
	assign drs_trig_ext = testbp_exttrg_bufo;
`else
	assign drs_trig_ext = 1'b0;
`endif


//pedestal trigger generator
	reg drs_trig_self;
	reg[29:0] drs_trig_c;

	always@(posedge clk_133m or posedge trig_rst) begin
		if(trig_rst) begin
			drs_trig_c <= 30'd0;	
			drs_trig_self <= 1'b0;
		end else begin
			if(drs_trig_c == TRIGGER_FREQ) begin
				drs_trig_self <= 1'b1;
				drs_trig_c <= drs_trig_c + 30'd1;
			end else if(drs_trig_c == (TRIGGER_FREQ + 30'd1)) begin
				drs_trig_self <= 1'b0;
				drs_trig_c <= 30'd0;
			end else begin
				drs_trig_c <= drs_trig_c + 30'd1;
			end
		end
	end

	assign drs_trig = 
		(TRIGGER_SELECT==8'd0) ? TRIGL1_async : 
		(TRIGGER_SELECT==8'd1) ? drs_trigl1out :
		(TRIGGER_SELECT==8'd2) ? drs_trig_self :
		(TRIGGER_SELECT==8'd3) ? TESTBP_EXTTRG_async :
		(TRIGGER_SELECT==8'd4) ? scb_tp_trig_ext :
		(TRIGGER_SELECT==8'd5) ? drs_trigl1 : 
		(TRIGGER_SELECT==8'd6) ? drs_trigl1out2 :
		(TRIGGER_SELECT==8'd7) ? drs_trigl0 : 
		(TRIGGER_SELECT==8'd8) ? drs_trig_ext : 1'b0;

	reg drs_dwrite_ir1;
	reg drs_dwrite_ir2;
	reg drs_dwrite_ir3;
	wire drs_dwrite_stop;
	wire drs_dwrite_start;
	assign drs_dwrite_stop = drs_dwrite_ir3 & ~drs_dwrite_ir2;
	assign drs_dwrite_start = ~drs_dwrite_ir3 & drs_dwrite_ir2;
	always@(posedge clk) begin
		drs_dwrite_ir1 <= DRS_DWRITE;
		drs_dwrite_ir2 <= drs_dwrite_ir1;
		drs_dwrite_ir3 <= drs_dwrite_ir2;
	end

//trigger & clock counter
	reg[31:0] drs_trig_counter_tmp;
	reg[63:0] drs_clock_counter_tmp;
	reg[31:0] TenMHz_counter_tmp;
	reg[15:0] PPS_counter_tmp;

	reg pps_ir1;
	reg pps_ir2;
	wire pps_tgl;
	assign pps_tgl = pps_ir1 & ~pps_ir2;

	always@(posedge clk_ext10m) begin
		pps_ir1 <= pps;
		pps_ir2 <= pps_ir1;
	end

	always@(posedge clk_ext10m or posedge rst_read) begin
		if(rst_read) begin
			TenMHz_counter_tmp <= 32'd0;
		end else begin
			if(pps_tgl) begin
				TenMHz_counter_tmp <= 32'd0;
			end else begin
				TenMHz_counter_tmp <= TenMHz_counter_tmp + 32'd1;
			end
		end
	end

	always@(posedge pps or posedge rst_read) begin
		if(rst_read) begin
			PPS_counter_tmp <= 16'd0;
		end else begin
			PPS_counter_tmp <= PPS_counter_tmp + 16'd1;
		end
	end

	/*
	always@(posedge clk_133m or posedge rst_read) begin
		if(rst_read) begin
			drs_trig_counter_tmp <= 32'd0;
		end else begin
			if(drs_trig) begin
				drs_trig_counter_tmp <= drs_trig_counter_tmp + 32'd1;
			end
		end
	end
	*/
	always@(posedge drs_trig or posedge rst_read) begin
		if(rst_read) begin
			drs_trig_counter_tmp <= 32'd0;
		end else begin
			drs_trig_counter_tmp <= drs_trig_counter_tmp + 32'd1;
		end
	end

	always@(posedge clk_133m or posedge rst_read) begin
		if(rst_read) begin
			drs_clock_counter_tmp <= 64'd0; //7.5nsec
		end else begin
			drs_clock_counter_tmp <= drs_clock_counter_tmp + 64'd1;
		end
	end

	reg[31:0] drs_trig_counter;
	reg[63:0] drs_clock_counter;
	reg[31:0] drs_event_counter;
	reg[31:0] TenMHz_counter;
	reg[15:0] PPS_counter;

	always@(posedge clk or posedge rst_read) begin
		if(rst_read) begin
			drs_trig_counter <= 32'd0;
			drs_clock_counter <= 64'd0;
			drs_event_counter <= 32'd0;
			TenMHz_counter <= 32'd0;
			PPS_counter <= 16'd0;
		end else begin
			if(drs_state == 4'd4 && drs_c == 11'd0) begin
				//if(DRS_DWRITE == 1'b0)begin
				if(drs_dwrite_stop)begin
					drs_trig_counter <= drs_trig_counter_tmp;
					drs_clock_counter <= drs_clock_counter_tmp;
					drs_event_counter <= drs_event_counter + 32'd1;
					TenMHz_counter <= TenMHz_counter_tmp;
					PPS_counter <= PPS_counter_tmp;
				end
			end
		end
	end


//drs state machine

	assign DRS_WSRIN = 1'd0;

	reg DRS_SRIN;
	reg[7:0] comDRS_SRCLK;
	reg[7:0] comDRS_A3;
	reg[7:0] comDRS_A2;
	reg[7:0] comDRS_A1;
	reg[7:0] comDRS_A0;
	
	reg[3:0] drs_state;
	reg[10:0] drs_c;
	reg drs_wsr_en;
	
	reg[63:0] drs_wsrcheck;
	reg[23:0] drs_stopch;

	reg led_check; //for debug


//drs state machine individual chip
	wire[7:0] indDRS_SRCLK;
	wire[7:0] indDRS_A3;
	wire[7:0] indDRS_A2;
	wire[7:0] indDRS_A1;
	wire[7:0] indDRS_A0;
	wire[7:0] inddrs_read_done;
	wire counterread_done;
	wire[7:0] DRS_RSRLOAD;

	assign DRS_SRCLK[7:0] = (drs_state==4'd5 ? indDRS_SRCLK[7:0] : comDRS_SRCLK[7:0] );
	assign DRS_A3[7:0] = (drs_state==4'd5 ? indDRS_A3[7:0]: comDRS_A3[7:0] );
	assign DRS_A2[7:0] = (drs_state==4'd5 ? indDRS_A2[7:0]: comDRS_A2[7:0] );
	assign DRS_A1[7:0] = (drs_state==4'd5 ? indDRS_A1[7:0]: comDRS_A1[7:0] );
	assign DRS_A0[7:0] = (drs_state==4'd5 ? indDRS_A0[7:0]: comDRS_A0[7:0] );


//trigger frequency offset	
	reg[15:0] trig_offset_c;
	reg[15:0] trig_offset_reg;
	reg[1:0] drs_dtapbuf;

	always@(posedge clk_133m or posedge rst_read) begin
		if(rst_read) begin
			trig_offset_c <= 16'd0;
			trig_offset_reg <= TRIGGER_FREQ_OFFSET;
			trig_rst <= 1'b1;
			drs_dtapbuf <= {DRS_DTAP[0],DRS_DTAP[0]};
		end else begin

			if(drs_state == 4'd4) begin
				drs_dtapbuf[1:0] <= {drs_dtapbuf[0],DRS_DTAP[0]};
			end else begin
				drs_dtapbuf <= {DRS_DTAP[0],DRS_DTAP[0]};
			end

			if(trig_offset_c == trig_offset_reg) begin
				if(trig_offset_reg != TRIGGER_FREQ_OFFSET) begin
					trig_rst <= 1'b1;
					trig_offset_reg <= TRIGGER_FREQ_OFFSET;
					trig_offset_c <= 16'd0;
				end else begin
					trig_rst <= 1'b0;
				end
			end else if(trig_offset_c == 16'd0) begin
				if(drs_state == 4'd4) begin
					if(DRS_WSROUT[0] & ( (drs_dtapbuf[1]&~drs_dtapbuf[0]) | (~drs_dtapbuf[1]&drs_dtapbuf[0]) ) ) begin
						trig_offset_c <= 16'd1;
					end
				end
			end else begin
					trig_offset_c <= trig_offset_c + 16'd1;
			end

		end
	end


//DRESET, DENABLE
	reg DRS_DENABLE;
	reg[7:0] DRS_RESETn;
	reg dreset_finish;
	reg[8:0] dreset_c;

	//always@(posedge clk or posedge rst) begin
	always@(posedge clk or posedge rst_read) begin
		//if(rst) begin
		if(rst_read) begin
			DRS_DENABLE <= 1'b0;
			DRS_RESETn <= 8'd0;
			dreset_c <= 9'd0;
			dreset_finish <= 1'b0;
		end else begin
			if(dreset_c == 9'd0) begin
				DRS_RESETn <= 8'd0;
				dreset_c <= dreset_c + 9'd1;
				dreset_finish <= 1'b0;
			//end else if(dreset_c == 9'd3) begin
			end else if(dreset_c == 9'd100) begin
				DRS_RESETn <= ~8'd0;
				dreset_c <= dreset_c + 9'd1;
			//end else if(dreset_c == 9'd4) begin
			end else if(dreset_c == 9'd200) begin
				DRS_DENABLE <= 1'b1;
				//dreset_finish <= 1'b1;
				dreset_c <= dreset_c + 9'd1;
			//end else if(dreset_c == 9'd201 || dreset_c == 9'd202) begin
			//	if(sec_66m) begin
			//		dreset_c <= dreset_c + 9'd1;
			//	end
			//end else if(dreset_c == 9'd7) begin
			//end else if(dreset_c == 9'd203) begin
			end else if(dreset_c == 9'd300) begin
				dreset_finish <= 1'b1;
				//if(drs_state == 4'd3) begin
				//	DRS_DENABLE <= 1'b1;
				//end
			end else begin
				//if(sec_66m) begin
					dreset_c <= dreset_c + 9'd1;
				//end
			end
		end
	end


//DWRITE 	
	wire rst_DRS_DWRITE_async;
	wire DRS_DWRITE_asyncen;
	reg DRS_DWRITE_async;
	reg rDRS_DWRITE;

	assign rst_DRS_DWRITE_async = ~( drs_state==4'd4 || drs_state==4'd7 || drs_state==4'd5 );
	assign DRS_DWRITE_asyncen = ( (drs_state==4'd4 || drs_state==4'd7) && ( TRIGGER_SELECT==8'd0 || TRIGGER_SELECT==8'd3 ) );
	//assign DRS_DWRITE_asyncen = ( (drs_state==4'd4 || drs_state==4'd7) && ( TRIGGER_SELECT==8'd0 || TRIGGER_SELECT==8'd3 || TRIGGER_SELECT==8'd8 ) );
	assign DRS_DWRITE = (DRS_DWRITE_asyncen ? DRS_DWRITE_async : rDRS_DWRITE);
	//assign DRS_DWRITE = rDRS_DWRITE;

	always@(posedge drs_trig or posedge rst_DRS_DWRITE_async) begin
		if(rst_DRS_DWRITE_async) begin
			DRS_DWRITE_async <= 1'b1;
		end else begin
			DRS_DWRITE_async <= 1'b0;
		end
	end

	reg[12:0] drs_dwrite_c;
	always@(posedge clk_133m or posedge rst_read) begin
	//always@(posedge clk or posedge rst_read) begin
		if(rst_read) begin
			rDRS_DWRITE <= 1'b0;
			drs_dwrite_c <= 13'd0;
		end else begin
			case(drs_state)
				
				4'd3:begin
					rDRS_DWRITE <= 1'b1;
					drs_dwrite_c <= 13'd0;
				end
				4'd4:begin
					if(DRS_DWRITE_asyncen==1'b1) begin
						rDRS_DWRITE <= 1'b0;
					end else if(drs_dwrite_c == 13'd0) begin
						if(drs_trig) begin
							drs_dwrite_c <= drs_dwrite_c + 13'd1;
						end
					end else if(drs_dwrite_c == 13'd1 + {2'd0,DRS_STOP_FROM_TRIG[10:0]}) begin
						rDRS_DWRITE <= 1'b0;
					end else begin
						drs_dwrite_c <= drs_dwrite_c + 13'd1;
					end
				end
				
			endcase
		end
	end


//BUSY
	reg drs_busy;
	OBUFDS #(
		.IOSTANDARD("LVDS_33")
	) OBUFDS_BUSY (
		.O(BP_BUSY_P),
		.OB(BP_BUSY_N),
		.I(drs_busy)
	);


//DRS4 state machine common
	always@(posedge clk or posedge rst_read) begin
		if(rst_read) begin
			DRS_SRIN <= 1'b1; //drs_srin must be high according to aono_san, but he does not know this reason
			comDRS_SRCLK <= 8'd0;
			//comDRS_A <= ~4'd0; //Disable all outputs (standby)
			comDRS_A3 <= ~8'd0; //Disable all outputs (standby)
			comDRS_A2 <= ~8'd0; 
			comDRS_A1 <= ~8'd0; 
			comDRS_A0 <= ~8'd0; 

			drs_state <= 4'd0;
			drs_c <= 11'd0;
			drs_wsr_en <= 1'b0;
			
			drs_wsrcheck <= 64'd0;
			
			drs_busy <= 1'b1;			
			led_check <= 1'b0;
		end else begin
			case(drs_state)
				4'd0:begin //initialize (wait for stable power supply)
					comDRS_A3 <= ~8'd0; //must: Address Read Shift Register
					comDRS_A2 <= 8'd0; //must
					comDRS_A1 <= ~8'd0; //must
					comDRS_A0 <= ~8'd0; //must
					if(dreset_finish) begin
						drs_state <= 4'd1;
					end
				end
				
				4'd1:begin //idle
					comDRS_A3 <= ~8'd0; //must: Address Read Shift Register
					comDRS_A2 <= 8'd0; //must
					comDRS_A1 <= ~8'd0; //must
					comDRS_A0 <= ~8'd0; //must

					comDRS_SRCLK <= 8'd0;
					DRS_SRIN <= 1'b0;

					if(drs_wsr_en == 1'b0) begin
						drs_state <= 4'd2;
					end else begin
						if(dac_en) begin
							drs_state <= 4'd3;
						end
					end
				end
			
				4'd2:begin //configure write shift register
					if(drs_c == 11'd0) begin
						//comDRS_A <= 4'b1101;
						comDRS_A3 <= ~8'd0; //Address Write Shift Register
						comDRS_A2 <= ~8'd0; 
						comDRS_A1 <= 8'd0;
						comDRS_A0 <= ~8'd0;
						drs_c <= drs_c + 11'd1;
					end else if(drs_c < 11'd9) begin
						comDRS_SRCLK <= ~comDRS_SRCLK;
						if(comDRS_SRCLK == 1'b0) begin

							if(DRS_CASCADENUM == 8'd1) begin
								// set to 8'b1111_1111
								if(drs_c == 11'd1) begin
									DRS_SRIN <= 1'b1;
								end
							end else if(DRS_CASCADENUM == 8'd2) begin
								if(drs_c == 11'd2 || drs_c == 11'd4 || drs_c == 11'd6 || drs_c == 11'd8) begin
									DRS_SRIN <= 1'b1;
								end else begin
									DRS_SRIN <= 1'b0;
								end
							end else begin
								// set to 8'b0001_0001
								if(drs_c == 11'd4 || drs_c == 11'd8) begin
									DRS_SRIN <= 1'b1;
								end else begin
									DRS_SRIN <= 1'b0;
								end
							end

						end else begin
							drs_c <= drs_c + 11'd1;
						end
					end else if(drs_c == 11'd9) begin
						comDRS_SRCLK <= 8'd0;
						DRS_SRIN <= 1'b0;
						drs_c <= 11'd0;
						drs_state <= 4'd1;
						drs_wsr_en <= 1'b1;
						//comDRS_A <= 4'b1011;
						comDRS_A3 <= ~8'd0; //Address Read Shift Register
						comDRS_A2 <= 8'd0; 
						comDRS_A1 <= ~8'd0;
						comDRS_A0 <= ~8'd0;
					end
				end
								
				4'd3:begin //start running
					comDRS_A3 <= ~8'd0; //Address Read Shift Register
					comDRS_A2 <= 8'd0; 
					comDRS_A1 <= ~8'd0; 
					comDRS_A0 <= ~8'd0; 
					comDRS_SRCLK <=8'd0;
					DRS_SRIN <= 1'b0;

					if(drs_c == 11'd0) begin
						//if(DRS_DWRITE == 1'b1) begin
						if(drs_dwrite_start) begin
							drs_c <= drs_c + 11'd1;
						end
					//end else if(drs_c == 11'd35) begin //0.5us waiting to charge full cells(this exists in the code for DRS4 Evaluation Board)
					end else if(drs_c == 11'd267) begin //4us
					//end else if(drs_c == 11'd3) begin
						//if(DRS_PLLLCK == 8'b1111_1111) begin
						if( (DRS_PLLLCK | ~DRS_PLLLCK_CHECK) == 8'b1111_1111) begin
							drs_state <= 4'd4;

							drs_busy <= 1'b0;

							drs_c <= 11'd0;								
						end
					end else begin
						drs_c <= drs_c + 11'd1;
					end
				end
				
				4'd4:begin //running
					comDRS_A3 <= ~8'd0; //Address Read Shift Register
					comDRS_A2 <= 8'd0; 
					comDRS_A1 <= ~8'd0; 
					comDRS_A0 <= ~8'd0; 
					comDRS_SRCLK <= 8'd0;
					DRS_SRIN <= 1'b0;

					/*
					if(DRS_DWRITE == 1'b0) begin
						drs_state <= 4'd7;
						drs_busy <= 1'b1;
					end
					*/

					if(drs_c==11'd0) begin
						//if(DRS_DWRITE==1'b0) begin
						if(drs_dwrite_stop) begin
							drs_c <= drs_c + 11'd1;
						end
					end else if(drs_c==11'd5) begin
						drs_state <= 4'd7;
						drs_busy <= 1'b1;
						drs_c <= 11'd0;
					end else begin
						drs_c <= drs_c + 11'd1;
					end
					
				end
				
				4'd5:begin //readout
					comDRS_A3 <= ~8'd0; //Address Read Shift Register
					comDRS_A2 <= 8'd0; 
					comDRS_A1 <= ~8'd0; 
					comDRS_A0 <= ~8'd0; 
					comDRS_SRCLK <= 8'd0;
					DRS_SRIN <= 1'b0;

					if(inddrs_read_done == 8'hFF && counterread_done == 1'b1) begin
						drs_state <= 4'd6;
					end
				end
		
				4'd6:begin //done
					drs_state <= 4'd1;

					comDRS_A3 <= ~8'd0; //Address Read Shift Register
					comDRS_A2 <= 8'd0; 
					comDRS_A1 <= ~8'd0; 
					comDRS_A0 <= ~8'd0; 
					comDRS_SRCLK <=8'd0;
					DRS_SRIN <= 1'b0;
					
					//drs_wsr_en <= 1'b0;
					led_check <= ~led_check;
				end
				
				4'd7:begin //check stop chennel
				
					if(drs_c == 11'd18) begin
						drs_c <= 11'd0;
						drs_state <= 4'd5;
					end else begin
						drs_c <= drs_c + 11'd1;					
					end
				
					if(drs_c == 11'd0) begin
						//comDRS_A <= 4'b1101;
						comDRS_A3 <= ~8'd0; //Address Write Shift Register
						comDRS_A2 <= ~8'd0; 
						comDRS_A1 <= 8'd0;
						comDRS_A0 <= ~8'd0;
					end else if(drs_c == 11'd17) begin
						//comDRS_A <= 4'b1011;
						comDRS_A3 <= ~8'd0; //Address Read Shift Register
						comDRS_A2 <= 8'd0; 
						comDRS_A1 <= ~8'd0;
						comDRS_A0 <= ~8'd0;
					end
					
					if(drs_c > 11'd0 && drs_c < 11'd17) begin
						comDRS_SRCLK <= ~comDRS_SRCLK;
					end else begin
						comDRS_SRCLK <= 8'd0;
					end
					
					if(DRS_SRCLK == 8'hFF) begin
						drs_wsrcheck[7:0] <= {drs_wsrcheck[6:0], DRS_SROUT[0]};
						drs_wsrcheck[15:8] <= {drs_wsrcheck[14:8], DRS_SROUT[1]};
						drs_wsrcheck[23:16] <= {drs_wsrcheck[22:16], DRS_SROUT[2]};
						drs_wsrcheck[31:24] <= {drs_wsrcheck[30:24], DRS_SROUT[3]};
						drs_wsrcheck[39:32] <= {drs_wsrcheck[38:32], DRS_SROUT[4]};
						drs_wsrcheck[47:40] <= {drs_wsrcheck[46:40], DRS_SROUT[5]};
						drs_wsrcheck[55:48] <= {drs_wsrcheck[54:48], DRS_SROUT[6]};
						drs_wsrcheck[63:56] <= {drs_wsrcheck[62:56], DRS_SROUT[7]};
					end

					if(DRS_CASCADENUM == 8'd1) begin
						// set to 8'b1111_1111
						if(drs_c == 11'd0) begin
							DRS_SRIN <= 1'b0;
						end else if(drs_c == 11'd1) begin
							DRS_SRIN <= 1'b1;					
						end else if(drs_c == 11'd17) begin
							DRS_SRIN <= 1'b0;
						end
					end else if(DRS_CASCADENUM == 8'd2) begin
						// set to 8'b0101_0101
						if(drs_c == 11'd0) begin
							DRS_SRIN <= 1'b0;
						end else if(drs_c == 11'd3 || drs_c == 11'd7 || drs_c == 11'd11 || drs_c == 11'd15) begin
							DRS_SRIN <= 1'b1;
						end else if(drs_c == 11'd5 || drs_c == 11'd9 || drs_c == 11'd13 || drs_c == 11'd17) begin
							DRS_SRIN <= 1'b0;
						end
					end else begin
						// set to 8'b0001_0001
						if(drs_c == 11'd0) begin
							DRS_SRIN <= 1'b0;
						end else if(drs_c == 11'd7 || drs_c == 11'd15) begin
							DRS_SRIN <= 1'b1;
						end else if(drs_c == 11'd9 || drs_c == 11'd17) begin
							DRS_SRIN <= 1'b0;
						end
					end

										
				end

			endcase

		end
	end

//wsrcheck
	generate
		for(m=0;m<8;m=m+1) begin : WSR_CHECK_GEN
			always@(posedge clk or posedge rst_read) begin
				if(rst_read) begin
					drs_stopch[m*3+2:m*3] <= 3'd0;
				end else begin
					if(drs_wsrcheck[m*8+7:m*8] == 8'b00010001) begin
						drs_stopch[m*3+2:m*3] <= 3'd0;
					end else if(drs_wsrcheck[m*8+7:m*8] == 8'b00100010) begin
						drs_stopch[m*3+2:m*3] <= 3'd1;
					end else if(drs_wsrcheck[m*8+7:m*8] == 8'b01000100) begin
						drs_stopch[m*3+2:m*3] <= 3'd2;
					end else if(drs_wsrcheck[m*8+7:m*8] == 8'b10001000) begin
						drs_stopch[m*3+2:m*3] <= 3'd3;

					end else if(drs_wsrcheck[m*8+7:m*8] == 8'b01010101) begin
						drs_stopch[m*3+2:m*3] <= 3'd0;
					end else if(drs_wsrcheck[m*8+7:m*8] == 8'b10101010) begin
						drs_stopch[m*3+2:m*3] <= 3'd1;

					end else begin
						drs_stopch[m*3+2:m*3] <= 3'd4;
					end
				end
			end
		end
	endgenerate

//--------------------------------------------
//AD9222

//sampling clock
	wire adc_clk;
	ODDR2	ODDR2_AD9222_CLK (.Q(adc_clk), .C0(clk_33m_90), .C1(~clk_33m_90), .CE(1'b1), .D0(1'b1), .D1(1'b0), .R(1'b0), .S(1'b0));

	OBUFDS #(
		.IOSTANDARD("LVDS_25")
	) OBUFDS_AD9222_CLK (
		.O(AD9222_CLK_P),
		.OB(AD9222_CLK_N),
		.I(adc_clk)
	);

//frame clock	
	wire adc_fco;
	wire adc_fcoddrout0;
	wire adc_fcoddrout1;
	reg adc_fcoddrout0_ir;
	reg adc_fcoddrout1_ir;
	reg adc_fcoddrout0_ir2;
	reg adc_fcoddrout1_ir2;

	always@(posedge adc_dco or posedge rst) begin
		if(rst) begin
			adc_fcoddrout0_ir <= 1'b0;
			adc_fcoddrout1_ir <= 1'b0;
			adc_fcoddrout0_ir2 <= 1'b0;
			adc_fcoddrout1_ir2 <= 1'b0;
		end else begin
			adc_fcoddrout0_ir <= adc_fcoddrout0;
			adc_fcoddrout1_ir <= adc_fcoddrout1;
			adc_fcoddrout0_ir2 <= adc_fcoddrout0_ir;
			adc_fcoddrout1_ir2 <= adc_fcoddrout1_ir;
		end
	end

	//IBUFGDS #(
	IBUFDS #(
		.DIFF_TERM("TRUE"),
		.IOSTANDARD("LVDS_25")
	) IBUFDS_AD9222_FCO (
		.O(adc_fco),
		.I(AD9222_FCO_P),
		.IB(AD9222_FCO_N)
	);

	IDDR2 #(
		.DDR_ALIGNMENT("C0"), // Sets output alignment to "NONE", "C0" or "C1"
		.INIT_Q0(1'b0), // Sets initial state of the Q0 output to 1'b0 or 1'b1
		.INIT_Q1(1'b0), // Sets initial state of the Q1 output to 1'b0 or 1'b1
		.SRTYPE("SYNC") // Specifies "SYNC" or "ASYNC" set/reset
	) IDDR2_ADCFCO (
		.Q0(adc_fcoddrout0), // 1-bit output captured with C0 clock
		.Q1(adc_fcoddrout1), // 1-bit output captured with C1 clock
		.C0(adc_ioclk2), // 1-bit clock input, clock region = TL
		.C1(adc_ioclk_inv2), // 1-bit clock input
		.CE(1'b1), // 1-bit clock enable input
		.D(adc_fco), // 1-bit DDR data input
		.R(rst), // 1-bit reset input
		.S(1'b0) // 1-bit set input
	);
	
//IDDR
	wire[7:0] adc_out;
	wire[7:0] adc_ddrout0;
	wire[7:0] adc_ddrout1;
	reg[7:0] adc_ddrout0_ir;
	reg[7:0] adc_ddrout1_ir;
	reg[7:0] adc_ddrout0_ir2;
	reg[7:0] adc_ddrout1_ir2;
	reg[23:0] adc_datbuf;
	reg[95:0] adc_datreg;

	always@(posedge adc_dco or posedge rst) begin
		if(rst) begin
			adc_ddrout0_ir <= 8'd0;
			adc_ddrout1_ir <= 8'd0;
			adc_ddrout0_ir2 <= 8'd0;
			adc_ddrout1_ir2 <= 8'd0;
		end else begin
			adc_ddrout0_ir <= adc_ddrout0;
			adc_ddrout1_ir <= adc_ddrout1;
			adc_ddrout0_ir2 <= adc_ddrout0_ir;
			adc_ddrout1_ir2 <= adc_ddrout1_ir;
		end
	end

	generate
		for(k=0;k<4;k=k+1) begin : ADC_IF_GEN_TR
		
			IBUFDS #(
				.DIFF_TERM("TRUE"),
				.IOSTANDARD("LVDS_25")
			) IBUFDS_AD9222_OUT (
				.O(adc_out[k]),
				.I(AD9222_OUT_P[k]),
				.IB(AD9222_OUT_N[k])
			);

			IDDR2 #(
				.DDR_ALIGNMENT("C0"), // Sets output alignment to "NONE", "C0" or "C1"
				.INIT_Q0(1'b0), // Sets initial state of the Q0 output to 1'b0 or 1'b1
				.INIT_Q1(1'b0), // Sets initial state of the Q1 output to 1'b0 or 1'b1
				.SRTYPE("SYNC") // Specifies "SYNC" or "ASYNC" set/reset
			) IDDR2_AD9222 (
				.Q0(adc_ddrout0[k]), // 1-bit output captured with C0 clock
				.Q1(adc_ddrout1[k]), // 1-bit output captured with C1 clock
				.C0(adc_ioclk), // 1-bit clock input
				.C1(adc_ioclk_inv), // 1-bit clock input
				.CE(1'b1), // 1-bit clock enable input
				.D(adc_out[k]), // 1-bit DDR data input
				.R(rst), // 1-bit reset input
				.S(1'b0) // 1-bit set input
			);

			always@(posedge adc_dco) begin //adc input buffer (parallel to serial converter)
				adc_datbuf[3*(k+1)-1:3*k] <= {adc_datbuf[3*k],adc_ddrout1_ir2[k],adc_ddrout0_ir2[k]};
				//adc_datbuf[3*(k+1)-1:3*k] <= {adc_datbuf[3*k],adc_ddrout1[k],adc_ddrout0[k]};
				adc_datreg[(12*k)+11:12*k] <= {adc_datreg[(12*k)+9:12*k],adc_datbuf[(3*k)+2:(3*k)+1]};
			end

		end
	endgenerate

	generate
		for(l=4;l<8;l=l+1) begin : ADC_IF_GEN_TL
		
			IBUFDS #(
				.DIFF_TERM("TRUE"),
				.IOSTANDARD("LVDS_25")
			) IBUFDS_AD9222_OUT (
				.O(adc_out[l]),
				.I(AD9222_OUT_P[l]),
				.IB(AD9222_OUT_N[l])
			);

			IDDR2 #(
				.DDR_ALIGNMENT("C0"), // Sets output alignment to "NONE", "C0" or "C1"
				.INIT_Q0(1'b0), // Sets initial state of the Q0 output to 1'b0 or 1'b1
				.INIT_Q1(1'b0), // Sets initial state of the Q1 output to 1'b0 or 1'b1
				.SRTYPE("SYNC") // Specifies "SYNC" or "ASYNC" set/reset
			) IDDR2_AD9222 (
				.Q0(adc_ddrout0[l]), // 1-bit output captured with C0 clock
				.Q1(adc_ddrout1[l]), // 1-bit output captured with C1 clock
				.C0(adc_ioclk2), // 1-bit clock input
				.C1(adc_ioclk_inv2), // 1-bit clock input
				.CE(1'b1), // 1-bit clock enable input
				.D(adc_out[l]), // 1-bit DDR data input
				.R(rst), // 1-bit reset input
				.S(1'b0) // 1-bit set input
			);

			always@(posedge adc_dco) begin //adc input buffer (parallel to serial converter)
				adc_datbuf[3*(l+1)-1:3*l] <= {adc_datbuf[3*l],adc_ddrout1_ir2[l],adc_ddrout0_ir2[l]};
				//adc_datbuf[3*(l+1)-1:3*l] <= {adc_datbuf[3*l],adc_ddrout1[l],adc_ddrout0[l]};
				adc_datreg[(12*l)+11:12*l] <= {adc_datreg[(12*l)+9:12*l],adc_datbuf[(3*l)+2:(3*l)+1]};
			end

		end
	endgenerate
	
//IDDR to FIFO
	reg[95:0] adc_dat;
	reg[2:0] adc_fcobuf;
	reg[11:0] adc_fcoall;

	reg adc_fco_flag_ir;
	reg[95:0] adc_datreg_ir;
	wire adc_fco_flag;
	assign adc_fco_flag = (adc_fcoall == 12'b111111000000);

	always@(posedge adc_dco) begin
		adc_fcobuf[2:0] <= {adc_fcobuf[0],adc_fcoddrout1_ir2,adc_fcoddrout0_ir2};
		adc_fcoall[11:0] <= {adc_fcoall[9:0],adc_fcobuf[2:1]};
	end
	

	always@(posedge adc_dco or posedge rst) begin
		if(rst) begin
			adc_fco_flag_ir <= 1'b0;
			adc_datreg_ir <= 96'd0;
			adc_dat[95:0] <= 96'd0;
			/*
			adc_fcobuf[2:0] <= 3'd0;
			adc_fcoall[11:0] <= 12'd0;
			adc_fco_flag_ir2 <= 1'b0;
			adc_fco_flag_ir3 <= 1'b0;
			adc_fco_flag_ir4 <= 1'b0;
			adc_datreg_ir2 <= 96'd0;
			adc_datreg_ir3 <= 96'd0;
			*/
		end else begin
			adc_fco_flag_ir <= adc_fco_flag;
			adc_datreg_ir <= adc_datreg;
			adc_dat[95:0] <= (adc_fco_flag_ir ? adc_datreg_ir[95:0] : adc_dat[95:0]);
			/*
			adc_fcobuf[2:0] <= {adc_fcobuf[0],adc_fcoddrout1,adc_fcoddrout0};
			adc_fcoall[11:0] <= {adc_fcoall[9:0],adc_fcobuf[2:1]};

			adc_fco_flag_ir2 <= adc_fco_flag_ir1;
			adc_fco_flag_ir3 <= adc_fco_flag_ir2;
			adc_fco_flag_ir4 <= adc_fco_flag_ir3;
			adc_datreg_ir1 <= adc_datreg;
			adc_datreg_ir2 <= adc_datreg_ir1;
			adc_datreg_ir3 <= adc_datreg_ir2;

			adc_dat[95:0] <= (adc_fco_flag_ir3 ? adc_datreg_ir3[95:0] : adc_dat[95:0]);
			*/
		end
	end

	wire[95:0] adc_dat_buffifoout;
	wire adc_buffifo_valid;
	wire adc_buffifo_rden;
	wire adc_buffifo_empty;
	wire adc_buffifo_full;
	wire adc_buffifo_progempty;
	//assign adc_buffifo_rden = ~TCP_TX_FULL & TCP_OPEN;
	assign adc_buffifo_rden = (test_valid_ir==16'd0 && adc_buffifo_valid==1'b0 && TCP_TX_FULL==1'b0) ? 1'b1 : 1'b0;
	ADC_BUF_FIFO adc_buf_fifo(
		//.rst(rst),
		.rst(rst_read),
		.wr_clk(adc_dco),
		//.rd_clk(clk),
		.rd_clk(clk_133m),
		.din(adc_dat[95:0]),
		//.wr_en(adc_fco_flag_ir),
		//.wr_en(adc_fco_flag_ir&adc_buffifo_empty),
		.wr_en(adc_fco_flag_ir&adc_buffifo_progempty),
		//.wr_en(adc_fco_flag_ir4),
		//.rd_en(int_clk_33m_90_tgl),
		.rd_en(adc_buffifo_rden),
		//.rd_en(1'b1),
		.dout(adc_dat_buffifoout[95:0]),
		//.dout(TCP_TX_DATA[7:0]),
		.full(adc_buffifo_full),
		.empty(adc_buffifo_empty),
		.valid(adc_buffifo_valid),
		//.valid(TCP_TX_WR)
		.prog_empty(adc_buffifo_progempty)
	);

	reg[127:0] test_dout_buf;
	reg[15:0] test_valid_ir;
	assign TCP_TX_WR = (test_valid_ir!=16'd0 && TCP_TX_FULL==1'b0);
	assign TCP_TX_DATA[7:0] = test_dout_buf[127:120];
	always@(posedge clk_133m or posedge rst_read) begin
		if(rst_read)begin
			test_dout_buf <= 128'd0;
			test_valid_ir <= 16'd0;
		end else begin
			if(TCP_TX_FULL==1'b0) begin
				test_dout_buf[127:0] <= adc_buffifo_valid ? 
					{4'd0,adc_dat_buffifoout[95:84],
					4'd0,adc_dat_buffifoout[83:72],
					4'd0,adc_dat_buffifoout[71:60],
					4'd0,adc_dat_buffifoout[59:48],
					4'd0,adc_dat_buffifoout[47:36],
					4'd0,adc_dat_buffifoout[35:24],
					4'd0,adc_dat_buffifoout[23:12],
					4'd0,adc_dat_buffifoout[11:0]} : {test_dout_buf[119:0],8'd0};
				test_valid_ir[15:0] <= {test_valid_ir[14:0],adc_buffifo_valid};
			end
		end
	end

	//assign adc_dat[95:0] = 96'h888777666555444333222111;

//--------------------------------------------
//FIFOs

	wire[7:0] dfifo_rdclk;
	wire[7:0] dfifo_rden;
	wire[7:0] dfifo_empty;
	wire[7:0] dfifo_valid;

	wire[63:0] dfifo_dout;
/*
	wire[7:0] dfifo_wr_clk;
	wire[127:0] dfifo_din;
	wire[7:0] dfifo_wr_en;
	wire[7:0] dfifo_progfull;

	DRS_FIFO drs_fifo_0(
		.rst(rst_read),
		.wr_clk(dfifo_wr_clk[0]),
		.rd_clk(dfifo_rdclk[0]),
		.din(dfifo_din[16*0+15:16*0]),
		.wr_en(dfifo_wr_en[0]),
		.rd_en(dfifo_rden[0]),
		.dout(dfifo_dout[8*0+7:8*0]),
		.full(),
		.empty(dfifo_empty[0]),
		.valid(dfifo_valid[0]),
		.prog_full(dfifo_progfull[0])
	);
*/

	//wire[31:0] drs_state_ind;
	//wire[111:0] drs_c_ind;
	generate
		for(i=0;i<8;i=i+1) begin : DRS_READ_GEN
			DRS_READ drs_read_i
			(
				.CLK(clk),
				.RST(rst_read),

				.DRS_STATE_COM(drs_state[3:0]),
				.DRS_READ_DONE_OUT(inddrs_read_done[i]),

				.DRS_CALREAD(DRS_CALREAD),
				.DRS_CASCADENUM(DRS_CASCADENUM[7:0]),
				.DRS_READDEPTH(DRS_READDEPTH[12:0]),
				.DRS_STOPCH(drs_stopch[3*i+1:3*i]),
				.INT_CLK_33M_90_TGL(int_clk_33m_90_tgl),

				.DRS_SRCLK(indDRS_SRCLK[i]),
				.DRS_A({indDRS_A3[i],indDRS_A2[i],indDRS_A1[i],indDRS_A0[i]}),
				.DRS_RSRLOAD(DRS_RSRLOAD[i]),
				.DRS_SROUT(DRS_SROUT[i]),

				.ADC_OUT(adc_dat_buffifoout[12*i+11:12*i]),
				.ADC_OUT_VALID(adc_buffifo_valid),

				.DFIFO_RD_CLK(dfifo_rdclk[i]),
				.DFIFO_RD_EN(dfifo_rden[i]),
				.DFIFO_DOUT(dfifo_dout[8*i+7:8*i]),
				.DFIFO_EMPTY(dfifo_empty[i]),
				.DFIFO_VALID(dfifo_valid[i])

				//.drs_state(drs_state_ind[4*i+3:4*i]),
				//.drs_c(drs_c_ind[14*i+13:14*i])

				//.DFIFO_WR_CLK(dfifo_wr_clk[i]),
				//.DFIFO_DIN(dfifo_din[16*i+15:16*i]),
				//.DFIFO_WR_EN(dfifo_wr_en[i])
				//.DFIFO_PROGFULL(dfifo_progfull[i])
			);

		end
	endgenerate

	wire cfifo_rdclk;
	wire cfifo_rden;
	wire[7:0] cfifo_dout;
	wire cfifo_empty;
	wire cfifo_valid;

	COUNTER_READ counter_read
	(
		.CLK(clk),
		.RST(rst_read),

		.DRS_STATE_COM(drs_state[3:0]),
		.DRS_EVENT_COUNTER(drs_event_counter[31:0]),
		.DRS_TRIG_COUNTER(drs_trig_counter[31:0]),
		.DRS_CLOCK_COUNTER(drs_clock_counter[63:0]),
		.TenMHz_COUNTER(TenMHz_counter[31:0]),
		.PPS_COUNTER(PPS_counter[15:0]),

		.COUNTERREAD_DONE(counterread_done),

		.CFIFO_RDCLK(cfifo_rdclk),
		.CFIFO_RDEN(cfifo_rden),
		.CFIFO_DOUT(cfifo_dout[7:0]),
		.CFIFO_EMPTY(cfifo_empty),
		.CFIFO_VALID(cfifo_valid)
	);

	wire sfifo_rden;
	wire sfifo_empty;
	assign sfifo_rden = ~sfifo_empty & ~TCP_TX_FULL & TCP_OPEN;

	DATA_FORMATTER data_formatter
	(
		.CLK(clk_133m),
		.RST(rst_read),
		
		.DRS_READDEPTH(DRS_READDEPTH[12:0]),

		.DFIFO_RDCLK(dfifo_rdclk[7:0]),
		.DFIFO_RDEN(dfifo_rden[7:0]),
		.DFIFO_EMPTY(dfifo_empty[7:0]),
		.DFIFO_VALID(dfifo_valid[7:0]),

		.DFIFO_DOUT0(dfifo_dout[7:0]),
		.DFIFO_DOUT1(dfifo_dout[15:8]),
		.DFIFO_DOUT2(dfifo_dout[23:16]),
		.DFIFO_DOUT3(dfifo_dout[31:24]),
		.DFIFO_DOUT4(dfifo_dout[39:32]),
		.DFIFO_DOUT5(dfifo_dout[47:40]),
		.DFIFO_DOUT6(dfifo_dout[55:48]),
		.DFIFO_DOUT7(dfifo_dout[63:56]),
		
		.CFIFO_RDCLK(cfifo_rdclk),
		.CFIFO_RDEN(cfifo_rden),
		.CFIFO_EMPTY(cfifo_empty),
		.CFIFO_VALID(cfifo_valid),

		.CFIFO_DOUT(cfifo_dout[7:0]),

		.SFIFO_RDCLK(clk_133m),
		//.SFIFO_RDEN(sfifo_rden),
		.SFIFO_RDEN(1'b0),
		//.SFIFO_DOUT(TCP_TX_DATA[7:0]),
		.SFIFO_DOUT(),
		.SFIFO_EMPTY(sfifo_empty),
		//.SFIFO_VALID(TCP_TX_WR)
		.SFIFO_VALID()
	);

//--------------------------------------------
//LED

	reg pps_check;
	always@(posedge pps or posedge rst) begin
		if(rst) begin
			pps_check <= 1'b0;
		end else begin
			pps_check <= ~pps_check;
		end
	end

	assign LED[0] = rst;
	assign LED[1] = extclk_locked;
	assign LED[2] = pps_check;
	assign LED[3] = led_check;

//--------------------------------------------
//DIP_SWITCH

	assign rst_sw = DIP_SWITCH[7];
	assign force_default_sw = DIP_SWITCH[6];
	//assign extclk_en_sw = DIP_SWITCH[5];

//--------------------------------------------
//SPI_IF remote configuration

	wire SPI_RBCP_ACT;
	wire SPI_RBCP_ACK;
	wire[7:0] SPI_RBCP_RD;
	wire RAM_RBCP_ACT;
	wire RAM_RBCP_ACK;
	wire[7:0] RAM_RBCP_RD;
	wire CS_M25P16_IF;
	wire SPI_PROGRAM;

	assign RBCP_ACK = SPI_RBCP_ACK | RAM_RBCP_ACK;
	assign RBCP_RD[7:0] = (SPI_RBCP_ACK ? SPI_RBCP_RD[7:0] : RAM_RBCP_RD[7:0]);
	assign SPI_PROGRAM_B = ~SPI_PROGRAM;
	assign CS_M25P16_IF   = (RBCP_ADDR[31:12]==20'd0);
	assign SPI_RBCP_ACT = (RBCP_ACT & CS_M25P16_IF);
	assign RAM_RBCP_ACT = (RBCP_ACT & ~CS_M25P16_IF);

	SPI_IF_drs spi_if_drs(
		.CLK           (clk_133m           ), // in : Clock
		.RST           (rst               ), // in : System reset
		// RBCP I/F
		.RBCP_ACT      (SPI_RBCP_ACT     ), // in : Active
		.RBCP_ADDR     (RBCP_ADDR[11:0]  ), // in : Address[11:0]
		.RBCP_WD       (RBCP_WD[7:0]     ), // in : Data[7:0]
		.RBCP_WE       (RBCP_WE          ), // in : Write enable
		.RBCP_RE       (RBCP_RE          ), // in : Read enable
		.RBCP_ACK      (SPI_RBCP_ACK     ), // out   : Access acknowledge
		.RBCP_RD       (SPI_RBCP_RD[7:0] ), // out   : Read data[7:0]
		// 
		.STS_REG04X    (8'd0    ), // in : General inputs
		.div_value     (2'd0),  // in  :
		.prog_start    (SPI_PROGRAM),  // out :
		.ledtgl        (led_check_c),
		// SPI I/F
		.SPI_SCK       (SPI_SCK          ), // out   : Clock
		.SPI_MISO      (SPI_MISO         ),  // in   : Serial data input
		.SPI_MOSI      (SPI_MOSI         ),  // out  : Serial data output
		.SPI_SS        (SPI_SS           )   // out  : Chip select
	);

//--------------------------------------------
//RBCP register

	wire[7:0] X00;
	wire[7:0] X01;
	wire[7:0] X02;
	wire[7:0] X03;
	wire[7:0] X04;
	wire[7:0] X05;
	wire[7:0] X06;
	wire[7:0] X07;
	wire[7:0] X08;
	wire[7:0] X09;
	wire[7:0] X0A;
	wire[7:0] X0B;
	wire[7:0] X0C;
	wire[7:0] X0D;
	wire[7:0] X0E;
	wire[7:0] X0F;

	wire[7:0] X10;
	wire[7:0] X11;
	wire[7:0] X12;
	wire[7:0] X13;
	wire[7:0] X14;
	wire[7:0] X15;
	wire[7:0] X16;
	wire[7:0] X17;
	wire[7:0] X18;
	wire[7:0] X19;
	wire[7:0] X1A;
	wire[7:0] X1B;
	wire[7:0] X1C;
	wire[7:0] X1D;
	wire[7:0] X1E;
	wire[7:0] X1F;

	wire[7:0] X20;
	wire[7:0] X21;
	wire[7:0] X22;
	wire[7:0] X23;
	wire[7:0] X24;
	wire[7:0] X25;
	wire[7:0] X26;
	wire[7:0] X27;
	wire[7:0] X28;
	wire[7:0] X29;
	wire[7:0] X2A;
	wire[7:0] X2B;
	wire[7:0] X2C;
	wire[7:0] X2D;
	wire[7:0] X2E;
	wire[7:0] X2F;

	wire[7:0] X30;
	wire[7:0] X31;
	wire[7:0] X32;
	wire[7:0] X33;
	wire[7:0] X34;
	wire[7:0] X35;
	wire[7:0] X36;
	wire[7:0] X37;
	wire[7:0] X38;
	wire[7:0] X39;
	wire[7:0] X3A;
	wire[7:0] X3B;
	wire[7:0] X3C;
	wire[7:0] X3D;
	wire[7:0] X3E;
	wire[7:0] X3F;

	wire[7:0] X40;
	wire[7:0] X41;
	wire[7:0] X42;
	wire[7:0] X43;
	wire[7:0] X44;
	wire[7:0] X45;
	wire[7:0] X46;
	wire[7:0] X47;
	wire[7:0] X48;
	wire[7:0] X49;
	wire[7:0] X4A;
	wire[7:0] X4B;
	wire[7:0] X4C;
	wire[7:0] X4D;
	wire[7:0] X4E;
	wire[7:0] X4F;

	wire[7:0] X50;
	wire[7:0] X51;
	wire[7:0] X52;
	wire[7:0] X53;
	wire[7:0] X54;
	wire[7:0] X55;
	wire[7:0] X56;
	wire[7:0] X57;
	wire[7:0] X58;
	wire[7:0] X59;
	wire[7:0] X5A;
	wire[7:0] X5B;
	wire[7:0] X5C;
	wire[7:0] X5D;
	wire[7:0] X5E;
	wire[7:0] X5F;

	wire[7:0] X60;
	wire[7:0] X61;
	wire[7:0] X62;
	wire[7:0] X63;
	wire[7:0] X64;
	wire[7:0] X65;
	wire[7:0] X66;
	wire[7:0] X67;
	wire[7:0] X68;
	wire[7:0] X69;
	wire[7:0] X6A;
	wire[7:0] X6B;
	wire[7:0] X6C;
	wire[7:0] X6D;
	wire[7:0] X6E;
	wire[7:0] X6F;

	wire[7:0] X70;
	wire[7:0] X71;
	wire[7:0] X72;
	wire[7:0] X73;
	wire[7:0] X74;
	wire[7:0] X75;
	wire[7:0] X76;
	wire[7:0] X77;
	wire[7:0] X78;
	wire[7:0] X79;
	wire[7:0] X7A;
	wire[7:0] X7B;
	wire[7:0] X7C;
	wire[7:0] X7D;
	wire[7:0] X7E;
	wire[7:0] X7F;

	wire[7:0] X80;
	wire[7:0] X81;
	wire[7:0] X82;
	wire[7:0] X83;
	wire[7:0] X84;
	wire[7:0] X85;
	wire[7:0] X86;
	wire[7:0] X87;
	wire[7:0] X88;
	wire[7:0] X89;
	wire[7:0] X8A;
	wire[7:0] X8B;
	wire[7:0] X8C;
	wire[7:0] X8D;
	wire[7:0] X8E;
	wire[7:0] X8F;
	
	wire[7:0] X90;
	wire[7:0] X91;
	wire[7:0] X92;
	wire[7:0] X93;
	wire[7:0] X94;
	wire[7:0] X95;
	wire[7:0] X96;
	wire[7:0] X97;
	wire[7:0] X98;
	wire[7:0] X99;
	wire[7:0] X9A;
	wire[7:0] X9B;
	wire[7:0] X9C;
	wire[7:0] X9D;
	wire[7:0] X9E;
	wire[7:0] X9F;

	wire[7:0] XA0;
	wire[7:0] XA1;
	wire[7:0] XA2;
	wire[7:0] XA3;
	wire[7:0] XA4;
	wire[7:0] XA5;
	wire[7:0] XA6;
	wire[7:0] XA7;
	wire[7:0] XA8;
	wire[7:0] XA9;
	wire[7:0] XAA;
	wire[7:0] XAB;
	wire[7:0] XAC;
	wire[7:0] XAD;
	wire[7:0] XAE;
	wire[7:0] XAF;

	wire[7:0] XB0;
	wire[7:0] XB1;
	wire[7:0] XB2;
	wire[7:0] XB3;
	wire[7:0] XB4;
	wire[7:0] XB5;
	wire[7:0] XB6;
	wire[7:0] XB7;
	wire[7:0] XB8;
	wire[7:0] XB9;
	wire[7:0] XBA;
	wire[7:0] XBB;
	wire[7:0] XBC;
	wire[7:0] XBD;
	wire[7:0] XBE;
	wire[7:0] XBF;

	wire[7:0] XC0;
	wire[7:0] XC1;
	wire[7:0] XC2;
	wire[7:0] XC3;
	wire[7:0] XC4;
	wire[7:0] XC5;
	wire[7:0] XC6;
	wire[7:0] XC7;
	wire[7:0] XC8;
	wire[7:0] XC9;
	wire[7:0] XCA;
	wire[7:0] XCB;
	wire[7:0] XCC;
	wire[7:0] XCD;
	wire[7:0] XCE;
	wire[7:0] XCF;

	RBCP_REG_drs rbcp_reg(
		.CLK(clk_133m),	// in	: System clock
		.RST(rst),	// in	: System reset
		.dacset_finish(dacset_finish), //in
		.scb_spisend_finish(scb_spisend_finish),
		.dtrigset_finish(dtrigset_finish),

		.l0_sc_write_done(l0_sc_write_done), //in
		.l0_sc_read_done(l0_sc_read_done), //in
		.l0_reset_done(l0_reset_done), //in
		.l0dela_set_done(l0dela_set_done), //in
		.l0dela_reset_done(l0dela_reset_done), //in
		.l1_sc_write_done(l1_sc_write_done), //in
		.l1_sc_read_done(l1_sc_read_done), //in
		.l1_reset_done(l1_reset_done), //in
		.bp_sc_write_done(bp_sc_write_done), //in
		.bp_fpgaprogram_done(bp_fpgaprogram_done), //in

		.sramwrite_finish(sramwrite_finish),
		.sramread_finish(sramread_finish),
		.adcspi_finish(adcspi_finish),
		
		// RBCP I/F
		.RBCP_ACT(RAM_RBCP_ACT),	// in	: Active
		.RBCP_ADDR(RBCP_ADDR[31:0]),	// in	: Address[31:0]
		.RBCP_WE(RBCP_WE),	// in	: Write enable
		.RBCP_WD(RBCP_WD[7:0]),	// in	: Write data[7:0]
		.RBCP_RE(RBCP_RE),	// in	: Read enable
		.RBCP_RD(RAM_RBCP_RD[7:0]),	// out	: Read data[7:0]
		.RBCP_ACK(RAM_RBCP_ACK),	// out	: Acknowledge
			
		// register	
		.X00Data(X00[7:0]), //in
		.X01Data(X01[7:0]), //in
		.X02Data(X02[7:0]), //in
		.X03Data(X03[7:0]), //in
		.X04Data(X04[7:0]), //in
		.X05Data(X05[7:0]), //in
		.X06Data(X06[7:0]), //in
		.X07Data(X07[7:0]), //in 
		.X08Data(X08[7:0]), //out : data in rbcp register 0x08
		.X09Data(X09[7:0]),
		.X0AData(X0A[7:0]),
		.X0BData(X0B[7:0]),
		.X0CData(X0C[7:0]),
		.X0DData(X0D[7:0]),
		.X0EData(X0E[7:0]),
		.X0FData(X0F[7:0]),

		.X10Data(X10[7:0]),
		.X11Data(X11[7:0]),
		.X12Data(X12[7:0]),
		.X13Data(X13[7:0]),
		.X14Data(X14[7:0]),
		.X15Data(X15[7:0]),
		.X16Data(X16[7:0]),
		.X17Data(X17[7:0]), 
		.X18Data(X18[7:0]),
		.X19Data(X19[7:0]),
		.X1AData(X1A[7:0]),
		.X1BData(X1B[7:0]),
		.X1CData(X1C[7:0]),
		.X1DData(X1D[7:0]),
		.X1EData(X1E[7:0]),
		.X1FData(X1F[7:0]),

		.X20Data(X20[7:0]),
		.X21Data(X21[7:0]),
		.X22Data(X22[7:0]),
		.X23Data(X23[7:0]),
		.X24Data(X24[7:0]),
		.X25Data(X25[7:0]),
		.X26Data(X26[7:0]),
		.X27Data(X27[7:0]), 
		.X28Data(X28[7:0]), //in
		.X29Data(X29[7:0]), //in
		.X2AData(X2A[7:0]), //in
		.X2BData(X2B[7:0]), //in
		.X2CData(X2C[7:0]), //in
		.X2DData(X2D[7:0]), //in
		.X2EData(X2E[7:0]), //in
		.X2FData(X2F[7:0]), //in

		.X30Data(X30[7:0]), //in
		.X31Data(X31[7:0]), //in
		.X32Data(X32[7:0]), //in
		.X33Data(X33[7:0]), //in
		.X34Data(X34[7:0]), //in
		.X35Data(X35[7:0]), //in
		.X36Data(X36[7:0]),
		.X37Data(X37[7:0]),
		.X38Data(X38[7:0]),
		.X39Data(X39[7:0]),
		.X3AData(X3A[7:0]),
		.X3BData(X3B[7:0]),
		.X3CData(X3C[7:0]),
		.X3DData(X3D[7:0]),
		.X3EData(X3E[7:0]),
		.X3FData(X3F[7:0]),

		.X40Data(X40[7:0]),
		.X41Data(X41[7:0]),
		.X42Data(X42[7:0]),
		.X43Data(X43[7:0]),
		.X44Data(X44[7:0]),
		.X45Data(X45[7:0]),
		.X46Data(X46[7:0]),
		.X47Data(X47[7:0]),
		.X48Data(X48[7:0]),
		.X49Data(X49[7:0]),
		.X4AData(X4A[7:0]), //in
		.X4BData(X4B[7:0]), //in
		.X4CData(X4C[7:0]), //in
		.X4DData(X4D[7:0]), //in
		.X4EData(X4E[7:0]), //in
		.X4FData(X4F[7:0]), //in

		.X50Data(X50[7:0]),
		.X51Data(X51[7:0]),
		.X52Data(X52[7:0]), 
		.X53Data(X53[7:0]), //in
		.X54Data(X54[7:0]), //in
		.X55Data(X55[7:0]), //in
		.X56Data(X56[7:0]),
		.X57Data(X57[7:0]),
		.X58Data(X58[7:0]),
		.X59Data(X59[7:0]), //in
		.X5AData(X5A[7:0]), //in
		.X5BData(X5B[7:0]), //in
		.X5CData(X5C[7:0]),
		.X5DData(X5D[7:0]),
		.X5EData(X5E[7:0]),
		.X5FData(X5F[7:0]),

		.X60Data(X60[7:0]),
		.X61Data(X61[7:0]),
		.X62Data(X62[7:0]),
		.X63Data(X63[7:0]),
		.X64Data(X64[7:0]), 
		.X65Data(X65[7:0]), //in
		.X66Data(X66[7:0]), //in
		.X67Data(X67[7:0]), //in
		.X68Data(X68[7:0]), //in
		.X69Data(X69[7:0]),
		.X6AData(X6A[7:0]),
		.X6BData(X6B[7:0]),
		.X6CData(X6C[7:0]),
		.X6DData(X6D[7:0]),
		.X6EData(X6E[7:0]),
		.X6FData(X6F[7:0]),

		.X70Data(X70[7:0]),
		.X71Data(X71[7:0]),
		.X72Data(X72[7:0]),
		.X73Data(X73[7:0]),
		.X74Data(X74[7:0]),
		.X75Data(X75[7:0]),
		.X76Data(X76[7:0]),
		.X77Data(X77[7:0]),
		.X78Data(X78[7:0]),
		.X79Data(X79[7:0]),
		.X7AData(X7A[7:0]),
		.X7BData(X7B[7:0]), //in
		.X7CData(X7C[7:0]), //in
		.X7DData(X7D[7:0]), //in
		.X7EData(X7E[7:0]), //in
		.X7FData(X7F[7:0]), //in

		.X80Data(X80[7:0]),
		.X81Data(X81[7:0]),
		.X82Data(X82[7:0]), 
		.X83Data(X83[7:0]), 
		.X84Data(X84[7:0]), 
		.X85Data(X85[7:0]), 
		.X86Data(X86[7:0]), 
		.X87Data(X87[7:0]), 
		.X88Data(X88[7:0]), 
		.X89Data(X89[7:0]), 
		.X8AData(X8A[7:0]), 
		.X8BData(X8B[7:0]), 
		.X8CData(X8C[7:0]), 
		.X8DData(X8D[7:0]), 
		.X8EData(X8E[7:0]), 
		.X8FData(X8F[7:0]), 
		
		.X90Data(X90[7:0]),
		.X91Data(X91[7:0]),
		.X92Data(X92[7:0]),
		.X93Data(X93[7:0]),
		.X94Data(X94[7:0]),
		.X95Data(X95[7:0]),
		.X96Data(X96[7:0]),
		.X97Data(X97[7:0]), 
		.X98Data(X98[7:0]), 
		.X99Data(X99[7:0]), 
		.X9AData(X9A[7:0]),
		.X9BData(X9B[7:0]),
		.X9CData(X9C[7:0]),
		.X9DData(X9D[7:0]), 
		.X9EData(X9E[7:0]), 
		.X9FData(X9F[7:0]), //in 
		
		.XA0Data(XA0[7:0]), 
		.XA1Data(XA1[7:0]), 
		.XA2Data(XA2[7:0]), 
		.XA3Data(XA3[7:0]), 
		.XA4Data(XA4[7:0]), 
		.XA5Data(XA5[7:0]), 
		.XA6Data(XA6[7:0]), 
		.XA7Data(XA7[7:0]), 
		.XA8Data(XA8[7:0]), 
		.XA9Data(XA9[7:0]), 
		.XAAData(XAA[7:0]), 
		.XABData(XAB[7:0]), 
		.XACData(XAC[7:0]), 
		.XADData(XAD[7:0]), 
		.XAEData(XAE[7:0]), 
		.XAFData(XAF[7:0]), 

		.XB0Data(XB0[7:0]), 
		.XB1Data(XB1[7:0]), 
		.XB2Data(XB2[7:0]), 
		.XB3Data(XB3[7:0]), 
		.XB4Data(XB4[7:0]), 
		.XB5Data(XB5[7:0]), 
		.XB6Data(XB6[7:0]), 
		.XB7Data(XB7[7:0]), //in 
		.XB8Data(XB8[7:0]), //in 
		.XB9Data(XB9[7:0]), //in 
		.XBAData(XBA[7:0]), //in 
		.XBBData(XBB[7:0]), //in 
		.XBCData(XBC[7:0]), //in 
		.XBDData(XBD[7:0]), //in 
		.XBEData(XBE[7:0]), //in 
		.XBFData(XBF[7:0]), //in 
		
		.XC0Data(XC0[7:0]), //in 
		.XC1Data(XC1[7:0]), //in 
		.XC2Data(XC2[7:0]), //in 
		.XC3Data(XC3[7:0]), //in 
		.XC4Data(XC4[7:0]), //in 
		.XC5Data(XC5[7:0]), //in 
		.XC6Data(XC6[7:0]), //in 
		.XC7Data(XC7[7:0]), 
		.XC8Data(XC8[7:0]),
		.XC9Data(XC9[7:0]),
		.XCAData(XCA[7:0]),
		.XCBData(XCB[7:0]),
		.XCCData(XCC[7:0]), 
		.XCDData(XCD[7:0]), 
		.XCEData(XCE[7:0]), 
		.XCFData(XCF[7:0])
	);

	assign {X00,X01} = FIRMWARE_VER;
	assign X02 = FIRMWARE_TRIGGER;
	assign X03 = DIP_SWITCH_READ;
	assign {X04,X05,X06,X07} = DEBUG_IN[31:0];
	//assign DEBUG_IN[31:0] = {8'd0,5'd0,drs_c[10:0],4'd0,drs_state[3:0]};
	assign DEBUG_IN[31:0] = {dfifo_empty[7:0],7'd0,cfifo_empty,7'd0,sfifo_empty,4'd0,drs_state[3:0]};
	//assign DEBUG_IN[31:0] = {inddrs_read_done[7:0],drs_c_ind[13:0],4'd0,drs_state_ind[3:0]};

	assign command_rst = (X08 == 8'hFF);

	assign DEBUG_PARAM = {X09[7:0],X0A[7:0]};

	assign TRIGGER_SELECT[7:0] = X0B[7:0];
	assign TRIGGER_FREQ = {X0C[5:0],X0D[7:0],X0E[7:0],X0F[7:0]};
	
	assign command_adcspi = (X10 == 8'hFF);
	assign ADC_SPI_DATA = X11[7:0];
	assign ADC_SPI_ADDR = {X12[4:0],X13[7:0]};

	assign command_dtrigset = (X20 == 8'hFF);
	assign DTRIG_THRESHOLD_0 = X21[7:0];
	assign DTRIG_THRESHOLD_1 = X22[7:0];
	assign DTRIG_THRESHOLD_2 = X23[7:0];
	assign DTRIG_THRESHOLD_3 = X24[7:0];
	assign DTRIG_THRESHOLD_4 = X25[7:0];
	assign DTRIG_THRESHOLD_5 = X26[7:0];
	assign DTRIG_THRESHOLD_6 = X27[7:0];
	assign {X28[7:0],X29[7:0]} = {IPR_0[15:0]};
	assign {X2A[7:0],X2B[7:0]} = {IPR_1[15:0]};
	assign {X2C[7:0],X2D[7:0]} = {IPR_2[15:0]};
	assign {X2E[7:0],X2F[7:0]} = {IPR_3[15:0]};
	assign {X30[7:0],X31[7:0]} = {IPR_4[15:0]};
	assign {X32[7:0],X33[7:0]} = {IPR_5[15:0]};
	assign {X34[7:0],X35[7:0]} = {IPR_6[15:0]};

	assign command_l0_sc_write = (X40 == 8'hFF);
	assign command_l0_sc_read = (X41 == 8'hFF);
	assign command_l0_reset = (X42 == 8'hFF);
	assign command_l0dela_set = (X43 == 8'hFF);
	assign command_l0dela_reset = (X44 == 8'hFF);
	assign command_l1_sc_write = (X45 == 8'hFF);
	assign command_l1_sc_read = (X46 == 8'hFF);
	assign command_l1_reset = (X47 == 8'hFF);
	assign RATE_WINDOW = {X48[7:0],X49[7:0]};
	assign {X4A[7:0],X4B[7:0]} = RATE_L1OUT;
	assign {X4C[7:0],X4D[7:0]} = RATE_L1OUT2;
	assign {X4E[7:0],X4F[7:0]} = RATE_TRIGL1;
	assign L0_SC_ADDRESS = X50[6:0];
	assign L0_SC_DATA = {X51[7:0],X52[7:0]};
	assign {X53[7:0],X54[7:0],X55[7:0]} = L0_SC_READ;
	assign L1_SC_ADDRESS = X56[6:0];
	assign L1_SC_DATA = {X57[7:0],X58[7:0]};
	assign {X59[7:0],X5A[7:0],X5B[7:0]} = L1_SC_READ;
	assign L0_DELAYEXPAND_DATA = {X5C[7:0],X5D[7:0],X5E[7:0]};

	assign command_bp_sc_write = (X60 == 8'hFF);
	assign BP_SC_SENDDATA[31:0] = {X61[7:0],X62[7:0],X63[7:0],X64[7:0]};
	assign {X65[7:0],X66[7:0],X67[7:0],X68[7:0]} = BP_SC_READ[31:0];
	assign command_bp_fpgaprogram = (X69 == 8'hFF);

	assign command_sramwrite = (X70 == 8'hFF);
	assign command_sramread = (X71 == 8'hFF);
	assign command_sramzz = (X72 == 8'hFF);
	assign SRAM_ADDR[18:0] = {X73[2:0],X74[7:0],X75[7:0]};
	assign SRAM_WRITEDATA[31:0] = {X76[7:0],X77[7:0],X78[7:0],X79[7:0]};
	assign SRAM_WRITEDATAP[3:0] = X7A[3:0];
	assign {X7B[7:0],X7C[7:0],X7D[7:0],X7E[7:0]} = SRAM_READDATA[31:0];
	assign X7F[7:0] = {4'd0,SRAM_READDATAP[3:0]};

	assign command_dacset = (X80 == 8'hFF);
	assign DAC_ROFS = {X81[7:0],X82[7:0]};
	assign DAC_OOFS = {X83[7:0],X84[7:0]};
	assign DAC_BIAS = {X85[7:0],X86[7:0]};
	assign DAC_CALP = {X87[7:0],X88[7:0]};
	assign DAC_CALN = {X89[7:0],X8A[7:0]};

//DRS4
	assign DRS_READDEPTH = {X90[4:0],X91[7:0]};
	assign DRS_STOP_FROM_TRIG = {X92[2:0],X93[7:0]};
	assign DRS_SAMP_FREQ = X94[7:0];
	assign DRS_READ_FROM_STOP = {X95[7:0], X96[7:0], X97[7:0], X98[7:0]};
	assign DRS_CLKOUT_ENABLE = X99[1:0];
	assign DRS_PLLLCK_CHECK = X9A[7:0];
	assign DRS_CALREAD = (X9B == 8'hFF);
	assign DRS_CASCADENUM = X9C[7:0];
	assign DRS_REFCLK_RESET = (X9D == 8'hFF);
	assign DRS_REFCLK_SELECT = X9E[7:0];
	assign X9F = {EXTCLK_ISLOCKED ? 8'h01 : 8'h00};
	
	assign command_scb_spisend = (XA0 == 8'hFF);
	assign command_tp_trig = (XA1 == 8'hFF);

	assign SCB_SPICMD[135:0] = {XA5[7:0],XA6[7:0],XA7[7:0],XA8[7:0],XA9[7:0],XAA[7:0],XAB[7:0],XAC[7:0],XAD[7:0],XAE[7:0],XAF[7:0],XB0[7:0],XB1[7:0],XB2[7:0],XB3[7:0],XB4[7:0],XB5[7:0]};
	assign SCB_SPILENGTH[7:0] = XB6[7:0];

	assign {XB7[7:0],XB8[7:0],XB9[7:0],XBA[7:0],XBB[7:0],XBC[7:0],XBD[7:0],XBE[7:0],XBF[7:0],XC0[7:0],XC1[7:0],XC2[7:0],XC3[7:0],XC4[7:0],XC5[7:0],XC6[7:0]} = SCB_SPIREAD[127:0];

	assign SCB_TP_TRIG_FREQ[29:0] = {XC7[5:0],XC8[7:0],XC9[7:0],XCA[7:0]};
	assign SCB_TP_TRIG_WIDTH[15:0] = {XCB[7:0],XCC[7:0]};
	assign TRIGGER_FREQ_OFFSET[15:0] = {XCD[7:0],XCE[7:0]};

endmodule
