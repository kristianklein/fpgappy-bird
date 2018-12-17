library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity binary2bcd is
    Port ( binary : in  STD_LOGIC_VECTOR (11 downto 0);
           bcd : out  STD_LOGIC_VECTOR (15 downto 0));
end binary2bcd;

architecture Behavioral of binary2bcd is
	-- FUNCTIONS
	-- "Double dabble" algorithm
	FUNCTION binary12bit2bcd (bin : STD_LOGIC_VECTOR(11 DOWNTO 0) ) RETURN STD_LOGIC_VECTOR IS
		VARIABLE i : INTEGER := 0;
		VARIABLE bcd_var : STD_LOGIC_VECTOR(15 downto 0) := (OTHERS => '0');
		VARIABLE bin_var : STD_LOGIC_VECTOR(11 downto 0) := bin;
	BEGIN
		FOR i IN 0 TO 11 LOOP  -- Iterate through each bit in the binary number
			
			bcd_var(15 downto 1) := bcd_var(14 downto 0);  -- Left shift bcd vector
			bcd_var(0) := bin_var(11);
			
			bin_var(11 downto 1) := bin_var(10 downto 0); -- Left shit binary vector
			bin_var(0) := '0';

			-- If ones, tens, hundreds or thousands is larger than 4, add 3 to the number to "carry" in base ten
			IF (i < 11 AND bcd_var(3 DOWNTO 0) > "0100") THEN
				bcd_var(3 DOWNTO 0) := bcd_var(3 DOWNTO 0) + "0011";
			END IF;

			IF (i < 11 AND bcd_var(7 DOWNTO 4) > "0100") THEN 
				bcd_var(7 DOWNTO 4) := bcd_var(7 DOWNTO 4) + "0011";
			END IF;

			IF (i < 11 AND bcd_var(11 DOWNTO 8) > "0100") THEN 
				bcd_var(11 DOWNTO 8) := bcd_var(11 DOWNTO 8) + "0011";
			END IF;

			IF (i < 11 AND bcd_var(15 DOWNTO 12) > "0100") THEN 
				bcd_var(15 DOWNTO 12) := bcd_var(15 DOWNTO 12) + "0011";
			END IF;
			
		END LOOP;
		
		RETURN bcd_var;
	END binary12bit2bcd;
begin

	bcd <= binary12bit2bcd(binary);

end Behavioral;

