
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mws5966_library;
use mws5966_library.mws5966_components.ALL; 
-----------------------------------------------------------------------------------
entity DataPath_Process is
	port (CLK 			: in  STD_LOGIC; 
			CLR 		   : in  STD_LOGIC;
			CODE_READY 	: in  STD_LOGIC;
			reg_in 		: in  STD_LOGIC_VECTOR(7  downto 0);
			CONTROL_OUT : in  STD_LOGIC_VECTOR(3  downto 0); 
			STATUS_in  	: out STD_LOGIC_VECTOR(7  downto 0);
			XCOORD		: out STD_LOGIC_VECTOR(7  downto 0);
			YCOORD		: out STD_LOGIC_VECTOR(7  downto 0);
			LED15_12		: out STD_LOGIC_VECTOR(15 downto 12)); 
end DataPath_Process;

architecture Behavioral of DataPath_Process is

signal ARROWup	      : STD_LOGIC;
signal ARROWdwn	   : STD_LOGIC;
signal ARROWright	   : STD_LOGIC;
signal ARROWleft	   : STD_LOGIC;
signal x_int			: STD_LOGIC_VECTOR (7 downto 0);
signal y_int  			: STD_LOGIC_VECTOR (7 downto 0); 

begin
	
	reg: Reg_nbit
	generic map (n     => 8)
	port map  	(D     => reg_in, 
					 LOAD  => CODE_READY,
					 CLK   => CLK,
					 CLR   => CLR,
					 Q     => STATUS_in);

	countX: CounterUpDown_nbit
	generic map (n => 8)
	port map 	(EN   => '1',	
					 UP   => ARROWright,	
				    DOWN	=> ARROWleft,
			       CLK 	=> CLK,
			       CLR 	=> CLR, 
			       Q 	=> x_int); 

	countY: CounterUpDown_nbit
	generic map (n => 8)
	port map 	(EN   => '1',	
					 UP   => ARROWup,	
				    DOWN	=> ARROWdwn,
			       CLK 	=> CLK,
			       CLR 	=> CLR, 
			       Q 	=> y_int);
					 
	-- define when arrows are on 
	ARROWup    <= '1' when (CONTROL_out = "1000") else '0';
					
	ARROWdwn   <= '1' when (CONTROL_out = "0010") else '0';
					
	ARROWright <= '1' when (CONTROL_out = "0001") else '0';
					
	ARROWleft  <= '1' when (CONTROL_out = "0010") else '0';
	
	-- define outputs 
	XCOORD <= x_int;
	
	YCOORD <= y_int;
	
	LED15_12	<= CONTROL_out; 
end Behavioral;

