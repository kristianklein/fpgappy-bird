library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity game_fsm is
    Port ( CLK : in STD_LOGIC;
		   button_pulse : in  STD_LOGIC;
           collision : in  STD_LOGIC;
           reset : out  STD_LOGIC;
           enable : out  STD_LOGIC);
end game_fsm;

architecture Behavioral of game_fsm is
	TYPE state_type IS (idle, running, paused, game_over);
	SIGNAL state : state_type := idle;
begin
	PROCESS (CLK, button_pulse, collision)
	BEGIN
		IF rising_edge(CLK) THEN
			CASE state IS
				WHEN idle =>
					enable <= '0';
					reset <= '0';
				 
					IF (button_pulse = '1') THEN
						state <= running;
					END IF;
				WHEN running =>
					enable <= '1';
					reset <= '0';
					
					IF (button_pulse = '1') THEN
						state <= paused;
					ELSIF (collision = '1') THEN
						state <= game_over;
					END IF;
				WHEN paused =>
					enable <= '0';
					reset <= '0';
					
					IF (button_pulse = '1') THEN
						state <= running;
					END IF;
				WHEN game_over =>
					enable <= '0';
					
					IF (button_pulse = '1') THEN
						state <= idle;
						reset <= '1';
					END IF;
			END CASE;
		END IF;
	END PROCESS;


end Behavioral;

