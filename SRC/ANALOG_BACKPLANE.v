//dragon_ver4_readout_board
//KONNO Yusuke
//Kyoto Univ.
//analog trigger backplane module
//20140224: created

module ANALOG_BACKPLANE(
			 FPGA_SLOW_CTRL3,
			 FPGA_SLOW_CTRL2,
			 FPGA_SLOW_CTRL1,
			 FPGA_SLOW_CTRL0,
			 clk_66m,
			 rst,
			 command_bp_sc_write,
			 bp_sc_write_done,
			 BP_SC_SENDDATA,
			 BP_SC_READ,
			 command_bp_fpgaprogram,
			 bp_fpgaprogram_done,
			 BP_FPGA_PROGRAM
				 
			 //DEBUG //debug
		 );
	 
//--------------------------------------------
//Port declaration
	input FPGA_SLOW_CTRL3;
	output FPGA_SLOW_CTRL2;
	output FPGA_SLOW_CTRL1;
	output FPGA_SLOW_CTRL0;
	input clk_66m;
	input rst;
	input command_bp_sc_write;
	output bp_sc_write_done;
	input[31:0] BP_SC_SENDDATA;
	output[31:0] BP_SC_READ;
	input command_bp_fpgaprogram;
	output bp_fpgaprogram_done;
	output BP_FPGA_PROGRAM;
	
//--------------------------------------------
//Analog Trigger Backplan Slow Control(SPI)

	reg bp_subclk;
	reg[5:0] bp_subclk_c;
	reg bp_sc_cs;
	reg bp_sc_clk;
	reg bp_sc_mosi;
	wire bp_sc_miso;
	reg[31:0] bp_sc_reg;
	reg[3:0] bp_state;
	reg[7:0] bp_count;
	reg bp_sc_write_done;
	reg[31:0] BP_SC_READ;

	assign FPGA_SLOW_CTRL0 = bp_sc_clk;
	assign FPGA_SLOW_CTRL1 = bp_sc_mosi;
	assign FPGA_SLOW_CTRL2 = bp_sc_cs;
	assign bp_sc_miso = FPGA_SLOW_CTRL3;

	always@(posedge clk_66m or posedge rst) begin
		if(rst) begin	
			bp_subclk <= 1'b0;
			bp_subclk_c <= 6'd0;
			bp_sc_cs <= 1'b1;
			bp_sc_clk <= 1'b0;
			bp_sc_mosi <= 1'b0;
			bp_sc_reg <= 32'd0;
			bp_state <= 4'd0;
			bp_count <= 8'd0;
			bp_sc_write_done <= 1'b0;
			BP_SC_READ <= 32'd0;
		end else begin
			case(bp_state)
				4'd0: begin //command wait
					bp_subclk <= 1'b0;
					bp_subclk_c <= 6'd0;
					bp_sc_cs <= 1'b1;
					bp_sc_clk <= 1'b0;
					bp_sc_mosi <= 1'b0;
					bp_sc_reg <= 32'd0;
					bp_state <= 4'd0;
					bp_count <= 8'd0;
					bp_sc_write_done <= 1'b0;

					if(command_bp_sc_write == 1'b1) begin
						bp_state <= 4'd1;
					end

					if(command_bp_sc_write == 1'b1) begin
						bp_sc_reg <= BP_SC_SENDDATA[31:0];
					end else begin
						bp_sc_reg <= 32'd0;
					end
				end

				4'd1: begin // write BP SC register
					if(bp_subclk == 1'd1 && bp_count == 8'd66) begin
						bp_subclk_c <= 6'd0;
						bp_subclk <= 1'b0;
					end else if(bp_subclk_c == 6'd15)begin
						bp_subclk_c <= 6'd0;
						bp_subclk <= 1'b1;
					end else begin
						bp_subclk_c <= bp_subclk_c + 6'd1;
						bp_subclk <= 1'b0;
					end

					if(bp_subclk == 1'b1) begin
						if(bp_count == 8'd66) begin
							bp_count <= 8'd0;
						end else begin
							bp_count <= bp_count + 8'd1;
						end

						if(bp_count == 8'd0) begin
							bp_sc_cs <= 1'b0;
						end else if(bp_count == 8'd65) begin
							bp_sc_cs <= 1'b1;
						end

						if(bp_count >= 8'd1 && bp_count < 8'd65) begin
							bp_sc_clk <= ~bp_sc_clk;
						end

						if(bp_count >= 8'd1 && bp_sc_clk == 1'b0) begin
							bp_sc_mosi <= bp_sc_reg[31];
							bp_sc_reg[31:0] <= {bp_sc_reg[30:0],1'b0};
						end

						if(bp_sc_clk == 1'b1) begin
							BP_SC_READ[31:0] <= {BP_SC_READ[30:0],bp_sc_miso};
						end

						if(bp_count == 8'd66) begin
							bp_state <= 4'd2;
						end
					end
				end

				4'd2: begin //write done
					if(command_bp_sc_write == 1'b0) begin
						bp_state <= 4'd0;
						bp_sc_write_done <= 1'b0;
					end else begin
						bp_sc_write_done <= 1'b1;
					end
				end
			endcase
		end
	end


//BP FPGA Reboot

	reg bp_fpgaprogram_done;
	reg[7:0] bp_reboot_c;

	assign BP_FPGA_PROGRAM = (command_bp_fpgaprogram ? 1'b0 : 1'b1);

	always@(posedge clk_66m or posedge rst) begin
		if(rst) begin
			bp_reboot_c <= 8'd0;
			bp_fpgaprogram_done <= 1'b0;
		end else begin
			bp_reboot_c <= (command_bp_fpgaprogram ? bp_reboot_c + 8'd1 : 8'd0);
			bp_fpgaprogram_done <= (command_bp_fpgaprogram & bp_reboot_c==8'd34 ? 1'b1 : 1'b0);
		end
	end

endmodule

