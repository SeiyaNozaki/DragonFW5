/*******************************************************************************
*                                                                              *
* Module      : RBCP_REG                                                       *
* Version     : v 0.2.0 2010/03/31                                             *
*                                                                              *
* Description : Register file                                                  *
*                                                                              *
*                Copyright (c) 2010 Bee Beans Technologies Co.,Ltd.            *
*                All rights reserved                                           *
*                                                                              *
*******************************************************************************/
//rbcp register for dragon
//KONNO Yusuke, Kyoto univ.

`define BASE_ADDR 32'h0000_1000

`define TRIGGER_SELECT_DF 8'b00000001
`define TRIGGER_FREQ_DF 32'd444444 //300Hz 1count=7.5nsec
`define TRIGGER_ENABLE_DF 8'b00000001
`define DTRIG_THRESHOLD_DF 8'd16
`define RATE_WINDOW_DF 16'd1000 //msec
`define RATE_WINDOWL1_DF 16'd1000 //msec
`define DAC_ROFS_DF 16'd28835
`define DAC_OOFS_DF 16'd34078
`define DAC_BIAS_DF 16'd18350
`define DAC_CALP_DF 16'd20971
`define DAC_CALN_DF 16'd20971
`define DRS_READDEPTH_DF 11'd100
`define DRS_STOP_FROM_TRIG_DF 11'd512
`define DRS_DWRITE_TO_READY_DF 11'd273
`define DRS_SAMP_FREQ_DF 8'd67 //(roughly)1GHz
`define DRS_READ_FROM_STOP_DF 32'd0
`define DRS_PLLLCK_CHECK_DF 8'b1111_1111
`define DRS_CASCADENUM_DF 8'd4
`define SCB_TP_TRIG_FREQ_DF 30'd444444 //300Hz 1count=7.5nsec
`define SCB_TP_TRIG_WIDTH_DF 16'd3 //30nsec 1count=7.5nsec
`define TRIGGER_FREQ_OFFSET_DF 16'd10 

module RBCP_REG_drs(
	// System
	CLK,			// in	: System clock
	RST,			// in	: System reset
	
	dacset_finish, // in : dac finish flag
	scb_spisend_finish, //in
	dtrigset_finish, //in

	l0_sc_write_done,
	l0_sc_read_done,
	l0_reset_done,
	l0dela_set_done,
	l0dela_reset_done,
	l1_sc_write_done,
	l1_sc_read_done,
	l1_reset_done,
	bp_sc_write_done,
	bp_fpgaprogram_done,

	sramwrite_finish, //in
	sramread_finish, //in
	adcspi_finish, //in
	
	// RBCP I/F
	RBCP_ACT,	// in	: Active
	RBCP_ADDR,	// in	: Address[31:0]
	RBCP_WE,		// in	: Write enable
	RBCP_WD,		// in	: Write data[7:0]
	RBCP_RE,		// in	: Read enable
	RBCP_RD,		// out	: Read data[7:0]
	RBCP_ACK, 	// out	: Acknowledge
		
	X00Data,
	X01Data,
	X02Data,
	X03Data,
	X04Data,
	X05Data,
	X06Data,
	X07Data,
	X08Data, 	// data in rbcp register
	X09Data,
	X0AData,
	X0BData,
	X0CData,
	X0DData,
	X0EData,
	X0FData,

	X10Data,
	X11Data,
	X12Data,
	X13Data,
	X14Data,
	X15Data,
	X16Data,
	X17Data,
	X18Data,
	X19Data,
	X1AData,
	X1BData,
	X1CData,
	X1DData,
	X1EData,
	X1FData,

	X20Data,
	X21Data,
	X22Data,
	X23Data,
	X24Data,
	X25Data,
	X26Data,
	X27Data,
	X28Data,
	X29Data,
	X2AData,
	X2BData,
	X2CData,
	X2DData,
	X2EData,
	X2FData,

	X30Data,
	X31Data,
	X32Data,
	X33Data,
	X34Data,
	X35Data,
	X36Data,
	X37Data,
	X38Data,
	X39Data,
	X3AData,
	X3BData,
	X3CData,
	X3DData,
	X3EData,
	X3FData,

	X40Data,
	X41Data,
	X42Data,
	X43Data,
	X44Data,
	X45Data,
	X46Data,
	X47Data,
	X48Data,
	X49Data,
	X4AData,
	X4BData,
	X4CData,
	X4DData,
	X4EData,
	X4FData,

	X50Data,
	X51Data,
	X52Data,
	X53Data,
	X54Data,
	X55Data,
	X56Data,
	X57Data,
	X58Data,
	X59Data,
	X5AData,
	X5BData,
	X5CData,
	X5DData,
	X5EData,
	X5FData,

	X60Data,
	X61Data,
	X62Data,
	X63Data,
	X64Data,
	X65Data,
	X66Data,
	X67Data,
	X68Data,
	X69Data,
	X6AData,
	X6BData,
	X6CData,
	X6DData,
	X6EData,
	X6FData,

	X70Data,
	X71Data,
	X72Data,
	X73Data,
	X74Data,
	X75Data,
	X76Data,
	X77Data,
	X78Data,
	X79Data,
	X7AData,
	X7BData,
	X7CData,
	X7DData,
	X7EData,
	X7FData,
	
	X80Data,
	X81Data,
	X82Data,
	X83Data,
	X84Data,
	X85Data,
	X86Data,
	X87Data,
	X88Data,
	X89Data,
	X8AData,
	X8BData,
	X8CData,
	X8DData,
	X8EData,
	X8FData,

	X90Data,
	X91Data,
	X92Data,
	X93Data,
	X94Data,
	X95Data,
	X96Data,
	X97Data,
	X98Data,
	X99Data,
	X9AData,
	X9BData,
	X9CData,
	X9DData,
	X9EData,
	X9FData,
	
	XA0Data,
	XA1Data,
	XA2Data,
	XA3Data,
	XA4Data,
	XA5Data,
	XA6Data,
	XA7Data,
	XA8Data,
	XA9Data,
	XAAData,
	XABData,
	XACData,
	XADData,
	XAEData,
	XAFData,

	XB0Data,
	XB1Data,
	XB2Data,
	XB3Data,
	XB4Data,
	XB5Data,
	XB6Data,
	XB7Data,
	XB8Data,
	XB9Data,
	XBAData,
	XBBData,
	XBCData,
	XBDData,
	XBEData,
	XBFData,

	XC0Data,
	XC1Data,
	XC2Data,
	XC3Data,
	XC4Data,
	XC5Data,
	XC6Data,
	XC7Data,
	XC8Data,
	XC9Data,
	XCAData,
	XCBData,
	XCCData,
	XCDData,
	XCEData,
	XCFData
);

//-------- Input/Output -------------
	input			CLK;
	input			RST;

	input dacset_finish;
	input scb_spisend_finish;
	input dtrigset_finish;

	input l0_sc_write_done;
	input l0_sc_read_done;
	input l0_reset_done;
	input l0dela_set_done;
	input l0dela_reset_done;
	input l1_sc_write_done;
	input l1_sc_read_done;
	input l1_reset_done;
	input bp_sc_write_done;
	input bp_fpgaprogram_done;

	input sramwrite_finish;
	input sramread_finish;
	input adcspi_finish;

	input			RBCP_ACT;
	input[31:0]	RBCP_ADDR;
	input			RBCP_WE;
	input[7:0]	RBCP_WD;
	input			RBCP_RE;
	output[7:0]	RBCP_RD;
	output		RBCP_ACK;
		
	input[7:0] X00Data;
	input[7:0] X01Data;
	input[7:0] X02Data;
	input[7:0] X03Data;
	input[7:0] X04Data;
	input[7:0] X05Data;
	input[7:0] X06Data;
	input[7:0] X07Data;
	output[7:0] X08Data;
	output[7:0] X09Data;
	output[7:0] X0AData;
	output[7:0] X0BData;
	output[7:0] X0CData;
	output[7:0] X0DData;
	output[7:0] X0EData;
	output[7:0] X0FData;

	output[7:0] X10Data;
	output[7:0] X11Data;
	output[7:0] X12Data;
	output[7:0] X13Data;
	output[7:0] X14Data;
	output[7:0] X15Data;
	output[7:0] X16Data;
	output[7:0] X17Data;
	output[7:0] X18Data;
	output[7:0] X19Data;
	output[7:0] X1AData;
	output[7:0] X1BData;
	output[7:0] X1CData;
	output[7:0] X1DData;
	output[7:0] X1EData;
	input[7:0] X1FData;

	output[7:0] X20Data;
	output[7:0] X21Data;
	output[7:0] X22Data;
	output[7:0] X23Data;
	output[7:0] X24Data;
	output[7:0] X25Data;
	output[7:0] X26Data;
	output[7:0] X27Data;
	input[7:0] X28Data;
	input[7:0] X29Data;
	input[7:0] X2AData;
	input[7:0] X2BData;
	input[7:0] X2CData;
	input[7:0] X2DData;
	input[7:0] X2EData;
	input[7:0] X2FData;

	input[7:0] X30Data;
	input[7:0] X31Data;
	input[7:0] X32Data;
	input[7:0] X33Data;
	input[7:0] X34Data;
	input[7:0] X35Data;
	output[7:0] X36Data;
	output[7:0] X37Data;
	output[7:0] X38Data;
	output[7:0] X39Data;
	output[7:0] X3AData;
	output[7:0] X3BData;
	output[7:0] X3CData;
	output[7:0] X3DData;
	output[7:0] X3EData;
	output[7:0] X3FData;

	output[7:0] X40Data;
	output[7:0] X41Data;
	output[7:0] X42Data;
	output[7:0] X43Data;
	output[7:0] X44Data;
	output[7:0] X45Data;
	output[7:0] X46Data;
	output[7:0] X47Data;
	output[7:0] X48Data;
	output[7:0] X49Data;
	input[7:0] X4AData;
	input[7:0] X4BData;
	input[7:0] X4CData;
	input[7:0] X4DData;
	input[7:0] X4EData;
	input[7:0] X4FData;

	output[7:0] X50Data;
	output[7:0] X51Data;
	output[7:0] X52Data;
	input[7:0] X53Data;
	input[7:0] X54Data;
	input[7:0] X55Data;
	output[7:0] X56Data;
	output[7:0] X57Data;
	output[7:0] X58Data;
	input[7:0] X59Data;
	input[7:0] X5AData;
	input[7:0] X5BData;
	output[7:0] X5CData;
	output[7:0] X5DData;
	output[7:0] X5EData;
	output[7:0] X5FData;

	output[7:0] X60Data;
	output[7:0] X61Data;
	output[7:0] X62Data;
	output[7:0] X63Data;
	output[7:0] X64Data;
	input[7:0] X65Data;
	input[7:0] X66Data;
	input[7:0] X67Data;
	input[7:0] X68Data;
	output[7:0] X69Data;
	output[7:0] X6AData;
	output[7:0] X6BData;
	output[7:0] X6CData;
	output[7:0] X6DData;
	output[7:0] X6EData;
	output[7:0] X6FData;

	output[7:0] X70Data;
	output[7:0] X71Data;
	output[7:0] X72Data;
	output[7:0] X73Data;
	output[7:0] X74Data;
	output[7:0] X75Data;
	output[7:0] X76Data;
	output[7:0] X77Data;
	output[7:0] X78Data;
	output[7:0] X79Data;
	output[7:0] X7AData;
	input[7:0] X7BData;
	input[7:0] X7CData;
	input[7:0] X7DData;
	input[7:0] X7EData;
	input[7:0] X7FData;
	
	output[7:0] X80Data;
	output[7:0] X81Data;
	output[7:0] X82Data;
	output[7:0] X83Data;
	output[7:0] X84Data;
	output[7:0] X85Data;
	output[7:0] X86Data;
	output[7:0] X87Data;
	output[7:0] X88Data;
	output[7:0] X89Data;
	output[7:0] X8AData;
	output[7:0] X8BData;
	output[7:0] X8CData;
	output[7:0] X8DData;
	output[7:0] X8EData;
	output[7:0] X8FData;
	
	output[7:0] X90Data;
	output[7:0] X91Data;
	output[7:0] X92Data;
	output[7:0] X93Data;
	output[7:0] X94Data;
	output[7:0] X95Data;
	output[7:0] X96Data;
	output[7:0] X97Data;
	output[7:0] X98Data;
	output[7:0] X99Data;
	output[7:0] X9AData;
	output[7:0] X9BData;
	output[7:0] X9CData;
	output[7:0] X9DData;
	output[7:0] X9EData;
	input[7:0] X9FData;

	output[7:0] XA0Data;
	output[7:0] XA1Data;
	output[7:0] XA2Data;
	output[7:0] XA3Data;
	output[7:0] XA4Data;
	output[7:0] XA5Data;
	output[7:0] XA6Data;
	output[7:0] XA7Data;
	output[7:0] XA8Data;
	output[7:0] XA9Data;
	output[7:0] XAAData;
	output[7:0] XABData;
	output[7:0] XACData;
	output[7:0] XADData;
	output[7:0] XAEData;
	output[7:0] XAFData;

	output[7:0] XB0Data;
	output[7:0] XB1Data;
	output[7:0] XB2Data;
	output[7:0] XB3Data;
	output[7:0] XB4Data;
	output[7:0] XB5Data;
	output[7:0] XB6Data;
	input[7:0] XB7Data;
	input[7:0] XB8Data;
	input[7:0] XB9Data;
	input[7:0] XBAData;
	input[7:0] XBBData;
	input[7:0] XBCData;
	input[7:0] XBDData;
	input[7:0] XBEData;
	input[7:0] XBFData;

	input[7:0] XC0Data;
	input[7:0] XC1Data;
	input[7:0] XC2Data;
	input[7:0] XC3Data;
	input[7:0] XC4Data;
	input[7:0] XC5Data;
	input[7:0] XC6Data;
	output[7:0] XC7Data;
	output[7:0] XC8Data;
	output[7:0] XC9Data;
	output[7:0] XCAData;
	output[7:0] XCBData;
	output[7:0] XCCData;
	output[7:0] XCDData;
	output[7:0] XCEData;
	output[7:0] XCFData;

