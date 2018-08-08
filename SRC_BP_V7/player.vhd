-------------------------------------------------------------------------------
-- copyright (c) 2006 xilinx, inc.
-- this design is confidential and proprietary of xilinx, all rights reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   vendor: xilinx
-- \   \   \/    version: 1.1
--  \   \        filename: player.vhd
--  /   /        date last modified:  Nov 9, 2006
-- /___/   /\    date created: October 2, 2005
-- \   \  /  \
--  \___\/\___\
-- 
--device: all 
--purpose: hardware based player for embedded jtag ACE files.
-- revision 1.1 
-- author: r. white
--reference:
--    xapp 424
--revision history:
--    rev 1.1 - initial release
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--									  
--  uncomment the following lines to use the declarations that are
--  provided for instantiating xilinx primitive components.
library unisim;
use unisim.vcomponents.all;

entity player_nty is
    
	 port ( 
    						 
		tms, tck, tdi : out std_logic;
		rdy, error, eof_done : out std_logic;
		rst, clk, load, tdo : in std_logic;
		prog_cntr : out std_logic_vector (6 downto 0);
		data : in std_logic_vector (7 downto 0)
     			  );
end player_nty;

architecture player_arch of player_nty is

signal pc, branch_val, sub_return: integer range 0 to 127; -- program control
signal reg1, reg2, data_in, gp_count : std_logic_vector (7 downto 0); -- data registers
signal num_bits : std_logic_vector (31 downto 0); 

signal 	count_en, count_once, count_strobe, 
			shift_en, shift_strobe, shift_once, shift_done, 
		  	mask_tdo, shift_count_en, shift_count_strobe, shift_count_once, 
			tdo_compare, more_bytes, count_zero, dec_bits, dec_bits_strobe, 
			dec_bits_once, tdo_shift_en, tdo_shift_once,	tdo_shift_strobe,
			load_once, load_en, exit_shift,
			meta1_ff, meta2_ff : std_logic;

signal output_sel : integer range 0 to 3; -- controls jtag outputs 

signal tdo_val, shift_in : std_logic_vector (7 downto 0); --jtag shift registers
signal shift_count, pad_shift: std_logic_vector (2 downto 0); 

signal tck_s, tms_s : std_logic; 

-- ace instructions

constant shift_tms :  std_logic_vector := "00000010"; --0X02
constant shift_tdi :  std_logic_vector := "00000011";	--0X03
constant shift_check :  std_logic_vector := "00000100"; --0X04
constant runtest :  std_logic_vector := "00000101";	--0X05
constant eof :  std_logic_vector := "00000111";	--0X07

--  labels for micro-program - see spreadsheet table for description
--  important!  edit this table after adding / removing any microprogram instructions

constant get_inst : integer := 8;
constant shift_nxt_byte : integer := 19;
constant runtest_entry : integer := 21;
constant shift_loop : integer := 24;
constant end_tdo : integer := 32;
constant tdo_check : integer := 34;
constant file_error : integer := 45;
constant tdo_chk_error : integer := 47;
constant inst_eof : integer := 49 ;
constant get_byte : integer := 55;
constant reset_chain : integer := 60;

-- labels for controlling header reads 

constant toss_header1  : integer := 255; 	  -- toss 255 bytes of header to get to user-defined section
constant toss_header2  : integer := 255;	  -- use 255 to toss rest (total 512) if not using header
														  -- or insert your code for what you use and change this
														  -- to toss remainder.  Also note, if you set to zero, 
														  -- you still need to include 2 null bytes at the beginning
														  -- of your file because the 2 tests are after 1st byte read

-- labels for jtag output selector

constant sel_runtest : integer := 0;
constant sel_tms : integer := 1;
constant sel_tdi : integer := 2;
constant sel_tdo_ck : integer := 3;

begin

	prog_counter:process (clk, rst)

	begin

	if rst = '0' then
		pc <= 0;
	else

	if rising_edge (clk) then
				  
					pc <= branch_val;
					
		end if;
	end if;

	end process;


