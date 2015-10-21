
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mws5966_library;
use mws5966_library.mws5966_components.ALL;


entity TopLevel8 is
	PORT (CLK			:	in STD_LOGIC;
			SWITCHES    :  in STD_LOGIC_VECTOR(11 downto 0); 
			H_sync1  	:  out STD_LOGIC;
			V_sync1 		:  out STD_LOGIC;
			RGB_out1		:  out STD_LOGIC_VECTOR(11 downto 0));
end TopLevel8;

architecture Behavioral of TopLevel8 is
	
component VHD_Control is
	port (CLK 	  : in  STD_LOGIC;
			RGB_in  : in  STD_LOGIC_VECTOR(11 downto 0); 
			H_sync  : out STD_LOGIC;
			V_sync  : out STD_LOGIC;
			X_out   : out STD_LOGIC_VECTOR(9 downto 0);
			Y_out   : out STD_LOGIC_VECTOR(9 downto 0);
			RGB_out : out STD_LOGIC_VECTOR(11 downto 0)); 
end component;	

begin
		
	VGA: VHD_Control 
		port map(CLK 	  =>  CLK,
				   RGB_in  =>  SWITCHES(11 downto 0), 
					H_sync  =>  H_sync1,
					V_sync  =>	V_sync1,
					X_out   =>	open,
					Y_out   =>	open,
					RGB_out =>	RGB_out1);
					
end Behavioral;