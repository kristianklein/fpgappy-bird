library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity debouncer is
    Port ( CLK : in  STD_LOGIC;
           button_raw : in  STD_LOGIC;
           pulse : out  STD_LOGIC;
           debounced : out  STD_LOGIC;
           toggle : out  STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is
	SIGNAL counter : STD_LOGIC_VECTOR(23 DOWNTO 0) := (OTHERS => '0');
	TYPE state_type IS (idle, pressed, active, released);
	SIGNAL state : state_type := idle;
	SIGNAL toggle_sig : STD_LOGIC := '0';
begin
	toggle <= toggle_sig;
	
	PROCESS (CLK, button_raw)
	BEGIN
		IF rising_edge(CLK) THEN
			CASE state IS
				WHEN idle =>
					IF (button_raw = '1') THEN
						state <= pressed;
						counter <= (OTHERS => '0');
					END IF;
				WHEN pressed =>
					IF (button_raw = '1') THEN
						IF (counter > 499999) THEN -- 10 ms debounce (500.000 cycles)
							pulse <= '1';
							debounced <= '1';
							toggle_sig <= NOT toggle_sig;
							state <= active;
						ELSE
							counter <= counter + 1;
						END IF;
					ELSE
						state <= idle;
					END IF;
				WHEN active =>
					pulse <= '0';
					
					IF (button_raw = '0') THEN
						state <= released;
						counter <= (OTHERS => '0');
					END IF;
					
					
				WHEN released =>
					IF (button_raw = '0') THEN
						
						IF (counter > 499999) THEN -- 10 ms debounce (500.000 cycles)
							debounced <= '0';
							state <= idle;
						ELSE
							counter <= counter + 1;
						END IF;
					ELSE
						state <= active;
					END IF; 
			END CASE;
			
			
		END IF;
		
	END PROCESS;

end Behavioral;