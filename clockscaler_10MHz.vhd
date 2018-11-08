-- SCALES 50 MHZ DOWN TO 12.5 MHZ
-- 50 MHz clock must be scaled down by 4
-- to get a 1 MHz clock
-- This means the output signal must be toggled
-- every other rising edge of the 50 MHz clock
-- 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clockscaler_12M5 is
    Port ( CLK : in  STD_LOGIC;
           CLK_12M5 : out  STD_LOGIC);
end clockscaler_12M5;

architecture Behavioral of clockscaler_12M5 is
	SIGNAL counter : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL CLK_12M5_sig : STD_LOGIC := '0';
begin
	CLK_12M5 <= CLK_12M5_sig; -- Map intermediate signal to output
	
	-- Count number of rising edges on 50 MHz clock
	-- and invert the intermediate signal every
	-- other rising edge
	PROCESS (CLK)
	BEGIN
		IF rising_edge(CLK) THEN
			IF (counter >= 1) THEN
				CLK_12M5_sig <= NOT CLK_12M5_sig; -- Invert intermediate signal
			ELSE
				counter <= counter + 1; -- Note: Signal is not updated until end of process!
			END IF;
		END IF;
	END PROCESS;
end Behavioral;

