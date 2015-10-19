----------------------------------------------------------------------------
-- Entity:        Lab06_Top_LVL
-- Written By:    Michael Stumpf 
-- Date Created:  10 OCT 15
-- Description:   implements lab06 
--
-- Revision History (10/14/15):
-- 
-- Dependencies:
--		ReaderControl FSM, Data path reader, process_FSM, DataPath_Process
--						  Debounce, oneShot, PulseGenerator, WordTo8dig7seg
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mws5966_library;
use mws5966_library.mws5966_components.ALL;


entity Lab06_Top_LVL is
	PORT (CLK			      :	in STD_LOGIC;
			PS2KBD_CLK_in	   :  in STD_LOGIC;
			PS2KBD_DATA_in		:  in STD_LOGIC;
			RESET			      :  in STD_LOGIC;
			SWITCHE1          :  in STD_LOGIC; 
			LED               :	out STD_LOGIC_VECTOR(15 downto 0); 
			ANODE             :	out STD_LOGIC_VECTOR(7 downto 0);
			SEGMENT           :	out STD_LOGIC_VECTOR(0 to 6));
end Lab06_Top_LVL;

architecture Behavioral of Lab06_Top_LVL is
	
	-- FSM reader outputs singals 
	signal EN_int          : STD_LOGIC;
	signal LOAD_int	     : STD_LOGIC;
	signal CLR_int 	     : STD_LOGIC;
	signal CODE_READY_int  : STD_LOGIC; 
	
	-- read DATA Path outputs signals 
	signal LES_int         : STD_LOGIC;
	signal TIMEOUT_int     : STD_LOGIC;
	signal Q8_int          : STD_LOGIC_vector(9  downto 0); 
	signal Q32_int         : STD_LOGIC_vector(31 downto 0); 
	signal State_int		  : STD_LOGIC_VECTOR(3 downto 0);
	
	-- FSM process outputs
	signal CONTROL_out_int : STD_LOGIC_VECTOR(3 downto 0);
	
	-- process data path outputs 
	signal process_LED	  : STD_LOGIC_VECTOR(3 downto 0);
	signal STATUS_in_proc  : STD_LOGIC_VECTOR(7 downto 0);
	signal XCOORD_int		  : STD_LOGIC_VECTOR(7  downto 0);
	signal YCOORD_int      : STD_LOGIC_VECTOR(7  downto 0);
	signal Q32Proc_int	  : STD_LOGIC_VECTOR(31 downto 0); 
	
	-- Debouncer signals 
	signal DB_KBDATA		  : STD_LOGIC;
	signal DB_KBCLK		  : STD_LOGIC;
	
	-- pulse signals 
	signal pulse_int       : STD_LOGIC;
	signal strobe 			  : STD_LOGIC;
	
	-- oneShot signals
	signal OS_CODE_READY   : STD_LOGIC;

	
	--Mux signals 
	signal Mux_out1		  : STD_LOGIC_VECTOR(7 downto 0);
	signal Mux_out2		  : STD_LOGIC_VECTOR(31 downto 0);
	
	-- instatiate components--------------------------------------------------------------------------------------------------- 
	component ReaderControlFSM is
	PORT (CLK			:	in  STD_LOGIC;
			RESET			:	in  STD_LOGIC;
			LES			:  in  STD_LOGIC; 
			KBCLK			:  in  STD_LOGIC; 
			--TIMEOUT     :  in  STD_LOGIC; 
			state_loc	:  out STD_LOGIC_VECTOR(3 downto 0);
			EN 			:  out STD_LOGIC;
			LOAD			:  out STD_LOGIC;
			CLR    		:  out STD_LOGIC;
			CODE_READY  :  out STD_LOGIC);	 
  end component;

	-- data path
	component DataPath_Reader is
	port(EN 			 		: in  STD_LOGIC; 
		  CLK 		 		: in  STD_LOGIC;
		  CLR        		: in  STD_LOGIC; 
		  CLR_reg         : in  STD_LOGIC;
		  LOAD 		 		: in  STD_LOGIC; 
		  --KBCLK 		 		: in  STD_LOGIC; 
		  KBDATA		 		: in  STD_LOGIC; 
		  CODE_READY 		: in  STD_LOGIC; 
		  LES        		: out STD_LOGIC;
		  --TIMEOUT    		: out STD_LOGIC;
		  Q8 					: out STD_LOGIC_VECTOR(9 downto 0);
		  Q32			 		: out STD_LOGIC_VECTOR(31 downto 0)); 		
   end component;
	
	component process_FSM is
		PORT (CLK			:	in  STD_LOGIC;
				RESET			:	in  STD_LOGIC;	
				CODE_READY  :  in  STD_LOGIC;
				SCANCODE    :  in  STD_LOGIC_VECTOR(7 downto 0);
				CONTROL_out :  out STD_LOGIC_VECTOR(3 downto 0)); 
	end component;

	component DataPath_Process is
	port (CLK 			: in  STD_LOGIC; 
			CLR 		   : in  STD_LOGIC;
			CODE_READY 	: in  STD_LOGIC;
			reg_in 		: in  STD_LOGIC_VECTOR(7  downto 0);
			CONTROL_OUT : in  STD_LOGIC_VECTOR(3  downto 0); 
			STATUS_in  	: out STD_LOGIC_VECTOR(7  downto 0);
			XCOORD		: out STD_LOGIC_VECTOR(7  downto 0);
			YCOORD		: out STD_LOGIC_VECTOR(7  downto 0);
			LED15_12		: out STD_LOGIC_VECTOR(15 downto 12)); 
	end component;
	
