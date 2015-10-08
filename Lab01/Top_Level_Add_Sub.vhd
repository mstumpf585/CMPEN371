----------------------------------------------------------------------------
-- Entity:        <Top_Level_Add_Sub>
-- Written By:    <Michael Stumpf and Ryan kelley>
-- Date Created:  <8/27/2015>
-- Description:   <Determines weather or not to subtract based of the input of the subtraction
-- 					signal. If the signal is high than the circuit will invert B(0...3)>
--
-- Revision History (date, initials, description):
-- 
-- Dependencies:
--		<FullAdder> <RCA>
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Top_Level_Add_Sub is
    Port ( A 			: in  STD_LOGIC_VECTOR(3 downto 0);		
           B			: in  STD_LOGIC_VECTOR(3 downto 0);
           SUBTRACT  : in  STD_LOGIC;
           SUM 		: out  STD_LOGIC_VECTOR(3 downto 0);
           OVERFLOW  : out  STD_LOGIC);
end Top_Level_Add_Sub;

architecture structual of Top_Level_Add_Sub is

		component RCA
		
		port(C_in 	: in  STD_LOGIC;
           A3 		: in  STD_LOGIC;
           A2 		: in  STD_LOGIC;
           A1 		: in  STD_LOGIC;
           A0 		: in  STD_LOGIC;
           B3 		: in  STD_LOGIC;
           B2 		: in  STD_LOGIC;
           B1 		: in  STD_LOGIC;
           B0 		: in  STD_LOGIC;
           SUM3 	: out  STD_LOGIC;
           SUM2 	: out  STD_LOGIC;
           SUM1 	: out  STD_LOGIC;
           SUM0 	: out  STD_LOGIC;
           C_out  : out  STD_LOGIC);
			  
		end component;
		
		-- Internal signals (wires) for Invert or Pass
		signal BXOR3 : STD_LOGIC;
		signal BXOR2 : STD_LOGIC;
		signal BXOR1 : STD_LOGIC;
		signal BXOR0 : STD_LOGIC;
		
		-- Internal signals (wires) for Invert or Pass
		signal SUM_int : STD_LOGIC_VECTOR(3 downto 0);
		
begin


		--Logic for Invert or Pass (0...3)
		BXOR3 <= B(3) xor SUBTRACT;
		BXOR2 <= B(2) xor SUBTRACT;
		BXOR1 <= B(1) xor SUBTRACT;
		BXOR0 <= B(0) xor SUBTRACT;
		
		RC: RCA port map(
				A3=>A(3),
				A2=>A(2),
				A1=>A(1),
				A0=>A(0),
				B3=>BXOR3,
				B2=>BXOR2,
				B1=>BXOR1,
				B0=>BXOR0,
				C_in=>SUBTRACT,
				SUM3=>SUM_int(3),
				SUM2=>SUM_int(2),
				SUM1=>SUM_int(1),
				SUM0=>SUM_int(0));

		
		
		--Logic for OVERFLOW
		OVERFLOW <= (SUBTRACT and (A(3) and (not B(3)) and (not SUM_int(3))))
					or ((not A(3)) and B(3) and SUM_int(3))
					or ((not SUBTRACT) and ((not A(3)) and (not B(3)) and SUM_int(3))) 
					or (A(3) and B(3) and not(SUM_int(3)));
		
		--set SUM(3..0) == SUM_int (3..0) to output
		SUM(3)<=SUM_int(3);
		SUM(2)<=SUM_int(2);
		SUM(1)<=SUM_int(1);
		SUM(0)<=SUM_int(0);
		
end structual;

