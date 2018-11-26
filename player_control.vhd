library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity player_control is
    Port ( CLK : in STD_LOGIC;
		   adc_value : in  STD_LOGIC_VECTOR (11 downto 0);
           player_y : out  STD_LOGIC_VECTOR (9 downto 0)); -- 10 bits just to make it the same as x coordinates
end player_control;

architecture Behavioral of player_control is
	SIGNAL adc_10bit : STD_LOGIC_VECTOR (9 DOWNTO 0); -- again using 10 bits, but the most significant bit should ALWAYS be 0
	SIGNAL counter : STD_LOGIC_VECTOR (19 DOWNTO 0); -- scale down 50 MHz clock to 60 Hz
	CONSTANT prescaler : INTEGER := 833333; -- 50.000.000 Hz / 833.333 ~= 60 Hz
	CONSTANT player_height : INTEGER := 40;
begin

	adc_10bit <= '0' & adc_value (11 DOWNTO 3);
	
	map_position: PROCESS (CLK)
	BEGIN
		IF rising_edge(CLK) THEN
			IF (counter >= prescaler) THEN
				-- Map ADC value to player y-position on screen
				-- y-position can be 0 to (480 - player_height)
				-- Max 9-bit ADC value is 511, so we subtract 
				-- 31 (~16 from each "end" of the potentiometer)
				-- and also subtract the player height, so the sprite
				-- cannot leave the bottom of the screen.
				-- In this case we must subtract 71 total, or 36 in
				-- each end - or in this case just map the bottom 36 values
				-- to 0 and the top 36 values to VMAX = 480 - player_height
				IF (adc_10bit < 36) THEN
					player_y <= (OTHERS => '0');
				ELSIF (adc_10bit > 475) THEN
					player_y <= "0110111000"; -- 440 binary
				ELSE
					player_y <= adc_10bit - 36;
				END IF;
				
			ELSE
				counter <= counter + 1;
			END IF;
		END IF;
	END PROCESS;

end Behavioral;

