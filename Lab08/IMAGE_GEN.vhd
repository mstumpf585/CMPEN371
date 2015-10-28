
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mws5966_library;
use mws5966_library.mws5966_components.ALL;

entity IMAGE_GEN is
	port(	BUTTON  : in STD_LOGIC_VECTOR(1 TO 5);
	   	CLK	  : in STD_LOGIC;
			X_in	  : in STD_LOGIC_VECTOR(9 downto 0);
			Y_in	  : in STD_LOGIC_VECTOR(9 downto 0);
			RGB_in  : in STD_LOGIC_VECTOR(11 downto 0);  
			RGB_out : out STD_LOGIC_VECTOR(11 downto 0));  
end IMAGE_GEN;

architecture Behavioral of IMAGE_GEN is

-- boarder compares 
signal XLES 				  : STD_LOGIC;
signal XGRT 				  : STD_LOGIC;
signal YLES 				  : STD_LOGIC;
signal YGRT 				  : STD_LOGIC;

-- box signals 
-- counters 
signal UpDwnX_int 		  : STD_LOGIC_VECTOR(9 downto 0);
signal UpDwnY_int 		  : STD_LOGIC_VECTOR(9 downto 0);

-- RCA 
signal sumX_intR 			  : STD_LOGIC_VECTOR(9 downto 0);
signal sumX_intL 			  : STD_LOGIC_VECTOR(9 downto 0);
signal sumY_intU 			  : STD_LOGIC_VECTOR(9 downto 0);
signal sumY_intD 			  : STD_LOGIC_VECTOR(9 downto 0);

-- comparitors 
signal CountRight		     : STD_LOGIC;
signal CountLeft		     : STD_LOGIC;
signal CountUp		     	  : STD_LOGIC;
signal CountDown		     : STD_LOGIC;

-- border detection 
signal LeftBorder			  : STD_LOGIC;
signal RightBorder		  : STD_LOGIC;
signal UpBorder			  : STD_LOGIC;
signal DownBorder			  : STD_LOGIC;

-- comparitors for box 
signal XLesBox	 			  : STD_LOGIC;
signal XGrtBox	 			  : STD_LOGIC;
signal YLesBox	 			  : STD_LOGIC;
signal YGrtBox	 			  : STD_LOGIC;
signal INBox	 			  : STD_LOGIC;

--Debounce signals 
signal DB_BTNR 			  : STD_LOGIC;
signal DB_BTNL 			  : STD_LOGIC;
signal DB_BTNU 			  : STD_LOGIC;
signal DB_BTND 			  : STD_LOGIC;
signal sample_pulse       : STD_LOGIC;
signal sample_pulse_count : STD_LOGIC;

-- BTN alias
alias BTNL : STD_LOGIC is BUTTON(1);
alias BTNR : STD_LOGIC is BUTTON(2);
alias BTNU : STD_LOGIC is BUTTON(3);
alias BTND : STD_LOGIC is BUTTON(4);
alias BTNC : STD_LOGIC is BUTTON(5);