micro_program: process (load, clk, pc)

	begin

		prog_cntr <= conv_std_logic_vector (pc , 7);

		if reg2 = reg1 then tdo_compare <= '1'; else tdo_compare <= '0'; end if;

		if more_bytes = '0' and shift_done = '1' then exit_shift <= '1'; 
			else exit_shift <= '0'; end if;

		if shift_count = "000" then shift_done <= '1'; else shift_done <= '0'; end if;

		shift_strobe <= shift_en and not shift_once;
		tdo_shift_strobe <= tdo_shift_en and not tdo_shift_once;
		count_strobe <= count_en and not count_once;
		shift_count_strobe <= shift_count_en and not shift_count_once;
		dec_bits_strobe <= dec_bits and not dec_bits_once;

		if rising_edge (clk) then

		meta1_ff <= load;
		meta2_ff <= meta1_ff;
		load_once <= meta2_ff;
		load_en <= meta2_ff and not load_once;
		shift_once <= shift_en;
		shift_count_once <= shift_count_en;
		tdo_shift_once <= tdo_shift_en;
		dec_bits_once <= dec_bits_strobe;
		count_once <= count_en;
	
		if count_strobe = '1' then
			gp_count <= gp_count - 1; 
			end if;
		
		if gp_count = "00000000" then count_zero <= '1'; else count_zero <= '0'; end if;


 		if tdo_shift_strobe = '1' then
			for i in 0 to 6 loop reg2 (i + 1) <= reg2 (i); end loop;
			for i in 0 to 6 loop tdo_val (i) <= tdo_val (i + 1); end loop;
			reg2(0) <= tdo_val (0);
			end if;
 
 		if shift_strobe = '1' then
			for i in 0 to 6 loop shift_in (i) <= shift_in (i+1); end loop;
			for i in 0 to 6 loop tdo_val (i + 1) <= tdo_val (i); end loop;
			tdo_val (0) <= tdo;
			shift_in (7) <= '0';
			end if;

 		if shift_count_strobe = '1' then shift_count <= shift_count -1; end if;
		
		if dec_bits_strobe = '1' then num_bits <= num_bits - 8; end if;
			
		if mask_tdo = '1' then reg2 <= data_in and reg2; reg1 <= data_in and reg1; end if;

		if num_bits > conv_std_logic_vector (7, 32) then more_bytes <= '1'; 
			else more_bytes <= '0'; 
			end if;


	case output_sel is

		when sel_tms => tms <= shift_in(0); tdi <= '0'; tck <= tck_s;
		when sel_tdi => tdi <= shift_in(0); tms <= tms_s; tck <= tck_s;
		when sel_tdo_ck => tdi <= shift_in(0); tms <= tms_s; tck <= tck_s;
		when sel_runtest => tdi <= '0' ; tms <= '0'; tck <= '0';
		when others => null;
		end case;

-- consult the spreadsheet included in your download for description of this case stmt 

	case pc is 

-- idle 

		when 0 => output_sel <= sel_runtest; rdy <= '0'; branch_val <= pc + 1; tck_s <= '0';
				error <= '0'; eof_done <= '0'; 

-- reset JTAG Bus to Test Logic Reset

		when 1 => branch_val <= reset_chain; sub_return <= PC + 1;
						 
--start ACE File

-- toss 1st 256 bytes which takes you the user-defined area of the header

	when 2 =>  gp_count <=  conv_std_logic_vector (toss_header1 , 8); branch_val <= PC + 1;
					count_en <= '0'; output_sel <= sel_runtest;

		-- for simulation, remember that you can adjust toss header constant to small number 

	when 3 =>  branch_val <= get_byte; count_en <= '0'; sub_return <= PC + 1;
	when 4 =>  if count_zero = '1' then branch_val <= pc + 1; else 
					 branch_val <= pc - 1 ; count_en <= '1'; end if;

-- insert code here if you want to evaluate user-defined header information.  
-- then set toss_header2 to remainder you want to toss.  otherwise toss next 256 bytes

	when 5 =>  gp_count <=  conv_std_logic_vector (toss_header2 , 8); branch_val <= PC + 1;
					count_en <= '0'; output_sel <= sel_runtest;

		-- for simulation, remember that you can adjust toss header constant to small number 

	when 6 =>  branch_val <= get_byte; count_en <= '0'; sub_return <= PC + 1;
	when 7 =>  if count_zero = '1' then branch_val <= pc + 1; else 
					 branch_val <= pc - 1 ; count_en <= '1'; end if;

--get_inst

	when 8 =>  branch_val <= get_byte; count_en <= '0'; sub_return <= PC + 1;
	when 9 =>  reg1 <= data_in; branch_val <= pc + 1;

	when 10 =>  branch_val <= get_byte; count_en <= '0'; sub_return <= PC + 1;
 	when 11 =>  dec_bits <= '0'; num_bits (7 downto 0) <= data_in; branch_val <= pc + 1;
	when 12 =>  branch_val <= get_byte; sub_return <= PC + 1;
	when 13 =>  num_bits (15 downto 8) <= data_in; branch_val <= pc + 1;
	when 14 =>  branch_val <= get_byte; sub_return <= PC + 1;
	when 15 =>  num_bits (23 downto 16) <= data_in; branch_val <= pc + 1;
	when 16 =>  branch_val <= get_byte; sub_return <= PC + 1;
	when 17 =>  num_bits (31 downto 24) <= data_in; branch_val <= pc + 1; shift_en <= '0';

--					if output_sel = sel_runtest then 
--					branch_val <= runtest_entry; else branch_val <= pc + 1; end if;  

		-- evaluate instruction
	when 18 =>	case reg1 is 

				when eof => branch_val <= inst_eof; 
				when shift_tms => branch_val <= shift_nxt_byte; output_sel <= sel_tms;
				when shift_tdi => branch_val <= shift_nxt_byte; output_sel <= sel_tdi;
				when shift_check => branch_val <= shift_nxt_byte; output_sel <= sel_tdo_ck;
				when runtest => branch_val <= runtest_entry ; output_sel <= sel_runtest;
				
				when others => branch_val <= file_error;
 	
				end case;


