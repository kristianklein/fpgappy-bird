LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY counter_2bit IS
    PORT ( clock : IN  STD_LOGIC;
           output : OUT  STD_LOGIC_VECTOR (1 DOWNTO 0));
END counter_2bit;

ARCHITECTURE behavioral OF counter_2bit IS
	SIGNAL counter : STD_LOGIC_VECTOR (1 DOWNTO 0) := "00";
BEGIN
	output <= counter;
	
	PROCESS (clock)
	BEGIN
		IF rising_edge(clock) THEN
			counter <= counter + 1;
		END IF;
	END PROCESS;
END behavioral;
