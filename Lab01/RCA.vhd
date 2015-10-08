----------------------------------------------------------------------------
-- Entity:        <RCA>
-- Written By:    <Michael Stumpf and Ryan kelley>
-- Date Created:  <8/26/2015>
-- Description:   <Determines weather or not to subtract based of the input of the subtraction
-- 					signal. If the signal is high than the circuit will invert B(0...3)>
--
-- Revision History (date, initials, description):
-- 
-- Dependencies:
--		<FullAdder>
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RCA is
    Port ( C_in : in  STD_LOGIC;
			  A 			: in  STD_LOGIC_VECTOR(3 downto 0);		
           B			: in  STD_LOGIC_VECTOR(3 downto 0);
           SUM 		: out  STD_LOGIC_VECTOR(3 downto 0);
           C_out  	: out  STD_LOGIC);
end RCA;


architecture Behavioral of RCA is
		
		component FullAdder
		port(A 		: in  STD_LOGIC;
           B 		: in  STD_LOGIC;
           C_in 	: in  STD_LOGIC;
           C_out 	: out  STD_LOGIC;
           SUM 	: out  STD_LOGIC);
		end component;

		-- Internal signals (wires)
		signal carry0 : STD_LOGIC;
		signal carry1 : STD_LOGIC;
		signal carry2 : STD_LOGIC;
begin
		--4 FUllAdders
		FA0: FullAdder port map(
				A=>A(0),
				B=>B(0),
				C_in=>C_in,
				C_out=>carry0,
				SUM=>SUM(0)
				);
				
		FA1: FullAdder port map(
				A=>A(1),
				B=>B(1),
				C_in=> carry0,
				C_out=>carry1,
				SUM=>SUM(1)
				);
				
				
		FA2: FullAdder port map(
				A=>A(2),
				B=>B(2),
				C_in=>carry1,
				C_out=>carry2,
				SUM=>SUM(2)
				);
				
				
		FA3: FullAdder port map(
				A=>A(3),
				B=>B(3),
				C_in=>carry2,
				C_out=>C_out,
				SUM=>SUM(3)
				);
				
end Behavioral;

