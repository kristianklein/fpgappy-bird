LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY bcd2sevenseg IS
    PORT ( bcd : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
           sevenseg : OUT  STD_LOGIC_VECTOR (6 DOWNTO 0));
END bcd2sevenseg;

ARCHITECTURE behavioral OF bcd2sevenseg IS

BEGIN
	WITH bcd SELECT
		sevenseg <= "0000001" WHEN "0000", --0
						"1001111" WHEN "0001", --1
						"0010010" WHEN "0010", --2
						"0000110" WHEN "0011", --3
						"1001100" WHEN "0100", --4
						"0100100" WHEN "0101", --5
						"0100000" WHEN "0110", --6
						"0001111" WHEN "0111", --7
						"0000000" WHEN "1000", --8
						"0000100" WHEN "1001", --9
						"0001000" WHEN "1010", --A
						"1100000" WHEN "1011", --B
						"0110001" WHEN "1100", --C
						"1000010" WHEN "1101", --D
						"0110000" WHEN "1110", --E
						"0111000" WHEN "1111", --F
						"0000000" WHEN OTHERS;

END behavioral;