begin
	
	-- Debouncers--------------------------------------------- 
	
	DBKBC: Debounce 
		port map (D      => PS2KBD_CLK_in,
				    SAMPLE => pulse_int,
				    CLK    => CLK,
				    Q      => DB_KBCLK);
					 
	DBKBD: Debounce 
		port map (D      => PS2KBD_DATA_in,
				    SAMPLE => pulse_int,
				    CLK    => CLK,
				    Q      => DB_KBDATA);
					
-- oneShot------------------------------------------
	OS: oneShot 
	port map (D   => CODE_READY_int,
			    CLK => CLK ,
			    Q   => OS_CODE_READY);
				 

-- pulse generator-------------------------------------
	pulse: PulseGenerator
	generic map (n         => 2,
				    maxCount  => 2)
	port map    (EN  		  => '1',      
				    CLK       => CLK,	 
				    CLR       => RESET,	 
				    PULSE_OUT => pulse_int);
					 
		
	-- pulse generator
	pulseWord: PulseGenerator
	generic map (n         => 17,
				    maxCount  => 100000)
	port map    (EN  		  => '1',      
				    CLK       => CLK,	 
				    CLR       => RESET,	 
				    PULSE_OUT => Strobe);
					 
	-- PROCESS control and data------------------------
	procFSM: process_FSM 
		port map (CLK			 => CLK,
					 RESET		 => RESET,
				    CODE_READY  => OS_CODE_READY,
				    SCANCODE    => STATUS_in_proc,
				    CONTROL_out => CONTROL_out_int);
					 
	procDATA: DataPath_Process
		port map (CLK 			    => CLK,
					 CLR 		       => RESET,
			       reg_in 		    => Q8_int(7 downto 0),
			       CODE_READY 	 => OS_CODE_READY,
			       CONTROL_OUT    => CONTROL_out_int,
			       STATUS_in  	 => STATUS_in_proc,
			       XCOORD			 => XCOORD_int,
					 YCOORD			 => YCOORD_int,
			       LED15_12		 => process_LED);	
				
	-- end Process control and data	-------------------	
	-- READ control and data ---------------------------
	ReadFSM: ReaderControlFSM
		port map (CLK	    	=>	CLK,
					 RESET	   =>	RESET,	
					 LES	 	   =>	LES_int,
					 KBCLK	   =>	DB_KBCLK,
					 --TIMEOUT    => TIMEOUT_int, 
					 state_loc	=> State_int,
					 EN 		   =>	EN_int,
					 LOAD		   =>	LOAD_int,
					 CLR      	=>	CLR_int,
					 CODE_READY => CODE_READY_int);
	
	
	-- DATA
	DataPath: DataPath_Reader 
	port map(EN 			=>	EN_int,
				CLK 		 	=> CLK,
				CLR         => CLR_INT,
				CLR_reg     => RESET,
				LOAD 		   => LOAD_int,
				--KBCLK 		=> DB_KBCLK,
				KBDATA		=> DB_KBDATA,
				CODE_READY  => OS_CODE_READY,
				LES         => LES_int,
				--TIMEOUT     => TIMEOUT_int,
				Q8				=> Q8_int,
				Q32			=> Q32_int); 		
	
	-- end read control and data ---------------------
	 
	-- led drivers
	LED(15 downto 4) <= Q8_int & "00";
	LED(3 downto 0)  <= CONTROL_out_int;
	
	
	Mux_out1 <= "11111111" when (SWITCHE1 = '0') else "11111111"; 
	Q32Proc_int <= XCOORD_int & YCOORD_int & "000000000000" & State_int;
	Mux_out2 <= Q32_int when (SWITCHE1 = '0') else Q32Proc_int;
	
	-- seven seg driver 				 
	HEX: WordTo8dig7seg
	port map(STROBE  	=> Strobe, 
				CLK     	=> CLK,
				CLR     	=> RESET,
				WORD    	=> Mux_out2,
				DIGIT_EN => Mux_out1,
				ANODE    => ANODE,
				SEGMENT  => SEGMENT);
									 
end Behavioral;