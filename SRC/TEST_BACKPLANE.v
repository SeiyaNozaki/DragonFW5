//dragon_ver4_readout_board
//KONNO Yusuke
//Kyoto University
//dummy backplane
//20140404 created

module TEST_BACKPLANE(
	clk_133m,
	TESTBP_EXTTRG,
	testbp_exttrg_bufo
);

	input clk_133m;
	input TESTBP_EXTTRG;
	output testbp_exttrg_bufo;

	reg testbp_exttrg_ir;
	reg testbp_exttrg_ir2;

	always@(posedge clk_133m) begin
		testbp_exttrg_ir <= TESTBP_EXTTRG;
		testbp_exttrg_ir2 <= testbp_exttrg_ir;
	end

	assign testbp_exttrg_bufo = testbp_exttrg_ir & ~testbp_exttrg_ir2;

endmodule	
