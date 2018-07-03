----------------------------------------------------------------------------------
-- Company: CIEMAT
-- Engineer: Sara Soleto Mayo
-- 
-- Create Date:    16:33:59 02/27/2018 
-- Design Name: 
-- Module Name:    FIFO_player - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity FIFO_player is
    Port ( 	
--------------------------FIFO-----------------------------
				data_in : in  STD_LOGIC_VECTOR (7 downto 0);
				rst_fifo : in STD_LOGIC;
				clk_in : in  STD_LOGIC;
				write_enable_fifo : in  STD_LOGIC;
				full_fifo : out  STD_LOGIC;
				empty_fifo : out  STD_LOGIC;
				rd_data_count : out  STD_LOGIC_VECTOR(9 downto 0);
				wr_data_count : out STD_LOGIC_VECTOR (9 downto 0);
				
---------------------------PLAYER---------------------------
            error_out: out STD_LOGIC;
				eof_out: out STD_LOGIC;
				tms : out STD_LOGIC;
				tck : out STD_LOGIC;
				tdi : out std_logic;
				tdo : in std_logic
			);
end FIFO_player;

---------------------- ARCHITECTURE-------------------------
architecture Behavioral of FIFO_player is

-----------------------PLAYER SIGNALS-----------------------
signal rdy : std_logic;
signal error : std_logic; 
signal eof_done : std_logic;
signal rst : std_logic;
signal clk : std_logic;
signal load : std_logic;
signal status: std_logic_vector(7 downto 0);
signal prog_cntr : std_logic_vector (6 downto 0);
signal data : std_logic_vector (7 downto 0);

------------------------FIFO SIGNALS------------------------
signal dout_fifo: std_logic_vector (7 downto 0);

signal rd_data_count_fifo : STD_LOGIC_VECTOR(9 DOWNTO 0);
signal wr_data_count_fifo : STD_LOGIC_VECTOR(9 DOWNTO 0);

signal data_count_fifo1: std_logic_vector(7 downto 0);
signal data_count_fifo2: std_logic_vector(7 downto 0);
signal data_count_fifo3: std_logic_vector(7 downto 0);
signal data_count_fifo4: std_logic_vector(7 downto 0);

signal q1: std_logic;
signal q2: std_logic;
signal load_fifo: std_logic;

signal read_enable: std_logic;
signal write_enable: std_logic;

signal empty: std_logic;
signal full: std_logic;


------------------------JTAG SIGNALS-------------------------
signal tck_int: std_logic;
signal tms_int: std_logic;
signal tdi_int: std_logic;
signal tdo_int: std_logic;

-------------------------CLK SIGNALS-------------------------

constant max_contador: integer := 1;
signal contador : integer range 0 to max_contador;

------------------------PLAYER COMPONENT---------------------
component player_nty
	Port (
		tms : out std_logic;
		tck : out std_logic;
		tdi : out std_logic;
		rdy : out std_logic;
		error : out std_logic; 
		eof_done : out std_logic;
		rst : in std_logic;
		clk : in std_logic; 
		load : in std_logic;
		tdo : in std_logic;
		prog_cntr : out std_logic_vector (6 downto 0);
		data : in std_logic_vector (7 downto 0)
		);
end component;

------------------------FIFO COMPONENT-----------------------

COMPONENT usb2jtag_fifo
		  PORT (
			 rst : IN STD_LOGIC;
			 wr_clk : IN STD_LOGIC;
			 rd_clk : IN STD_LOGIC;
			 din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			 wr_en : IN STD_LOGIC;
			 rd_en : IN STD_LOGIC;
			 dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			 full : OUT STD_LOGIC;
			 empty : OUT STD_LOGIC;
			 rd_data_count : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
			 wr_data_count : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
		  );
END COMPONENT;

begin

	status <= "00" & empty &  full & '0' & error & eof_done & rdy;
	rst <= not rst_FIFO;
	
	write_enable <= write_enable_fifo and not full;
	
	data_count_fifo1 <= rd_data_count_fifo(7 downto 0);
	data_count_fifo2 <= "000000" & rd_data_count_fifo(9 downto 8);
	data_count_fifo3 <= wr_data_count_fifo(7 downto 0);
	data_count_fifo4 <= "000000" & wr_data_count_fifo(9 downto 8);
	
	
	
			  
-------------------------FIFO MAP-----------------------------
			  
U1 : usb2jtag_fifo PORT MAP
		  ( rst => rst_FIFO,
			 wr_clk => clk,
			 rd_clk => clk,
			 din => data_in,
			 wr_en => write_enable,
			 rd_en => read_enable,
			 dout => dout_fifo,
			 full => full,
			 empty => empty,
			 rd_data_count => rd_data_count_fifo,
          wr_data_count => wr_data_count_fifo
		  );			  
 
-------------------------PLAYER MAP---------------------------
U2: player_nty Port map
		  ( tms => tms_int,
			 tck => tck_int,
			 tdi => tdi_int,
			 rdy => rdy,
		    error => error,
		    eof_done => eof_done,
		    rst => rst,
		    clk => clk,
			 load => load_fifo,
			 tdo => tdo_int,
			 prog_cntr => prog_cntr,
		    data => dout_fifo
			);
-------------------------CLK GENERATION-----------------------
	
generate_clk: process(clk_in)
	begin
		if clk_in'event and clk_in='1' then
			clk <= not clk_in;
		end if;
	end process;
			
---------------READ_ENABLE AND LOAD_ENABLE PROCESS------------
enable_read: process(clk)
	begin
	  if clk'event and clk='1' then
			q1 <= rdy and not empty;
			q2 <= q1;
		 end if;
	end process;
	  
	 read_enable <= q1 and not q2;
	 
load_enable: process(clk)
	begin
	  if clk'event and clk='1' then
			load_fifo <= read_enable;
		 end if;
	end process;
	
   tms <= tms_int;
   tck <= tck_int;
   tdi <= tdi_int;
	
   tdo_int <= tdo;
	
	empty_fifo <= empty;
	full_fifo <= full;
	
	error_out <= error;
	eof_out <= eof_done;
	
end Behavioral;