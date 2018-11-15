-- This module automatically scales the 50 MHz clock
-- down to 12.5 MHz (max for the ADC) and then the input
-- prescaler signal can be used to additionally scale down
-- the clock.
-- If the prescaler is set to 0 or 1, the scaled_clock
-- signal is 12.5 MHz. If the prescaler is 2 the scaled_clock
-- is 6.25 MHz and so on.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity variable_clockscaler is
    Port ( clock : in  STD_LOGIC;
			  prescaler : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           scaled_clock : out  STD_LOGIC);
end variable_clockscaler;

architecture Behavioral of variable_clockscaler is
	SIGNAL fixed_counter : STD_LOGIC_VECTOR (1 DOWNTO 0) := "00";
	SIGNAL prescale_counter : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL scaled_clock_sig : STD_LOGIC := '0';
begin
	scaled_clock <= scaled_clock_sig; -- Map intermediate signal to output
	
	-- Scale 50 MHz to 12.5 MHz (always!)
	PROCESS (clock)
	BEGIN
		IF (fixed_counter = 3) THEN -- If we need to scale by 4, we wait until counter is 4 - 1 = 3
			
			-- Scale 12.5 MHz by prescaler
			IF (prescale_counter = (prescaler - 1)) THEN
				scaled_clock_sig <= NOT scaled_clock_sig; -- Invert scaled_clock signal	
				prescale_counter <= (OTHERS => '0'); -- Reset counter
			ELSE
				prescale_counter <= prescale_counter + 1;
			END IF;
			
			fixed_counter <= (OTHERS => '0');
			
		ELSE
			fixed_counter <= fixed_counter + 1;
		END IF;
	END PROCESS;
	
end Behavioral;