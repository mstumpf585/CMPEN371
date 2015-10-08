
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Top_Level_Add_sub_tb IS
END Top_Level_Add_sub_tb;
 
ARCHITECTURE behavior OF Top_Level_Add_sub_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Top_Level_Add_Sub
    PORT(
         A3 : IN  std_logic;
         A2 : IN  std_logic;
         A1 : IN  std_logic;
         A0 : IN  std_logic;
         B3 : IN  std_logic;
         B2 : IN  std_logic;
         B1 : IN  std_logic;
         B0 : IN  std_logic;
         SUBTRACT : IN  std_logic;
         SUM3 : OUT  std_logic;
         SUM2 : OUT  std_logic;
         SUM1 : OUT  std_logic;
         SUM0 : OUT  std_logic;
         OVERFLOW : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A3 : std_logic := '0';
   signal A2 : std_logic := '0';
   signal A1 : std_logic := '0';
   signal A0 : std_logic := '0';
   signal B3 : std_logic := '0';
   signal B2 : std_logic := '0';
   signal B1 : std_logic := '0';
   signal B0 : std_logic := '0';
   signal SUBTRACT : std_logic := '0';

 	--Outputs
   signal SUM3 : std_logic;
   signal SUM2 : std_logic;
   signal SUM1 : std_logic;
   signal SUM0 : std_logic;
   signal OVERFLOW : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Top_Level_Add_Sub PORT MAP (
          A3 => A3,
          A2 => A2,
          A1 => A1,
          A0 => A0,
          B3 => B3,
          B2 => B2,
          B1 => B1,
          B0 => B0,
          SUBTRACT => SUBTRACT,
          SUM3 => SUM3,
          SUM2 => SUM2,
          SUM1 => SUM1,
          SUM0 => SUM0,
          OVERFLOW => OVERFLOW
        ); 

   -- Stimulus process
   stim_proc: process
	
   begin		
	
      -- hold reset state for 100 ns.
      wait for 100 ns;			
		-- 4+3
		A3 <= '0'; A2 <= '1'; A1 <= '0'; A0 <= '0';   
		B3 <= '0'; B2 <= '0'; B1 <= '1'; B0 <= '1'; 
		SUBTRACT <= '0';		
		wait for 100 ns;
		
		assert (OVERFLOW = '0' and SUM3 = '0' and SUM2 = '1' and SUM1 = '1' and SUM0 = '1') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- 1+1
		A3 <= '0'; A2 <= '0'; A1 <= '0'; A0 <= '1';   
		B3 <= '0'; B2 <= '0'; B1 <= '0'; B0 <= '1'; 
		SUBTRACT <= '0';		
		wait for 100 ns;
		
		assert (OVERFLOW = '0' and SUM3 = '0' and SUM2 = '0' and SUM1 = '1' and SUM0 = '0') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- -6+5 
		A3 <= '1'; A2 <= '0'; A1 <= '1'; A0 <= '0';   
		B3 <= '0'; B2 <= '1'; B1 <= '0'; B0 <= '1'; 
		SUBTRACT <= '0';		
		wait for 100 ns;
		
		assert (OVERFLOW = '0' and SUM3 = '1' and SUM2 = '1' and SUM1 = '1' and SUM0 = '1') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- -3-4	
		A3 <= '1'; A2 <= '1'; A1 <= '0'; A0 <= '1';   
		B3 <= '0'; B2 <= '1'; B1 <= '0'; B0 <= '0'; 
		SUBTRACT <= '1';		
		wait for 100 ns;
		
		assert (OVERFLOW = '0' and SUM3 = '1' and SUM2 = '0' and SUM1 = '0' and SUM0 = '1') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- 4 - 7
		A3 <= '0'; A2 <= '1'; A1 <= '0'; A0 <= '0';   
		B3 <= '0'; B2 <= '1'; B1 <= '1'; B0 <= '1'; 
		SUBTRACT <= '1';		
		wait for 100 ns;
		
		assert (OVERFLOW = '0' and SUM3 = '1' and SUM2 = '1' and SUM1 = '0' and SUM0 = '1') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
			
		-- -8+2
		A3 <= '1'; A2 <= '0'; A1 <= '0'; A0 <= '0';   
		B3 <= '0'; B2 <= '0'; B1 <= '1'; B0 <= '0'; 
		SUBTRACT <= '0';		
		wait for 100 ns;
		
		assert (OVERFLOW = '0' and SUM3 = '1' and SUM2 = '0' and SUM1 = '1' and SUM0 = '0') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- 7-3
		A3 <= '0'; A2 <= '1'; A1 <= '1'; A0 <= '1';   
		B3 <= '0'; B2 <= '0'; B1 <= '1'; B0 <= '1'; 
		SUBTRACT <= '1';		
		wait for 100 ns;
		
		assert (OVERFLOW = '0' and SUM3 = '0' and SUM2 = '1' and SUM1 = '0' and SUM0 = '0') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
			
		-- -8-4
		A3 <= '1'; A2 <= '0'; A1 <= '0'; A0 <= '0';   
		B3 <= '0'; B2 <= '1'; B1 <= '0'; B0 <= '0'; 
		SUBTRACT <= '1';		
		wait for 100 ns;
		
		assert (OVERFLOW = '1' and SUM3 = '0' and SUM2 = '1' and SUM1 = '0' and SUM0 = '0') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
			
		-- 5-2 
		A3 <= '0'; A2 <= '1'; A1 <= '0'; A0 <= '1';   
		B3 <= '0'; B2 <= '0'; B1 <= '1'; B0 <= '0'; 
		SUBTRACT <= '1';		
		wait for 100 ns;
		
		assert (OVERFLOW = '0' and SUM3 = '0' and SUM2 = '0' and SUM1 = '1' and SUM0 = '1') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
			
			
		-- -6+5
		A3 <= '1'; A2 <= '0'; A1 <= '1'; A0 <= '0';   
		B3 <= '0'; B2 <= '1'; B1 <= '0'; B0 <= '1'; 
		SUBTRACT <= '0';		
		wait for 100 ns;
		
		assert (OVERFLOW = '0' and SUM3 = '1' and SUM2 = '1' and SUM1 = '1' and SUM0 = '1') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
				
		-- 6 + -4
		A3 <= '0'; A2 <= '1'; A1 <= '1'; A0 <= '0';   
		B3 <= '1'; B2 <= '1'; B1 <= '0'; B0 <= '0'; 
		SUBTRACT <= '0';		
		wait for 100 ns;
		
		assert (OVERFLOW = '0' and SUM3 = '0' and SUM2 = '0' and SUM1 = '1' and SUM0 = '0') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
		
		-- -3+5	
		A3 <= '1'; A2 <= '1'; A1 <= '0'; A0 <= '1';   
		B3 <= '0'; B2 <= '1'; B1 <= '0'; B0 <= '1'; 
		SUBTRACT <= '0';		
		wait for 100 ns;
		
		assert (OVERFLOW = '0' and SUM3 = '0' and SUM2 = '0' and SUM1 = '1' and SUM0 = '0') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- -2+9	
		A3 <= '1'; A2 <= '1'; A1 <= '1'; A0 <= '0';   
		B3 <= '1'; B2 <= '0'; B1 <= '0'; B0 <= '1'; 
		SUBTRACT <= '0';		
		wait for 100 ns;
		
		assert (OVERFLOW = '1' and SUM3 = '0' and SUM2 = '1' and SUM1 = '1' and SUM0 = '1') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- -1+8	
		A3 <= '1'; A2 <= '1'; A1 <= '1'; A0 <= '1';   
		B3 <= '1'; B2 <= '0'; B1 <= '0'; B0 <= '0'; 
		SUBTRACT <= '0';		
		wait for 100 ns;
		
		assert (OVERFLOW = '1' and SUM3 = '0' and SUM2 = '1' and SUM1 = '1' and SUM0 = '1') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- 8-3	
		A3 <= '1'; A2 <= '0'; A1 <= '0'; A0 <= '0';   
		B3 <= '0'; B2 <= '0'; B1 <= '1'; B0 <= '1'; 
		SUBTRACT <= '1';		
		wait for 100 ns;
		
		assert (OVERFLOW = '1' and SUM3 = '0' and SUM2 = '1' and SUM1 = '0' and SUM0 = '1') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- 5-4	
		A3 <= '0'; A2 <= '1'; A1 <= '0'; A0 <= '1';   
		B3 <= '0'; B2 <= '1'; B1 <= '0'; B0 <= '0'; 
		SUBTRACT <= '1';		
		wait for 100 ns;
		
		assert (OVERFLOW = '0' and SUM3 = '0' and SUM2 = '0' and SUM1 = '0' and SUM0 = '1') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
		
		-- 6-4	
		A3 <= '0'; A2 <= '1'; A1 <= '1'; A0 <= '0';   
		B3 <= '0'; B2 <= '1'; B1 <= '0'; B0 <= '0'; 
		SUBTRACT <= '1';		
		wait for 100 ns;
		
		assert (OVERFLOW = '0' and SUM3 = '0' and SUM2 = '0' and SUM1 = '1' and SUM0 = '0') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
		
		-- 5-3	
		A3 <= '0'; A2 <= '1'; A1 <= '0'; A0 <= '1';   
		B3 <= '0'; B2 <= '0'; B1 <= '1'; B0 <= '1'; 
		SUBTRACT <= '1';		
		wait for 100 ns;
		
		assert (OVERFLOW = '0' and SUM3 = '0' and SUM2 = '0' and SUM1 = '1' and SUM0 = '0') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- -7 -2	
		A3 <= '1'; A2 <= '0'; A1 <= '0'; A0 <= '1';   
		B3 <= '0'; B2 <= '0'; B1 <= '1'; B0 <= '0'; 
		SUBTRACT <= '1';		
		wait for 100 ns;
		
		assert (OVERFLOW = '1' and SUM3 = '0' and SUM2 = '1' and SUM1 = '1' and SUM0 = '1') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;
			
		-- - 8+1	
		A3 <= '1'; A2 <= '0'; A1 <= '0'; A0 <= '0';   
		B3 <= '0'; B2 <= '0'; B1 <= '0'; B0 <= '1'; 
		SUBTRACT <= '0';		
		wait for 100 ns;
		
		assert (OVERFLOW = '0' and SUM3 = '1' and SUM2 = '0' and SUM1 = '0' and SUM0 = '1') 
			report "FAILURE: C_out and/or SUM does not equal expected value." 
			severity failure;	
			
      wait;
   end process;

END;
