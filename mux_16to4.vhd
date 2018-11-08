LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux_16to4 IS
    PORT ( input : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           output : OUT  STD_LOGIC_VECTOR (3 DOWNTO 0);
           sel : IN  STD_LOGIC_VECTOR (1 DOWNTO 0)
			 );
END mux_16to4;

ARCHITECTURE behavioral OF mux_16to4 IS
BEGIN
	WITH sel SELECT
		output <= input(3 DOWNTO 0) WHEN "00",
					 input(7 DOWNTO 4) WHEN "01",
					 input(11 DOWNTO 8) WHEN "10",
					 input(15 DOWNTO 12) WHEN "11",
					 "0000" WHEN OTHERS;
END behavioral;
