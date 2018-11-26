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
           bird_rom_adr : out STD_LOGIC_VECTOR (7 DOWNTO 0);
           bird_rom_rgb : in STD_LOGIC_VECTOR (7 DOWNTO 0);
           RGB_out : out  STD_LOGIC_VECTOR (7 downto 0));
end game_render;

architecture Behavioral of game_render is
	SIGNAL bird_adr_counter : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0');
  CONSTANT NUM_BIRD_PIXELS : INTEGER := 203; -- 17 x 12
begin
	-- Map signals to outputs
  bird_rom_adr <= bird_adr_counter;
  
	draw: PROCESS (vga_clock)
	BEGIN
		IF rising_edge(vga_clock) THEN
			IF (RGB_enable = '1') THEN
        -- Render bird
        IF v_pos >= player_y AND
           v_pos < player_y + 12 AND -- 0 to 11 = 12 pixels
           h_pos >= 20 AND
           h_pos < 37
        THEN
           -- Get rgb value from bird_rom
           RGB_out <= bird_rom_rgb;
           bird_adr_counter <= bird_adr_counter + 1;
        -- Reset bird_adr_counter when display area has been scanned
        ELSIF bird_adr_counter >= NUM_BIRD_PIXELS THEN
          bird_adr_counter <= (OTHERS => '0');
        ELSE
          -- Draw background (blue)
          RGB_out <= "01001011";
        END IF;
        
        
			ELSE
				RGB_out <= (OTHERS => '0'); -- turn all off when not in display area
			END IF;
		END IF;
	END PROCESS;

end Behavioral;

