
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mws5966_library;
use mws5966_library.mws5966_Components.ALL;
------------------------------------------------------------------------------------
entity Lab03_top_level_mws5966 is
	port( SWITCHES : in  STD_LOGIC_VECTOR(15 downto 0);
			BTNL     : in  STD_LOGIC;
			BTNR     : in  STD_LOGIC;
			BTNU     : in  STD_LOGIC;
			BTND     : in  STD_LOGIC;
			BTNC     : in  STD_LOGIC;
			LED      : out STD_LOGIC_VECTOR (15 downto 0);
			ANODE    : out STD_LOGIC_VECTOR (7 downto 0);
			SEGMENT  : out STD_LOGIC_VECTOR (0 TO 6));
end Lab03_top_level_mws5966;

architecture Structural of Lab03_top_level_mws5966 is

	-- internal signals 
	signal AVG_int     : STD_LOGIC_VECTOR (3 downto 0);
	--signal Decode_out  : STD_LOGIC_VECTOR (7 downto 0); 
	signal EN_int      : STD_LOGIC;
	signal HEX_in 		 : STD_LOGIC_VECTOR (3 downto 0);
	signal MAX_int     : STD_LOGIC_VECTOR (3 downto 0);
	signal MIN_int     : STD_LOGIC_VECTOR (3 downto 0);
	signal MUX4to1_sel : STD_LOGIC_VECTOR (1 downto 0); 
	signal MUX_out     : STD_LOGIC_VECTOR (3 downto 0);
	signal SUM_int     : STD_LOGIC_VECTOR (3 downto 0);
	
 
begin
   
	-- LED assignments
	LED <= SWITCHES;
	-- logic
	-- logic for MUX4to1_sel
	MUX4to1_sel <= "00" when (BTNL = '1' or BTNR = '1') else 
						"01" when (BTNU = '1') else 
						"10" when (BTND = '1') else 
						"11" when (BTNC = '1') else 
						"00"; 
						
	--logic for EN_int
	EN_int <= (not BTNL) and (not BTNR) and (not BTNU) and (not BTND) and (not BTNC); 
	
	--logic for HEX_in 
	HEX_in <= SWITCHES(15 downto 12) when EN_int = '1' else 
				 MUX_out;
--------------------------------------------------------------------------------------------						
	--mapping components 
	Addsub: AdderSubtractor_nbit
		generic map (N=> 4)
		port map    (A        => SWITCHES(15 downto 12),			  
                   B			 => SWITCHES(11 downto  8),
                   SUBTRACT => BTNR,  
                   SUM  	 => SUM_int,	
                   OVERFLOW => open); 
	AVG: average_nbit
		port map(A_avg   => SWITCHES(15 downto 12),   
		     B_avg   => SWITCHES(11 downto  8),			  
		     C_avg   => SWITCHES(7  downto  4),
			  D_avg   => SWITCHES(3  downto  0), 
		     avg_out => AVG_int);

	MIN: MIN_nbit
		generic map (N=>4)
		port map    (A_top   => SWITCHES(15 downto 12), 	
				       B_top   =>	SWITCHES(11 downto  8), 
				       C_top   =>	SWITCHES(7 downto   4),				    
					    D_top   => SWITCHES(3 downto   0),
			          MIN_OUT => MIN_int);
					 
	MAX: MAX_nbit
		generic map (N=>4)
		port map    (A_top   => SWITCHES(15 downto 12), 	
				       B_top   =>	SWITCHES(11 downto  8), 
				       C_top   =>	SWITCHES(7 downto   4),				    
					    D_top   => SWITCHES(3 downto   0),
			          MAX_OUT => MAX_int);
						 
	-- if getting errors on muxout look here
	MUX: Mux4to1_nbit
		generic map (N=>4)
		port map    (X0  => SUM_int, 	
						 X1  => MAX_int,
						 X2  => MIN_int, 
					    X3  => AVG_int,       
						 SEL => MUX4to1_sel,
						 Y	  => MUX_out);
						 
	DECODE: Decoder3to8
		port map (X  => SWITCHES(15 downto 12), 
					 EN => EN_int,
					 Y  => ANODE);
					 
	HEX: HexToSEvenSeg
		port map (HEX     =>	HEX_in,	
					 SEGMENT => SEGMENT);
		
end Structural;

