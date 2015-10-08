
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mws5966_library;
use mws5966_library.mws5966_components.ALL;
--------------------------------------------------------------------------
entity DataPath is
  port(CLK      			: in STD_LOGIC;
		 CLR      			: in STD_LOGIC;
		 Strobe   			: in STD_LOGIC;
		 CONTROL_out      : in STD_LOGIC_VECTOR(4  downto 0);
	    Train_FSM 			: in STD_LOGIC_VECTOR(15 downto 0);
	    PingPong_FSM 		: in STD_LOGIC_VECTOR(15 downto 0);
	    Physics_FSM 		: in STD_LOGIC_VECTOR(15 downto 0);
	    Wall_FSM 			: in STD_LOGIC_VECTOR(15 downto 0);
	    SEGMENT  			: out STD_LOGIC_VECTOR(0 to 6); 
	    ANODE    			: out STD_LOGIC_VECTOR(7 downto 0);
	    LED      			: out STD_LOGIC_VECTOR(15 downto 0));
	
end DataPath;

architecture Behavioral of DataPath is

-- reg signals 
signal Q_int     : STD_LOGIC_VECTOR(3 downto 0); 
-- word signals 
signal Hex2Seven : STD_LOGIC_VECTOR(31 downto 0);

begin

-- prep the word to put in register before data enters wordTo8dig7seg
	Hex2Seven(31 downto 4)  <= (others => '0');
	Hex2Seven(3  downto 0)  <= Q_int(3 downto 0); 
	
	
	
	HEX: WordTo8dig7seg
	port map(STROBE  	=> Strobe, 
				CLK     	=> CLK,
				CLR     	=> CLR,
				WORD    	=> Hex2Seven,
				DIGIT_EN => "00000001",
				ANODE    => ANODE,
				SEGMENT  => SEGMENT);
				
	Reg: Reg_nbit
	generic map (n => 4)
	port map    (D    => CONTROL_out(3 downto 0),
				    LOAD => CONTROL_out(4), 
				    CLK  => CLK,
				    CLR  => CLR,
				    Q    => Q_int);
					 
	--MUX 5:1 led based off last 3 bits of control out  
	LED <= Train_FSM    when Q_int(2 downto 0) = "010" else
			 PingPong_FSM when Q_int(2 downto 0) = "011" else 
			 physics_FSM  when Q_int(2 downto 0) = "100" else 
			 wall_FSM     when Q_int(2 downto 0) = "101" else 
		    "0000000000000000"; 

end Behavioral;

