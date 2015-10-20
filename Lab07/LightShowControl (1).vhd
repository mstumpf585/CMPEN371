----------------------------------------------------------------------------
-- Entity:        LightShowControl
-- Written By:    E. George Walters
-- Date Created:  7 Oct 14
-- Description:   FSM that controls the datapath for a light show
--
-- Revision History (date, initials, description):
--    11 Oct 15, egw100, updated for FA 15
-- Dependencies:
--		(none)
----------------------------------------------------------------------------
library IEEE;
use     IEEE.STD_LOGIC_1164.ALL;

--------------------------------------------------------------------------------
entity LightShowControl is
    port (BUTTON      : in  STD_LOGIC_VECTOR (1 to 5);
          SWITCH      : in  STD_LOGIC_VECTOR (1 downto 0);
          STATUS_in   : in  STD_LOGIC_VECTOR (0 to 7);
          RESET       : in  STD_LOGIC;
			 CLK         : in  STD_LOGIC;
          CONTROL_out : out STD_LOGIC_VECTOR (0 to 8);
          DEBUG_out   : out STD_LOGIC_VECTOR (7 downto 0));
end LightShowControl;
--------------------------------------------------------------------------------

architecture FSM of LightShowControl is

   -- State enumeration and state register
   type STATE_TYPE is (
      RESET_STATE,         -- Reset state
      CHECK_MODE,          -- Check is mode is run full speed, single cycle, etc.
      READ_MEMORY,         -- Read memory at address selected by switches
      WAIT_FOR_BTNU,       -- Wait for UP button to be pressed (single cycle mode)
      DECODE_INSTRUCTION,  -- Decode instruction
      LOAD_LED_REG,        -- Load LED register with pattern
      LOAD_DELAY_REG,      -- Load delay setpoint register with number of ms to wait
      WAIT_FOR_DELAY,      -- Wait for delay counter to complete
      LOAD_PC_PLUS_1,      -- Load PC with PC + 1 (next instruction in ROM
      LOAD_PC_WITH_ADDRESS -- Load PC with address specified by jump or branch instruction
   );
   signal presentState, nextState : STATE_TYPE;
   
	-- Alias buttons
   alias BTNL : STD_LOGIC is BUTTON(1);
   alias BTNR : STD_LOGIC is BUTTON(2);
   alias BTNU : STD_LOGIC is BUTTON(3);
   alias BTND : STD_LOGIC is BUTTON(4);
   alias BTNC : STD_LOGIC is BUTTON(5);

   -- Alias status signals from datapath
	alias DelayDone        is STATUS_in(0);
	alias OpIsNOP          is STATUS_in(1);
	alias OpIsLoadLEDReg   is STATUS_in(2);
	alias OpIsDelay        is STATUS_in(3);
	alias OpIsJump         is STATUS_in(4);
	alias OpIsBranchIfBtnL is STATUS_in(5);
	alias OpIsBranchIfBtnC is STATUS_in(6);
	alias OpIsBranchIfBtnR is STATUS_in(7);

	-- Alias state machine outputs to datapath
	--   alias RunProgram       is CONTROL_out(0);
	--   alias PCMux_SEL        is CONTROL_out(1);
	--   alias PCReg_LOAD       is CONTROL_out(2);
	--   alias PCReg_CLR        is CONTROL_out(3);
	--   alias LEDReg_LOAD      is CONTROL_out(4);
	--   alias LEDReg_CLR       is CONTROL_out(5);
	--   alias DelayReg_LOAD    is CONTROL_out(6);
	--   alias DelayReg_CLR     is CONTROL_out(7);
	--   alias DelayCounter_CLR is CONTROL_out(8);
	
begin

	-- State register
	process (clk) is
	begin
		if (CLK'event and CLK = '1') then
         if (RESET = '1') then
            presentState <= RESET_STATE;
         else
            presentState <= nextState;
         end if;
		end if;
	end process;
	
	-- Next state logic
	process (presentState, BUTTON, SWITCH, STATUS_in) is
	begin
		case presentState is

			when RESET_STATE => 
				nextState <= CHECK_MODE;

			when CHECK_MODE => 
				if (SWITCH = "00") then
					nextState <= READ_MEMORY;
				elsif (SWITCH = "01") then
					nextState <= WAIT_FOR_BTNU;
				elsif (SWITCH = "11") then
					nextState <= DECODE_INSTRUCTION;
				else
					nextState <= CHECK_MODE;
				end if;

			when READ_MEMORY => 
				if (SWITCH /= "00") then
					nextState <= CHECK_MODE;
				else
					nextState <= READ_MEMORY;
				end if;

			when WAIT_FOR_BTNU => 
				if (BTNU = '1') then
					nextState <= DECODE_INSTRUCTION;
				else
					nextState <= CHECK_MODE;
				end if;

			when DECODE_INSTRUCTION => 
				if (OpIsNOP = '1') then
					nextState <= LOAD_PC_PLUS_1;
            elsif (OpIsLoadLEDReg = '1') then
               nextState <= LOAD_LED_REG;
            elsif (OpIsDelay = '1') then
               nextState <= LOAD_DELAY_REG;
            elsif (OpIsJump = '1') then
               nextState <= LOAD_PC_WITH_ADDRESS;
            elsif (OpIsBranchIfBtnL = '1' and BTNL = '1') then
               nextState <= LOAD_PC_WITH_ADDRESS;
            elsif (OpIsBranchIfBtnC = '1' and BTNC = '1') then
               nextState <= LOAD_PC_WITH_ADDRESS;
            elsif (OpIsBranchIfBtnR = '1' and BTNR = '1') then
               nextState <= LOAD_PC_WITH_ADDRESS;
				else
					nextState <= LOAD_PC_PLUS_1;
				end if;

			when LOAD_LED_REG => 
				nextState <= LOAD_PC_PLUS_1;

			when LOAD_DELAY_REG => 
				nextState <= WAIT_FOR_DELAY;

			when WAIT_FOR_DELAY => 
				if (DelayDone = '1') then
					nextState <= LOAD_PC_PLUS_1;
				else
					nextState <= WAIT_FOR_DELAY;
				end if;

			when LOAD_PC_PLUS_1 => 
				nextState <= CHECK_MODE;

			when LOAD_PC_WITH_ADDRESS => 
				nextState <= CHECK_MODE;

			when others => 
				nextState <= RESET_STATE;

		end case;

	end process;
   
   -- Control word
   with presentState select
      -- Control bit: 012345678
      CONTROL_out <= "000101011" when RESET_STATE,
                     "100000000" when CHECK_MODE,
                     "000000000" when READ_MEMORY,
                     "100000000" when WAIT_FOR_BTNU,
                     "100000000" when DECODE_INSTRUCTION,
                     "100010000" when LOAD_LED_REG,
                     "100000101" when LOAD_DELAY_REG,
                     "100000000" when WAIT_FOR_DELAY,
                     "101000000" when LOAD_PC_PLUS_1,
                     "111000000" when LOAD_PC_WITH_ADDRESS,
                     "100000000" when others;
   
   -- Debug output
   with presentState select
      DEBUG_out <= x"00" when RESET_STATE,
                   x"01" when CHECK_MODE,
                   x"02" when READ_MEMORY,
                   x"03" when WAIT_FOR_BTNU,
                   x"04" when DECODE_INSTRUCTION,
                   x"05" when LOAD_LED_REG,
                   x"06" when LOAD_DELAY_REG,
                   x"07" when WAIT_FOR_DELAY,
                   x"08" when LOAD_PC_PLUS_1,
                   x"09" when LOAD_PC_WITH_ADDRESS,
                   x"ff" when others;
   

end FSM;

