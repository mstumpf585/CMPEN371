----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

 
entity PS2FSM is
	PORT (CLK			:	in  STD_LOGIC;
			RESET			:	in  STD_LOGIC;
			LES			:  in  STD_LOGIC; 
			KBCLK			:  in  STD_LOGIC; 			
			EN 			:  out STD_LOGIC;
			LOAD			:  out STD_LOGIC;
			CLR    		:  out STD_LOGIC;
			CODE_READY  :  out STD_LOGIC);	 
end PS2FSM;

architecture Behavioral of PS2FSM is

	type STATE_TYPE is (RESET_STATE, IDLE, INIT, COMP, INC, WAIT1, WAIT2, LOAD, CODE_READY_STATE);
	
	signal presentState : STATE_TYPE; 
	signal nextState	  : STATE_TYPE;

begin
	
	process (CLK,CLR)
	begin 
		if (CLR = '1') then 
			presentState <= Off;
		elsif (CLK'event and CLK = '1') then 
			presentState <= nextState;
		end if; 
	end process; 
	
	---------------upper fsm----------------
	process(presentState, EN, LES, CLR, LOAD, CODE_READY KBCLK, RESET,)
	begin 
		case presentState is 
		
		-- RESET
		-- sets every thing back to zero 
		-- if CLR isn't high go to idle
		
			when RESET_STATE => 
				
				EN 		  <= '0'; 
				LOAD       <= '0';
				CLR        <= '0';
				CODE_READY <= '0';
			
				if(RESET = '0') then 
					nextState <= IDLE;
					
				elsif(RESET = '1') then 
					nextState <= RESET_STATE; 
				
				end if; 
				
		-- IDLE
		-- Wait for KBCLK to drop to go to next state 
		-- Code ready is High 
		
			when IDLE => 
				
				EN 		  <= '0'; 
				LOAD       <= '0';
				CLR_out    <= '0';
				CODE_READY <= '1';
			
				if(KBCLK = '0') then 
					nextState <= INIT;
				
				elsif(KBCLK = '1') then 
					nextState <= IDLE;
			
				end if; 
				
		-- INIT
		-- Clears components in data path 
		
			when INIT => 
					
				EN 		  <= '0'; 
				LOAD       <= '0';
				CLR_out    <= '0';
				CODE_READY <= '0';
				
				nextState <= COMP;
		
		 -- COMP	
		 -- Takes in the Les signal from the comparator
		 -- Moves to WAIT1 or CODE_READY depending on the Max count (10) 
		 
			 when COMP => 
			 
				EN 		  <= '0'; 
				LOAD       <= '0';
				CLR_out    <= '0';
				CODE_READY <= '0';
				
				if(LES = '0') then 
					nextState <= CODE_READY_STATE;
			
				elsif(LES = '1') then  
					nextState <= WAIT1; 
			
				end if;
				
		-- WAIT1
		-- Stays in wait1 till KBCLK goes high
		
			when WAIT1 => 
			
				EN 		  <= '0'; 
				LOAD       <= '0';
				CLR_out    <= '0';
				CODE_READY <= '0';
				
				if(KBCLK = '0') then 
					nextState <= WAIT1;
					
				elsif(KBCLK = '1') then
					nextState <= WAIT2;
					
				end if; 
						
		-- WAIT2 
		-- Stays in wait2 till KBCLK goes low 
		
			when WAIT2 => 
			
				EN 		  <= '0'; 
				LOAD       <= '0';
				CLR_out    <= '0';
				CODE_READY <= '0';
				
				if(KBCLK = '0') then 
					nextState <= LOAD; 
				
				elsif(KBCLK = '1') then 
					nextState <= WAIT2; 
					
				end if; 
				
		-- LOAD
		-- Loads a single bit into the shit register 
			
			when LOAD => 
				
				EN 		  <= '0'; 
				LOAD       <= '1';
				CLR_out    <= '0';
				CODE_READY <= '0';
				
				nextState <= INC; 
				
		-- INC 
		-- increments the count to be compared with 10 
		
			when INC => 
			
				EN 		  <= '1'; 
				LOAD       <= '0';
				CLR_out    <= '0';
				CODE_READY <= '0';
				
				nextState <= COMP; 
				
		-- CODE_READY_STATE
		-- tells the data path the code is read to be accepted 
		
			when CODE_READY_STATE => 
				
				EN 		  <= '0'; 
				LOAD       <= '0';
				CLR_out    <= '0';
				CODE_READY <= '1';
				
				nextState <= IDLE: 
		
			end case; 
	end process; 		
	end Behavioral; 

