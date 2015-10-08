
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PingPong_FSM is
	Port (CLK			:	in STD_LOGIC;
			CLR			:	in STD_LOGIC; 
			EN        	:	in STD_LOGIC; 
			control_out :	out STD_LOGIC_VECTOR(15 downto 0));
end PingPong_FSM;

architecture Behavioral of PingPong_FSM is

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
	process(presentState)
	begin 
		case presentState is 
			
			when T0 => 
				control_out <= ZERO;
				nextState <= T1;

		----------------------------
			when T1 => 
				control_out <= ONE;
				nextState <= T2;
	
		-----------------------------		
			when T2 => 
				control_out <= TWO;
				nextState <= T3;
		
		-------------------------------	
			when T3 => 
				control_out <= THREE;
				nextState <= T4;
				
		------------------------------	
			when T4 => 
				control_out <= FOUR;
				nextState <= T5;
				
		------------------------------	
			when T5 => 
				control_out <= FIVE;
				nextState <= T6;	
				
		------------------------------
			when T6 => 
				control_out <= SIX;
				nextState <= T7;				
	
		-------------------------------	
			when T7 => 
				control_out <= SEVEN;
				nextState <= T8;	
				
		--------------------------------	
			when T8 => 
				control_out <= EIGHT;
				nextState <= T9;
					
		-------------------------------		
			when T9 => 
				control_out <= NINE;
				nextState <= T10;
					
		------------------------------		
			when T10 => 
				control_out <= A;
				nextState <= T11;
					
		------------------------------	
			when T11 => 
				control_out <= B;
				nextState <= T12;
					
		------------------------------
				
			when T12 => 
				control_out <= C;
				nextState <= T13;
					
		------------------------------
				
			when T13 => 
				control_out <= D;
				nextState <= T14;
					
		-------------------------------
			when T14 => 
				control_out <= E;
				nextState <= T15;				
				

		-------------------------------	
			when T15 => 
				control_out <= F;
				nextState <= T16;	

		------------------------------
		--Count down----------------------------------------------------------------
			when T16 => 
				control_out <= F;
				nextState <= T17;

		----------------------------
			when T17 => 
				control_out <= E;
				nextState <= T18;
	
		-----------------------------		
			when T18 => 
				control_out <= D;
				nextState <= T19;
		
		-------------------------------	
			when T19 => 
				control_out <= C;
				nextState <= T20;
				
		------------------------------	
			when T20 => 
				control_out <= B;
				nextState <= T21;
				
		------------------------------	
			when T21 => 
				control_out <= A;
				nextState <= T22;	
				
		------------------------------
			when T22 => 
				control_out <= NINE;
				nextState <= T23;				
	
		-------------------------------	
			when T23 => 
				control_out <= EIGHT;
				nextState <= T24;	
				
		--------------------------------	
			when T24 => 
				control_out <= SEVEN;
				nextState <= T25;
					
		-------------------------------		
			when T25 => 
				control_out <= SIX;
				nextState <= T26;
					
		------------------------------		
			when T26 => 
				control_out <= FIVE;
				nextState <= T27;
					
		------------------------------	
			when T27 => 
				control_out <= FOUR;
				nextState <= T28;
					
		------------------------------
				
			when T28 => 
				control_out <= THREE;
				nextState <= T29;
					
		------------------------------
				
			when T29 => 
				control_out <= TWO;
				nextState <= T30;
					
		-------------------------------
			when T30 => 
				control_out <= ONE;
				nextState <= T31;				
				

		-------------------------------	
			when T31 => 
				control_out <= ZERO;
				nextState <= T0;	

		------------------------------
			end case; 
	end process;
end Behavioral;


