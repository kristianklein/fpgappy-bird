library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity obstacle is
    Port ( game_clock : in  STD_LOGIC;
		   reset : in STD_LOGIC;
           obstacle_x : out  STD_LOGIC_VECTOR (9 downto 0);
           obstacle_y : out  STD_LOGIC_VECTOR (9 downto 0));
end obstacle;

architecture Behavioral of obstacle is
   SIGNAL x_sig : STD_LOGIC_VECTOR(9 DOWNTO 0) := "1010000000"; -- 640
   SIGNAL y_sig : STD_LOGIC_VECTOR(9 DOWNTO 0) := "0001000000"; -- 128 for testing
begin
  obstacle_x <= x_sig;
  obstacle_y <= y_sig;

  PROCESS (game_clock)
  BEGIN
    IF (reset = '1') THEN
		x_sig <= "1010000000";
	ELSIF rising_edge(game_clock) THEN
	  IF (x_sig < 1) THEN
        x_sig <= "1010000000";
      ELSE
        x_sig <= x_sig - 1;
      END IF;
	END IF;
	
  END PROCESS;

end Behavioral;

