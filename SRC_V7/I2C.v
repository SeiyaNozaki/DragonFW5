`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:58:15 11/10/2016 
// Design Name: 
// Module Name:    I2C
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module I2C(
    CLK,           //input
    RST,           //input
    SDA_out,       //output
    SDA_in,        //input
	 SCL_out,       //output
	 SCL_in,        //input
	 i2c_finish,    //output
	 i2c_set,       //input
	 I2C_ADDR,      //input
	 I2C_CMD,       //input
	 i2c_mode,      //input
	 i2c_data_num,  //input
	 clk_stretch,   //input
	 I2C_WRITEDATA, //input
	 I2C_READDATA,   //output
	 LED_state0 //debug output
	 );
	
	//port declaration
	input CLK;
	input RST;
   output SDA_out;
   input SDA_in;
	output SCL_out;
	input SCL_in;
	output i2c_finish;
	input i2c_set;
	input[6:0] I2C_ADDR;
	input[7:0] I2C_CMD;
	input i2c_mode;     //0:write 1:read
	input i2c_data_num; //0:0byte(CMD only) 1:1byte
	input clk_stretch;
	input[7:0] I2C_WRITEDATA;
	output[15:0] I2C_READDATA;	
	output[3:0] LED_state0;

	//register declaration
	reg SDA_reg;
	reg SCL_reg;
	reg i2c_finish;
	reg[15:0] recv_data;
	reg[7:0] send_reg;
	
	reg[2:0] reg_count;
	reg[15:0] ack_count;
	reg RorW_reg; //0:write 1:read
	reg send_data_state;
	reg data_num;
	reg set_flag;

	reg[3:0] SDA_state;
	reg SCL_state1;
	reg[1:0] SCL_state2;
	reg[3:0] LED_state;
	
	assign SDA_out = (SDA_reg)? 1'bz : 1'b0;
	assign SCL_out = (SCL_reg)? 1'bz : 1'b0;
	assign I2C_READDATA[15:0] = recv_data[15:0];
	assign LED_state0 = LED_state;
	
	//i2c bus control
	always@(posedge CLK or posedge RST)begin
		if(RST) begin	
			SDA_reg <= 1'b1;
			SCL_reg <= 1'b1;
			i2c_finish <= 1'b0;
			recv_data[15:0] <= 16'd0;
			send_reg[7:0] <= 8'd0;
	
			reg_count[2:0] <= 3'd0;
			ack_count[15:0] <= 16'd0;
			RorW_reg  <= 1'b0;
			send_data_state <= 1'b0;
			data_num  <= 1'b0;
			set_flag  <= 1'b0;

			SDA_state[3:0] <= 4'd0;
			SCL_state1 <= 1'b0;
			SCL_state2[1:0] <= 2'd0;
			LED_state[3:0] <= 4'd0;
			
		end else begin
		
			//SCL 
			if(SCL_state1 == 1'b0)begin
				SCL_reg <= 1'b1; 
				SCL_state2[1:0] <= 2'b00;
			end else begin
				SCL_state2[1:0] <= SCL_state2[1:0] + 2'b01;
				if(SCL_state2[0] == 1'b1)begin
					SCL_reg <= SCL_state2[1];
				end
			end
				
			//SDA
			case(SDA_state[3:0]) 
				4'd0:begin //set
					if(i2c_set == 1'b1)begin
						SDA_state[3:0] <= SDA_state[3:0] + 4'd1;
					end else begin
						SDA_reg   <= 1'b1;
						send_data_state <= 1'b0;
						data_num  <= 1'b0;
						reg_count <= 3'd0;
						ack_count <= 16'd0;
						set_flag  <= 1'b0;
						RorW_reg  <= 1'b0; //write
					end
				end
				
				4'd1:begin //start
					SDA_reg <= 1'b0; 
					SDA_state[3:0]  <= SDA_state[3:0]  + 4'd1;
					SCL_state1      <= 1'b1;
					SCL_state2[1:0] <= SCL_state2[1:0] + 2'b01;
				end
				
				4'd2:begin //set & send data
					if(set_flag == 1'b0)begin
						//set send_data to register
						set_flag <= 1'b1;
						if(send_data_state == 1'b0)begin
							send_reg[7:0] <= {I2C_ADDR[6:0],RorW_reg};
						end else begin
							if(data_num == 1'b0)begin
								send_reg[7:0] <= I2C_CMD[7:0];
							end else begin
								send_reg[7:0] <= I2C_WRITEDATA[7:0];	
							end
						end
					end else begin

						//send data to slave
						if(SCL_state2[1:0] == 2'b10)begin
							SDA_reg <= send_reg[7];
						end
						if(SCL_state2[1:0] == 2'b00)begin
							if(reg_count[2:0] < 3'd7) begin
								send_reg[7:0] <= {send_reg[6:0],1'b0};
								reg_count[2:0] <= reg_count[2:0] + 3'd1;
							end else begin
								reg_count[2:0] <= 3'd0; //reset
								set_flag <= 1'b0;
								SDA_state[3:0] <= SDA_state[3:0] + 4'd1;
								
							end 
						end
					end
				end
							
				4'd3:begin //recieve ACK
					
					//release SDA line
					if(SCL_state2[1:0] == 2'b10)begin
						SDA_reg <= 1'b1;
						
					end
					
					if(SCL_state2[1:0] == 2'b00)begin
						if(SDA_in == 1'b1)begin
							
							if(i2c_set == 1'b1)begin
								if(i2c_finish == 1'b0)begin
									ack_count[15:0] <= ack_count[15:0] + 16'd1;
									SDA_state[3:0] <= 4'd4;//-> restart(No Hold Master Mode)
									if(ack_count[15:0] == 16'hffff)begin
										ack_count[15:0] <= 16'd0;
										i2c_finish <= 1'b1;
									end
								end
							end else begin
								i2c_finish <= 1'b0;
								SCL_state1 <= 1'b0;
								SDA_state[3:0] <= 4'd0; //-->STOP(false)
							end
											
						end else begin
							if(RorW_reg == 1'b1)begin
								SDA_state[3:0] <= 4'd5;//-> receive data
							end else begin
								//after send I2C_ADDR
								if(send_data_state == 1'b0)begin
									SDA_state[3:0] <= 4'd2;//-> send data
									send_data_state <= 1'b1;
								end else begin
								
								//after send I2C_CMD
									//read mode
									if(i2c_mode == 1'b1)begin
										if(clk_stretch == 0)begin
											SDA_state[3:0] <= 4'd4;//reStart
											send_data_state <= 1'b0;
										end else begin
											SCL_state1 <= 1'b0;
											SDA_state[3:0] <= 4'd8;//clock stretch
										end
									
									end else	begin
									//write mode
										if(data_num < i2c_data_num)begin
											SDA_state[3:0] <= 4'd2; //send data
											data_num <= data_num + 1'b1;
										end else begin
											SDA_state[3:0] <= 4'd7; //stop
										end
									end
									
								end
							end
						end
					end
				end
							
				4'd4:begin //restart
					if(SCL_state2[1:0] == 2'b10)begin
						SDA_reg <= 1'b1;
					end 			
					if(SCL_state2[1:0] == 2'b00)begin
						SDA_reg <= 1'b0;
						RorW_reg <= 1'b1; //read
						SDA_state[3:0] <= 4'd2;
					end
				end
				
				4'd5:begin //receive data from slave
					//release SDA line
					if(SCL_state2[1:0] == 2'b10 && reg_count == 3'd0)begin
						SDA_reg <= 1'b1;
					end
					
					if(SCL_state2[1:0] == 2'b00)begin
						recv_data[15:0] <= {recv_data[14:0],SDA_in};
						if(reg_count < 3'd7)begin
							reg_count <= reg_count + 3'd1;
						end else begin
							reg_count <= 3'd0; //reset
							SDA_state[3:0] <= SDA_state[3:0] +4'd1;
						end		
					end
				end
						
				4'd6:begin //send ACK/NACK to slave
					if(SCL_state2[1:0] == 2'b10)begin
						if(data_num == i2c_data_num)begin
							SDA_reg <= 1'b1; //NACK
						end else begin
							SDA_reg <= 1'b0; //ACK
						end
					end
					if(SCL_state2[1:0] == 2'b00)begin
						if(data_num < i2c_data_num)begin
							SDA_state[3:0] <= 4'd5;
							data_num <= data_num + 1'b1;
						end else begin
							SDA_state[3:0] <= SDA_state[3:0] + 4'd1;
						end
					end
				end
				
				4'd7:begin //finish
					if(i2c_set == 1'b1)begin
						if(i2c_finish == 1'b0)begin
							if(SCL_state2[1:0] == 2'b10)begin
								SDA_reg <= 1'b0;
							end
					
							if(SCL_state2[1:0] == 2'b00)begin
								SDA_reg <= 1'b1; //finish
								SCL_state1 <= 1'b0;
								i2c_finish <= 1'b1;
							end
						end
					end else begin
						i2c_finish <= 1'b0;
						SDA_state[3:0] <= 4'd0;
					end
				end

				4'd8:begin //clock stretch
					if(SCL_state2[1:0] == 2'd0 && SCL_in == 1'b1)begin
						SCL_state1 <= 1'b1;
						SDA_state <= 4'd5;
					end
				end
				
				default: SDA_state[3:0] <= 4'd0;
			endcase
		end
	end
endmodule


