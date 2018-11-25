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
  
  COMPONENT sampler
	PORT(
		CLK : IN std_logic;
		done : IN std_logic;
		prescaler : IN std_logic_vector(15 downto 0);
		enable : IN std_logic;          
		start : OUT std_logic
		);
	END COMPONENT;

	COMPONENT adc_interface
	PORT(
		Clk : IN std_logic;
		Start : IN std_logic;
		D0 : IN std_logic;
		D1 : IN std_logic;          
		Done : OUT std_logic;
		SClk : OUT std_logic;
		CS : OUT std_logic;
		AD1 : OUT std_logic_vector(11 downto 0);
		AD2 : OUT std_logic_vector(11 downto 0)
		);
	END COMPONENT;

	-- SIGNALS
	SIGNAL AD1_sig : STD_LOGIC_VECTOR (11 DOWNTO 0);
	SIGNAL AD2_sig : STD_LOGIC_VECTOR (11 DOWNTO 0);
	SIGNAL bcd_sig : STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL seven_segment_sig : STD_LOGIC_VECTOR (6 DOWNTO 0);
	SIGNAL anode_sig : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL start_sig : STD_LOGIC;
  SIGNAL done_sig : STD_LOGIC;
begin
	LD0 <= done_sig;
  LD1 <= start_sig;
  
  -- INSTANTIATIONS
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
  
	Inst_sampler: sampler PORT MAP(
		CLK => CLK,
		done => done_sig,
		prescaler => "0000000000000010", -- scale down by 1 MHz down by 2 (500 kHz)
		enable => '1',
		start => start_sig
	);
	
	Inst_adc_interface: adc_interface PORT MAP(
		Clk => CLK,
		Start => start_sig,
		Done => done_sig,
		SClk => JA4, -- Sclk pin on the ADC
		CS => JA1, -- CS pin on ADC
		D0 => JA2,
		D1 => JA3,
		AD1 => AD1_sig,
		AD2 => AD2_sig
	);	
	-- Mapping signals to outputs
	(AN3,AN2,AN1,AN0) <= anode_sig;
	(CA,CB,CC,CD,CE,CF,CG) <= seven_segment_sig;
end Behavioral;

