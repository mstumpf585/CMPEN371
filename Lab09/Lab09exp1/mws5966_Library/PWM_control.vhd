
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mws5966_library;
use mws5966_library.mws5966_components.ALL;

entity PWM_control is
	generic( n : integer := 8); 
	port(CLK		: in STD_LOGIC;
		  PD 		: in STD_LOGIC_VECTOR(n-1 downto 0);
		  PW		: in STD_logic_VECTOR(n-1 downto 0);
		  PW_out : out STD_LOGIC);
end PWM_control;

architecture Behavioral of PWM_control is

signal count_int : STD_LOGIC_VECTOR(n-1 downto 0);
signal LES_int   : STD_LOGIC;
signal EQU_int   : STD_LOGIC;

begin

	count: counter_nbit
		generic map(n => 8)
		port map   (EN		=> '1', 
						CLK	=> CLK,
						CLR   => EQU_int,
						Q		=> count_int);
						
	equals: CompareEQU
		generic map (n   => 8)
		port map 	(A   => count_int,
						 B   => PD,
						 EQU => EQU_int);
						 
	less: CompareLES
		generic map(n=> 8)
		port map   (A	 => count_int,
						B   => PW,
					   LES => LES_int);
	
	DFF: D_flip_flop
		port map(D    => LES_int,
					CLK  => CLK,
					Q	  => PW_out);
					

end Behavioral;

