library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity obstacle is
    Port ( game_clock : in  STD_LOGIC;
		   reset : in STD_LOGIC;
           obstacle_x : out  STD_LOGIC_VECTOR (9 downto 0);
           generate_random_y : out STD_LOGIC);
end obstacle;

architecture Behavioral of obstacle is
   SIGNAL x_sig : STD_LOGIC_VECTOR(9 DOWNTO 0) := "1010000000"; -- 640
   SIGNAL obstacle_count : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0');
begin
  obstacle_x <= x_sig;

  PROCESS (game_clock)
  BEGIN
    IF (reset = '1') THEN
		x_sig <= "1010000000";
		generate_random_y <= '0';
	ELSIF rising_edge(game_clock) THEN
	  IF (x_sig < 1) THEN
        x_sig <= "1010000000";
		generate_random_y <= '1';
      ELSE
        x_sig <= x_sig - 1;
		generate_random_y <= '0';
      END IF;
	END IF;
	
  END PROCESS;

end Behavioral;

