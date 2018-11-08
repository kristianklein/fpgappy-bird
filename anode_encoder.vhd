LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY anode_encoder IS
    PORT ( input : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
           output : OUT  STD_LOGIC_VECTOR (3 DOWNTO 0));
END anode_encoder;

ARCHITECTURE behavioral OF anode_encoder IS

BEGIN
	WITH input SELECT
		output <= "1110" WHEN "00", -- Remember: Active LOW!
					 "1101" WHEN "01",
					 "1011" WHEN "10",
					 "0111" WHEN "11",
					 "1111" WHEN OTHERS;
END behavioral;
