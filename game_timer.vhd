library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity game_timer is
    Port ( CLK : in  STD_LOGIC;
           collision : in STD_LOGIC;
           points : out  STD_LOGIC_VECTOR (11 downto 0);
           game_clock : out  STD_LOGIC);
end game_timer;

architecture Behavioral of game_timer is
	SIGNAL outer_prescaler : STD_LOGIC_VECTOR (23 DOWNTO 0) := (OTHERS => '0');
  SIGNAL inner_prescaler : STD_LOGIC_VECTOR (6 DOWNTO 0) := (OTHERS => '0');
	SIGNAL level_counter : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0'); -- Max level: 20
  SIGNAL obstacles_passed : STD_LOGIC_VECTOR (1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL points_sig : STD_LOGIC_VECTOR (11 DOWNTO 0) := (OTHERS => '0');
  SIGNAL display_counter : STD_LOGIC_VECTOR (9 DOWNTO 0) := (OTHERS => '0');
  SIGNAL game_clock_sig : STD_LOGIC := '0';
  TYPE state_type IS (idle, running, game_over);
  SIGNAL state : state_type := running;
begin
  -- Map signals to outputs
  game_clock <= game_clock_sig;
  points <= points_sig;

	PROCESS (CLK)
	BEGIN
    IF rising_edge(CLK) THEN
    CASE state IS
      WHEN idle =>
      
      -- RUNNING
      WHEN running =>
        IF (collision = '1') THEN
          state <= game_over;
        END IF;
        
        -- Scale down 50 MHz clock to of 3200 Hz (160 Hz * 20)
        -- (4 seconds for an entire screen to roll by at 160 Hz)
        -- Increase the game_clock frequency every third screen
        -- by increasing the level-counter
          IF (outer_prescaler > 15624) THEN -- 3200 Hz (outer clock) 15624
            
            outer_prescaler <= (OTHERS => '0');
                    
            IF (inner_prescaler >= (50 - level_counter)) THEN
              inner_prescaler <= (OTHERS => '0');
              game_clock_sig <= NOT game_clock_sig;
              
              -- Grant 1 point for each full screen that rolls by (= one obstacle)
              IF (display_counter >= 639) THEN
                display_counter <= (OTHERS => '0');
                obstacles_passed <= obstacles_passed + 1; -- ikke her!
                points_sig <= points_sig + 1;
              ELSE
                display_counter <= display_counter + 1;
              END IF;
              
              
              -- Increase level if obstacles_passed > 2
              IF (obstacles_passed > 0) THEN
                obstacles_passed <= (OTHERS => '0');
                level_counter <= level_counter + 1;
              END IF;
            ELSE
              inner_prescaler <= inner_prescaler + 1;
            END IF;
            
          ELSE
            outer_prescaler <= outer_prescaler + 1;
          END IF;
        
      
      -- GAME OVER
      WHEN game_over =>
      
    END CASE;
		END IF;
	END PROCESS;

end Behavioral;

