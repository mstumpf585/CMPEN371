
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
	port (CLK 		   : STD_LOGIC;
			CLR 		   : STD_LOGIC;
			STATUS_in   : STD_LOGIC_VECTOR (0 to 1);
			Control_out : STD_LOGIC_VECTOR (0 to 1);
			Debug_out	: STD_LOGIC_VECTOR (3 downto 0));
			
end FSM;

architecture Behavioral of FSM is

begin


end Behavioral;

