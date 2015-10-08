
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Wall_FSM is
	Port (CLK			:	in STD_LOGIC;
			CLR			:	in STD_LOGIC; 
			EN        	:	in STD_LOGIC; 
			STATUS_in 	:  in STD_LOGIC_VECTOR(15 downto 0);
			control_out :	out STD_LOGIC_VECTOR(15 downto 0));
end Wall_FSM;

architecture Behavioral of Wall_FSM is

type STATE_TYPE is (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15,
						  T16, T17, T18, T19, T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31);
	
	signal presentState : STATE_TYPE; 
	signal nextState	  : STATE_TYPE;
	
	constant  ZERO: 		STD_LOGIC_VECTOR(15 downto 0) := "1000000000000000";	
	constant   ONE: 		STD_LOGIC_VECTOR(15 downto 0) := "0100000000000000";
	constant   TWO: 		STD_LOGIC_VECTOR(15 downto 0) := "0010000000000000";
	constant THREE: 		STD_LOGIC_VECTOR(15 downto 0) := "0001000000000000";
	constant  FOUR: 		STD_LOGIC_VECTOR(15 downto 0) := "0000100000000000";
	constant  FIVE: 		STD_LOGIC_VECTOR(15 downto 0) := "0000010000000000";
	constant   SIX: 		STD_LOGIC_VECTOR(15 downto 0) := "0000001000000000";
	constant SEVEN:		STD_LOGIC_VECTOR(15 downto 0) := "0000000100000000";
	constant EIGHT: 		STD_LOGIC_VECTOR(15 downto 0) := "0000000010000000";
	constant  NINE: 		STD_LOGIC_VECTOR(15 downto 0) := "0000000001000000";
	constant     A: 		STD_LOGIC_VECTOR(15 downto 0) := "0000000000100000";
	constant     B: 		STD_LOGIC_VECTOR(15 downto 0) := "0000000000010000";
	constant     C: 		STD_LOGIC_VECTOR(15 downto 0) := "0000000000001000";
	constant     D: 		STD_LOGIC_VECTOR(15 downto 0) := "0000000000000100";
	constant     E: 		STD_LOGIC_VECTOR(15 downto 0) := "0000000000000010";
	constant     F: 		STD_LOGIC_VECTOR(15 downto 0) := "0000000000000001";
	
begin

