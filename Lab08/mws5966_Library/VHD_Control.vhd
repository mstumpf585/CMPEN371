
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_STD.ALL; 
library mws5966_library;
use mws5966_library.mws5966_components.ALL; 

entity VHD_Control is
	port (CLK 	  : in  STD_LOGIC;
			RGB_in  : in  STD_LOGIC_VECTOR(11 downto 0); 
			H_sync  : out STD_LOGIC;
			V_sync  : out STD_LOGIC;
			X_out   : out STD_LOGIC_VECTOR(9 downto 0);
			Y_out   : out STD_LOGIC_VECTOR(9 downto 0);
			RGB_out : out STD_LOGIC_VECTOR(11 downto 0)); 
end VHD_Control;

architecture Behavioral of VHD_Control is

signal PixelCLK			: STD_LOGIC;
signal RGB_Enable_Reg	: STD_LOGIC;

-- Horizontal signals 
signal Hcount				: STD_LOGIC_VECTOR(9 downto 0); 
signal Hactive 			: STD_LOGIC;
signal RollH				: STD_LOGIC;
signal HcountClr			: STD_LOGIC;
signal H_LT656				: STD_LOGIC;
signal H_6T751				: STD_LOGIC;

-- Vertical signals 
signal Vcount				: STD_LOGIC_VECTOR(9 downto 0);
signal Vactive  			: STD_LOGIC;
signal RollV				: STD_LOGIC;
signal VcountEN			: STD_LOGIC; 
signal VcountClr			: STD_LOGIC; 
signal V_LT490				: STD_LOGIC;
signal V_GT491				: STD_LOGIC;

-- flip flop
signal DFFreg_in 			: STD_LOGIC;
signal DFFH_in 			: STD_LOGIC;
signal DFFV_in 			: STD_LOGIC;
 

begin

	-- pulse gens 
	PULSE25i : PulseGenerator 
		generic map (2, 3)
		port map 	(EN    => '1',
					    CLK   => CLK,
					    CLR   => '0',
    					 PULSE_out => PixelCLK);
	-- Horizotal--------------------------------------------------------------
	
	Hcounter: Counter_nbit
	   generic map (10) 
		port map 	(EN  => PixelCLK, 
						 CLK => CLK, 
					    CLR => HcountClr, 
					    Q   => Hcount);
						 
	compare_HEQU : CompareEQU 
		generic map (10) 
		port map    (A   => Hcount, 
						 B   => "1100011111", 
						 EQU => RollH);
						 
	compare_HLES1 : CompareLES
		generic map (10)
		port map		(A   => Hcount,
						 B   => "1010010000",
						 LES => Hactive);
						 
	compare_HLES2 : CompareLES
		generic map (10)
		port map		(A   => Hcount,
						 B   => "1010000000",
						 LES => H_LT656);
						 
	compare_HGTR : CompareGRT
		generic map (10)
		port map		(A   => Hcount,
						 B   => "1011101111",
						 GRT => H_6T751);
	
	X_out <= Hcount;
	HcountClr <= '1' when (RollH = '1' and PixelCLK = '1') else '0'; 
	-- Vertical------------------------------------------------------------------ 
	Vcounter: Counter_nbit
	   generic map (10) 
		port map (EN  => VcountEN, 
				    CLK => CLK, 
					 CLR => VcountClr, 
					 Q   => Vcount);

	compare_VEQU : CompareEQU 
		generic map (10) 
		port map    (A   => Vcount, 
						 B   => "1000001100", 
						 EQU => RollV);
						 
	compare_VLES1 : CompareLES
		generic map (10)
		port map		(A   =>  Vcount,
						 B   =>  "0111100000",
						 LES => Vactive);
						 
	compare_VLES2 : CompareLES
		generic map (10)
		port map		(A   => Vcount,
						 B   => "0111101010",
						 LES => V_LT490);
						 
	compare_VGTR : CompareGRT
		generic map (10)
		port map		(A   =>  Vcount,
						 B   =>  "0111101011",
						 GRT => V_GT491);
	
	Y_out <= Vcount; 
	VcountEN	 <= '1' when (RollH = '1' and PixelCLK = '1') else '0';  
	VcountClr <= '1' when (RollH = '1' and PixelCLK = '1' and RollV = '1') else '0'; 
	
	-- DFFS------------------------------------------------------------------------	
	DFFreg_in <= '1' when (Hactive = '1' and Vactive = '1') else '0'; 
	DFFH_in   <= '1' when (H_LT656 = '1' or H_6T751 = '1') else '0'; 
	DFFV_in   <= '1' when (V_LT490 = '1' or V_GT491 = '1') else '0'; 
	
	DFFreg: D_flip_flop_CE 
		port map  (D   => DFFreg_in,
					  CE  => pixelCLK,
				     CLK => CLK,
					  Q   => RGB_Enable_Reg);
					  	DFFHsync: D_flip_flop_CE
		port map  (D   => DFFH_in,
					  CE  => PixelCLK,
				     CLK => CLK,
					  Q   => H_sync);
					  
	DFFVsync: D_flip_flop_CE				  
		port map  (D   => DFFV_in,
					  CE  => PixelCLK,
				     CLK => CLK,
					  Q   => V_sync);
		
	--outputs -----------------------------------------------------------------------
	--mux_out 
	RGB_out <= RGB_in when (RGB_Enable_Reg = '1') 
		else x"000";
	
end Behavioral;

