library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity process_FSM is
		PORT (CLK			:	in  STD_LOGIC;
				RESET			:	in  STD_LOGIC;	
				CODE_READY  :  in  STD_LOGIC;
				SCANCODE    :  in  STD_LOGIC_VECTOR(7 downto 0);
				CONTROL_out :  out STD_LOGIC_VECTOR(3 downto 0)); 
end process_FSM;

architecture Behavioral of process_FSM is

type STATE_TYPE is (RESET_STATE, IDLE, LOAD_STATE, WAIT1, ARROWSon, ARROWSoff);
	
	signal presentState : STATE_TYPE; 
	signal nextState	  : STATE_TYPE;
	
begin

	process (CLK,RESET)
	begin 
		if (RESET = '1') then 
			presentState <= RESET_STATE;
		elsif (CLK'event and CLK = '1') then 
			presentState <= nextState;
		end if; 
	end process; 
	
	---------------upper fsm----------------
	process(presentState, CLK, SCANCODE, CODE_READY)
	begin 
		case presentState is 
		
		-- Reset_state 
		-- takes everything to zero
			when RESET_STATE =>
				CONTROL_out <= "0000";
				nextState <= IDLE; 
				
		-- IDLE
		-- Wait for CODE_READY to go high then go to next state 
		-- output 000 
		
			when IDLE => 
				Control_out <= "0000";
				if(CODE_READY = '0') then 
					nextState <= IDLE;
				
				elsif(CODE_READY = '1') then 
					nextState <= LOAD_STATE;
			
				end if; 
				
		-- LOAD_STATE
		-- Clears components in data path 
		
			when LOAD_STATE => 
				Control_out <= "0000";
				if(SCANCODE = "11110000") then -- F0
					nextState <= WAIT1;
				
				else
					nextState <= ARROWSon;
					
				end if;
		
		 -- WAIT1	
		 -- Takes in the Les signal from the comparator
		 -- Moves to WAIT1 or CODE_READY depending on the Max count (10) 
		 
			 when WAIT1 => 
				Control_out <= "0000";
				if(CODE_READY = '0') then 
					nextState <= WAIT1;
			
				elsif(CODE_READY = '1') then  
					nextState <= ARROWSoff; 
			
				end if;
				
		-- ARROWSon
		-- Stays in wait1 till KBCLK goes high
		
			when ARROWSon => 
				
				if(SCANCODE = x"75") then 
					CONTROL_out <= "0001";
					
				elsif(SCANCODE = x"6b") then
					CONTROL_out <= "0100";
					
				elsif(SCANCODE = x"72") then 
					CONTROL_out <= "0010";
					
				elsif(SCANCODE = x"74") then 
					CONTROL_out <= "0001";
				else 
					CONTROL_out <= "0000";
				end if; 
				
				nextState <= IDLE;
		-- ARROWSoff 
		-- Stays in wait2 till KBCLK goes low 
		
			when ARROWSoff => 
				CONTROL_out <= "0000"; 
				
				nextState <= IDLE; 
				end case; 
		end process; 
end Behavioral;

