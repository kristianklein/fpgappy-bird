-- Dette modul anmoder om en sample fra ADC interfacet ved en bestemt
-- samplingfrekvens, som kan indstilles vha. prescaler-inputtet (ikke implementeret endnu)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sampler is
    Port ( CLK : in  STD_LOGIC;
			  CS : out STD_LOGIC;
			  SCLK : out STD_LOGIC;
			  D0 : in STD_LOGIC;
			  D1 : in STD_LOGIC;
			  -- prescaler : in STD_LOGIC_VECTOR (7 DOWNTO 0);
           AD1_hex : out  STD_LOGIC_VECTOR (11 downto 0);
           AD2_hex : out  STD_LOGIC_VECTOR (11 downto 0)
			);
end sampler;

architecture Behavioral of sampler is
	-- COMPONENTS
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
	SIGNAL start_sig : STD_LOGIC;
	SIGNAL done_sig : STD_LOGIC;
	SIGNAL prescale_counter : STD_LOGIC_VECTOR (15 DOWNTO 0);
begin
	-- INSTANTIATIONS
	Inst_adc_interface: adc_interface PORT MAP(
		Clk => CLK,
		Start => start_sig,
		Done => done_sig,
		SClk => SCLK,
		CS => CS,
		D0 => D0,
		D1 => D1,
		AD1 => AD1_sig,
		AD2 => AD2_sig
	);
	
	-- Mapping signals to outputs
	AD1_hex <= AD1_sig;
	AD2_hex <= AD2_sig;
	
	PROCESS (CLK)
	BEGIN
		IF rising_edge(CLK) THEN
			IF (prescale_counter >= 49999) THEN -- sampling rate of 1 kHz
				start_sig <= '1'; -- start conversion
				prescale_counter <= (OTHERS => '0');
			ELSE
				prescale_counter <= prescale_counter + 1;
				
				IF (done_sig = '1') THEN
					start_sig <= '0';
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
end Behavioral;

