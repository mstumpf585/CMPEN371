---------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mws5966_library;
use mws5966_library.mws5966_components.ALL;

entity mws5966 is
	port(CLK		  : in  STD_LOGIC;
		  SWITCHES : in  STD_LOGIC_VECTOR(15 downto 4);
		  led17_r  : out STD_LOGIC;
		  led17_g  : out STD_LOGIC;
		  led17_b  : out STD_LOGIC);
		  
end mws5966;

architecture Behavioral of mws5966 is

alias R_Control : STD_LOGIC_VECTOR is SWITCHES(15 downto 12);
alias G_Control : STD_LOGIC_VECTOR is SWITCHES(11 downto  8);
alias B_Control : STD_LOGIC_VECTOR is SWITCHES(7  downto  4);

signal red_int   : STD_LOGIC_VECTOR(7 downto 0);
signal green_int : STD_LOGIC_VECTOR(7 downto 0);
signal blue_int  : STD_LOGIC_VECTOR(7 downto 0);
	
begin

	
	 
	red_int   <= "0000" & R_Control;
	green_int <= "0000" & g_Control;
	blue_int  <= "0000" & b_Control;
	
	PWM2:PWM_control 
		generic map(n      => 8) 
		port map   (CLK	 => CLK,
						PD 	 => "11111111",
						PW		 => red_int,
						PW_out => led17_r);
						
		PWM1:PWM_control 
			generic map(n      => 8) 
			port map   (CLK	 => CLK,
							PD 	 => "11111111",
							PW		 => green_int,
							PW_out => led17_g);

		PWM0:PWM_control 
			generic map(n      => 8) 
			port map   (CLK	 => CLK,
							PD 	 => "11111111",
							PW		 => blue_int,
							PW_out => led17_b);


end Behavioral;



