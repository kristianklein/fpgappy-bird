library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity continous_adc_test is
    Port ( CLK : in  STD_LOGIC;
           JA1,JA4 : out  STD_LOGIC; -- CS and SCLK
           JA2,JA3 : in  STD_LOGIC; -- D0 and D1
           AN0,AN1,AN2,AN3 : out  STD_LOGIC;
           CA,CB,CC,CD,CE,CF,CG : out  STD_LOGIC;
           DP : out  STD_LOGIC;
			  LD0, LD1 : OUT STD_LOGIC);
end continous_adc_test;

architecture Behavioral of continous_adc_test is
	-- COMPONENTS
	COMPONENT sampler
	PORT(
		CLK : IN std_logic;
		D0 : IN std_logic;
		D1 : IN std_logic;          
		CS : OUT std_logic;
		SCLK : OUT std_logic;
		AD1_hex : OUT std_logic_vector(11 downto 0);
		AD2_hex : OUT std_logic_vector(11 downto 0);
		LD0, LD1 : OUT STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT binary2bcd
	PORT(
		binary : IN std_logic_vector(11 downto 0);          
		bcd : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	COMPONENT display_driver
	PORT(
		bcd : IN std_logic_vector(15 downto 0);
		dp_vector : IN std_logic_vector(3 downto 0);
		clock : IN std_logic;          
		seven_segment : OUT std_logic_vector(6 downto 0);
		anodes : OUT std_logic_vector(3 downto 0);
		dp : OUT std_logic
		);
	END COMPONENT;
	
	-- SIGNALS
	SIGNAL AD1_sig : STD_LOGIC_VECTOR (11 DOWNTO 0);
	SIGNAL AD2_sig : STD_LOGIC_VECTOR (11 DOWNTO 0);
	SIGNAL bcd_sig : STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL seven_segment_sig : STD_LOGIC_VECTOR (6 DOWNTO 0);
	SIGNAL anode_sig : STD_LOGIC_VECTOR (3 DOWNTO 0);
begin
	-- INSTANTIATIONS
	Inst_sampler: sampler PORT MAP(
		CLK => CLK,
		CS => JA1,
		SCLK => JA4,
		D0 => JA2,
		D1 => JA3,
		AD1_hex => AD1_sig,
		AD2_hex => AD2_sig,
		LD0 => LD0,
		LD1 => LD1
	);
	
	Inst_binary2bcd: binary2bcd PORT MAP(
		binary => AD1_sig,
		bcd => bcd_sig
	);


	Inst_display_driver: display_driver PORT MAP(
		bcd => bcd_sig,
		dp_vector => "1111",
		clock => CLK,
		seven_segment => seven_segment_sig,
		anodes => anode_sig,
		dp => DP 
	);
	
	-- Mapping signals to outputs
	(AN3,AN2,AN1,AN0) <= anode_sig;
	(CA,CB,CC,CD,CE,CF,CG) <= seven_segment_sig;
end Behavioral;

