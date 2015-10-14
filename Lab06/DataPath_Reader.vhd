library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mws5966_library;
use mws5966_library.mws5966_components.ALL; 

entity DataPath_Reader is
	port(EN 			 : in  STD_LOGIC; 
		  CLK 		 : in  STD_LOGIC;
		  CLR        : in  STD_LOGIC;
		  CLR_reg	 : in  STD_LOGIC;
		  LOAD 		 : in  STD_LOGIC; 
		  KBCLK 		 : in  STD_LOGIC; 
		  KBDATA		 : in  STD_LOGIC; 
		  CODE_READY : in  STD_LOGIC; 
		  LES        : out STD_LOGIC;
		  TIMEOUT    : out STD_LOGIC;
		  Q8  		 : out STD_LOGIC_VECTOR(9 downto 0); 		
		  Q32  		 : out STD_LOGIC_VECTOR(31 downto 0)); 		
end DataPath_Reader;

architecture Behavioral of DataPath_Reader is

signal count_int : STD_LOGIC_VECTOR(3  downto 0); 
signal SIPO_out  : STD_LOGIC_VECTOR(9  downto 0);
signal Q32_int   : STD_LOGIC_VECTOR(31 downto 0);

begin

-- portmaps 
	counter: Counter_nbit
	   generic map ( n   => 4)
		port map    (EN   => EN,
					    CLK  => CLK, 
					    CLR  => CLR, 
					    Q    => count_int);
						 
	with(count_int < "1010") select 
		LES <= '1' when true, 
		'0' when others; 
		
	sipo: SIPO_nbit
		generic map(n => 10)
		port map   (D      => KBDATA,  
				      CLK    => CLK, 
			         CLR    => CLR,
			         Rshift => LOAD,
			         Lshift => '0', 
			         Q      =>  SIPO_out);
	-- SET Q8 EQUAL
	Q8<= SIPO_out; 

	byteSIPO: byte_sipo 
	port map   (D      => SIPO_out(7 downto 0),
					CLK    => CLK,                                                                                                  
					CLR    => CLR_reg,
					Rshift => CODE_READY,
					Q      => Q32);
	
--	pulse: PulseGenerator
--	generic map (n         => 32,
--				    maxCount  => 10000000 )
--	port map    (EN  =>  KBCLK,      
--				    CLK =>	CLK,	 
--				    CLR =>	CLR,	 
--				    PULSE_OUT => TIMEOUT);

end Behavioral;

