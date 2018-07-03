//dragon_ver3_readout_board
//KONNO Yusuke
//Kyoto Univ.
//ad9222 spi module

module ADC_SPI(
	AD9222_CSBn,
	AD9222_SCLK,
	AD9222_SDIO,
	AD9222_SDIO_DIR,

	clk,
	rst,
	adcspi_en,
	//ADC_TEST_PATTERN,
	ADC_SPI_DATA,
	ADC_SPI_ADDR,
	command_dacset,
	adcspi_finish
 );
	 
//--------------------------------------------
//Port declaration
	output AD9222_CSBn;
	output AD9222_SCLK;
	inout AD9222_SDIO;
	output AD9222_SDIO_DIR;
	
	input clk;
	input rst;
	output adcspi_en;
	//input[3:0] ADC_TEST_PATTERN;
	input[7:0] ADC_SPI_DATA;
	input[12:0] ADC_SPI_ADDR;
	input command_dacset;
	output adcspi_finish;
//------------------------------------------------------------------
//AD9222 SPI (for gerating test pattern)
	reg AD9222_CSBn;
	reg AD9222_SCLK;
	wire AD9222_SDIO;
	reg ad9222_sdo;
	reg AD9222_SDIO_DIR;
	reg[7:0] adcspi_c;
	reg[23:0] adcspi_sr;
	reg adcspi_en;
	reg[1:0] adcspi_state;
	reg[7:0] adcspi_c2;
	reg adcspi_finish;
	
	assign AD9222_SDIO = (AD9222_SDIO_DIR ? ad9222_sdo : 1'bz);
	
	always@(posedge clk or posedge rst)begin
		if(rst)begin
			AD9222_CSBn <= 1'b1;
			AD9222_SCLK <= 1'b0;
			ad9222_sdo <= 1'b0;
			AD9222_SDIO_DIR <= 1'b0;
			adcspi_c <= 8'd0;
			adcspi_sr <= 24'd0;
			adcspi_en <= 1'b0;
			adcspi_state <= 2'd0;
			adcspi_c2 <= 8'd0;
			adcspi_finish <= 1'b0;
		end else begin

			case(adcspi_state)

				2'd0:begin
					if(adcspi_c2 == 8'd100) begin
					adcspi_c2 <= 8'd0;
						if(adcspi_c == 8'd0)begin
							AD9222_CSBn <= 1'b0;
							AD9222_SDIO_DIR <= 1'b1;
								//adcspi_sr <= {1'b0,2'b00,13'h00D,4'b0000,ADC_TEST_PATTERN};
								adcspi_sr <= {1'b0,2'b00,ADC_SPI_ADDR,ADC_SPI_DATA};
							adcspi_c <= adcspi_c + 8'd1;
						end else if (adcspi_c == 8'd1) begin
							ad9222_sdo <= adcspi_sr[23];
							adcspi_c <= adcspi_c + 8'd1;
						end else if(adcspi_c < 8'd26) begin
							if(AD9222_SCLK == 1'b0)begin
								AD9222_SCLK <= 1'b1;
								adcspi_sr[23:0] <= {adcspi_sr[22:0],1'b0};
							end else begin
								AD9222_SCLK <= 1'b0;
								ad9222_sdo <= adcspi_sr[23];
								adcspi_c <= adcspi_c + 8'd1;
							end
						end else if(adcspi_c == 8'd26) begin
							AD9222_CSBn <= 1'b1;
							ad9222_sdo <= 1'b0;
							AD9222_SDIO_DIR <= 1'b1;
							adcspi_c <= 8'd0;
							adcspi_sr <= 24'd0;
						end
					end else begin
						adcspi_c2 <= adcspi_c2 + 8'd1;
					end
					
					if(adcspi_c == 8'd26) begin
						adcspi_state <= 2'd3;
					end
				end
				
				2'd1: begin //done
					adcspi_en <= 1'b1;
					if(command_dacset) begin
						adcspi_state <= 2'd2;
					end
				end
				
				2'd2: begin //reset
					AD9222_CSBn <= 1'b1;
					AD9222_SCLK <= 1'b0;
					ad9222_sdo <= 1'b0;
					AD9222_SDIO_DIR <= 1'b0;
					adcspi_c <= 8'd0;
					adcspi_sr <= 24'd0;
					adcspi_en <= 1'b0;					
					adcspi_c2 <= 8'd0;
					
					adcspi_state <= 2'd0;
				end

				2'd3:begin //finish flag
					if(command_dacset == 1'b1) begin
						adcspi_finish <= 1'b1;
					end else begin
						adcspi_finish <= 1'b0;
					end
					
					if(command_dacset == 1'b0) begin
						adcspi_state <= 2'd1;
					end
				end

			endcase

		end
	end

endmodule
