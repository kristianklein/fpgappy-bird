library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga_driver is
    Port ( CLK : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           hsync : out  STD_LOGIC;
           vsync : out  STD_LOGIC;
		   v_pos : out STD_LOGIC_VECTOR (9 DOWNTO 0);
		   h_pos : out STD_LOGIC_VECTOR (9 DOWNTO 0);
		   RGB_enable : out STD_LOGIC;
		   vga_clock : out STD_LOGIC);
end vga_driver;

architecture Behavioral of vga_driver is
  SIGNAL vga_clock_sig : STD_LOGIC := '0';
  
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
  SIGNAL h_pos_sig : STD_LOGIC_VECTOR (9 DOWNTO 0);
  SIGNAL v_pos_sig : STD_LOGIC_VECTOR (9 DOWNTO 0);
  
  SIGNAL RGB_enable_sig : STD_LOGIC := '0';
  
begin

-- Scale 50 MHz down to 25 Mhz (display refresh rate of ~60 Hz)
clock_25MHz: PROCESS (CLK)
BEGIN
  IF rising_edge(CLK) THEN
    vga_clock_sig <= NOT vga_clock_sig;
  END IF;
END PROCESS;

-- Counter for horisontal position
horisontal_scan: PROCESS (vga_clock_sig, reset)
BEGIN
  IF (reset = '1') THEN
    h_pos_sig <= (OTHERS => '0');
  ELSIF rising_edge(vga_clock_sig) THEN
    IF (h_pos_sig >= 799) THEN -- Reached end of line
      h_pos_sig <= (OTHERS => '0');
    ELSE
      h_pos_sig <= h_pos_sig + 1;
    END IF;
  END IF;
END PROCESS;

-- Counter for vertical position
vertical_scan: PROCESS (vga_clock_sig, reset)
BEGIN
  IF (reset = '1') THEN
    v_pos_sig <= (OTHERS => '0');
  ELSIF rising_edge(vga_clock_sig) THEN
    IF (h_pos_sig >= H_BACKPORCH + H_DISPLAY + H_FRONTPORCH + H_SYNCPULSE) THEN -- Only increment vertical counter when horisontal counter reaches end of line
      IF (v_pos_sig >= V_BACKPORCH + V_DISPLAY + V_FRONTPORCH + V_SYNCPULSE) THEN
        v_pos_sig <= (OTHERS => '0');
      ELSE
        v_pos_sig <= v_pos_sig + 1;
      END IF;
    END IF;
  END IF;
END PROCESS;

-- Horisontal synchronisation
horisontal_sync: PROCESS (vga_clock_sig, reset)
BEGIN
  IF (reset = '1') THEN
    hsync <= '0';
  ELSIF rising_edge(vga_clock_sig) THEN
    -- hsync should be high while scanning back porch and display area and front porch,
    -- and low when scanning the sync pulse area
    -- Here I have the display area from count 0-H_DISPLAY to make it easier for myself
    IF (h_pos_sig <= H_DISPLAY + H_FRONTPORCH OR h_pos_sig > H_DISPLAY + H_FRONTPORCH + H_SYNCPULSE) THEN
      hsync <= '1';
    ELSE
      hsync <= '0';
    END IF;
  END IF;
END PROCESS;

-- Vertical synchronisation
vertical_sync: PROCESS (vga_clock_sig, reset)
BEGIN
  IF (reset = '1') THEN
    vsync <= '0';
  ELSIF rising_edge(vga_clock_sig) THEN
    -- vsync should be high while scanning back porch and display area and front porch,
    -- and low when scanning the sync pulse area (same as horisontal)
    -- Here I have the display area from count 0-V_DISPLAY to make it easier for myself
    IF (v_pos_sig <= V_DISPLAY + V_FRONTPORCH OR v_pos_sig > V_DISPLAY + V_FRONTPORCH + V_SYNCPULSE) THEN
      vsync <= '1';
    ELSE
      vsync <= '0';
    END IF;
  END IF;
END PROCESS;

-- Control when the RGB pins can be high (only in the display area)
RGB_control: PROCESS (vga_clock_sig, reset, v_pos_sig, h_pos_sig)
BEGIN
  IF (reset = '1') THEN
    RGB_enable_sig <= '0';
  ELSIF rising_edge(vga_clock_sig) THEN
    IF (h_pos_sig <= H_DISPLAY AND v_pos_sig <= V_DISPLAY) THEN
      RGB_enable_sig <= '1';
    ELSE
      RGB_enable_sig <= '0';
    END IF;
  END IF;
END PROCESS;

-- Map signals to outputs
RGB_enable <= RGB_enable_sig;
v_pos <= v_pos_sig;
h_pos <= h_pos_sig;
vga_clock <= vga_clock_sig;

end Behavioral;