begin
	
	-- borders --------------------------------------------------------------
	LESX: compareLES
		generic map(N => 10) 
		port map	  (A	   => X_in,	
						B	   => "0000001010",	
						LES   => XLES);
					
	GRTX: compareGRT
		generic map(N => 10) 
		port map	  (A	   => X_in,	
						B	   => "1001110110" ,	
						GRT   => XGRT);
						
	LESY: compareLES
		generic map(N => 10) 
		port map	  (A	   => y_in,	
						B	   => "0000001010",	
						LES   => YLES);
					
	GRTY: compareGRT
		generic map(N => 10) 
		port map	  (A	   => Y_in,	
						B	   => "0111010110",	
						GRT   => YGRT);
	
	-- Box ---------------------------------------------------------------------
	-- Debouncers ------------
	BDR: Debounce
		port map(D			=> BTNR,     
					SAMPLE   => sample_pulse,
					CLK      => CLK,
					Q        => DB_BTNR);
					
	BDL: Debounce
		port map(D			=> BTNL,     
					SAMPLE   => sample_pulse,
					CLK      => CLK,
					Q        => DB_BTNL);
					
	BDU: Debounce
		port map(D			=> BTNU,     
					SAMPLE   => sample_pulse,
					CLK      => CLK,
					Q        => DB_BTNU);
					
	BDD: Debounce
		port map(D			=> BTND,     
					SAMPLE   => sample_pulse,
					CLK      => CLK,
					Q        => DB_BTND);
					
	PULSE1 : PulseGenerator 
		generic map (20, 1000000) 
		port map 	(EN    	    => '1',
					    CLK   	    => CLK,
					    CLR  		 => '0',
					    PULSE_OUT   => sample_pulse);
					 
	-- X part----------------- 
	
	CountRight <= DB_BTNR and RightBorder;
	CountLeft  <= DB_BTNL and LeftBorder;
	
	UpDwnX: CounterUpDown_nbit
		 generic map(n      => 10)
		 port map   (EN 	  => sample_pulse,	
						 UP 	  => CountRight,
					    DOWN	  => CountLeft,
						 CLK 	  => CLK,
						 CLR 	  => '0',
						 Q 	  => UpDwnX_int);
						 
	RCAXR: RCA_nbit 
			  generic map(N => 10) 
			  port map	 (A	  => SUMX_intL,	
							  B	  => "0000010000",	
							  c_in  => '0',
							  c_out => open, 
							  SUM	  => SUMX_intR);
							  
							  
	RCAXL: RCA_nbit 
			  generic map(N => 10) 
			  port map	 (A	  => UpDwnX_int,	
							  B	  => "0100101100",	
							  c_in  => '0',
							  c_out => open, 
							  SUM	  => SUMX_intL);
							  
	RightBox: compareLES
		generic map(N => 10) 
		port map	  (A	   => X_in,	
						B	   => SUMX_intR,	
						LES   => XLesBox);
					
	LeftBox: compareGRT
		generic map(N => 10) 
		port map	  (A	   => X_in,	
						B	   => SUMX_intL,	
						GRT   => XGrtBox);
	-- boarder detection 
	BorderLeft: compareGRT
		generic map(N => 10) 
		port map	  (A	   => SUMX_intL,	
						B	   => "0000001001" ,	
						GRT   => LeftBorder);
						
	BorderRight: compareLES
		generic map(N => 10) 
		port map	  (A	   => SUMX_intR,	
						B	   => "1001110111" ,	
						LES   => RightBorder);
						
	-- Y part -------------------		
	CountUp	 <= DB_BTNU and UpBorder;
	CountDown <= DB_BTND and DownBorder;
	
	UpDwnY: CounterUpDown_nbit
		 generic map(n      => 10)
		 port map   (EN 	  => sample_pulse,	
						 UP 	  => CountDown,
					    DOWN	  => CountUp,
						 CLK 	  => CLK,
						 CLR 	  => BTNC,
						 Q 	  => UpDwnY_int);
						 			  
	RCAYU: RCA_nbit 
			  generic map(N => 10) 
			  port map	 (A	  => "0000010000",	
							  B	  => SUMY_intU,	
							  c_in  => '0',
							  c_out => open, 
							  SUM	  => SUMY_intD);
	
	RCAYD: RCA_nbit 
			  generic map(N => 10) 
			  port map	 (A	  => "0011011100",	
							  B	  => UpDwnY_int,	
							  c_in  => '0',
							  c_out => open, 
							  SUM	  => SUMY_intU);
							  
	DownBox: compareLES
		generic map(N => 10) 
		port map	  (A	   => y_in,	
						B	   => SUMY_intD,	
						LES   => YLesBox);
					
	UpBox: compareGRT
		generic map(N => 10) 
		port map	  (A	   => Y_in,	
						B	   => SUMY_intU,	
						GRT   => YGrtBox);
						
	-- boarder detection 
	BorderUp: compareGRT
		generic map(N => 10) 
		port map	  (A	   => SUMY_intU,	
						B	   => "0000001001" ,	
						GRT   => UpBorder);
						
	BorderDown: compareLES
		generic map(N => 10) 
		port map	  (A	   => SUMY_intD,	
						B	   => "0111010111" ,	
						LES   => DownBorder);
						
	-- and box comparitors
	INBox <= XLesBox and XGrtBox and YLesBox and YGrtBox; 
	RGB_out <= NOT RGB_in when (  XLES = '1' OR XGRT='1' OR YGRT='1' OR YLES='1' or INBox = '1') else 
				  --"000011111111" when (XLesBox = '1' and XGrtBox = '1' and YLesBox = '1' and YGrtBox = '1') else 
					RGB_in;
				
end Behavioral;

