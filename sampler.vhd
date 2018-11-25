-- Dette modul anmoder om en sample fra ADC interfacet ved en bestemt
-- samplingfrekvens, som kan indstilles via prescaler inputtet (16-bit)
-- Den maksimale samplingfrekvens er sat til 1 MSps (skaleret med 50 som default)
-- og den nedskaleres så yderligere herfra. En prescaler på 0 eller 1 giver 
-- altså 1 MSps, en prescaler på 2 giver 500 kSps, 3 giver 333 kSps, osv.
-- Den laveste samplingfrekvens (prescaler = 65535) er altså ~15 Hz
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sampler is
    Port ( CLK : in  STD_LOGIC;
           done : in STD_LOGIC;
           prescaler : in STD_LOGIC_VECTOR (15 downto 0);
           enable : in STD_LOGIC;
			     start : out STD_LOGIC
			   );
end sampler;

architecture Behavioral of sampler is
	-- SIGNALS
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
      -- Ydre counter
      
      IF rising_edge(CLK) THEN
        IF (constant_counter >= 49) THEN -- skaleres altid med 50 (50-1)
          
          -- Indre counter
          IF (prescaler = 0 OR prescale_counter >= (prescaler - 1)) THEN -- sampling rate of ~495 kHz (you cannot set the counter lower than 100 or the ADC stalls, fix it in ADC interface)
            start_sig <= '1'; -- start conversion
            prescale_counter <= (OTHERS => '0');
          ELSE
            prescale_counter <= prescale_counter + 1;
            
            IF (done_sig = '1') THEN
              start_sig <= '0';
            END IF;
            
          END IF;
          
          constant_counter <= (OTHERS => '0'); -- reset ydre counter
        ELSE
          constant_counter <= constant_counter + 1;
        END IF;
          
      END IF;
      
      
    END IF;
		
	END PROCESS;
	
end Behavioral;

