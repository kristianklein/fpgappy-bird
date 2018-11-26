library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity game_render is
    Port ( vga_clock : in  STD_LOGIC;
           player_y : in  STD_LOGIC_VECTOR (9 downto 0);
           h_pos : in  STD_LOGIC_VECTOR (9 downto 0);
           v_pos : in  STD_LOGIC_VECTOR (9 downto 0);
           RGB_enable : in  STD_LOGIC;
           RGB_out : out  STD_LOGIC_VECTOR (7 downto 0));
end game_render;

architecture Behavioral of game_render is
	
begin
	
	draw: PROCESS (vga_clock)
	BEGIN
		IF rising_edge(vga_clock) THEN
			IF (RGB_enable = '1') THEN
				IF (v_pos >= player_y AND v_pos < (player_y + 40) AND h_pos >= 10 AND h_pos < 50) THEN
					RGB_out <= "11100000";
				ELSE
					RGB_out <= (OTHERS => '0');
				END IF;
			ELSE
				RGB_out <= (OTHERS => '0'); -- turn all off when not in display area
			END IF;
		END IF;
	END PROCESS;

end Behavioral;

