

module BP_reconfiguration(
	// System
	CLK_133m,			// in	: System clock
	CLK_66m,	// in	: FIFO clock
	RST,			// in	: System reset
	
	//BP JTAG I/F
	JTAG_TCK,
	JTAG_TMS,
	JTAG_TDI,
	JTAG_TDO,
		
	// RBCP I/F
	RBCP_ACT,	// in	: Active
	RBCP_ADDR,	// in	: Address[31:0]
	RBCP_WE,		// in	: Write enable
	RBCP_WD,		// in	: Write data[7:0]
	RBCP_RE,		// in	: Read enable
	RBCP_RD,    // out   : Read data[7:0]
	RBCP_ACK 	// out	: Acknowledge
);

//-------- Input/Output -------------
	input			CLK_133m;
	input			CLK_66m;
	input			RST;
	
	output       JTAG_TCK;
	output       JTAG_TMS;
	output       JTAG_TDI;
	input        JTAG_TDO;
			
	input			RBCP_ACT;
	input[31:0]	RBCP_ADDR;
	input			RBCP_WE;
	input[7:0]	RBCP_WD;
	input			RBCP_RE;
	output[7:0] RBCP_RD;
	output		RBCP_ACK;
			
//------------------------------------------------------------------------------
//	RBCP Control
//------------------------------------------------------------------------------
	reg[31:0]	irAddr;
	reg			irWe;
	reg[7:0]		irWd;
	reg			irRe;

	always@ (posedge CLK_133m or posedge RST) begin
		if(RST)begin
			irAddr[31:0]	<= 32'd0;
			irWe				<= 1'b0;
			irWd[7:0]		<= 8'd0;
			irRe           <= 1'b0;
		end else begin
			irAddr[31:0]	<= RBCP_ADDR[31:0];
			irWe				<= RBCP_WE;
			irWd[7:0]		<= RBCP_WD[7:0];
			irRe           <= RBCP_RE;		
		end
	end

	reg			regCs;
	reg[23:0]	regAddr;
	reg[7:0]		regWd;
	reg			regWe;
	reg			regRe;
	
	/*
	always@ (posedge CLK_133m or posedge RST) begin
		if(RST)begin
			regCs   <= 1'b0;
			regAddr <= 24'd0;
			regWd   <= 8'd0;
			regWe   <= 1'b0;
			regRe   <= 1'b0;
		end else begin
		
			regCs				<= ( irAddr[31:12] == 20'd2);

			regAddr[23:0]	<= (irWe|irRe ? irAddr[23:0] : regAddr[23:0]);
			regWd[7:0]		<= (irWe  ? irWd[7:0]    : regWd[7:0]   );
			regWe				<= irWe;
			regRe				<= irRe;
		end
	end
*/

	always@ (posedge CLK_133m ) begin
	
			regCs				<= ( irAddr[31:12] == 20'd2);

			regAddr[23:0]	<= (irWe|irRe ? irAddr[23:0] : regAddr[23:0]);
			regWd[7:0]		<= (irWe  ? irWd[7:0]    : regWd[7:0]   );
			regWe				<= irWe;
			regRe				<= irRe;
		
	end
	
//------------------------------------------------------------------------------
//	write operation with rbcp
//------------------------------------------------------------------------------
	reg	regAck_wr	;
	reg	orAck_wr		;
	reg   reg_write_enable_fifo;
	

	reg	regAck133	;
	//reg   regAck66		;
	//reg   cnt_orAck   ;


	always@(posedge CLK_133m or posedge RST) begin
		if(RST) begin
			regAck133 <= 1'b0;
			//regAck66 <= 1'b0;
			//reg_write_enable_fifo <= 1'b0;
			regAck_wr <= 1'b0;
			orAck_wr  <= 1'b0;
		end else begin
			
			if(regAck_wr == 1'b0)begin
				regAck_wr <= regCs & regWe;
			end
			/*
			if(reg_write_enable_fifo == 1'b0 && regAck133 == 1'b0)begin
				regAck133 <= (regAck_wr ? 1'b1:1'b0);
			end
			*/
			/*
			if(regAck_wr == 1'b1 && full_fifo == 1'b0 && clk_tmp == 1'b0)begin	
				reg_write_enable_fifo <= 1'b1;
				//regAck66  <= 1'b1;
			end
			*/
			if(reg_write_enable_fifo == 1'b1)begin
				orAck_wr <= 1'b1;
				
//				if(clk_tmp)reg_write_enable_fifo <= 1'b0;		
				//reg_write_enable_fifo <= (clk_tmp ? 1'b0: reg_write_enable_fifo);
			end
			
			if(orAck_wr == 1'b1)begin
				orAck_wr <= 1'b0;
				regAck_wr <= 1'b0;
			end
			/*
			if(regAck66 == 1'b0 && regAck133 == 1'b0)begin
				regAck133 <= (regAck ? 1'b1:1'b0);
			end
			
			if(regAck66 == 1'b0 && regAck133 == 1'b1 && full_fifo == 1'b0 && clk_tmp == 1'b0)begin	
				reg_write_enable_fifo <= 1'b1;
				regAck66  <= 1'b1;
			end 
			
			if(regAck66 == 1'b1 && reg_write_enable_fifo == 1'b1 && clk_tmp == 1'b1)begin
				reg_write_enable_fifo <= 1'b0;
				regAck66  <= 1'b0;			
			end
					
			if(regAck66 == 1'b1 && write_enable_fifo == 1'b1 )begin
				regAck133 <= 1'b0;
				orAck <= 1'b1;
			end
			
			if(orAck == 1'b1)begin
				orAck <= 1'b0;
			end
			*/
		end
	end	
	
	
	
		
	always@(negedge CLK_133m or posedge RST) begin
		if(RST)begin
			reg_write_enable_fifo <= 1'b0;
		end else begin
			if(regAck_wr == 1'b1 && full_fifo == 1'b0 && clk_tmp == 1'b0)begin	
				reg_write_enable_fifo <= 1'b1;
			end	
			if(reg_write_enable_fifo == 1'b1)begin
				reg_write_enable_fifo <= (clk_tmp ? 1'b0: reg_write_enable_fifo);
			end
		end
	end
	
//--------------------------------------
//	Read operation with rbcp
//--------------------------------------
	reg		[7:0]	muxRegDataA		;
	reg				RegAck_rd		;

	always@ (posedge CLK_133m or posedge RST) begin
		if(RST)begin
			muxRegDataA[7:0] <= 8'd0;
			RegAck_rd <= 1'b0;
		end else begin
			case(regAddr[7:0])
				8'h01:  muxRegDataA[7:0] <= {7'd0, empty_fifo};
				8'h02:  muxRegDataA[7:0] <= {7'd0, full_fifo};
				default:muxRegDataA[7:0] <= {7'd0, empty_fifo};
			endcase

			//muxRegAck		<= regCs & (regRe | regWe);
			RegAck_rd		<= regCs &  regRe;
		end
	end
		
	wire			RBCP_ACK		;
	wire	[7:0]	RBCP_RD			;
	reg orAck_rd;
	reg[7:0] orRD;
	
	always@(posedge CLK_133m or posedge RST)begin
		if(RST)begin
			orAck_rd  <= 1'b0;
			orRD[7:0] <= 8'd0;
		end else begin
			orAck_rd <= RegAck_rd;
			orRD[7:0] <= (RegAck_rd ? muxRegDataA[7:0] : 8'd0);
		end
	end

	assign RBCP_ACK      = orAck_wr | orAck_rd;
	assign RBCP_RD[7:0]  = orRD[7:0]; 


//------------------------------------------------------------------------------
//	For CIEMAT module
//------------------------------------------------------------------------------

	//---- clock(33MHz) for CIEMAT module ----
	reg clk_tmp;
	reg[1:0] clk_cnt;	
	
	always@ (posedge CLK_133m or posedge RST) begin
		if(RST)begin
			clk_tmp <= 1'b0;
			clk_cnt[1:0] <= 2'd0;
		end else begin
			if(clk_cnt == 2'd1)begin
				clk_tmp <= clk_tmp + 1'b1;
				clk_cnt <= 2'd0;
			end else begin
				clk_tmp <= clk_tmp;
				clk_cnt <= clk_cnt + 2'd1;
			end

		end
	end
	
	
	//---- signal for CIEMAT module ----
	wire write_enable_fifo;
	wire full_fifo;
	wire empty_fifo;
	wire[9:0] rd_data_count;
	wire[9:0] wr_data_count;
	wire error_out;
	wire eof_out;
	wire clk_ciemat;
	
	assign write_enable_fifo = reg_write_enable_fifo;
	assign clk_ciemat = clk_tmp;
	//----------
	/*
	wire JTAG_TMS_temp;
	wire JTAG_TDI_temp;
	wire JTAG_TCK_temp;
	assign JTAG_TMS = reg_write_enable_fifo;
	assign JTAG_TDI = orAck_wr;
	assign JTAG_TCK = clk_tmp;
	*/
	//--------------


	Dragon2jtag dragon2jtag(
		.data_in(regWd[7:0]),	// in	: ACE data(1 byte)
		.rst_fifo(RST),         // in : reset
		.clk_in(clk_ciemat),       // in : clock for FIFO
		.write_enable_fifo(write_enable_fifo), // in 
		.full_fifo(full_fifo),                 // out
		.empty_fifo(empty_fifo),               // out
		.rd_data_count(rd_data_count[9:0]),    // out
		.wr_data_count(wr_data_count[9:0]),    // out
  		.error_out(error_out),                 // out
		.eof_out(eof_out),                     // out
		.tms(JTAG_TMS),                        // out
		//.tms(JTAG_TMS_temp),                        // out
		.tdi(JTAG_TDI),                        // out
		//.tdi(JTAG_TDI_temp),                        // out
		.tck(JTAG_TCK),          		// out
		//.tck(JTAG_TCK_temp),                        // out
		.tdo(JTAG_TDO)                         // in
	);
	
endmodule
