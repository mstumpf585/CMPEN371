
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mws5966_library;
use mws5966_library.mws5966_components.ALL;

entity byte_sipo is
	port   (D      : in STD_LOGIC_VECTOR(7 downto 0);
			  CLK    : in STD_LOGIC;
			  CLR    : in STD_LOGIC;
			  Rshift : in STD_LOGIC;
			  Q      : out STD_LOGIC_VECTOR(31 downto 0));
end byte_sipo;

architecture Behavioral of byte_sipo is

signal Q_int : STD_LOGIC_VECTOR(31 downto 0):=(others =>'0'); 

begin
 -- registers 
process (CLK) is 
		begin
			if (CLK'event and CLK='1') then 
				if (RSHIFT = '1' and CLR = '0') then
					 Q_int <= D & Q_int(31 downto 8);
				
				elsif( Rshift = '1' and CLR = '1') then
					 Q_int <= (OTHERS => '0');
					 
				elsif( Rshift = '0' and CLR = '1') then 
					 Q_int <= (OTHERS => '0');
					  
				 end if;
			end if;
		end process;
		Q <= Q_int;
end Behavioral;


