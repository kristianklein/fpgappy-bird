library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga_driver is
    Port ( CLK : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           rgb_in : in STD_LOGIC_VECTOR (7 DOWNTO 0);
           hsync : out  STD_LOGIC;
           vsync : out  STD_LOGIC;
           rgb_out : out STD_LOGIC_VECTOR (7 DOWNTO 0));
end vga_driver;

architecture Behavioral of vga_driver is
  SIGNAL vga_clock : STD_LOGIC := '0';
  
  ---- CONSTANTS FOR VGA TIMING
  -- Horisontal
  CONSTANT H_BACKPORCH : INTEGER := 48;
  CONSTANT H_DISPLAY : INTEGER := 639; -- 640 - 1 (count starts at 0)
  CONSTANT H_FRONTPORCH : INTEGER := 16;
  CONSTANT H_SYNCPULSE : INTEGER := 96;
  
  -- Vertical
  CONSTANT V_BACKPORCH : INTEGER := 33;
  CONSTANT V_DISPLAY : INTEGER := 479; -- 480 - 1 (count start at 0)
  CONSTANT V_FRONTPORCH : INTEGER := 10;
  CONSTANT V_SYNCPULSE : INTEGER := 2;
  
  -- COUNTERS
  SIGNAL h_pos : INTEGER RANGE 0 TO 799 := 0;
  SIGNAL v_pos : INTEGER RANGE 0 TO 524 := 0;
  
  SIGNAL RGB_enable : STD_LOGIC := '0';
  
begin

-- Scale 50 MHz down to 25 Mhz (display refresh rate of ~60 Hz)
clock_25MHz: PROCESS (CLK)
BEGIN
  IF rising_edge(CLK) THEN
    vga_clock <= NOT vga_clock;
  END IF;
END PROCESS;

-- Counter for horisontal position
horisontal_scan: PROCESS (vga_clock, reset)
BEGIN
  IF (reset = '1') THEN
    h_pos <= 0;
  ELSIF rising_edge(vga_clock) THEN
    IF (h_pos = 799) THEN -- Reached end of line
      h_pos <= 0;
    ELSE
      h_pos <= h_pos + 1;
    END IF;
  END IF;
END PROCESS;

-- Counter for vertical position
vertical_scan: PROCESS (vga_clock, reset)
BEGIN
  IF (reset = '1') THEN
    v_pos <= 0;
  ELSIF rising_edge(vga_clock) THEN
    IF (h_pos = H_BACKPORCH + H_DISPLAY + H_FRONTPORCH + H_SYNCPULSE) THEN -- Only increment vertical counter when horisontal counter reaches end of line
      IF (v_pos = V_BACKPORCH + V_DISPLAY + V_FRONTPORCH + V_SYNCPULSE) THEN
        v_pos <= 0;
      ELSE
        v_pos <= v_pos + 1;
      END IF;
    END IF;
  END IF;
END PROCESS;

-- Horisontal synchronisation
horisontal_sync: PROCESS (vga_clock, reset)
BEGIN
  IF (reset = '1') THEN
    hsync <= '0';
  ELSIF rising_edge(vga_clock) THEN
    -- hsync should be high while scanning back porch and display area and front porch,
    -- and low when scanning the sync pulse area
    -- Here I have the display area from count 0-H_DISPLAY to make it easier for myself
    IF (h_pos <= H_DISPLAY + H_FRONTPORCH OR h_pos > H_DISPLAY + H_FRONTPORCH + H_SYNCPULSE) THEN
      hsync <= '1';
    ELSE
      hsync <= '0';
    END IF;
  END IF;
END PROCESS;

-- Vertical synchronisation
vertical_sync: PROCESS (vga_clock, reset)
BEGIN
  IF (reset = '1') THEN
    vsync <= '0';
  ELSIF rising_edge(vga_clock) THEN
    -- vsync should be high while scanning back porch and display area and front porch,
    -- and low when scanning the sync pulse area (same as horisontal)
    -- Here I have the display area from count 0-V_DISPLAY to make it easier for myself
    IF (v_pos <= V_DISPLAY + V_FRONTPORCH OR v_pos > V_DISPLAY + V_FRONTPORCH + V_SYNCPULSE) THEN
      vsync <= '1';
    ELSE
      vsync <= '0';
    END IF;
  END IF;
END PROCESS;

-- Control when the RGB pins can be high (only in the display area)
RGB_control: PROCESS (vga_clock, reset, v_pos, h_pos)
BEGIN
  IF (reset = '1') THEN
    RGB_enable <= '0';
  ELSIF rising_edge(vga_clock) THEN
    IF (h_pos <= H_DISPLAY AND v_pos <= V_DISPLAY) THEN
      RGB_enable <= '1';
    ELSE
      RGB_enable <= '0';
    END IF;
  END IF;
END PROCESS;

draw_display: PROCESS (vga_clock, reset, v_pos, h_pos, RGB_enable)
BEGIN
  IF (reset = '1') THEN
    rgb_out <= "00000000";
  ELSIF rising_edge(vga_clock) THEN
    IF (RGB_enable = '1') THEN
      rgb_out <= rgb_in;
    ELSE
      rgb_out <= "00000000";
    END IF;
  END IF;
END PROCESS;

end Behavioral;

