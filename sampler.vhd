-- This module request a sample from the ADC interface at a specific
-- sampling frequency, which is set by the 16-bit prescaler input.
-- The 50 MHz clock is always scaled down by 50, to give a maximum
-- sampling frequency of 1 MSa/s (prescaler set to 0 or 1).
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sampler is
    Port (	CLK : in  STD_LOGIC;
			done : in STD_LOGIC;
			prescaler : in STD_LOGIC_VECTOR (15 downto 0);
			enable : in STD_LOGIC;
			start : out STD_LOGIC
			);
end sampler;

architecture Behavioral of sampler is
	-------------
	-- SIGNALS --
	-------------
	SIGNAL constant_counter: STD_LOGIC_VECTOR (5 DOWNTO 0) := (OTHERS => '0');
	SIGNAL prescale_counter : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL start_sig : STD_LOGIC := '0';
	SIGNAL done_sig : STD_LOGIC;
begin
	-- Mapping signals to outputs
  start <= start_sig;
  done_sig <= done;

	--LD1 <= start_sig;
	PROCESS (CLK)
	BEGIN
    IF (enable = '1') THEN
      -- Outer counter
      
      IF rising_edge(CLK) THEN
        IF (constant_counter >= 49) THEN -- Always scale down by a minimum of 50
          
          -- Inner counter
          IF (prescaler = 0 OR prescale_counter >= (prescaler - 1)) THEN -- sampling rate of ~495 kHz (you cannot set the counter lower than 100 or the ADC stalls, fix it in ADC interface)
            start_sig <= '1'; -- start conversion
            prescale_counter <= (OTHERS => '0');
          ELSE
            prescale_counter <= prescale_counter + 1;
            
            IF (done_sig = '1') THEN
              start_sig <= '0';
            END IF;
            
          END IF;
          
          constant_counter <= (OTHERS => '0'); -- reset outer counter
        ELSE
          constant_counter <= constant_counter + 1;
        END IF;
          
      END IF;
      
      
    END IF;
		
	END PROCESS;
	
end Behavioral;

