----------------------------------------------------------------------------
-- Entity:        Lab07_egw100
-- Written By:    E. George Walters
-- Date Created:  7 Oct 14
-- Description:   Top level VHDL model for CMPEN 371 FA15 Lab 7
--
-- Revision History (10/18/2015, MS, description):
--    11 Oct 15, egw100, updated for FA 15
-- Dependencies:
--		EGW100_Components.pkg
----------------------------------------------------------------------------
library IEEE;
use     IEEE.STD_LOGIC_1164.ALL;

library mws5966_library;
use 	  mws5966_library.mws5966_Components.all; 
----------------------------------------------------------------------------
entity Lab07_egw100 is
	port (SWITCH      : in  STD_LOGIC_VECTOR (15 downto 0);
			BUTTON      : in  STD_LOGIC_VECTOR (1 to 5);
			CLK         : in  STD_LOGIC;							
			ANODE       : out STD_LOGIC_VECTOR (7 downto 0);
			SEGMENT     : out STD_LOGIC_VECTOR (0 to 6);
			LED         : out STD_LOGIC_VECTOR (15 downto 0));
end Lab07_egw100;
----------------------------------------------------------------------------

architecture Structural of Lab07_egw100 is

	-- Alias buttons
   alias BTNL : STD_LOGIC is BUTTON(1);
   alias BTNR : STD_LOGIC is BUTTON(2);
   alias BTNU : STD_LOGIC is BUTTON(3);
   alias BTND : STD_LOGIC is BUTTON(4);
   alias BTNC : STD_LOGIC is BUTTON(5);

	-- Periodic pulse signals
	signal pulse_1ms   : STD_LOGIC;
   
   -- 7-Segment display
   signal displayWord : STD_LOGIC_VECTOR (31 downto 0);
   
   -- Other wires
   signal resetSig    : STD_LOGIC;
   signal controlWord : STD_LOGIC_VECTOR(0 to 8);
   signal statusWord  : STD_LOGIC_VECTOR(0 to 7);
		
   component LightShowControl is
       port (BUTTON      : in  STD_LOGIC_VECTOR (1 to 5);
             SWITCH      : in  STD_LOGIC_VECTOR (1 downto 0);
             STATUS_in   : in  STD_LOGIC_VECTOR (0 to 7);
             RESET       : in  STD_LOGIC;
             CLK         : in  STD_LOGIC;
             CONTROL_out : out STD_LOGIC_VECTOR (0 to 8);
             DEBUG_out   : out STD_LOGIC_VECTOR (7 downto 0));
   end component;

   component LightShowDatapath is
       port (SWITCH       : in  STD_LOGIC_VECTOR (15 downto 6);
             CONTROL_in   : in  STD_LOGIC_VECTOR (0 to 8);
             CLK          : in  STD_LOGIC;
             STATUS_out   : out STD_LOGIC_VECTOR (0 to 7);
             DISPLAY_WORD : out STD_LOGIC_VECTOR (31 downto 0);
             LED          : out STD_LOGIC_VECTOR (15 downto 0));
   end component;

begin

   -- Light show control FSM
   FSM_LIGHT_SHOW : LightShowControl port map (
      BUTTON      => BUTTON,
      SWITCH      => SWITCH(1 downto 0),
      STATUS_in   => statusWord,
      RESET       => resetSig,
      CLK         => CLK,
      CONTROL_out => controlWord,
      DEBUG_out   => open
   );
   resetSig <= BTNL and BTND and BTNR;

   -- Light show datapath
   DP_LIGHT_SHOW : LightShowDatapath port map (
      SWITCH       => SWITCH(15 downto 6),
      CONTROL_in   => controlWord,
      CLK          => CLK,
      STATUS_out   => statusWord,
      DISPLAY_WORD => displayWord,
      LED          => LED
   );

	-- Generate a pulse every 1 ms to drive 4-digit 7-segment display anodes
	PULSE1ms : PulseGenerator generic map (17, 100000) port map (
		EN    	 => '1',
		CLK   	 => CLK,
		CLR  		 => '0',
		PULSE_OUT => Pulse_1ms
	);
	
	-- 4-digit 7-segment display driver
	W24D7S : WordTo8dig7seg port map (
		WORD     => displayWord,
		STROBE   => Pulse_1ms,
		CLK      => CLK,
		CLR 		=> resetSig,
		DIGIT_EN => "11111111",
		ANODE    => ANODE,
		SEGMENT  => SEGMENT
	);

end Structural;

