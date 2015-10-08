----------------------------------------------------------------------------
-- Entity:        FullAdder_tb
-- Written By:    E. George Walters
-- Date Created:  18 Aug 13
-- Description:   VHDL testbench for FullAdder
--
-- Revision History (date, initials, description):
--   26 Aug 14, egw100, Modified port signal names to reflect course standard
-- 
-- Dependencies:
--   FullAdder
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

----------------------------------------------------------------------------
entity RCA_tb is
end    RCA_tb;
----------------------------------------------------------------------------

architecture Behavioral of RCA_tb is

	-- Unit Under Test (UUT)
	component RCA is
		Port ( C_in : in  STD_LOGIC;
            A 			: in  STD_LOGIC_VECTOR(3 downto 0);		
				B			: in  STD_LOGIC_VECTOR(3 downto 0);
				SUM 		: out  STD_LOGIC_VECTOR(3 downto 0);
				C_out 	: out  STD_LOGIC);
	end component RCA;

   --Inputs
   signal A3    : std_logic := '0';
	signal A2    : std_logic := '0';
	signal A1    : std_logic := '0';
	signal A0    : std_logic := '0';
   signal B3    : std_logic := '0';
	signal B2    : std_logic := '0';
	signal B1    : std_logic := '0';
	signal B0    : std_logic := '0';
   signal C_in  : std_logic := '0';

 	--Outputs
   signal C_out  : std_logic;
   signal SUM3   : std_logic;
	signal SUM2   : std_logic;
	signal SUM1   : std_logic;
	signal SUM0   : std_logic;
	
