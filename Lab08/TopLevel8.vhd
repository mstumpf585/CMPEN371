
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mws5966_library;
use mws5966_library.mws5966_components.ALL;


entity TopLevel8 is
	PORT (CLK			:	in STD_LOGIC;
			SWITCHES    :  in STD_LOGIC_VECTOR(11 downto 0);
			BUTTON   	: 	in STD_LOGIC_VECTOR(1 TO 5);
			H_sync  		:  out STD_LOGIC;
			V_sync 		:  out STD_LOGIC;
			RGB_out		:  out STD_LOGIC_VECTOR(11 downto 0));
end TopLevel8;

architecture Behavioral of TopLevel8 is

signal X_int 	: STD_LOGIC_VECTOR(9 downto 0);
signal Y_int 	: STD_LOGIC_VECTOR(9 downto 0);
signal RGB_int : STD_LOGIC_VECTOR(11 downto 0);

component IMAGE_GEN is
	port( BUTTON  : in STD_LOGIC_VECTOR(1 TO 5);
			CLK     : in STD_LOGIC;
			X_in	  : in STD_LOGIC_VECTOR(9 downto 0);
			Y_in	  : in STD_LOGIC_VECTOR(9 downto 0);
			RGB_in  : in STD_LOGIC_VECTOR(11 downto 0);  
			RGB_out : out STD_LOGIC_VECTOR(11 downto 0));  
end component;

begin
		
	VGA: VHD_Control 
		port map(CLK 	  =>  CLK,
				   RGB_in  =>  RGB_int, 
					H_sync  =>  H_sync,
					V_sync  =>	V_sync,
					X_out   =>	X_int,
					Y_out   =>	Y_int,
					RGB_out =>	RGB_out);
					
	IMG: IMAGE_GEN
		port map(BUTTON  => BUTTON,
					CLK     =>    CLK,    
					X_in    => X_int,
					Y_in    => Y_int,
					RGB_in  => SWITCHES(11 downto 0),
					RGB_out => RGB_int);
					
end Behavioral;