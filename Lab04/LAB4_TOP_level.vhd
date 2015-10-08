----------------------------------------------------------------------------
-- Entity:        LAB4_TOP
-- Written By:    Michael Stumpf
-- Date Created:  21 Sep 15
-- Description:   stores n bits 
--
-- Revision History (date, initials, description):
-- 	(none)
-- Dependencies:
--		Reg_nbit, Counter_nbit, D_flip_flop, Debounce, oneShot, PulseGenerator 
--		WordTo8dig7seg, HexToSevenSeg
----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library mws5966_library;
use mws5966_library.mws5966_Components.ALL;


entity LAB4_TOP_level is
	port( SWITCHES : in  STD_LOGIC_VECTOR(15 downto 0);
			BTNL     : in  STD_LOGIC;
			BTNR     : in  STD_LOGIC;
			BTNU     : in  STD_LOGIC;
			BTND     : in  STD_LOGIC;
			BTNC     : in  STD_LOGIC;
			CLK      : in  STD_LOGIC; 
			LED      : out STD_LOGIC_VECTOR (15 downto 0);
			ANODE    : out STD_LOGIC_VECTOR (7 downto 0);
			SEGMENT  : out STD_LOGIC_VECTOR (0 TO 6));
end LAB4_TOP_level;

architecture Behavioral of LAB4_TOP_level is

-- constants 
	-- anode 7..0
		constant anode7  : STD_LOGIC_VECTOR(7 downto 0) := "01111111"; 
		constant anode6  : STD_LOGIC_VECTOR(7 downto 0) := "10111111"; 	
		constant anode5  : STD_LOGIC_VECTOR(7 downto 0) := "11011111"; 
		constant anode4  : STD_LOGIC_VECTOR(7 downto 0) := "11101111"; 
		constant anode3  : STD_LOGIC_VECTOR(7 downto 0) := "11110111"; 
		constant anode2  : STD_LOGIC_VECTOR(7 downto 0) := "11111011"; 
		constant anode1  : STD_LOGIC_VECTOR(7 downto 0) := "11111101"; 
		constant anode0  : STD_LOGIC_VECTOR(7 downto 0) := "11111110"; 
		constant anodeOFF: STD_LOGIC_VECTOR(7 downto 0) := "11111111"; 
		
	-- this is for any generic components 
		constant n:        integer :=3;

	-- maxCount constant to clear counter 
		constant maxCount: integer := 8;

-- word to hex internal signals 
		signal CLR_int     : STD_LOGIC;
		signal comp_eq_out : STD_LOGIC;
		signal count_int   : STD_LOGIC_VECTOR (2  downto 0);
		signal DIGIT_EN    : STD_LOGIC_VECTOR (7  downto 0) := "10001111"; 
		signal mux_out1    : STD_LOGIC_VECTOR (7  downto 0); 
		signal mux_out2    : STD_LOGIC_VECTOR (3  downto 0); 
		signal WORD        : STD_LOGIC_VECTOR (31 downto 0);
		
-- pulse gen signals 
signal PULSE_OUT_16   	: STD_LOGIC; 
signal PULSE_OUT_50M  	: STD_LOGIC; 
signal PULSE_OUT_1000 	: STD_LOGIC; 
signal PULSE_OUT_500 	: STD_LOGIC; 

--flip flop signals 
signal DFF1_int       	: STD_LOGIC;
signal DFF2_int         : STD_LOGIC;

-- one shot signals 
signal OSreg_int        : STD_LOGIC;
signal OSsreg_int       : STD_LOGIC;
signal OSup_int         : STD_LOGIC;
signal OSdwn_int        : STD_LOGIC;
signal OSctr_int        : STD_LOGIC;
signal OSBTNR_int        : STD_LOGIC;
signal OSpulse_int      : STD_LOGIC;

--debounce signals 
signal DebounceUP_int   : STD_LOGIC;
signal DebounceDWN_int  : STD_LOGIC;
signal DebounceCTR_int  : STD_LOGIC;
signal DebounceBTNR_int  : STD_LOGIC;
signal DebounceSREG_int : STD_LOGIC;
signal DebouncePulse_int: STD_LOGIC;

