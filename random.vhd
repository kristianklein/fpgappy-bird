library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity random is
    Port ( CLK : in STD_LOGIC;
		   start : in  STD_LOGIC;
           random_number : out  STD_LOGIC_VECTOR (9 downto 0));
end random;

architecture Behavioral of random is
	TYPE state_type IS (idle, randomize, done);
	SIGNAL state : state_type := idle;
	SIGNAL random_16bit : STD_LOGIC_VECTOR (15 DOWNTO 0) := "0110011001010001"; -- arbitrary seed
	SIGNAL mask : STD_LOGIC_VECTOR (15 DOWNTO 0) := "1101001010010101";
	SIGNAL LSB : STD_LOGIC;
begin
	-- 16-bit mask = 0xD295 = 0b1101001010010101
	-- LSFR
	
	PROCESS (CLK, start)
	BEGIN
		IF rising_edge(CLK) THEN
			CASE state IS
				WHEN idle =>
					IF (start = '1') THEN
						state <= randomize;
						LSB <= random_16bit(0);
					END IF;
									
				WHEN randomize =>
					IF (LSB = '1') THEN -- apply mask after right shift
						random_16bit <= ('0' & random_16bit(15 DOWNTO 1)) XOR mask;
					ELSE -- just right shift
						random_16bit <= '0' & random_16bit(15 DOWNTO 1);
					END IF;
					state <= done;
					
				WHEN done =>
					IF (random_16bit(8 DOWNTO 0) > 440) THEN
						random_number <= '0' & (random_16bit(8 DOWNTO 0) - 100);
					ELSE
						random_number <= '0' & random_16bit(8 DOWNTO 0);
					END IF;
					
					IF (start = '0') THEN
						state <= idle;
					END IF;
					
			END CASE;
		END IF;
	END PROCESS;

end Behavioral;

