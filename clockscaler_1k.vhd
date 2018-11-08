-- SCALES 50 MHZ DOWN TO 1 KHZ
-- 50 MHz clock must be scaled down by 50000
-- to get a 1 kHz clock
-- This means the output signal must be toggled
-- every 25000th rising edge of the 50 MHz clock
-- 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clockscaler_1k is
    Port ( CLK : in  STD_LOGIC;
           CLK_1k : out  STD_LOGIC);
end clockscaler_1k;

architecture Behavioral of clockscaler_1k is
	SIGNAL counter : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL CLK_1k_sig : STD_LOGIC := '0';
begin
	CLK_1k <= CLK_1k_sig; -- Map intermediate signal to output
	
	-- Count number of rising edges on 50 MHz clock
	-- and invert the intermediate signal every
	-- 25000 rising edge
	PROCESS (CLK)
	BEGIN
		IF rising_edge(CLK) THEN
			IF (counter >= 24999) THEN
				CLK_1k_sig <= NOT CLK_1k_sig; -- Invert intermediate signal
			ELSE
				counter <= counter + 1; -- Note: Signal is not updated until end of process!
			END IF;
		END IF;
	END PROCESS;
end Behavioral;