--mux signals 
signal muxIn0           : STD_LOGIC_VECTOR (15 downto 0); 
signal muxIn1         	: STD_LOGIC_VECTOR (15 downto 0); 
signal muxIn2         	: STD_LOGIC_VECTOR (15 downto 0); 
signal muxIn3         	: STD_LOGIC_VECTOR (15 downto 0); 
signal muxIn4         	: STD_LOGIC_VECTOR (15 downto 0); 
signal muxIn5         	: STD_LOGIC_VECTOR (15 downto 0); 
signal muxIn6         	: STD_LOGIC_VECTOR (15 downto 0); 
signal muxIn7         	: STD_LOGIC_VECTOR (15 downto 0);
signal muxOut        	: STD_LOGIC_VECTOR (15 downto 0);


signal Q_int            : STD_LOGIC_VECTOR (15 downto 0);
 
begin

 -- registers 
	-- shift reg 
	process (CLK) is 
		begin
			if (CLK'event and CLK='1') then 
				if (OSctr_int = '1') then
					Q_int(15)  <= SWITCHES(0);
					Q_int(14)  <= Q_int(15);
					Q_int(13)  <= Q_int(14);
					Q_int(12)  <= Q_int(13);
					Q_int(11)  <= Q_int(12);
					Q_int(10)  <= Q_int(11);
					Q_int(9)   <= Q_int(10);
					Q_int(8)   <= Q_int(9);
					Q_int(7)   <= Q_int(8);
					Q_int(6)   <= Q_int(7);
					Q_int(5)   <= Q_int(6);
					Q_int(4)   <= Q_int(5);
					Q_int(3)   <= Q_int(4);
					Q_int(2)   <= Q_int(3);
					Q_int(1)   <= Q_int(2);
					Q_int(0)   <= Q_int(1);
				 end if;
			end if;
		end process;
		
		LED    <= Q_int; 
		muxIn0 <= Q_int;
--end shiftreg
-----------------------------------------------------		
	REG1: counter_nbit
	   generic map (n=>16)
		port map( 
				EN  => PULSE_OUT_16,
				CLK => CLK,
				CLR => BTNR,
				Q   => muxIn1); 

	REG2: counter_nbit
		generic map (n=>16)
		port map( 
				EN  => PULSE_OUT_50M,
				CLK => CLK,
				CLR => BTNR,
				Q   => muxIn2);
				
	REG3: Reg_nbit
	generic map (n=>16)
		port map(
				D    => muxIn2,   
				LOAD => BTNL,
				CLK  => CLK,
				CLR  => '0',
				Q    => muxIn3);
				
	REG4: counter_nbit
	generic map (n=>16)
		port map( 
				EN  => BTNU,
				CLK => CLK,
				CLR => BTNR,
				Q   => muxIn4);		
	
				
	REG5: counter_nbit
	generic map (n=>16)
		port map( 
				EN  => OSreg_int,
				CLK => CLK,
				CLR => BTNR,
				Q   => muxIn5);
				
	REG6: counter_nbit
	generic map (n=>16)
		port map( 
				EN  => OSup_int,
				CLK => CLK,
				CLR => BTNR,
				Q   => muxIn6);
				
	REG7: counterUpDown_nbit
		generic map  (n => 16)
		port map( 
				EN   => '1',	
				UP   =>	OSup_int,
				DOWN =>	OSdwn_int,
				CLK  =>	CLK,
				CLR  =>  BTNR,	
				Q 	  => 	muxIn7);
--sync 
	DFFS1: D_flip_flop 
		port map(
				D   => BTNU,
				CLK => CLK,
				Q   => DFF1_int);
				
	DFFS2: D_flip_flop 
		port map(
				D   => DFF1_int,
				CLK => CLK,
				Q   => DFF2_int);
--debouncers  				
	DBUP: Debounce
		port map(
			D      => BTNU,
			SAMPLE => PULSE_OUT_500,
			CLK    => CLK,
			Q      => DebounceUP_int);
			
	DBDOWN: Debounce
		port map(
			D      => BTND,
			SAMPLE => PULSE_OUT_500,
			CLK    => CLK,
			Q      => DebounceDWN_int);
			
	DBCTR: Debounce
		port map(
			D      => BTNC,
			SAMPLE => PULSE_OUT_1000,
			CLK    => CLK,
			Q      => DebounceCTR_int);
			
-- one shots 
	OSreg: oneShot
		port map(
			D    => DFF2_int, 
			CLK  => CLK,
			Q    => OSreg_int);
			
	OSup: oneShot
		port map(
			D    => DebounceUP_int,
			CLK  => CLK,
			Q    => OSup_int);
			
	OSdwn: oneShot
		port map(
			D   => DebounceDWN_int,
			CLK => CLK,
			Q   => OSdwn_int);
			
	OSctr: oneShot
		port map(
			D   => DebounceCTR_int,
			CLK => CLK,
			Q   => OSctr_int);
			
-- pulse gens 		
	PULSE16: pulseGenerator
		generic map (
			n        => 32,
			maxCount => 6250000) 
		port map    (
			EN  	    => '1',     
			CLK 	    => CLK,	 
			CLR 		 => BTNR,	 
		   PULSE_OUT => PULSE_OUT_16);
					
	PULSE1000: pulseGenerator
		generic map (
			n         => 32,
			maxCount  => 104000)
		port map    (
			EN  	     => '1',     
			CLK 	     => CLK,	 
			CLR 		  => BTNR,	 
			PULSE_OUT => PULSE_OUT_1000);
			
	PULSE500: pulseGenerator
		generic map (
			n         => 32,
			maxCount  => 200000)
		port map    (
			EN  	     => '1',     
			CLK 	     => CLK,	 
			CLR 		  => BTNR,	 
			PULSE_OUT => PULSE_OUT_500);
					
	PULSE50M: pulseGenerator
		generic map (
			n         => 32,
		   maxCount  => 2)
		port map    (
			EN  	     => '1',     
			CLK 	     => CLK,	 
			CLR 		  => BTNR,	 
			PULSE_OUT => PULSE_OUT_50M);
			
-- word to hex to seven seg -----------------------------------------------------------------------------------
--mux 8:1 anode 
	ANODE    <= anode7 when (count_int = "111") and DIGIT_EN(7) = '1' else 
				   anode6 when (count_int = "110") and DIGIT_EN(6) = '1' else 
				   anode5 when (count_int = "101") and DIGIT_EN(5) = '1' else 
				   anode4 when (count_int = "100") and DIGIT_EN(4) = '1' else 
				   anode3 when (count_int = "011") and DIGIT_EN(3) = '1' else 
				   anode2 when (count_int = "010") and DIGIT_EN(2) = '1' else 
				   anode1 when (count_int = "001") and DIGIT_EN(1) = '1' else 
				   anode0 when (count_int = "000") and DIGIT_EN(0) = '1' else 
				   anodeOFF;

 	--define word 
   WORD(31)           <= '0';
   WORD(30 downto 28) <= SWITCHES(15 downto 13);
	WORD(27 downto 16) <= (others => '0');
	WORD(15 downto 0)  <=  muxOut ;
		
	-- mux 8:1 hex 		
	mux_out2 <= WORD(31 downto 28) when (count_int = "111") else 
				   WORD(27 downto 24) when (count_int = "110") else 
				   WORD(23 downto 20) when (count_int = "101") else 
				   WORD(19 downto 16) when (count_int = "100") else 
				   WORD(15 downto 12) when (count_int = "011") else 
				   WORD(11 downto  8) when (count_int = "010") else 
				   WORD(7  downto  4) when (count_int = "001") else 
				   WORD(3  downto  0) when (count_int = "000") else 
				   WORD(31 downto 28) ;  

	-- portmaps 
	counter: Counter_nbit
	   generic map ( n => n)
		port map
			(EN   => PULSE_OUT_1000,
			 CLK  => CLK, 
			 CLR  => CLR_int, 
			 Q    => count_int);
			 
		HEXx: HexToSevenSeg
				port map( 
					HEX     => mux_out2,
					SEGMENT => SEGMENT);
			
			 
	--compare if equal to 7
	CLR_int   <= '1' when (to_integer(unsigned(count_int)) = maxCount) else 
					 '1' when (BTNR = '1') else
					 '0'; 
-----------------------------------------------------------------------------------------------------------------		 
-- mux 8:1 
	muxOut <= muxIn7 when SWITCHES(15 downto 13) = "111" else 
				 muxIn6 when SWITCHES(15 downto 13) = "110" else 
				 muxIn5 when SWITCHES(15 downto 13) = "101" else 
				 muxIn4 when SWITCHES(15 downto 13) = "100" else 
				 muxIn3 when SWITCHES(15 downto 13) = "011" else 
				 muxIn2 when SWITCHES(15 downto 13) = "010" else 
				 muxIn1 when SWITCHES(15 downto 13) = "001" else 
				 muxIn0 when SWITCHES(15 downto 13) = "000" else 
			    muxIn0;
	
end Behavioral;

