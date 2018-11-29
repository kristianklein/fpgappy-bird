library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity collision_detector is
    Port ( player_y : in  STD_LOGIC_VECTOR (9 downto 0);
           obstacle_x : in  STD_LOGIC_VECTOR (9 downto 0);
           obstacle_y : in  STD_LOGIC_VECTOR (9 downto 0);
           collision : out  STD_LOGIC);
end collision_detector;

architecture Behavioral of collision_detector is
  
begin
  PROCESS (player_y, obstacle_x, obstacle_y)
  BEGIN
    IF (obstacle_x <= 37 AND (player_y < obstacle_y OR player_y >= obstacle_y + 40-12)) THEN
      collision <= '1';
    ELSE
      collision <= '0';
    END IF;
  END PROCESS;

end Behavioral;

