----------------------------------------------------------------------------
-- Entity:        ReadFSM
-- Written By:    Michael Stumpf 
-- Date Created:  10 OCT 15
-- Description:   control to read in the scan code and store them in a register 
--
-- Revision History (10/14/15):
-- 
-- Dependencies:
--		read data
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

 
entity ReaderControlFSM is
	PORT (CLK			:	in  STD_LOGIC;
			RESET			:	in  STD_LOGIC;
			LES			:  in  STD_LOGIC; 
			KBCLK			:  in  STD_LOGIC; 
		--	TIMEOUT     :  in  STD_LOGIC; 
			EN 			:  out STD_LOGIC;
			LOAD			:  out STD_LOGIC;
			CLR    		:  out STD_LOGIC;
			state_loc	:  out STD_LOGIC_VECTOR(3 downto 0);
			CODE_READY  :  out STD_LOGIC);	 
end ReaderControlFSM;

architecture Behavioral of ReaderControlFSM is

	type STATE_TYPE is (RESET_STATE, IDLE, INIT, COMP, INC, WAIT1, WAIT2, LOAD_STATE, CODE_READY_STATE);
	
	signal presentState : STATE_TYPE; 
	signal nextState	  : STATE_TYPE;

begin
	
	process (CLK,RESET)
	begin 
		if (RESET = '1') then 
			presentState <= RESET_STATE;
			
		elsif (rising_edge(CLK)) then 
			presentState <= nextState;

		end if; 
	end process; 
	
	---------------upper fsm----------------
	process(presentState, RESET, KBCLK, LES)
	begin 
		case presentState is 
		-- RESET 
		-- GO TO IDLE IF RESET = 0 ELSE GO TO RESET
			when RESET_STATE =>
				EN 		  <= '0'; 
				LOAD       <= '0';
				CLR        <= '1';
				CODE_READY <= '0';
				state_loc  <= "1101";
				
			if (RESET = '0') then 
				nextState <= IDLE;
			
			else 
				nextState <= RESET_STATE;
				
			end if;
			
		-- IDLE
		-- Wait for KBCLK to drop to go to next state 
		-- Code ready is High 
		
			when IDLE => 
				
				
					EN 		  <= '0'; 
					LOAD       <= '0';
					CLR        <= '0';
					CODE_READY <= '0';
					state_loc  <= "1111";
					
				if(KBCLK = '0') then 
					nextState <= INIT;
				
				else 
					nextState <= IDLE;
					
				end if; 
				
		-- INIT
		-- Clears components in data path 
		
			when INIT => 
					
				EN 		  <= '0'; 
				LOAD       <= '0';
				CLR        <= '1';
				CODE_READY <= '0';
				state_loc  <= "1110";
				
				nextState <= COMP;
					
		 -- COMP	
		 -- Takes in the Les signal from the comparator
		 -- Moves to WAIT1 or CODE_READY depending on the Max count (10) 
		 
			 when COMP => 
			 
				EN 		  <= '0'; 
				LOAD       <= '0';
				CLR        <= '0';
				CODE_READY <= '0';
				state_loc  <= "1100";
				
				if(LES = '1') then 
					nextState <= WAIT1;
					
				else
					nextState <= CODE_READY_STATE;
					
				end if;
				
		-- WAIT1
		-- Stays in wait1 till KBCLK goes high
		
			when WAIT1 => 
			
				EN 		  <= '0'; 
				LOAD       <= '0';
				CLR        <= '0';
				CODE_READY <= '0';
				state_loc  <= "1000";
				
				if(KBCLK = '1' ) then 
					nextState <= WAIT2;
					
				else  
					nextState <= WAIT1;
					
				end if; 
						
		-- WAIT2 
		-- Stays in wait2 till KBCLK goes low 
		
			when WAIT2 => 
			
				EN 		  <= '0'; 
				LOAD       <= '0';
				CLR        <= '0';
				CODE_READY <= '0';
				state_loc  <= "1001";
				
				if(KBCLK = '0') then 
					nextState <= LOAD_STATE; 
					
				else
					nextState <= wait2;
				
				end if; 
				
		-- LOAD
		-- Loads a single bit into the shit register 
			
			when LOAD_STATE => 
				
				EN 		  <= '0'; 
				LOAD       <= '1';
				CLR        <= '0';
				CODE_READY <= '0';
				state_loc  <="0001";
								
				nextState <= INC;
						
		-- INC 
		-- increments the count to be compared with 10 
		
			when INC => 
			
				EN 		  <= '1'; 
				LOAD       <= '0';
				CLR        <= '0';
				CODE_READY <= '0';
				state_loc  <="0011";
						
				nextState <= COMP;
					
		-- CODE_READY_STATE
		-- tells the data path the code is read to be accepted 
		
			when CODE_READY_STATE => 
				
				EN 		  <= '0'; 
				LOAD       <= '0';
				CLR        <= '0';
				CODE_READY <= '1';
				state_loc  <="0111";
				
				if(KBCLK = '1') then
					nextState <= IDLE;
					
				else 
					nextState <= CODE_READY_STATE;
			
				end if; 
					
		-- OTHERS state 		
			when others =>
				
				nextState <= RESET_STATE; 
			
			end case; 
	end process; 		
end Behavioral; 