begin

	-- Instantiate the Unit Under Test (UUT)
   uut: RCA port map (
          A(3)     => A3,
			 A(2)     => A2,
			 A(1)     => A1,
			 A(0)     => A0,
          B(3)     => B3,
			 B(2)     => B2,
			 B(1)     => B1,
			 B(0)     => B0,
          C_in   	 => C_in,
          C_out    => C_out,
          SUM(3)   => SUM3,
			 SUM(2)   => SUM2,
			 SUM(1)   => SUM1,
			 SUM(0)   => SUM0
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
		
		--random test cases 
		
		-- 0+0
		A3 <= '0'; A2 <= '0'; A1 <= '0'; A0 <= '0';   B3 <= '0'; B2 <= '0'; B1 <= '0'; B0 <= '0'; C_in <= '0';
		wait for 100 ns;
		assert (C_out = '0' and SUM3 = '0' and SUM2 = '0' and SUM1 = '0' and SUM0 = '0') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
		
		-- 4+8
		A3 <= '0'; A2 <= '1'; A1 <= '0'; A0 <= '0';   
		B3 <= '1'; B2 <= '0'; B1 <= '0'; B0 <= '0'; 
		C_in <= '0';		
		wait for 100 ns;
		
		assert (C_out = '0' and SUM3 = '1' and SUM2 = '1' and SUM1 = '0' and SUM0 = '0') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- 1+1
		A3 <= '0'; A2 <= '0'; A1 <= '0'; A0 <= '1';   
		B3 <= '0'; B2 <= '0'; B1 <= '0'; B0 <= '1'; 
		C_in <= '0';		
		wait for 100 ns;
		
		assert (C_out = '0' and SUM3 = '0' and SUM2 = '0' and SUM1 = '1' and SUM0 = '0') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- 7+9
		A3 <= '0'; A2 <= '1'; A1 <= '1'; A0 <= '1';   
		B3 <= '1'; B2 <= '0'; B1 <= '0'; B0 <= '1'; 
		C_in <= '0';		
		wait for 100 ns;
		
		assert (C_out = '1' and SUM3 = '0' and SUM2 = '0' and SUM1 = '0' and SUM0 = '0') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- 10+5 
		A3 <= '1'; A2 <= '0'; A1 <= '1'; A0 <= '0';   
		B3 <= '0'; B2 <= '1'; B1 <= '0'; B0 <= '1'; 
		C_in <= '0';		
		wait for 100 ns;
		
		assert (C_out = '0' and SUM3 = '1' and SUM2 = '1' and SUM1 = '1' and SUM0 = '1') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- 7+4	
		A3 <= '0'; A2 <= '1'; A1 <= '1'; A0 <= '1';   
		B3 <= '0'; B2 <= '1'; B1 <= '0'; B0 <= '0'; 
		C_in <= '0';		
		wait for 100 ns;
		
		assert (C_out = '0' and SUM3 = '1' and SUM2 = '0' and SUM1 = '1' and SUM0 = '1') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
			
		-- 4+8
		A3 <= '0'; A2 <= '1'; A1 <= '0'; A0 <= '0';   
		B3 <= '1'; B2 <= '0'; B1 <= '0'; B0 <= '0'; C_in <= '0';		
		wait for 100 ns;
		
		assert (C_out = '0' and SUM3 = '1' and SUM2 = '1' and SUM1 = '0' and SUM0 = '0') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- 2+3
		A3 <= '0'; A2 <= '0'; A1 <= '0'; A0 <= '1';   
		B3 <= '0'; B2 <= '0'; B1 <= '0'; B0 <= '1'; 
		C_in <= '0';		
		wait for 100 ns;
		
		assert (C_out = '0' and SUM3 = '0' and SUM2 = '0' and SUM1 = '1' and SUM0 = '0') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- 7+9
		A3 <= '0'; A2 <= '1'; A1 <= '1'; A0 <= '1';   
		B3 <= '1'; B2 <= '0'; B1 <= '0'; B0 <= '1'; 
		C_in <= '0';		
		wait for 100 ns;
		
		assert (C_out = '1' and SUM3 = '0' and SUM2 = '0' and SUM1 = '0' and SUM0 = '0') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- 10+5 
		A3 <= '1'; A2 <= '0'; A1 <= '1'; A0 <= '0';   
		B3 <= '0'; B2 <= '1'; B1 <= '0'; B0 <= '1'; 
		C_in <= '0';		
		wait for 100 ns;
		
		assert (C_out = '0' and SUM3 = '1' and SUM2 = '1' and SUM1 = '1' and SUM0 = '1') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- 7+4	
		A3 <= '0'; A2 <= '1'; A1 <= '1'; A0 <= '1';   
		B3 <= '0'; B2 <= '1'; B1 <= '0'; B0 <= '0'; 
		C_in <= '0';		
		wait for 100 ns;
		
		assert (C_out = '0' and SUM3 = '1' and SUM2 = '0' and SUM1 = '1' and SUM0 = '1') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
	
		-- 6+4	
		A3 <= '0'; A2 <= '1'; A1 <= '1'; A0 <= '0';   
		B3 <= '0'; B2 <= '1'; B1 <= '0'; B0 <= '0'; 
		C_in <= '0';		
		wait for 100 ns;
		
		assert (C_out = '0' and SUM3 = '1' and SUM2 = '0' and SUM1 = '1' and SUM0 = '0') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
		
		-- 3+5	
		A3 <= '0'; A2 <= '0'; A1 <= '1'; A0 <= '1';   
		B3 <= '0'; B2 <= '1'; B1 <= '0'; B0 <= '1'; 
		C_in <= '0';		
		wait for 100 ns;
		
		assert (C_out = '0' and SUM3 = '1' and SUM2 = '0' and SUM1 = '0' and SUM0 = '0') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- 2+9	
		A3 <= '0'; A2 <= '0'; A1 <= '1'; A0 <= '0';   
		B3 <= '1'; B2 <= '0'; B1 <= '0'; B0 <= '1'; 
		C_in <= '0';		
		wait for 100 ns;
		
		assert (C_out = '0' and SUM3 = '1' and SUM2 = '0' and SUM1 = '1' and SUM0 = '1') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- 1+8	
		A3 <= '0'; A2 <= '0'; A1 <= '0'; A0 <= '1';   
		B3 <= '1'; B2 <= '0'; B1 <= '0'; B0 <= '0'; 
		C_in <= '0';		
		wait for 100 ns;
		
		assert (C_out = '0' and SUM3 = '1' and SUM2 = '0' and SUM1 = '0' and SUM0 = '1') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- 3+8	
		A3 <= '0'; A2 <= '0'; A1 <= '1'; A0 <= '1';   
		B3 <= '1'; B2 <= '0'; B1 <= '0'; B0 <= '0'; 
		C_in <= '0';		
		wait for 100 ns;
		
		assert (C_out = '0' and SUM3 = '1' and SUM2 = '0' and SUM1 = '1' and SUM0 = '1') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- 5+4	
		A3 <= '0'; A2 <= '1'; A1 <= '0'; A0 <= '1';   
		B3 <= '0'; B2 <= '1'; B1 <= '0'; B0 <= '0'; 
		C_in <= '0';		
		wait for 100 ns;
		
		assert (C_out = '0' and SUM3 = '1' and SUM2 = '0' and SUM1 = '0' and SUM0 = '1') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
		
		
      wait;
		
   end process;

end Behavioral;