-- shift_nxt_byte

	when 19 =>  branch_val <= get_byte; count_en <= '0'; sub_return <= PC + 1;
	when 20 =>  shift_in <= data_in;	 branch_val <= pc + 1;

-- runtest_entry

	when 21 => if more_bytes = '1' then branch_val <= pc + 1; 	else  
					branch_val <= pc + 2; end if;  shift_count_en <= '0';
	when 22 =>  shift_count <= conv_std_logic_vector (7, 3); 
					pad_shift <= conv_std_logic_vector (7, 3); branch_val <= pc + 2; 
	when 23 =>  shift_count <= num_bits (2 downto 0) ;
					pad_shift <= num_bits (2 downto 0) ; branch_val <= pc + 1; 

	when 24 =>   branch_val <= pc + 1; shift_count_en <= '0'; -- wait for exit_shift
	when 25 =>  if exit_shift = '1' then tms_s <= '1'; else tms_s <= '0'; end if;
					branch_val <= pc + 1;  
	when 26 => tck_s <= '1'; branch_val <= pc + 1; -- extra TCK - clk divide 	
	when 27 => tck_s <= '1'; branch_val <= pc + 1; shift_en <= '1'; 	

-- fyi - an easy way to divide jtag clock further is to add extra '1' and '0' states here

	when 28 => tck_s <= '0'; branch_val <= pc + 1; shift_en <= '0'; tms_s <= '0';
	when 29 => tck_s <= '0'; branch_val <= pc + 1; shift_en <= '0'; tms_s <= '0';	 -- extra TCK clk div
   when 30 =>  if shift_done = '1' then branch_val <= pc + 1;
				else branch_val <= pc - 6; shift_count_en <= '1'; end if;    
	when 31 =>  if output_sel = sel_tdo_ck then branch_val <= tdo_check;  
				else branch_val <= pc + 1; end if;

   when 32 => 	if more_bytes = '1' then dec_bits <= '1'; branch_val <= pc + 1;  
					else branch_val <= get_inst; end if;				 
	when 33 =>  dec_bits <= '0'; if output_sel = sel_runtest then  branch_val <= runtest_entry; 
					else branch_val <= shift_nxt_byte; end if;


-- tdo_check

  	when 34 =>  shift_count <= pad_shift; branch_val <= pc + 1;	
					tdo_shift_en <= '0';
	when 35 =>  tdo_shift_en <= '1';  shift_count_en <= '0'; branch_val <= pc + 1;
	when 36 =>  tdo_shift_en <= '0';  if shift_done = '1' then branch_val <= pc + 1;
					else branch_val <= pc - 1; shift_count_en <= '1'; end if;

	when 37 =>  branch_val <= get_byte; sub_return <= PC + 1;
	when 38 =>  reg1 <= data_in; branch_val <= pc + 1; --tdo expected 
	when 39 =>  branch_val <= get_byte;  sub_return <= PC + 1;

	when 40 => mask_tdo <= '1'; branch_val <= pc + 1; --mask reg2 with data_in;

	when 41 => mask_tdo <= '0'; branch_val <= pc + 1;  -- wait for compare circuit to settle
	when 42 =>	 if tdo_compare = '1' then branch_val <= end_tdo;  else 
						branch_val <= tdo_chk_error; end if;

-- file_error 

	when 45 => branch_val <= reset_chain; sub_return <= PC + 1;	  -- reset JTAG Bus
	when 46 =>    error <= '1';	eof_done <= '1'; -- stop here 

--tdo_check error 

	when 47 => branch_val <= reset_chain; sub_return <= PC + 1;	 -- reset JTAG Bus
	when 48 =>    error <= '1';	eof_done <= '0';-- stop here 

-- eof

	when 49 => branch_val <= reset_chain; sub_return <= PC + 1; 
	when 50 =>    eof_done <= '1';	error <= '0';  -- stop here 

-- get byte

	when 55 =>  rdy <= '1'; branch_val <= pc + 1; count_en <= '0';
	when 56 => if load_en = '1' then branch_val <= pc + 1; end if;
	when 57 =>  data_in <= data; rdy <= '0'; branch_val <= sub_return;

-- Reset JTAG chain

	when 60 => output_sel <= sel_tms; rdy <= '0'; branch_val <= pc + 1; 
						shift_in <= "11111111";	shift_count <= conv_std_logic_vector (4, 3); 
	when 61 => tck_s <= '1'; branch_val <= pc + 1; shift_en <= '1'; shift_count_en <= '0';	
	when 62 => tck_s <= '0'; branch_val <= pc + 1; shift_en <= '0';
	when 63 =>  if shift_done = '1' then branch_val <= sub_return;
				else branch_val <= pc - 2; shift_count_en <= '1'; end if;    

	when others => null;
	end case;

	end if; 

 end process;
					 		                              
end player_arch;

package player_pkg is
	component player_nty
	end component;
end package;
