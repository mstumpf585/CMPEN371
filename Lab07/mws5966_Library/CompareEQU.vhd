----------------------------------------------------------------------------
-- Entity:        CompareGRT
-- Written By:    Michael Stumpf
-- Date Created:  11 Sep 15
-- Description:   compares two n bit unsigned numbers to see which is bigger
--
-- Revision History (date, initials, description):
-- 	(none)
-- Dependencies:
--		None
----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_STD.ALL; 
----------------------------------------------------------------------------
entity CompareEQU is
	generic ( N : integer := 4); 
   Port    ( A : in  STD_LOGIC_VECTOR (n-1 downto 0);
             B : in  STD_LOGIC_VECTOR (n-1 downto 0);
             EQU : out STD_LOGIC);
end CompareEQU;

architecture Behavioral of CompareEQU is

-- none 

begin

EQU <= '1' when (A = B) 
			  else '0'; 

end Behavioral;

