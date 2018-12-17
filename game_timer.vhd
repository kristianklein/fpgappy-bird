library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity game_timer is
    Port ( CLK : in  STD_LOGIC;
		   enable : in STD_LOGIC;
		   reset : in STD_LOGIC;
           points : out  STD_LOGIC_VECTOR (11 downto 0);
           game_clock : out  STD_LOGIC);
end game_timer;

architecture Behavioral of game_timer is
	SIGNAL outer_prescaler : STD_LOGIC_VECTOR (23 DOWNTO 0) := (OTHERS => '0');
	SIGNAL inner_prescaler : STD_LOGIC_VECTOR (6 DOWNTO 0) := (OTHERS => '0');
	SIGNAL level_counter : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0'); -- Max level: 20
	SIGNAL obstacles_passed : STD_LOGIC_VECTOR (1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL points_sig : STD_LOGIC_VECTOR (11 DOWNTO 0) := (OTHERS => '0');
	SIGNAL display_counter : STD_LOGIC_VECTOR (11 DOWNTO 0) := (OTHERS => '0');
	SIGNAL game_clock_sig : STD_LOGIC := '0';
begin
  -- Map signals to outputs
  game_clock <= game_clock_sig;
  points <= points_sig;

	PROCESS (CLK, enable, reset)
	BEGIN
	IF (reset = '1') THEN
		outer_prescaler <= (OTHERS => '0');
		inner_prescaler <= (OTHERS => '0');
		level_counter <= (OTHERS => '0');
		obstacles_passed <= (OTHERS => '0');
		points_sig <= (OTHERS => '0');
		display_counter <= (OTHERS => '0');
    ELSIF (rising_edge(CLK) AND enable = '1') THEN    
        -- Scale down 50 MHz clock to of 6400 Hz
        -- Increase the game_clock frequency every other screen
        -- by increasing the level-counter
          IF (outer_prescaler > 7814) THEN -- 6400 Hz (outer clock) 15624 counts
            
            outer_prescaler <= (OTHERS => '0');
            
            IF (inner_prescaler >= (30 - level_counter)) THEN
              inner_prescaler <= (OTHERS => '0');
              game_clock_sig <= NOT game_clock_sig;
              
              -- Grant 1 point for each full screen that rolls by (= one obstacle)
			  -- 640 pixels = 2*640 clock edges
              IF (display_counter >= 1280) THEN
                display_counter <= (OTHERS => '0');
                obstacles_passed <= obstacles_passed + 1;
                points_sig <= points_sig + 1;
              ELSE
                display_counter <= display_counter + 1;
              END IF;
              
              
              -- Increase level for every other obstacle
              IF (obstacles_passed > 1) THEN
                obstacles_passed <= (OTHERS => '0');
				IF (level_counter > 29) THEN
					level_counter <= (OTHERS => '0');
				ELSE
					level_counter <= level_counter + 1;
				END IF;
              END IF;
            ELSE
              inner_prescaler <= inner_prescaler + 1;
            END IF;
            
          ELSE
            outer_prescaler <= outer_prescaler + 1;
          END IF;
	END IF;
	END PROCESS;

end Behavioral;