//------------------------------------------------------------------------------
//	Control
//------------------------------------------------------------------------------
	reg[31:0]	irAddr;
	reg			irWe;
	reg[7:0]		irWd;
	reg			irRe;

	always@ (posedge CLK or posedge RST) begin
		if(RST)begin
			irAddr[31:0]	<= 32'd0;
			irWe				<= 1'b0;
			irWd[7:0]		<= 8'd0;
			irRe				<= 1'b0;
		end else begin
			irAddr[31:0]	<= RBCP_ADDR[31:0];
			irWe				<= RBCP_WE;
			irWd[7:0]		<= RBCP_WD[7:0];
			irRe				<= RBCP_RE;
		end
	end

	reg			regCs;
	reg[23:0]	regAddr;
	reg[7:0]		regWd;
	reg			regWe;
	reg			regRe;

	always@ (posedge CLK) begin
		//regCs				<= (irAddr[31:8]==25'd0);
		regCs				<= ( (irAddr[31:0] & 32'hFFFF_FF00)==`BASE_ADDR);

		regAddr[23:0]	<= (irWe | irRe ? irAddr[23:0] : regAddr[23:0]);
		regWd[7:0]		<= (irWe        ? irWd[7:0]    : regWd[7:0]   );
		regWe				<= irWe;
		regRe				<= irRe;
	end

//------------------------------------------------------------------------------
//	Registers
//------------------------------------------------------------------------------
	reg[8'hCF:8]	regBe;

	always@ (posedge CLK or posedge RST) begin
		if(RST) begin
			regBe[207:8] <= 200'd0;
		end else begin
			regBe[regAddr[7:0]]	<= regCs & regWe;
		end
	end

//--------------------------------------
//	Register file
//--------------------------------------
	reg[7:0] regX08Data;
	reg[7:0] regX09Data;
	reg[7:0] regX0AData;
	reg[7:0] regX0BData;
	reg[7:0] regX0CData;
	reg[7:0] regX0DData;
	reg[7:0] regX0EData;
	reg[7:0] regX0FData;

	reg[7:0] regX10Data;
	reg[7:0] regX11Data;
	reg[7:0] regX12Data;
	reg[7:0] regX13Data;
	reg[7:0] regX14Data;
	reg[7:0] regX15Data;
	reg[7:0] regX16Data;
	reg[7:0] regX17Data;
	reg[7:0] regX18Data;
	reg[7:0] regX19Data;
	reg[7:0] regX1AData;
	reg[7:0] regX1BData;
	reg[7:0] regX1CData;
	reg[7:0] regX1DData;
	reg[7:0] regX1EData;
	//reg[7:0] regX1FData;

	reg[7:0] regX20Data;
	reg[7:0] regX21Data;
	reg[7:0] regX22Data;
	reg[7:0] regX23Data;
	reg[7:0] regX24Data;
	reg[7:0] regX25Data;
	reg[7:0] regX26Data;
	reg[7:0] regX27Data;
	//reg[7:0] regX28Data;
	//reg[7:0] regX29Data;
	//reg[7:0] regX2AData;
	//reg[7:0] regX2BData;
	//reg[7:0] regX2CData;
	//reg[7:0] regX2DData;
	//reg[7:0] regX2EData;
	//reg[7:0] regX2FData;

	//reg[7:0] regX30Data;
	//reg[7:0] regX31Data;
	//reg[7:0] regX32Data;
	//reg[7:0] regX33Data;
	//reg[7:0] regX34Data;
	//reg[7:0] regX35Data;
	reg[7:0] regX36Data;
	reg[7:0] regX37Data;
	reg[7:0] regX38Data;
	reg[7:0] regX39Data;
	reg[7:0] regX3AData;
	reg[7:0] regX3BData;
	reg[7:0] regX3CData;
	reg[7:0] regX3DData;
	reg[7:0] regX3EData;
	reg[7:0] regX3FData;

	reg[7:0] regX40Data;
	reg[7:0] regX41Data;
	reg[7:0] regX42Data;
	reg[7:0] regX43Data;
	reg[7:0] regX44Data;
	reg[7:0] regX45Data;
	reg[7:0] regX46Data;
	reg[7:0] regX47Data;
	reg[7:0] regX48Data;
	reg[7:0] regX49Data;
	//reg[7:0] regX4AData;
	//reg[7:0] regX4BData;
	//reg[7:0] regX4CData;
	//reg[7:0] regX4DData;
	//reg[7:0] regX4EData;
	//reg[7:0] regX4FData;

	reg[7:0] regX50Data;
	reg[7:0] regX51Data;
	reg[7:0] regX52Data;
	//reg[7:0] regX53Data;
	//reg[7:0] regX54Data;
	//reg[7:0] regX55Data;
	reg[7:0] regX56Data;
	reg[7:0] regX57Data;
	reg[7:0] regX58Data;
	//reg[7:0] regX59Data;
	//reg[7:0] regX5AData;
	//reg[7:0] regX5BData;
	reg[7:0] regX5CData;
	reg[7:0] regX5DData;
	reg[7:0] regX5EData;
	reg[7:0] regX5FData;

	reg[7:0] regX60Data;
	reg[7:0] regX61Data;
	reg[7:0] regX62Data;
	reg[7:0] regX63Data;
	reg[7:0] regX64Data;
	//reg[7:0] regX65Data;
	//reg[7:0] regX66Data;
	//reg[7:0] regX67Data;
	//reg[7:0] regX68Data;
	reg[7:0] regX69Data;
	reg[7:0] regX6AData;
	reg[7:0] regX6BData;
	reg[7:0] regX6CData;
	reg[7:0] regX6DData;
	reg[7:0] regX6EData;
	reg[7:0] regX6FData;

	reg[7:0] regX70Data;
	reg[7:0] regX71Data;
	reg[7:0] regX72Data;
	reg[7:0] regX73Data;
	reg[7:0] regX74Data;
	reg[7:0] regX75Data;
	reg[7:0] regX76Data;
	reg[7:0] regX77Data;
	reg[7:0] regX78Data;
	reg[7:0] regX79Data;
	reg[7:0] regX7AData;
	//reg[7:0] regX7BData;
	//reg[7:0] regX7CData;
	//reg[7:0] regX7DData;
	//reg[7:0] regX7EData;
	//reg[7:0] regX7FData;

	reg[7:0] regX80Data;
	reg[7:0] regX81Data;
	reg[7:0] regX82Data;
	reg[7:0] regX83Data;
	reg[7:0] regX84Data;
	reg[7:0] regX85Data;
	reg[7:0] regX86Data;
	reg[7:0] regX87Data;
	reg[7:0] regX88Data;
	reg[7:0] regX89Data;
	reg[7:0] regX8AData;
	reg[7:0] regX8BData;
	reg[7:0] regX8CData;
	reg[7:0] regX8DData;
	reg[7:0] regX8EData;
	reg[7:0] regX8FData;
	
	reg[7:0] regX90Data;
	reg[7:0] regX91Data;
	reg[7:0] regX92Data;
	reg[7:0] regX93Data;
	reg[7:0] regX94Data;
	reg[7:0] regX95Data;
	reg[7:0] regX96Data;
	reg[7:0] regX97Data;
	reg[7:0] regX98Data;
	reg[7:0] regX99Data;
	reg[7:0] regX9AData;
	reg[7:0] regX9BData;
	reg[7:0] regX9CData;
	reg[7:0] regX9DData;
	reg[7:0] regX9EData;
	//reg[7:0] regX9FData;

	reg[7:0] regXA0Data;
	reg[7:0] regXA1Data;
	reg[7:0] regXA2Data;
	reg[7:0] regXA3Data;
	reg[7:0] regXA4Data;
	reg[7:0] regXA5Data;
	reg[7:0] regXA6Data;
	reg[7:0] regXA7Data;
	reg[7:0] regXA8Data;
	reg[7:0] regXA9Data;
	reg[7:0] regXAAData;
	reg[7:0] regXABData;
	reg[7:0] regXACData;
	reg[7:0] regXADData;
	reg[7:0] regXAEData;
	reg[7:0] regXAFData;

	reg[7:0] regXB0Data;
	reg[7:0] regXB1Data;
	reg[7:0] regXB2Data;
	reg[7:0] regXB3Data;
	reg[7:0] regXB4Data;
	reg[7:0] regXB5Data;
	reg[7:0] regXB6Data;
	//reg[7:0] regXB7Data;
	//reg[7:0] regXB8Data;
	//reg[7:0] regXB9Data;
	//reg[7:0] regXBAData;
	//reg[7:0] regXBBData;
	//reg[7:0] regXBCData;
	//reg[7:0] regXBDData;
	//reg[7:0] regXBEData;
	//reg[7:0] regXBFData;

	//reg[7:0] regXC0Data;
	//reg[7:0] regXC1Data;
	//reg[7:0] regXC2Data;
	//reg[7:0] regXC3Data;
	//reg[7:0] regXC4Data;
	//reg[7:0] regXC5Data;
	//reg[7:0] regXC6Data;
	reg[7:0] regXC7Data;
	reg[7:0] regXC8Data;
	reg[7:0] regXC9Data;
	reg[7:0] regXCAData;
	reg[7:0] regXCBData;
	reg[7:0] regXCCData;
	reg[7:0] regXCDData;
	reg[7:0] regXCEData;
	reg[7:0] regXCFData;

	always@ (posedge CLK or posedge RST) begin
		if(RST)begin
			regX08Data <= 8'd0;
			regX09Data <= 8'd0;
			regX0AData <= 8'd0;
			regX0BData <= `TRIGGER_SELECT_DF;
			{regX0CData, regX0DData, regX0EData, regX0FData} <= `TRIGGER_FREQ_DF;
			
			regX10Data <= 8'd0;
			regX11Data <= 8'd0;
			regX12Data <= 8'd0;
			regX13Data <= 8'd0;
			regX14Data <= 8'd0;
			regX15Data <= 8'd0;
			regX16Data <= 8'd0;
			regX17Data <= 8'd0;
			regX18Data <= 8'd0;
			regX19Data <= 8'd0;
			regX1AData <= 8'd0;
			regX1BData <= 8'd0;
			regX1CData <= 8'd0;
			regX1DData <= 8'd0;
			regX1EData <= `TRIGGER_ENABLE_DF;
			//regX1FData <= 8'd0;

			regX20Data <= 8'd0;
			regX21Data <= `DTRIG_THRESHOLD_DF;
			regX22Data <= `DTRIG_THRESHOLD_DF;
			regX23Data <= `DTRIG_THRESHOLD_DF;
			regX24Data <= `DTRIG_THRESHOLD_DF;
			regX25Data <= `DTRIG_THRESHOLD_DF;
			regX26Data <= `DTRIG_THRESHOLD_DF;
			regX27Data <= `DTRIG_THRESHOLD_DF;
			//regX28Data <= 8'd0;
			//regX29Data <= 8'd0;
			//regX2AData <= 8'd0;
			//regX2BData <= 8'd0;
			//regX2CData <= 8'd0;
			//regX2DData <= 8'd0;
			//regX2EData <= 8'd0;
			//regX2FData <= 8'd0;

			//regX30Data <= 8'd0;
			//regX31Data <= 8'd0;
			//regX32Data <= 8'd0;
			//regX33Data <= 8'd0;
			//regX34Data <= 8'd0;
			//regX35Data <= 8'd0;
			regX36Data <= 8'd0;
			regX37Data <= 8'd0;
			regX38Data <= 8'd0;
			regX39Data <= 8'd0;
			regX3AData <= 8'd0;
			regX3BData <= 8'd0;
			regX3CData <= 8'd0;
			regX3DData <= 8'd0;
			{regX3EData, regX3FData} <= `RATE_WINDOW_DF;

			regX40Data <= 8'd0;
			regX41Data <= 8'd0;
			regX42Data <= 8'd0;
			regX43Data <= 8'd0;
			regX44Data <= 8'd0;
			regX45Data <= 8'd0;
			regX46Data <= 8'd0;
			regX47Data <= 8'd0;
			{regX48Data, regX49Data} <= `RATE_WINDOWL1_DF;
			//regX4AData <= 8'd0;
			//regX4BData <= 8'd0;
			//regX4CData <= 8'd0;
			//regX4DData <= 8'd0;
			//regX4EData <= 8'd0;
			//regX4FData <= 8'd0;

			regX50Data <= 8'd0;
			regX51Data <= 8'd0;
			regX52Data <= 8'd0;
			//regX53Data <= 8'd0;
			//regX54Data <= 8'd0;
			//regX55Data <= 8'd0;
			regX56Data <= 8'd0;
			regX57Data <= 8'd0;
			regX58Data <= 8'd0;
			//regX59Data <= 8'd0;
			//regX5AData <= 8'd0;
			//regX5BData <= 8'd0;
			regX5CData <= 8'd0;
			regX5DData <= 8'd0;
			regX5EData <= 8'd0;
			regX5FData <= 8'd0;

			regX60Data <= 8'd0;
			regX61Data <= 8'd0;
			regX62Data <= 8'd0;
			regX63Data <= 8'd0;
			regX64Data <= 8'd0;
			//regX65Data <= 8'd0;
			//regX66Data <= 8'd0;
			//regX67Data <= 8'd0;
			//regX68Data <= 8'd0;
			regX69Data <= 8'd0;
			regX6AData <= 8'd0;
			regX6BData <= 8'd0;
			regX6CData <= 8'd0;
			regX6DData <= 8'd0;
			regX6EData <= 8'd0;
			regX6FData <= 8'd0;

			regX70Data <= 8'd0;
			regX71Data <= 8'd0;
			regX72Data <= 8'd0;
			regX73Data <= 8'd0;
			regX74Data <= 8'd0;
			regX75Data <= 8'd0;
			regX76Data <= 8'd0;
			regX77Data <= 8'd0;
			regX78Data <= 8'd0;
			regX79Data <= 8'd0;
			regX7AData <= 8'd0;
			//regX7BData <= 8'd0;
			//regX7CData <= 8'd0;
			//regX7DData <= 8'd0;
			//regX7EData <= 8'd0;
			//regX7FData <= 8'd0;

			regX80Data <= 8'd0;
			{regX81Data, regX82Data} <= `DAC_ROFS_DF;
			{regX83Data, regX84Data} <= `DAC_OOFS_DF;
			{regX85Data, regX86Data} <= `DAC_BIAS_DF;
			{regX87Data, regX88Data} <= `DAC_CALP_DF;
			{regX89Data, regX8AData} <= `DAC_CALN_DF;
			regX8BData <= 8'd0;
			regX8CData <= 8'd0;
			regX8DData <= 8'd0;
			{regX8EData, regX8FData} <= {5'd0, `DRS_DWRITE_TO_READY_DF};

			{regX90Data, regX91Data} <= {5'd0, `DRS_READDEPTH_DF};
			{regX92Data, regX93Data} <= {5'd0, `DRS_STOP_FROM_TRIG_DF};
			regX94Data <= `DRS_SAMP_FREQ_DF;
			regX95Data <= 8'd0;
			regX96Data <= 8'd0;
			regX97Data <= 8'd0;
			regX98Data <= 8'd0;
			regX99Data <= 8'd0;
			regX9AData <= `DRS_PLLLCK_CHECK_DF;
			regX9BData <= 8'd0;
			regX9CData <= `DRS_CASCADENUM_DF;
			regX9DData <= 8'd0;
			regX9EData <= 8'd0;
			//regX9FData <= 8'd0;

			regXA0Data <= 8'd0;
			regXA1Data <= 8'd0;
			regXA2Data <= 8'd0;
			regXA3Data <= 8'd0;
			regXA4Data <= 8'd0;
			regXA5Data <= 8'd0;
			regXA6Data <= 8'd0;
			regXA7Data <= 8'd0;
			regXA8Data <= 8'd0;
			regXA9Data <= 8'd0;
			regXAAData <= 8'd0;
			regXABData <= 8'd0;
			regXACData <= 8'd0;
			regXADData <= 8'd0;
			regXAEData <= 8'd0;
			regXAFData <= 8'd0;

			regXB0Data <= 8'd0;
			regXB1Data <= 8'd0;
			regXB2Data <= 8'd0;
			regXB3Data <= 8'd0;
			regXB4Data <= 8'd0;
			regXB5Data <= 8'd0;
			regXB6Data <= 8'd0;
			//regXB7Data <= 8'd0;
			//regXB8Data <= 8'd0;
			//regXB9Data <= 8'd0;
			//regXBAData <= 8'd0;
			//regXBBData <= 8'd0;
			//regXBCData <= 8'd0;
			//regXBDData <= 8'd0;
			//regXBEData <= 8'd0;
			//regXBFData <= 8'd0;

			//regXC0Data <= 8'd0;
			//regXC1Data <= 8'd0;
			//regXC2Data <= 8'd0;
			//regXC3Data <= 8'd0;
			//regXC4Data <= 8'd0;
			//regXC5Data <= 8'd0;
			//regXC6Data <= 8'd0;
			{regXC7Data,regXC8Data,regXC9Data,regXCAData} <= {2'd0,`SCB_TP_TRIG_FREQ_DF};
			{regXCBData, regXCCData} <= `SCB_TP_TRIG_WIDTH_DF;
			{regXCDData, regXCEData} <= `TRIGGER_FREQ_OFFSET_DF;
			regXCFData <= 8'd0;
			
		end else begin
			if(regBe[8]) begin
				regX08Data[7:0] <= regWd[7:0];
			end
			if(regBe[9]) begin
				regX09Data[7:0] <= regWd[7:0];
			end
			if(regBe[10]) begin
				regX0AData[7:0] <= regWd[7:0];
			end
			if(regBe[11]) begin
				regX0BData[7:0] <= regWd[7:0];
			end
			if(regBe[12]) begin
				regX0CData[7:0] <= regWd[7:0];
			end
			if(regBe[13]) begin
				regX0DData[7:0] <= regWd[7:0];
			end
			if(regBe[14]) begin
				regX0EData[7:0] <= regWd[7:0];
			end
			if(regBe[15]) begin
				regX0FData[7:0] <= regWd[7:0];
			end

			if(regX10Data[7:0]==8'hff) begin
				if(adcspi_finish == 1'b1) begin
					regX10Data[7:0] <= 8'd0;
				end
			end else if(regBe[16]) begin
				regX10Data[7:0] <= regWd[7:0];
			end
			if(regBe[17]) begin
				regX11Data[7:0] <= regWd[7:0];
			end
			if(regBe[18]) begin
				regX12Data[7:0] <= regWd[7:0];
			end
			if(regBe[19]) begin
				regX13Data[7:0] <= regWd[7:0];
			end
			if(regBe[20]) begin
				regX14Data[7:0] <= regWd[7:0];
			end
			if(regBe[21]) begin
				regX15Data[7:0] <= regWd[7:0];
			end
			if(regBe[22]) begin
				regX16Data[7:0] <= regWd[7:0];
			end
			if(regBe[23]) begin
				regX17Data[7:0] <= regWd[7:0];
			end
			if(regBe[24]) begin
				regX18Data[7:0] <= regWd[7:0];
			end
			if(regBe[25]) begin
				regX19Data[7:0] <= regWd[7:0];
			end
			if(regBe[26]) begin
				regX1AData[7:0] <= regWd[7:0];
			end
			if(regBe[27]) begin
				regX1BData[7:0] <= regWd[7:0];
			end
			if(regBe[28]) begin
				regX1CData[7:0] <= regWd[7:0];
			end
			if(regBe[29]) begin
				regX1DData[7:0] <= regWd[7:0];
			end
			if(regBe[30]) begin
				regX1EData[7:0] <= regWd[7:0];
			end
			/*
			if(regBe[31]) begin
				regX1FData[7:0] <= regWd[7:0];
			end
			*/

			if(regX20Data[7:0]==8'hff) begin
				if(dtrigset_finish == 1'b1) begin
					regX20Data[7:0] <= 8'd0;
				end
			end else if(regBe[32]) begin
				regX20Data[7:0] <= regWd[7:0];
			end
			if(regBe[33]) begin
				regX21Data[7:0] <= regWd[7:0];
			end
			if(regBe[34]) begin
				regX22Data[7:0] <= regWd[7:0];
			end
			if(regBe[35]) begin
				regX23Data[7:0] <= regWd[7:0];
			end
			if(regBe[36]) begin
				regX24Data[7:0] <= regWd[7:0];
			end
			if(regBe[37]) begin
				regX25Data[7:0] <= regWd[7:0];
			end
			if(regBe[38]) begin
				regX26Data[7:0] <= regWd[7:0];
			end
			if(regBe[39]) begin
				regX27Data[7:0] <= regWd[7:0];
			end
			/*
			if(regBe[40]) begin
				regX28Data[7:0] <= regWd[7:0];
			end
			if(regBe[41]) begin
				regX29Data[7:0] <= regWd[7:0];
			end
			if(regBe[42]) begin
				regX2AData[7:0] <= regWd[7:0];
			end
			if(regBe[43]) begin
				regX2BData[7:0] <= regWd[7:0];
			end
			if(regBe[44]) begin
				regX2CData[7:0] <= regWd[7:0];
			end
			if(regBe[45]) begin
				regX2DData[7:0] <= regWd[7:0];
			end
			if(regBe[46]) begin
				regX2EData[7:0] <= regWd[7:0];
			end
			if(regBe[47]) begin
				regX2FData[7:0] <= regWd[7:0];
			end

			if(regBe[48]) begin
				regX30Data[7:0] <= regWd[7:0];
			end
			if(regBe[49]) begin
				regX31Data[7:0] <= regWd[7:0];
			end
			if(regBe[50]) begin
				regX32Data[7:0] <= regWd[7:0];
			end
			if(regBe[51]) begin
				regX33Data[7:0] <= regWd[7:0];
			end
			if(regBe[52]) begin
				regX34Data[7:0] <= regWd[7:0];
			end
			if(regBe[53]) begin
				regX35Data[7:0] <= regWd[7:0];
			end
			*/
			if(regBe[54]) begin
				regX36Data[7:0] <= regWd[7:0];
			end
			if(regBe[55]) begin
				regX37Data[7:0] <= regWd[7:0];
			end
			if(regBe[56]) begin
				regX38Data[7:0] <= regWd[7:0];
			end
			if(regBe[57]) begin
				regX39Data[7:0] <= regWd[7:0];
			end
			if(regBe[58]) begin
				regX3AData[7:0] <= regWd[7:0];
			end
			if(regBe[59]) begin
				regX3BData[7:0] <= regWd[7:0];
			end
			if(regBe[60]) begin
				regX3CData[7:0] <= regWd[7:0];
			end
			if(regBe[61]) begin
				regX3DData[7:0] <= regWd[7:0];
			end
			if(regBe[62]) begin
				regX3EData[7:0] <= regWd[7:0];
			end
			if(regBe[63]) begin
				regX3FData[7:0] <= regWd[7:0];
			end

			if(regX40Data[7:0]==8'hff) begin
				if(l0_sc_write_done == 1'b1) begin
					regX40Data[7:0] <= 8'd0;
				end
			end else if(regBe[64]) begin
				regX40Data[7:0] <= regWd[7:0];
			end
			if(regX41Data[7:0]==8'hff) begin
				if(l0_sc_read_done == 1'b1) begin
					regX41Data[7:0] <= 8'd0;
				end
			end else if(regBe[65]) begin
				regX41Data[7:0] <= regWd[7:0];
			end
			if(regX42Data[7:0]==8'hff) begin
				if(l0_reset_done == 1'b1) begin
					regX42Data[7:0] <= 8'd0;
				end
			end else if(regBe[66]) begin
				regX42Data[7:0] <= regWd[7:0];
			end
			if(regX43Data[7:0]==8'hff) begin
				if(l0dela_set_done == 1'b1) begin
					regX43Data[7:0] <= 8'd0;
				end
			end else if(regBe[67]) begin
				regX43Data[7:0] <= regWd[7:0];
			end
			if(regX44Data[7:0]==8'hff) begin
				if(l0dela_reset_done == 1'b1) begin
					regX44Data[7:0] <= 8'd0;
				end
			end else if(regBe[68]) begin
				regX44Data[7:0] <= regWd[7:0];
			end
			if(regX45Data[7:0]==8'hff) begin
				if(l1_sc_write_done == 1'b1) begin
					regX45Data[7:0] <= 8'd0;
				end
			end else if(regBe[69]) begin
				regX45Data[7:0] <= regWd[7:0];
			end
			if(regX46Data[7:0]==8'hff) begin
				if(l1_sc_read_done == 1'b1) begin
					regX46Data[7:0] <= 8'd0;
				end
			end else if(regBe[70]) begin
				regX46Data[7:0] <= regWd[7:0];
			end
			if(regX47Data[7:0]==8'hff) begin
				if(l1_reset_done == 1'b1) begin
					regX47Data[7:0] <= 8'd0;
				end
			end else if(regBe[71]) begin
				regX47Data[7:0] <= regWd[7:0];
			end
			if(regBe[72]) begin
				regX48Data[7:0] <= regWd[7:0];
			end
			if(regBe[73]) begin
				regX49Data[7:0] <= regWd[7:0];
			end
			/*
			if(regBe[74]) begin
				regX4AData[7:0] <= regWd[7:0];
			end
			if(regBe[75]) begin
				regX4BData[7:0] <= regWd[7:0];
			end
			if(regBe[76]) begin
				regX4CData[7:0] <= regWd[7:0];
			end
			if(regBe[77]) begin
				regX4DData[7:0] <= regWd[7:0];
			end
			if(regBe[78]) begin
				regX4EData[7:0] <= regWd[7:0];
			end
			if(regBe[79]) begin
				regX4FData[7:0] <= regWd[7:0];
			end
			*/

			if(regBe[80]) begin
				regX50Data[7:0] <= regWd[7:0];
			end
			if(regBe[81]) begin
				regX51Data[7:0] <= regWd[7:0];
			end
			if(regBe[82]) begin
				regX52Data[7:0] <= regWd[7:0];
			end
			/*
			if(regBe[83]) begin
				regX53Data[7:0] <= regWd[7:0];
			end
			if(regBe[84]) begin
				regX54Data[7:0] <= regWd[7:0];
			end
			if(regBe[85]) begin
				regX55Data[7:0] <= regWd[7:0];
			end
			*/
			if(regBe[86]) begin
				regX56Data[7:0] <= regWd[7:0];
			end
			if(regBe[87]) begin
				regX57Data[7:0] <= regWd[7:0];
			end
			if(regBe[88]) begin
				regX58Data[7:0] <= regWd[7:0];
			end
			/*
			if(regBe[89]) begin
				regX59Data[7:0] <= regWd[7:0];
			end
			if(regBe[90]) begin
				regX5AData[7:0] <= regWd[7:0];
			end
			if(regBe[91]) begin
				regX5BData[7:0] <= regWd[7:0];
			end
			*/
			if(regBe[92]) begin
				regX5CData[7:0] <= regWd[7:0];
			end
			if(regBe[93]) begin
				regX5DData[7:0] <= regWd[7:0];
			end
			if(regBe[94]) begin
				regX5EData[7:0] <= regWd[7:0];
			end
			if(regBe[95]) begin
				regX5FData[7:0] <= regWd[7:0];
			end

			if(regX60Data[7:0]==8'hff) begin
				if(bp_sc_write_done == 1'b1) begin
					regX60Data[7:0] <= 8'd0;
				end
			end else if(regBe[96]) begin
				regX60Data[7:0] <= regWd[7:0];
			end
			if(regBe[97]) begin
				regX61Data[7:0] <= regWd[7:0];
			end
			if(regBe[98]) begin
				regX62Data[7:0] <= regWd[7:0];
			end
			if(regBe[99]) begin
				regX63Data[7:0] <= regWd[7:0];
			end
			if(regBe[100]) begin
				regX64Data[7:0] <= regWd[7:0];
			end
			/*
			if(regBe[101]) begin
				regX65Data[7:0] <= regWd[7:0];
			end
			if(regBe[102]) begin
				regX66Data[7:0] <= regWd[7:0];
			end
			if(regBe[103]) begin
				regX67Data[7:0] <= regWd[7:0];
			end
			if(regBe[104]) begin
				regX68Data[7:0] <= regWd[7:0];
			end
			*/

		    if(regX69Data[7:0]==8'hff) begin
				if(bp_fpgaprogram_done == 1'b1) begin
					regX69Data[7:0] <= 8'd0;
				end
			end else if(regBe[105]) begin
				regX69Data[7:0] <= regWd[7:0];
			end

			if(regBe[106]) begin
				regX6AData[7:0] <= regWd[7:0];
			end
			if(regBe[107]) begin
				regX6BData[7:0] <= regWd[7:0];
			end
			if(regBe[108]) begin
				regX6CData[7:0] <= regWd[7:0];
			end
			if(regBe[109]) begin
				regX6DData[7:0] <= regWd[7:0];
			end
			if(regBe[110]) begin
				regX6EData[7:0] <= regWd[7:0];
			end
			if(regBe[111]) begin
				regX6FData[7:0] <= regWd[7:0];
			end

			if(regX70Data[7:0]==8'hff) begin
				if(sramwrite_finish == 1'b1) begin
					regX70Data[7:0] <= 8'd0;
				end
			end else if(regBe[112]) begin
				regX70Data[7:0] <= regWd[7:0];
			end
			if(regX71Data[7:0]==8'hff) begin
				if(sramread_finish == 1'b1) begin
					regX71Data[7:0] <= 8'd0;
				end
			end else if(regBe[113]) begin
				regX71Data[7:0] <= regWd[7:0];
			end
			if(regBe[114]) begin
				regX72Data[7:0] <= regWd[7:0];
			end
			if(regBe[115]) begin
				regX73Data[7:0] <= regWd[7:0];
			end
			if(regBe[116]) begin
				regX74Data[7:0] <= regWd[7:0];
			end
			if(regBe[117]) begin
				regX75Data[7:0] <= regWd[7:0];
			end
			if(regBe[118]) begin
				regX76Data[7:0] <= regWd[7:0];
			end
			if(regBe[119]) begin
				regX77Data[7:0] <= regWd[7:0];
			end
			if(regBe[120]) begin
				regX78Data[7:0] <= regWd[7:0];
			end
			if(regBe[121]) begin
				regX79Data[7:0] <= regWd[7:0];
			end
			if(regBe[122]) begin
				regX7AData[7:0] <= regWd[7:0];
			end
			/*
			if(regBe[123]) begin
				regX7BData[7:0] <= regWd[7:0];
			end
			if(regBe[124]) begin
				regX7CData[7:0] <= regWd[7:0];
			end
			if(regBe[125]) begin
				regX7DData[7:0] <= regWd[7:0];
			end
			if(regBe[126]) begin
				regX7EData[7:0] <= regWd[7:0];
			end
			if(regBe[127]) begin
				regX7FData[7:0] <= regWd[7:0];
			end
			*/
			
			if(regX80Data[7:0]==8'hff) begin
				if(dacset_finish == 1'b1) begin
					regX80Data[7:0] <= 8'd0;
				end
			end else if(regBe[128]) begin
				regX80Data[7:0] <= regWd[7:0];
			end
			if(regBe[129]) begin
				regX81Data[7:0] <= regWd[7:0];
			end
			if(regBe[130]) begin
				regX82Data[7:0] <= regWd[7:0];
			end
			if(regBe[131]) begin
				regX83Data[7:0] <= regWd[7:0];
			end
			if(regBe[132]) begin
				regX84Data[7:0] <= regWd[7:0];
			end
			if(regBe[133]) begin
				regX85Data[7:0] <= regWd[7:0];
			end
			if(regBe[134]) begin
				regX86Data[7:0] <= regWd[7:0];
			end
			if(regBe[135]) begin
				regX87Data[7:0] <= regWd[7:0];
			end
			if(regBe[136]) begin
				regX88Data[7:0] <= regWd[7:0];
			end
			if(regBe[137]) begin
				regX89Data[7:0] <= regWd[7:0];
			end
			if(regBe[138]) begin
				regX8AData[7:0] <= regWd[7:0];
			end
			if(regBe[139]) begin
				regX8BData[7:0] <= regWd[7:0];
			end
			if(regBe[140]) begin
				regX8CData[7:0] <= regWd[7:0];
			end
			if(regBe[141]) begin
				regX8DData[7:0] <= regWd[7:0];
			end
			if(regBe[142]) begin
				regX8EData[7:0] <= regWd[7:0];
			end
			if(regBe[143]) begin
				regX8FData[7:0] <= regWd[7:0];
			end
			
			if(regBe[144]) begin
				regX90Data[7:0] <= regWd[7:0];
			end
			if(regBe[145]) begin
				regX91Data[7:0] <= regWd[7:0];
			end
			if(regBe[146]) begin
				regX92Data[7:0] <= regWd[7:0];
			end
			if(regBe[147]) begin
				regX93Data[7:0] <= regWd[7:0];
			end
			if(regBe[148]) begin
				regX94Data[7:0] <= regWd[7:0];
			end
			if(regBe[149]) begin
				regX95Data[7:0] <= regWd[7:0];
			end
			if(regBe[150]) begin
				regX96Data[7:0] <= regWd[7:0];
			end
			if(regBe[151]) begin
				regX97Data[7:0] <= regWd[7:0];
			end
			if(regBe[152]) begin
				regX98Data[7:0] <= regWd[7:0];
			end
			if(regBe[153]) begin
				regX99Data[7:0] <= regWd[7:0];
			end
			if(regBe[154]) begin
				regX9AData[7:0] <= regWd[7:0];
			end
			if(regBe[155]) begin
				regX9BData[7:0] <= regWd[7:0];
			end
			if(regBe[156]) begin
				regX9CData[7:0] <= regWd[7:0];
			end
			
			if(regX9DData==8'hFF) begin
				regX9DData[7:0] <= 8'h00;
			end else if(regBe[157]) begin
				regX9DData[7:0] <= regWd[7:0];
			end

			if(regBe[158]) begin
				regX9EData[7:0] <= regWd[7:0];
			end
			//if(regBe[159]) begin
			//	regX9FData[7:0] <= regWd[7:0];
			//end

			if(regXA0Data[7:0]==8'hff) begin
				if(scb_spisend_finish == 1'b1) begin
					regXA0Data[7:0] <= 8'd0;
				end
			end else if(regBe[160]) begin
				regXA0Data[7:0] <= regWd[7:0];
			end
			if(regBe[161]) begin
				regXA1Data[7:0] <= regWd[7:0];
			end
			if(regBe[162]) begin
				regXA2Data[7:0] <= regWd[7:0];
			end
			if(regBe[163]) begin
				regXA3Data[7:0] <= regWd[7:0];
			end
			if(regBe[164]) begin
				regXA4Data[7:0] <= regWd[7:0];
			end
			if(regBe[165]) begin
				regXA5Data[7:0] <= regWd[7:0];
			end
			if(regBe[166]) begin
				regXA6Data[7:0] <= regWd[7:0];
			end
			if(regBe[167]) begin
				regXA7Data[7:0] <= regWd[7:0];
			end
			if(regBe[168]) begin
				regXA8Data[7:0] <= regWd[7:0];
			end
			if(regBe[169]) begin
				regXA9Data[7:0] <= regWd[7:0];
			end
			if(regBe[170]) begin
				regXAAData[7:0] <= regWd[7:0];
			end
			if(regBe[171]) begin
				regXABData[7:0] <= regWd[7:0];
			end
			if(regBe[172]) begin
				regXACData[7:0] <= regWd[7:0];
			end
			if(regBe[173]) begin
				regXADData[7:0] <= regWd[7:0];
			end
			if(regBe[174]) begin
				regXAEData[7:0] <= regWd[7:0];
			end
			if(regBe[175]) begin
				regXAFData[7:0] <= regWd[7:0];
			end

			if(regBe[176]) begin
				regXB0Data[7:0] <= regWd[7:0];
			end
			if(regBe[177]) begin
				regXB1Data[7:0] <= regWd[7:0];
			end
			if(regBe[178]) begin
				regXB2Data[7:0] <= regWd[7:0];
			end
			if(regBe[179]) begin
				regXB3Data[7:0] <= regWd[7:0];
			end
			if(regBe[180]) begin
				regXB4Data[7:0] <= regWd[7:0];
			end
			if(regBe[181]) begin
				regXB5Data[7:0] <= regWd[7:0];
			end
			if(regBe[182]) begin
				regXB6Data[7:0] <= regWd[7:0];
			end
			/*
			if(regBe[183]) begin
				regXB7Data[7:0] <= regWd[7:0];
			end
			if(regBe[184]) begin
				regXB8Data[7:0] <= regWd[7:0];
			end
			if(regBe[185]) begin
				regXB9Data[7:0] <= regWd[7:0];
			end
			if(regBe[186]) begin
				regXBAData[7:0] <= regWd[7:0];
			end
			if(regBe[187]) begin
				regXBBData[7:0] <= regWd[7:0];
			end
			if(regBe[188]) begin
				regXBCData[7:0] <= regWd[7:0];
			end
			if(regBe[189]) begin
				regXBDData[7:0] <= regWd[7:0];
			end
			if(regBe[190]) begin
				regXBEData[7:0] <= regWd[7:0];
			end
			if(regBe[191]) begin
				regXBFData[7:0] <= regWd[7:0];
			end

			if(regBe[192]) begin
				regXC0Data[7:0] <= regWd[7:0];
			end
			if(regBe[193]) begin
				regXC1Data[7:0] <= regWd[7:0];
			end
			if(regBe[194]) begin
				regXC2Data[7:0] <= regWd[7:0];
			end
			if(regBe[195]) begin
				regXC3Data[7:0] <= regWd[7:0];
			end
			if(regBe[196]) begin
				regXC4Data[7:0] <= regWd[7:0];
			end
			if(regBe[197]) begin
				regXC5Data[7:0] <= regWd[7:0];
			end
			if(regBe[198]) begin
				regXC6Data[7:0] <= regWd[7:0];
			end
			*/
			if(regBe[199]) begin
				regXC7Data[7:0] <= regWd[7:0];
			end
			if(regBe[200]) begin
				regXC8Data[7:0] <= regWd[7:0];
			end
			if(regBe[201]) begin
				regXC9Data[7:0] <= regWd[7:0];
			end
			if(regBe[202]) begin
				regXCAData[7:0] <= regWd[7:0];
			end
			if(regBe[203]) begin
				regXCBData[7:0] <= regWd[7:0];
			end
			if(regBe[204]) begin
				regXCCData[7:0] <= regWd[7:0];
			end
			if(regBe[205]) begin
				regXCDData[7:0] <= regWd[7:0];
			end
			if(regBe[206]) begin
				regXCEData[7:0] <= regWd[7:0];
			end
			if(regBe[207]) begin
				regXCFData[7:0] <= regWd[7:0];
			end
		end
	end
	
	wire[7:0] X00Data;
	wire[7:0] X01Data;
	wire[7:0] X02Data;
	wire[7:0] X03Data;
	wire[7:0] X04Data;
	wire[7:0] X05Data;
	wire[7:0] X06Data;
	wire[7:0] X07Data;
	wire[7:0] X08Data;
	wire[7:0] X09Data;
	wire[7:0] X0AData;
	wire[7:0] X0BData;
	wire[7:0] X0CData;
	wire[7:0] X0DData;
	wire[7:0] X0EData;
	wire[7:0] X0FData;

	wire[7:0] X10Data;
	wire[7:0] X11Data;
	wire[7:0] X12Data;
	wire[7:0] X13Data;
	wire[7:0] X14Data;
	wire[7:0] X15Data;
	wire[7:0] X16Data;
	wire[7:0] X17Data;
	wire[7:0] X18Data;
	wire[7:0] X19Data;
	wire[7:0] X1AData;
	wire[7:0] X1BData;
	wire[7:0] X1CData;
	wire[7:0] X1DData;
	wire[7:0] X1EData;
	wire[7:0] X1FData;

	wire[7:0] X20Data;
	wire[7:0] X21Data;
	wire[7:0] X22Data;
	wire[7:0] X23Data;
	wire[7:0] X24Data;
	wire[7:0] X25Data;
	wire[7:0] X26Data;
	wire[7:0] X27Data;
	wire[7:0] X28Data;
	wire[7:0] X29Data;
	wire[7:0] X2AData;
	wire[7:0] X2BData;
	wire[7:0] X2CData;
	wire[7:0] X2DData;
	wire[7:0] X2EData;
	wire[7:0] X2FData;

	wire[7:0] X30Data;
	wire[7:0] X31Data;
	wire[7:0] X32Data;
	wire[7:0] X33Data;
	wire[7:0] X34Data;
	wire[7:0] X35Data;
	wire[7:0] X36Data;
	wire[7:0] X37Data;
	wire[7:0] X38Data;
	wire[7:0] X39Data;
	wire[7:0] X3AData;
	wire[7:0] X3BData;
	wire[7:0] X3CData;
	wire[7:0] X3DData;
	wire[7:0] X3EData;
	wire[7:0] X3FData;

	wire[7:0] X40Data;
	wire[7:0] X41Data;
	wire[7:0] X42Data;
	wire[7:0] X43Data;
	wire[7:0] X44Data;
	wire[7:0] X45Data;
	wire[7:0] X46Data;
	wire[7:0] X47Data;
	wire[7:0] X48Data;
	wire[7:0] X49Data;
	wire[7:0] X4AData;
	wire[7:0] X4BData;
	wire[7:0] X4CData;
	wire[7:0] X4DData;
	wire[7:0] X4EData;
	wire[7:0] X4FData;

	wire[7:0] X50Data;
	wire[7:0] X51Data;
	wire[7:0] X52Data;
	wire[7:0] X53Data;
	wire[7:0] X54Data;
	wire[7:0] X55Data;
	wire[7:0] X56Data;
	wire[7:0] X57Data;
	wire[7:0] X58Data;
	wire[7:0] X59Data;
	wire[7:0] X5AData;
	wire[7:0] X5BData;
	wire[7:0] X5CData;
	wire[7:0] X5DData;
	wire[7:0] X5EData;
	wire[7:0] X5FData;

	wire[7:0] X60Data;
	wire[7:0] X61Data;
	wire[7:0] X62Data;
	wire[7:0] X63Data;
	wire[7:0] X64Data;
	wire[7:0] X65Data;
	wire[7:0] X66Data;
	wire[7:0] X67Data;
	wire[7:0] X68Data;
	wire[7:0] X69Data;
	wire[7:0] X6AData;
	wire[7:0] X6BData;
	wire[7:0] X6CData;
	wire[7:0] X6DData;
	wire[7:0] X6EData;
	wire[7:0] X6FData;

	wire[7:0] X70Data;
	wire[7:0] X71Data;
	wire[7:0] X72Data;
	wire[7:0] X73Data;
	wire[7:0] X74Data;
	wire[7:0] X75Data;
	wire[7:0] X76Data;
	wire[7:0] X77Data;
	wire[7:0] X78Data;
	wire[7:0] X79Data;
	wire[7:0] X7AData;
	wire[7:0] X7BData;
	wire[7:0] X7CData;
	wire[7:0] X7DData;
	wire[7:0] X7EData;
	wire[7:0] X7FData;

	wire[7:0] X80Data;
	wire[7:0] X81Data;
	wire[7:0] X82Data;
	wire[7:0] X83Data;
	wire[7:0] X84Data;
	wire[7:0] X85Data;
	wire[7:0] X86Data;
	wire[7:0] X87Data;
	wire[7:0] X88Data;
	wire[7:0] X89Data;
	wire[7:0] X8AData;
	wire[7:0] X8BData;
	wire[7:0] X8CData;
	wire[7:0] X8DData;
	wire[7:0] X8EData;
	wire[7:0] X8FData;

	wire[7:0] X90Data;
	wire[7:0] X91Data;
	wire[7:0] X92Data;
	wire[7:0] X93Data;
	wire[7:0] X94Data;
	wire[7:0] X95Data;
	wire[7:0] X96Data;
	wire[7:0] X97Data;
	wire[7:0] X98Data;
	wire[7:0] X99Data;
	wire[7:0] X9AData;
	wire[7:0] X9BData;
	wire[7:0] X9CData;
	wire[7:0] X9DData;
	wire[7:0] X9EData;
	wire[7:0] X9FData;

	wire[7:0] XA0Data;
	wire[7:0] XA1Data;
	wire[7:0] XA2Data;
	wire[7:0] XA3Data;
	wire[7:0] XA4Data;
	wire[7:0] XA5Data;
	wire[7:0] XA6Data;
	wire[7:0] XA7Data;
	wire[7:0] XA8Data;
	wire[7:0] XA9Data;
	wire[7:0] XAAData;
	wire[7:0] XABData;
	wire[7:0] XACData;
	wire[7:0] XADData;
	wire[7:0] XAEData;
	wire[7:0] XAFData;

	wire[7:0] XB0Data;
	wire[7:0] XB1Data;
	wire[7:0] XB2Data;
	wire[7:0] XB3Data;
	wire[7:0] XB4Data;
	wire[7:0] XB5Data;
	wire[7:0] XB6Data;
	wire[7:0] XB7Data;
	wire[7:0] XB8Data;
	wire[7:0] XB9Data;
	wire[7:0] XBAData;
	wire[7:0] XBBData;
	wire[7:0] XBCData;
	wire[7:0] XBDData;
	wire[7:0] XBEData;
	wire[7:0] XBFData;

	wire[7:0] XC0Data;
	wire[7:0] XC1Data;
	wire[7:0] XC2Data;
	wire[7:0] XC3Data;
	wire[7:0] XC4Data;
	wire[7:0] XC5Data;
	wire[7:0] XC6Data;
	wire[7:0] XC7Data;
	wire[7:0] XC8Data;
	wire[7:0] XC9Data;
	wire[7:0] XCAData;
	wire[7:0] XCBData;
	wire[7:0] XCCData;
	wire[7:0] XCDData;
	wire[7:0] XCEData;
	wire[7:0] XCFData;

	assign X08Data[7:0] = regX08Data[7:0];
	assign X09Data[7:0] = regX09Data[7:0];
	assign X0AData[7:0] = regX0AData[7:0];
	assign X0BData[7:0] = regX0BData[7:0];
	assign X0CData[7:0] = regX0CData[7:0];
	assign X0DData[7:0] = regX0DData[7:0];
	assign X0EData[7:0] = regX0EData[7:0];
	assign X0FData[7:0] = regX0FData[7:0];

	assign X10Data[7:0] = regX10Data[7:0];
	assign X11Data[7:0] = regX11Data[7:0];
	assign X12Data[7:0] = regX12Data[7:0];
	assign X13Data[7:0] = regX13Data[7:0];
	assign X14Data[7:0] = regX14Data[7:0];
	assign X15Data[7:0] = regX15Data[7:0];
	assign X16Data[7:0] = regX16Data[7:0];
	assign X17Data[7:0] = regX17Data[7:0];
	assign X18Data[7:0] = regX18Data[7:0];
	assign X19Data[7:0] = regX19Data[7:0];
	assign X1AData[7:0] = regX1AData[7:0];
	assign X1BData[7:0] = regX1BData[7:0];
	assign X1CData[7:0] = regX1CData[7:0];
	assign X1DData[7:0] = regX1DData[7:0];
	assign X1EData[7:0] = regX1EData[7:0];
	//assign X1FData[7:0] = regX1FData[7:0];

	assign X20Data[7:0] = regX20Data[7:0];
	assign X21Data[7:0] = regX21Data[7:0];
	assign X22Data[7:0] = regX22Data[7:0];
	assign X23Data[7:0] = regX23Data[7:0];
	assign X24Data[7:0] = regX24Data[7:0];
	assign X25Data[7:0] = regX25Data[7:0];
	assign X26Data[7:0] = regX26Data[7:0];
	assign X27Data[7:0] = regX27Data[7:0];
	//assign X28Data[7:0] = regX28Data[7:0];
	//assign X29Data[7:0] = regX29Data[7:0];
	//assign X2AData[7:0] = regX2AData[7:0];
	//assign X2BData[7:0] = regX2BData[7:0];
	//assign X2CData[7:0] = regX2CData[7:0];
	//assign X2DData[7:0] = regX2DData[7:0];
	//assign X2EData[7:0] = regX2EData[7:0];
	//assign X2FData[7:0] = regX2FData[7:0];

	//assign X30Data[7:0] = regX30Data[7:0];
	//assign X31Data[7:0] = regX31Data[7:0];
	//assign X32Data[7:0] = regX32Data[7:0];
	//assign X33Data[7:0] = regX33Data[7:0];
	//assign X34Data[7:0] = regX34Data[7:0];
	//assign X35Data[7:0] = regX35Data[7:0];
	assign X36Data[7:0] = regX36Data[7:0];
	assign X37Data[7:0] = regX37Data[7:0];
	assign X38Data[7:0] = regX38Data[7:0];
	assign X39Data[7:0] = regX39Data[7:0];
	assign X3AData[7:0] = regX3AData[7:0];
	assign X3BData[7:0] = regX3BData[7:0];
	assign X3CData[7:0] = regX3CData[7:0];
	assign X3DData[7:0] = regX3DData[7:0];
	assign X3EData[7:0] = regX3EData[7:0];
	assign X3FData[7:0] = regX3FData[7:0];

	assign X40Data[7:0] = regX40Data[7:0];
	assign X41Data[7:0] = regX41Data[7:0];
	assign X42Data[7:0] = regX42Data[7:0];
	assign X43Data[7:0] = regX43Data[7:0];
	assign X44Data[7:0] = regX44Data[7:0];
	assign X45Data[7:0] = regX45Data[7:0];
	assign X46Data[7:0] = regX46Data[7:0];
	assign X47Data[7:0] = regX47Data[7:0];
	assign X48Data[7:0] = regX48Data[7:0];
	assign X49Data[7:0] = regX49Data[7:0];
	//assign X4AData[7:0] = regX4AData[7:0];
	//assign X4BData[7:0] = regX4BData[7:0];
	//assign X4CData[7:0] = regX4CData[7:0];
	//assign X4DData[7:0] = regX4DData[7:0];
	//assign X4EData[7:0] = regX4EData[7:0];
	//assign X4FData[7:0] = regX4FData[7:0];

	assign X50Data[7:0] = regX50Data[7:0];
	assign X51Data[7:0] = regX51Data[7:0];
	assign X52Data[7:0] = regX52Data[7:0];
	//assign X53Data[7:0] = regX53Data[7:0];
	//assign X54Data[7:0] = regX54Data[7:0];
	//assign X55Data[7:0] = regX55Data[7:0];
	assign X56Data[7:0] = regX56Data[7:0];
	assign X57Data[7:0] = regX57Data[7:0];
	assign X58Data[7:0] = regX58Data[7:0];
	//assign X59Data[7:0] = regX59Data[7:0];
	//assign X5AData[7:0] = regX5AData[7:0];
	//assign X5BData[7:0] = regX5BData[7:0];
	assign X5CData[7:0] = regX5CData[7:0];
	assign X5DData[7:0] = regX5DData[7:0];
	assign X5EData[7:0] = regX5EData[7:0];
	assign X5FData[7:0] = regX5FData[7:0];

	assign X60Data[7:0] = regX60Data[7:0];
	assign X61Data[7:0] = regX61Data[7:0];
	assign X62Data[7:0] = regX62Data[7:0];
	assign X63Data[7:0] = regX63Data[7:0];
	assign X64Data[7:0] = regX64Data[7:0];
	//assign X65Data[7:0] = regX65Data[7:0];
	//assign X66Data[7:0] = regX66Data[7:0];
	//assign X67Data[7:0] = regX67Data[7:0];
	//assign X68Data[7:0] = regX68Data[7:0];
	assign X69Data[7:0] = regX69Data[7:0];
	assign X6AData[7:0] = regX6AData[7:0];
	assign X6BData[7:0] = regX6BData[7:0];
	assign X6CData[7:0] = regX6CData[7:0];
	assign X6DData[7:0] = regX6DData[7:0];
	assign X6EData[7:0] = regX6EData[7:0];
	assign X6FData[7:0] = regX6FData[7:0];

	assign X70Data[7:0] = regX70Data[7:0];
	assign X71Data[7:0] = regX71Data[7:0];
	assign X72Data[7:0] = regX72Data[7:0];
	assign X73Data[7:0] = regX73Data[7:0];
	assign X74Data[7:0] = regX74Data[7:0];
	assign X75Data[7:0] = regX75Data[7:0];
	assign X76Data[7:0] = regX76Data[7:0];
	assign X77Data[7:0] = regX77Data[7:0];
	assign X78Data[7:0] = regX78Data[7:0];
	assign X79Data[7:0] = regX79Data[7:0];
	assign X7AData[7:0] = regX7AData[7:0];
	//assign X7BData[7:0] = regX7BData[7:0];
	//assign X7CData[7:0] = regX7CData[7:0];
	//assign X7DData[7:0] = regX7DData[7:0];
	//assign X7EData[7:0] = regX7EData[7:0];
	//assign X7FData[7:0] = regX7FData[7:0];

	assign X80Data[7:0] = regX80Data[7:0];
	assign X81Data[7:0] = regX81Data[7:0];
	assign X82Data[7:0] = regX82Data[7:0];
	assign X83Data[7:0] = regX83Data[7:0];
	assign X84Data[7:0] = regX84Data[7:0];
	assign X85Data[7:0] = regX85Data[7:0];
	assign X86Data[7:0] = regX86Data[7:0];
	assign X87Data[7:0] = regX87Data[7:0];
	assign X88Data[7:0] = regX88Data[7:0];
	assign X89Data[7:0] = regX89Data[7:0];
	assign X8AData[7:0] = regX8AData[7:0];
	assign X8BData[7:0] = regX8BData[7:0];
	assign X8CData[7:0] = regX8CData[7:0];
	assign X8DData[7:0] = regX8DData[7:0];
	assign X8EData[7:0] = regX8EData[7:0];
	assign X8FData[7:0] = regX8FData[7:0];
	
	assign X90Data[7:0] = regX90Data[7:0];
	assign X91Data[7:0] = regX91Data[7:0];
	assign X92Data[7:0] = regX92Data[7:0];
	assign X93Data[7:0] = regX93Data[7:0];
	assign X94Data[7:0] = regX94Data[7:0];
	assign X95Data[7:0] = regX95Data[7:0];
	assign X96Data[7:0] = regX96Data[7:0];
	assign X97Data[7:0] = regX97Data[7:0];
	assign X98Data[7:0] = regX98Data[7:0];
	assign X99Data[7:0] = regX99Data[7:0];
	assign X9AData[7:0] = regX9AData[7:0];
	assign X9BData[7:0] = regX9BData[7:0];
	assign X9CData[7:0] = regX9CData[7:0];
	assign X9DData[7:0] = regX9DData[7:0];
	assign X9EData[7:0] = regX9EData[7:0];
	//assign X9FData[7:0] = regX9FData[7:0];
	
	assign XA0Data[7:0] = regXA0Data[7:0];
	assign XA1Data[7:0] = regXA1Data[7:0];
	assign XA2Data[7:0] = regXA2Data[7:0];
	assign XA3Data[7:0] = regXA3Data[7:0];
	assign XA4Data[7:0] = regXA4Data[7:0];
	assign XA5Data[7:0] = regXA5Data[7:0];
	assign XA6Data[7:0] = regXA6Data[7:0];
	assign XA7Data[7:0] = regXA7Data[7:0];
	assign XA8Data[7:0] = regXA8Data[7:0];
	assign XA9Data[7:0] = regXA9Data[7:0];
	assign XAAData[7:0] = regXAAData[7:0];
	assign XABData[7:0] = regXABData[7:0];
	assign XACData[7:0] = regXACData[7:0];
	assign XADData[7:0] = regXADData[7:0];
	assign XAEData[7:0] = regXAEData[7:0];
	assign XAFData[7:0] = regXAFData[7:0];

	assign XB0Data[7:0] = regXB0Data[7:0];
	assign XB1Data[7:0] = regXB1Data[7:0];
	assign XB2Data[7:0] = regXB2Data[7:0];
	assign XB3Data[7:0] = regXB3Data[7:0];
	assign XB4Data[7:0] = regXB4Data[7:0];
	assign XB5Data[7:0] = regXB5Data[7:0];
	assign XB6Data[7:0] = regXB6Data[7:0];
	//assign XB7Data[7:0] = regXB7Data[7:0];
	//assign XB8Data[7:0] = regXB8Data[7:0];
	//assign XB9Data[7:0] = regXB9Data[7:0];
	//assign XBAData[7:0] = regXBAData[7:0];
	//assign XBBData[7:0] = regXBBData[7:0];
	//assign XBCData[7:0] = regXBCData[7:0];
	//assign XBDData[7:0] = regXBDData[7:0];
	//assign XBEData[7:0] = regXBEData[7:0];
	//assign XBFData[7:0] = regXBFData[7:0];

	//assign XC0Data[7:0] = regXC0Data[7:0];
	//assign XC1Data[7:0] = regXC1Data[7:0];
	//assign XC2Data[7:0] = regXC2Data[7:0];
	//assign XC3Data[7:0] = regXC3Data[7:0];
	//assign XC4Data[7:0] = regXC4Data[7:0];
	//assign XC5Data[7:0] = regXC5Data[7:0];
	//assign XC6Data[7:0] = regXC6Data[7:0];
	assign XC7Data[7:0] = regXC7Data[7:0];
	assign XC8Data[7:0] = regXC8Data[7:0];
	assign XC9Data[7:0] = regXC9Data[7:0];
	assign XCAData[7:0] = regXCAData[7:0];
	assign XCBData[7:0] = regXCBData[7:0];
	assign XCCData[7:0] = regXCCData[7:0];
	assign XCDData[7:0] = regXCDData[7:0];
	assign XCEData[7:0] = regXCEData[7:0];
	assign XCFData[7:0] = regXCFData[7:0];
//--------------------------------------
//	Read data mux.
//--------------------------------------
	reg		[7:0]	muxRegDataA		;
	reg				muxRegAck		;

	always@ (posedge CLK) begin
		case(regAddr[7:0])
			8'h00:   muxRegDataA[7:0] <= X00Data[7:0];
			8'h01:   muxRegDataA[7:0] <= X01Data[7:0];
			8'h02:   muxRegDataA[7:0] <= X02Data[7:0];
			8'h03:   muxRegDataA[7:0] <= X03Data[7:0];
			8'h04:   muxRegDataA[7:0] <= X04Data[7:0];
			8'h05:   muxRegDataA[7:0] <= X05Data[7:0];
			8'h06:   muxRegDataA[7:0] <= X06Data[7:0];
			8'h07:   muxRegDataA[7:0] <= X07Data[7:0];
			8'h08:   muxRegDataA[7:0] <= X08Data[7:0];
			8'h09:   muxRegDataA[7:0] <= X09Data[7:0];
			8'h0A:   muxRegDataA[7:0] <= X0AData[7:0];
			8'h0B:   muxRegDataA[7:0] <= X0BData[7:0];
			8'h0C:   muxRegDataA[7:0] <= X0CData[7:0];
			8'h0D:   muxRegDataA[7:0] <= X0DData[7:0];
			8'h0E:   muxRegDataA[7:0] <= X0EData[7:0];
			8'h0F:   muxRegDataA[7:0] <= X0FData[7:0];

			8'h10:   muxRegDataA[7:0] <= X10Data[7:0];
			8'h11:   muxRegDataA[7:0] <= X11Data[7:0];
			8'h12:   muxRegDataA[7:0] <= X12Data[7:0];
			8'h13:   muxRegDataA[7:0] <= X13Data[7:0];
			8'h14:   muxRegDataA[7:0] <= X14Data[7:0];
			8'h15:   muxRegDataA[7:0] <= X15Data[7:0];
			8'h16:   muxRegDataA[7:0] <= X16Data[7:0];
			8'h17:   muxRegDataA[7:0] <= X17Data[7:0];
			8'h18:   muxRegDataA[7:0] <= X18Data[7:0];
			8'h19:   muxRegDataA[7:0] <= X19Data[7:0];
			8'h1A:   muxRegDataA[7:0] <= X1AData[7:0];
			8'h1B:   muxRegDataA[7:0] <= X1BData[7:0];
			8'h1C:   muxRegDataA[7:0] <= X1CData[7:0];
			8'h1D:   muxRegDataA[7:0] <= X1DData[7:0];
			8'h1E:   muxRegDataA[7:0] <= X1EData[7:0];
			8'h1F:   muxRegDataA[7:0] <= X1FData[7:0];

			8'h20:   muxRegDataA[7:0] <= X20Data[7:0];
			8'h21:   muxRegDataA[7:0] <= X21Data[7:0];
			8'h22:   muxRegDataA[7:0] <= X22Data[7:0];
			8'h23:   muxRegDataA[7:0] <= X23Data[7:0];
			8'h24:   muxRegDataA[7:0] <= X24Data[7:0];
			8'h25:   muxRegDataA[7:0] <= X25Data[7:0];
			8'h26:   muxRegDataA[7:0] <= X26Data[7:0];
			8'h27:   muxRegDataA[7:0] <= X27Data[7:0];
			8'h28:   muxRegDataA[7:0] <= X28Data[7:0];
			8'h29:   muxRegDataA[7:0] <= X29Data[7:0];
			8'h2A:   muxRegDataA[7:0] <= X2AData[7:0];
			8'h2B:   muxRegDataA[7:0] <= X2BData[7:0];
			8'h2C:   muxRegDataA[7:0] <= X2CData[7:0];
			8'h2D:   muxRegDataA[7:0] <= X2DData[7:0];
			8'h2E:   muxRegDataA[7:0] <= X2EData[7:0];
			8'h2F:   muxRegDataA[7:0] <= X2FData[7:0];

			8'h30:   muxRegDataA[7:0] <= X30Data[7:0];
			8'h31:   muxRegDataA[7:0] <= X31Data[7:0];
			8'h32:   muxRegDataA[7:0] <= X32Data[7:0];
			8'h33:   muxRegDataA[7:0] <= X33Data[7:0];
			8'h34:   muxRegDataA[7:0] <= X34Data[7:0];
			8'h35:   muxRegDataA[7:0] <= X35Data[7:0];
			8'h36:   muxRegDataA[7:0] <= X36Data[7:0];
			8'h37:   muxRegDataA[7:0] <= X37Data[7:0];
			8'h38:   muxRegDataA[7:0] <= X38Data[7:0];
			8'h39:   muxRegDataA[7:0] <= X39Data[7:0];
			8'h3A:   muxRegDataA[7:0] <= X3AData[7:0];
			8'h3B:   muxRegDataA[7:0] <= X3BData[7:0];
			8'h3C:   muxRegDataA[7:0] <= X3CData[7:0];
			8'h3D:   muxRegDataA[7:0] <= X3DData[7:0];
			8'h3E:   muxRegDataA[7:0] <= X3EData[7:0];
			8'h3F:   muxRegDataA[7:0] <= X3FData[7:0];

			8'h40:   muxRegDataA[7:0] <= X40Data[7:0];
			8'h41:   muxRegDataA[7:0] <= X41Data[7:0];
			8'h42:   muxRegDataA[7:0] <= X42Data[7:0];
			8'h43:   muxRegDataA[7:0] <= X43Data[7:0];
			8'h44:   muxRegDataA[7:0] <= X44Data[7:0];
			8'h45:   muxRegDataA[7:0] <= X45Data[7:0];
			8'h46:   muxRegDataA[7:0] <= X46Data[7:0];
			8'h47:   muxRegDataA[7:0] <= X47Data[7:0];
			8'h48:   muxRegDataA[7:0] <= X48Data[7:0];
			8'h49:   muxRegDataA[7:0] <= X49Data[7:0];
			8'h4A:   muxRegDataA[7:0] <= X4AData[7:0];
			8'h4B:   muxRegDataA[7:0] <= X4BData[7:0];
			8'h4C:   muxRegDataA[7:0] <= X4CData[7:0];
			8'h4D:   muxRegDataA[7:0] <= X4DData[7:0];
			8'h4E:   muxRegDataA[7:0] <= X4EData[7:0];
			8'h4F:   muxRegDataA[7:0] <= X4FData[7:0];

			8'h50:   muxRegDataA[7:0] <= X50Data[7:0];
			8'h51:   muxRegDataA[7:0] <= X51Data[7:0];
			8'h52:   muxRegDataA[7:0] <= X52Data[7:0];
			8'h53:   muxRegDataA[7:0] <= X53Data[7:0];
			8'h54:   muxRegDataA[7:0] <= X54Data[7:0];
			8'h55:   muxRegDataA[7:0] <= X55Data[7:0];
			8'h56:   muxRegDataA[7:0] <= X56Data[7:0];
			8'h57:   muxRegDataA[7:0] <= X57Data[7:0];
			8'h58:   muxRegDataA[7:0] <= X58Data[7:0];
			8'h59:   muxRegDataA[7:0] <= X59Data[7:0];
			8'h5A:   muxRegDataA[7:0] <= X5AData[7:0];
			8'h5B:   muxRegDataA[7:0] <= X5BData[7:0];
			8'h5C:   muxRegDataA[7:0] <= X5CData[7:0];
			8'h5D:   muxRegDataA[7:0] <= X5DData[7:0];
			8'h5E:   muxRegDataA[7:0] <= X5EData[7:0];
			8'h5F:   muxRegDataA[7:0] <= X5FData[7:0];

			8'h60:   muxRegDataA[7:0] <= X60Data[7:0];
			8'h61:   muxRegDataA[7:0] <= X61Data[7:0];
			8'h62:   muxRegDataA[7:0] <= X62Data[7:0];
			8'h63:   muxRegDataA[7:0] <= X63Data[7:0];
			8'h64:   muxRegDataA[7:0] <= X64Data[7:0];
			8'h65:   muxRegDataA[7:0] <= X65Data[7:0];
			8'h66:   muxRegDataA[7:0] <= X66Data[7:0];
			8'h67:   muxRegDataA[7:0] <= X67Data[7:0];
			8'h68:   muxRegDataA[7:0] <= X68Data[7:0];
			8'h69:   muxRegDataA[7:0] <= X69Data[7:0];
			8'h6A:   muxRegDataA[7:0] <= X6AData[7:0];
			8'h6B:   muxRegDataA[7:0] <= X6BData[7:0];
			8'h6C:   muxRegDataA[7:0] <= X6CData[7:0];
			8'h6D:   muxRegDataA[7:0] <= X6DData[7:0];
			8'h6E:   muxRegDataA[7:0] <= X6EData[7:0];
			8'h6F:   muxRegDataA[7:0] <= X6FData[7:0];

			8'h70:   muxRegDataA[7:0] <= X70Data[7:0];
			8'h71:   muxRegDataA[7:0] <= X71Data[7:0];
			8'h72:   muxRegDataA[7:0] <= X72Data[7:0];
			8'h73:   muxRegDataA[7:0] <= X73Data[7:0];
			8'h74:   muxRegDataA[7:0] <= X74Data[7:0];
			8'h75:   muxRegDataA[7:0] <= X75Data[7:0];
			8'h76:   muxRegDataA[7:0] <= X76Data[7:0];
			8'h77:   muxRegDataA[7:0] <= X77Data[7:0];
			8'h78:   muxRegDataA[7:0] <= X78Data[7:0];
			8'h79:   muxRegDataA[7:0] <= X79Data[7:0];
			8'h7A:   muxRegDataA[7:0] <= X7AData[7:0];
			8'h7B:   muxRegDataA[7:0] <= X7BData[7:0];
			8'h7C:   muxRegDataA[7:0] <= X7CData[7:0];
			8'h7D:   muxRegDataA[7:0] <= X7DData[7:0];
			8'h7E:   muxRegDataA[7:0] <= X7EData[7:0];
			8'h7F:   muxRegDataA[7:0] <= X7FData[7:0];

			8'h80:   muxRegDataA[7:0] <= X80Data[7:0];
			8'h81:   muxRegDataA[7:0] <= X81Data[7:0];
			8'h82:   muxRegDataA[7:0] <= X82Data[7:0];
			8'h83:   muxRegDataA[7:0] <= X83Data[7:0];
			8'h84:   muxRegDataA[7:0] <= X84Data[7:0];
			8'h85:   muxRegDataA[7:0] <= X85Data[7:0];
			8'h86:   muxRegDataA[7:0] <= X86Data[7:0];
			8'h87:   muxRegDataA[7:0] <= X87Data[7:0];
			8'h88:   muxRegDataA[7:0] <= X88Data[7:0];
			8'h89:   muxRegDataA[7:0] <= X89Data[7:0];
			8'h8A:   muxRegDataA[7:0] <= X8AData[7:0];
			8'h8B:   muxRegDataA[7:0] <= X8BData[7:0];
			8'h8C:   muxRegDataA[7:0] <= X8CData[7:0];
			8'h8D:   muxRegDataA[7:0] <= X8DData[7:0];
			8'h8E:   muxRegDataA[7:0] <= X8EData[7:0];
			8'h8F:   muxRegDataA[7:0] <= X8FData[7:0];

			8'h90:   muxRegDataA[7:0] <= X90Data[7:0];
			8'h91:   muxRegDataA[7:0] <= X91Data[7:0];
			8'h92:   muxRegDataA[7:0] <= X92Data[7:0];
			8'h93:   muxRegDataA[7:0] <= X93Data[7:0];
			8'h94:   muxRegDataA[7:0] <= X94Data[7:0];
			8'h95:   muxRegDataA[7:0] <= X95Data[7:0];
			8'h96:   muxRegDataA[7:0] <= X96Data[7:0];
			8'h97:   muxRegDataA[7:0] <= X97Data[7:0];
			8'h98:   muxRegDataA[7:0] <= X98Data[7:0];
			8'h99:   muxRegDataA[7:0] <= X99Data[7:0];
			8'h9A:   muxRegDataA[7:0] <= X9AData[7:0];
			8'h9B:   muxRegDataA[7:0] <= X9BData[7:0];
			8'h9C:   muxRegDataA[7:0] <= X9CData[7:0];
			8'h9D:   muxRegDataA[7:0] <= X9DData[7:0];
			8'h9E:   muxRegDataA[7:0] <= X9EData[7:0];
			8'h9F:   muxRegDataA[7:0] <= X9FData[7:0];
			
			8'hA0:   muxRegDataA[7:0] <= XA0Data[7:0];
			8'hA1:   muxRegDataA[7:0] <= XA1Data[7:0];
			8'hA2:   muxRegDataA[7:0] <= XA2Data[7:0];
			8'hA3:   muxRegDataA[7:0] <= XA3Data[7:0];
			8'hA4:   muxRegDataA[7:0] <= XA4Data[7:0];
			8'hA5:   muxRegDataA[7:0] <= XA5Data[7:0];
			8'hA6:   muxRegDataA[7:0] <= XA6Data[7:0];
			8'hA7:   muxRegDataA[7:0] <= XA7Data[7:0];
			8'hA8:   muxRegDataA[7:0] <= XA8Data[7:0];
			8'hA9:   muxRegDataA[7:0] <= XA9Data[7:0];
			8'hAA:   muxRegDataA[7:0] <= XAAData[7:0];
			8'hAB:   muxRegDataA[7:0] <= XABData[7:0];
			8'hAC:   muxRegDataA[7:0] <= XACData[7:0];
			8'hAD:   muxRegDataA[7:0] <= XADData[7:0];
			8'hAE:   muxRegDataA[7:0] <= XAEData[7:0];
			8'hAF:   muxRegDataA[7:0] <= XAFData[7:0];
			
			8'hB0:   muxRegDataA[7:0] <= XB0Data[7:0];
			8'hB1:   muxRegDataA[7:0] <= XB1Data[7:0];
			8'hB2:   muxRegDataA[7:0] <= XB2Data[7:0];
			8'hB3:   muxRegDataA[7:0] <= XB3Data[7:0];
			8'hB4:   muxRegDataA[7:0] <= XB4Data[7:0];
			8'hB5:   muxRegDataA[7:0] <= XB5Data[7:0];
			8'hB6:   muxRegDataA[7:0] <= XB6Data[7:0];
			8'hB7:   muxRegDataA[7:0] <= XB7Data[7:0];
			8'hB8:   muxRegDataA[7:0] <= XB8Data[7:0];
			8'hB9:   muxRegDataA[7:0] <= XB9Data[7:0];
			8'hBA:   muxRegDataA[7:0] <= XBAData[7:0];
			8'hBB:   muxRegDataA[7:0] <= XBBData[7:0];
			8'hBC:   muxRegDataA[7:0] <= XBCData[7:0];
			8'hBD:   muxRegDataA[7:0] <= XBDData[7:0];
			8'hBE:   muxRegDataA[7:0] <= XBEData[7:0];
			8'hBF:   muxRegDataA[7:0] <= XBFData[7:0];

			8'hC0:   muxRegDataA[7:0] <= XC0Data[7:0];
			8'hC1:   muxRegDataA[7:0] <= XC1Data[7:0];
			8'hC2:   muxRegDataA[7:0] <= XC2Data[7:0];
			8'hC3:   muxRegDataA[7:0] <= XC3Data[7:0];
			8'hC4:   muxRegDataA[7:0] <= XC4Data[7:0];
			8'hC5:   muxRegDataA[7:0] <= XC5Data[7:0];
			8'hC6:   muxRegDataA[7:0] <= XC6Data[7:0];
			8'hC7:   muxRegDataA[7:0] <= XC7Data[7:0];
			8'hC8:   muxRegDataA[7:0] <= XC8Data[7:0];
			8'hC9:   muxRegDataA[7:0] <= XC9Data[7:0];
			8'hCA:   muxRegDataA[7:0] <= XCAData[7:0];
			8'hCB:   muxRegDataA[7:0] <= XCBData[7:0];
			8'hCC:   muxRegDataA[7:0] <= XCCData[7:0];
			8'hCD:   muxRegDataA[7:0] <= XCDData[7:0];
			8'hCE:   muxRegDataA[7:0] <= XCEData[7:0];
			8'hCF:   muxRegDataA[7:0] <= XCFData[7:0];
			
			default:muxRegDataA[7:0] <= X00Data[7:0];
		endcase

		muxRegAck		<= regCs & (regRe | regWe);
	end

//------------------------------------------------------------------------------
//	Output
//------------------------------------------------------------------------------
	reg				orAck			;
	reg		[7:0]	orRd			;

	always@ (posedge CLK) begin
		orAck <= muxRegAck;
		orRd[7:0] <= (muxRegAck ? muxRegDataA[7:0] : 8'd0);
	end

	wire			RBCP_ACK		;
	wire	[7:0]	RBCP_RD			;

	assign	RBCP_ACK		= orAck;
	assign	RBCP_RD[7:0]	= orRd[7:0];

//------------------------------------------------------------------------------
endmodule
