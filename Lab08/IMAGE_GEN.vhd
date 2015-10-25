
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mws5966_library;
use mws5966_library.mws5966_components.ALL;

entity IMAGE_GEN is
	port( X_in	  : in STD_LOGIC_VECTOR(9 downto 0);
			Y_in	  : in STD_LOGIC_VECTOR(9 downto 0);
			RGB_in  : in STD_LOGIC_VECTOR(11 downto 0);  
			RGB_out : out STD_LOGIC_VECTOR(11 downto 0));  
end IMAGE_GEN;

architecture Behavioral of IMAGE_GEN is

signal XLES : STD_LOGIC;
signal XGRT : STD_LOGIC;
signal YLES : STD_LOGIC;
signal YGRT : STD_LOGIC;

begin

	LESX: compareLES
		generic map(N => 10) 
		port map	  (A	   => X_in,	
						B	   => "0000001010",	
						LES   => XLES);
					
	GRTX: compareGRT
		generic map(N => 10) 
		port map	  (A	   => X_in,	
						B	   => "1001110110" ,	
						GRT   => XGRT);
						
	LESY: compareLES
		generic map(N => 10) 
		port map	  (A	   => y_in,	
						B	   => "0000001010",	
						LES   => YLES);
					
	GRTY: compareGRT
		generic map(N => 10) 
		port map	  (A	   => Y_in,	
						B	   => "0010000000",	
						GRT   => YGRT);

RGB_out <= NOT RGB_in when ( YLES='1'  or XLES = '1' OR XGRT='1'  ) else --OR  OR YGRT='1'
				RGB_in;
				
end Behavioral;

