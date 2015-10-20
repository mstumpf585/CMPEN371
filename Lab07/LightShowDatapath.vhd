----------------------------------------------------------------------------
-- Entity:        LightShowDatapath
-- Written By:    E. George Walters
-- Date Created:  7 Oct 14
-- Description:   VHDL model of the datapath for a light show
--
-- Revision History (date, initials, description):
--    11 Oct 15, egw100, updated for FA 15
-- Dependencies:
--		EGWComponents.pkg
----------------------------------------------------------------------------
library IEEE;
use     IEEE.STD_LOGIC_1164.ALL;
use     IEEE.NUMERIC_STD.ALL;

library mws5966_library;
use 	  mws5966_library.mws5966_components.ALL; 
--------------------------------------------------------------------------------
entity LightShowDatapath is
    port (SWITCH       : in  STD_LOGIC_VECTOR (15 downto 6);
          CONTROL_in   : in  STD_LOGIC_VECTOR (0 to 8);
			 CLK          : in  STD_LOGIC;
          STATUS_out   : out STD_LOGIC_VECTOR (0 to 7);
          DISPLAY_WORD : out STD_LOGIC_VECTOR (31 downto 0);
          LED          : out STD_LOGIC_VECTOR (15 downto 0));
end LightShowDatapath;
--------------------------------------------------------------------------------

architecture Structural of LightShowDatapath is

	-- Alias control signals from control FSM
   alias RunProgram       is CONTROL_in(0);
   alias PCMux_SEL        is CONTROL_in(1);
   alias PCReg_LOAD       is CONTROL_in(2);
   alias PCReg_CLR        is CONTROL_in(3);
   alias LEDReg_LOAD      is CONTROL_in(4);
   alias LEDReg_CLR       is CONTROL_in(5);
   alias DelayReg_LOAD    is CONTROL_in(6);
   alias DelayReg_CLR     is CONTROL_in(7);
   alias DelayCounter_CLR is CONTROL_in(8);

   -- Alias status signals to control FSM
	alias DelayDone        is STATUS_out(0);
	alias OpIsNOP          is STATUS_out(1);
	alias OpIsLoadLEDReg   is STATUS_out(2);
	alias OpIsDelay        is STATUS_out(3);
	alias OpIsJump         is STATUS_out(4);
	alias OpIsBranchIfBtnL is STATUS_out(5);
	alias OpIsBranchIfBtnC is STATUS_out(6);
	alias OpIsBranchIfBtnR is STATUS_out(7);

   -- Wires
	signal pulse_1ms     : STD_LOGIC;
   signal PC            : STD_LOGIC_VECTOR (9 downto 0);
   signal nextPC        : STD_LOGIC_VECTOR (9 downto 0);
   signal ROMaddress    : STD_LOGIC_VECTOR (9 downto 0);
   signal instruction   : STD_LOGIC_VECTOR (19 downto 0);
   signal delayCount    : STD_LOGIC_VECTOR (15 downto 0);
   signal delaySetpoint : STD_LOGIC_VECTOR (15 downto 0);

   component LightShowROM is
      port (ADDRESS  : in  STD_LOGIC_VECTOR (9 downto 0);
            CLK      : in  STD_LOGIC;
            DATA_out : out STD_LOGIC_VECTOR (19 downto 0));
   end component;

begin

   -- Next PC select MUX and PC+1 adder
   with PCMux_SEL select
      nextPC <= std_logic_vector(unsigned(PC) + 1) when '0',
                instruction (9 downto 0)              when '1',
                "0000000000"                          when others;
   
   -- Program Counter (PC) register
   REG_PC : Reg_nbit generic map (10) port map (
      D    => nextPC,
      LOAD => PCReg_LOAD,
      CLK  => CLK,
      CLR  => PCReg_CLR,
      Q    => PC
   );

   -- ROM address select MUX
   with RunProgram select
      ROMaddress <= SWITCH(15 downto 6) when '0',
                    PC                  when '1',
                    "0000000000"        when others;
   
   -- ROM to store light show program
   ROM : LightShowROM port map (
      ADDRESS  => ROMaddress,
      CLK      => CLK,
      DATA_out => instruction
   );
   
   -- OpCode decoder
   with instruction(19 downto 16) select
      OpIsNOP <= '0' when "0100",   -- Load LED reg
                 '0' when "0001",   -- Delay
                 '0' when "1000",   -- Jump
                 '0' when "1100",   -- Branch if BTNL pressed
                 '0' when "1010",   -- Branch if BTNC pressed
                 '0' when "1001",   -- Branch if BTNR pressed
                 '1' when others;                 
   OpIsLoadLEDReg   <= '1' when instruction(19 downto 16) = "0100" else '0';
   OpIsDelay        <= '1' when instruction(19 downto 16) = "0001" else '0';
   OpIsJump         <= '1' when instruction(19 downto 16) = "1000" else '0';
   OpIsBranchIfBtnL <= '1' when instruction(19 downto 16) = "1100" else '0';
   OpIsBranchIfBtnC <= '1' when instruction(19 downto 16) = "1010" else '0';
   OpIsBranchIfBtnR <= '1' when instruction(19 downto 16) = "1001" else '0';

   -- LED register
   REG_LED : Reg_nbit generic map (16) port map (
      D    => instruction (15 downto 0),
      LOAD => LEDReg_LOAD,
      CLK  => CLK,
      CLR  => LEDReg_CLR,
      Q    => LED
   );

	-- Generate a pulse every 1 ms to drive delay counter
	PULSE1ms : PulseGenerator generic map (17, 100000) port map (
		EN    => '1',
		CLK   => CLK,
		CLR   => '0',
		PULSE_out => Pulse_1ms
	);

   -- Delay counter
   CTR_DELAY : Counter_nbit generic map (16) port map (
		EN  => Pulse_1ms, 
		CLK => CLK, 
		CLR => DelayCounter_CLR, 
		Q   => delayCount
	);
	
   -- Delay counter setpoint register
   REG_DELAY_SP : Reg_nbit generic map (16) port map (
      D    => instruction (15 downto 0),
      LOAD => DelayReg_LOAD,
      CLK  => CLK,
      CLR  => DelayReg_CLR,
      Q    => delaySetpoint
   );

	-- Delay counter comparitor (check if done)
   compare_i : CompareEQU generic map (16) port map (
		A   => delayCount, 
		B   => delaySetpoint, 
		EQU => DelayDone
	);
   
   -- Assign display word for 7-segment display
   DISPLAY_WORD (31 downto 20) <= "00" & ROMaddress;
   DISPLAY_WORD (19 downto  0) <= instruction;
   
end Structural;