process (CLK,CLR,EN)
	begin 
		if (CLR = '1') then 
			presentState <= T0;
		elsif (CLK'event and CLK = '1' and EN = '1') then 
			presentState <= nextState;
		end if; 
	end process; 
	
	---------------upper fsm----------------
	process(presentState, STATUS_in)
	begin 
		case presentState is 
			
			when T0 => 
			  if(STATUS_in(0) = '0') then 
					control_out <= ZERO;
					nextState <= T1;
				elsif(STATUS_in(0) = '1') then
					nextState <= T1;
				
				end if;
		----------------------------
			when T1 => 
				control_out <= ONE;
				
				if(STATUS_in(1) = '0') then
					nextState <= T2;
					
				elsif(STATUS_in(1) = '1') then
					nextState <= T0;
					
				end if;
		-----------------------------		
			when T2 => 
				control_out <= TWO;
				
			 	if(STATUS_in(2) = '0') then
					nextState <= T3;
					
				elsif(STATUS_in(2) = '1') then
					nextState <= T30;
					
				end if;
		-------------------------------	
			when T3 => 
				control_out <= THREE;
				
				if(STATUS_in(3) = '0') then
					nextState <= T4;
				elsif(STATUS_in(3) = '1') then
					nextState <= T29;
					
				end if;
		------------------------------	
			when T4 => 
				control_out <= FOUR;
				
				if(STATUS_in(4) = '0') then
					nextState <= T5;
					
				elsif(STATUS_in(4) = '1') then
					nextState <= T28;
					
				end if;
		------------------------------	
			when T5 => 
				control_out <= FIVE;
				
				if(STATUS_in(5) = '0') then
					nextState <= T6;
					
				elsif(STATUS_in(5) = '1') then
					nextState <= T27;
					
				end if;		
		------------------------------
			when T6 => 
				control_out <= SIX;
								
				if(STATUS_in(6) = '0') then
					nextState <= T7;
					
				elsif(STATUS_in(6) = '1') then
					nextState <= T26;
					
				end if;
		-------------------------------	
			when T7 => 
				control_out <= SEVEN;
			
				if(STATUS_in(7) = '0') then
					nextState <= T8;
					
				elsif(STATUS_in(7) = '1') then
					nextState <= T25;
					
				end if;	
		--------------------------------	
			when T8 => 
				control_out <= EIGHT;
				
				if(STATUS_in(8) = '0') then
					nextState <= T9;
					
				elsif(STATUS_in(8) = '1') then
					nextState <= T24;
					
				end if;	
		-------------------------------		
			when T9 => 
				control_out <= NINE;
				
				if(STATUS_in(9) = '0') then
					nextState <= T10;
					
				elsif(STATUS_in(9) = '1') then
					nextState <= T23;
					
				end if;		
		------------------------------		
			when T10 => 
				control_out <= A;
				
				if(STATUS_in(10) = '0') then
					nextState <= T11;
					
				elsif(STATUS_in(10) = '1') then
					nextState <= T22;
					
				end if;
		------------------------------	
			when T11 => 
				control_out <= B;
					
				if(STATUS_in(11) = '0') then
					nextState <= T12;
					
				elsif(STATUS_in(11) = '1') then
					nextState <= T21;
					
				end if;		
		------------------------------
				
			when T12 => 
				control_out <= C;
					
				if(STATUS_in(12) = '0') then
					nextState <= T13;
					
				elsif(STATUS_in(12) = '1') then
					nextState <= T20;
					
				end if;
		------------------------------
				
			when T13 => 
				control_out <= D;
					
				if(STATUS_in(13) = '0') then
					nextState <= T14;
					
				elsif(STATUS_in(13) = '1') then
					nextState <= T19;
					
				end if;
		-------------------------------
			when T14 => 
				control_out <= E;
								
				
			   if(STATUS_in(14) = '0') then
					nextState <= T15;
					
				elsif(STATUS_in(14) = '1') then
					nextState <= T18;
					
				end if;

		-------------------------------	
			when T15 => 
				 if(STATUS_in(15) = '0') then 
					control_out <= F;
					nextState <= T16;
					
					end if;
		------------------------------
		--Count down----------------------------------------------------------------
			when T16 => 
				if(STATUS_in(15) = '0') then 
					control_out <= F;
					nextState <= T17;
				end if;
		----------------------------
			when T17 => 
				control_out <= E;
				
				if(STATUS_in(14) = '0') then
					nextState <= T18;
					
				elsif(STATUS_in(14) = '1') then
					nextState <= T15;
					
				end if;
		-----------------------------		
			when T18 => 
				control_out <= D;
				
				if(STATUS_in(13) = '0') then
					nextState <= T19;
					
				elsif(STATUS_in(13) = '1') then
					nextState <= T14;
					
				end if;
		-------------------------------	
			when T19 => 
				control_out <= C;
				
				if(STATUS_in(12) = '0') then
					nextState <= T20;
					
				elsif(STATUS_in(12) = '1') then
					nextState <= T13;
					
				end if;
		------------------------------	
			when T20 => 
				control_out <= B;
				
				if(STATUS_in(11) = '0') then
					nextState <= T21;
					
				elsif(STATUS_in(11) = '1') then
					nextState <= T12;
					
				end if;
		------------------------------	
			when T21 => 
				control_out <= A;	
				
				if(STATUS_in(10) = '0') then
					nextState <= T22;
					
				elsif(STATUS_in(10) = '1') then
					nextState <= T11;
					
				end if;
		------------------------------
			when T22 => 
				control_out <= NINE;
				nextState <= T23;				
		
				if(STATUS_in(9) = '0') then
					nextState <= T23;
					
				elsif(STATUS_in(9) = '1') then
					nextState <= T10;
					
				end if;
		-------------------------------	
			when T23 => 
				control_out <= EIGHT;	
				
			   if(STATUS_in(8) = '0') then
					nextState <= T24;
					
				elsif(STATUS_in(8) = '1') then
					nextState <= T9;
					
				end if;
		--------------------------------	
			when T24 => 
				control_out <= SEVEN;
					
				if(STATUS_in(7) = '0') then
					nextState <= T25;
					
				elsif(STATUS_in(7) = '1') then
					nextState <= T8;
					
				end if;
		-------------------------------		
			when T25 => 
				control_out <= SIX;
					
				if(STATUS_in(6) = '0') then
					nextState <= T26;
					
				elsif(STATUS_in(6) = '1') then
					nextState <= T7;
					
				end if;
		------------------------------		
			when T26 => 
				control_out <= FIVE;
					
				if(STATUS_in(5) = '0') then
					nextState <= T27;
					
				elsif(STATUS_in(5) = '1') then
					nextState <= T6;
					
				end if;
		------------------------------	
			when T27 => 
				control_out <= FOUR;
					
				if(STATUS_in(4) = '0') then
					nextState <= T28;
					
				elsif(STATUS_in(4) = '1') then
					nextState <= T5;
					
				end if;
		------------------------------
				
			when T28 => 
				control_out <= THREE;
					
				if(STATUS_in(3) = '0') then
					nextState <= T29;
					
				elsif(STATUS_in(3) = '1') then
					nextState <= T4;
					
				end if;
		------------------------------
				
			when T29 => 
				control_out <= TWO;
					
				if(STATUS_in(2) = '0') then
					nextState <= T30;
					
				elsif(STATUS_in(2) = '1') then
					nextState <= T3;
					
				end if;
		-------------------------------
			when T30 => 
				control_out <= ONE;				
				
				if(STATUS_in(1) = '0') then
					nextState <= T31;
					
				elsif(STATUS_in(1) = '1') then
					nextState <= T2;
					
				end if;

		-------------------------------	
			when T31 => 
				 if(STATUS_in(0) = '0') then 
					control_out <= ZERO;
					nextState <= T0;
				elsif(STATUS_in(0) = '1') then
					nextState <= T0;
				end if;
		------------------------------
			end case; 
		end process;
end Behavioral;

