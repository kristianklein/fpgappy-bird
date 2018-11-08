-- SCALES 50 MHZ DOWN TO 25 MHZ
-- 50 MHz clock must be scaled down by 2
-- to get a 25 MHz clock
-- This means the output signal must be toggled
-- every other rising edge of the 50 MHz clock
-- 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clockscaler_25M is
    Port ( CLK : in  STD_LOGIC;
           CLK_25M : out  STD_LOGIC);
end clockscaler_25M;

architecture Behavioral of clockscaler_25M is
	SIGNAL counter : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL CLK_25M_sig : STD_LOGIC := '0';
begin
	CLK_25M <= CLK_25M_sig; -- Map intermediate signal to output
	
	-- Count number of rising edges on 50 MHz clock
	-- and invert the intermediate signal every
	-- other rising edge
	PROCESS (CLK)
	BEGIN
		IF rising_edge(CLK) THEN
			IF (counter >= 1) THEN
				CLK_25M_sig <= NOT CLK_25M_sig; -- Invert intermediate signal
			ELSE
				counter <= counter + 1; -- Note: Signal is not updated until end of process!
			END IF;
		END IF;
	END PROCESS;
end Behavioral;