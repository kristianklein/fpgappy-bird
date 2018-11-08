LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux_4to1 IS
    PORT ( input : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
           output : OUT  STD_LOGIC;
			  sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0)
			 );
END mux_4to1;

ARCHITECTURE behavioral OF mux_4to1 IS
BEGIN
	WITH sel SELECT
		output <= input(0) WHEN "00",
					 input(1) WHEN "01",
					 input(2) WHEN "10",
					 input(3) WHEN "11",
					 '0' WHEN OTHERS;
END behavioral;
