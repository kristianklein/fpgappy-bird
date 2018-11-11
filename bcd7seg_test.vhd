----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:11:37 11/11/2018 
-- Design Name: 
-- Module Name:    bcd7seg_test - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bcd7seg_test is
    Port ( SW0,SW1,SW2,SW3 : in STD_LOGIC;
					 BTN0,BTN1,BTN2,BTN3 : in STD_LOGIC;
           CA,CB,CC,CD,CE,CF,CG : out  STD_LOGIC;
					 LD0 : out STD_LOGIC;
           AN0,AN1,AN2,AN3 : out  STD_LOGIC);
end bcd7seg_test;

architecture Behavioral of bcd7seg_test is
	COMPONENT bcd2sevenseg
	PORT(
		bcd : IN std_logic_vector(3 downto 0);          
		sevenseg : OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;
	
	SIGNAL bcd_sig : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL seven_sig : STD_LOGIC_VECTOR (6 DOWNTO 0);
	
begin
	Inst_bcd2sevenseg: bcd2sevenseg PORT MAP(
		bcd => bcd_sig,
		sevenseg => seven_sig
	);
	
	bcd_sig <= SW3&SW2&SW1&SW0;
	
	(CA,CB,CC,CD,CE,CF,CG) <= seven_sig;
	
	AN0 <= '0';
	AN1 <= '0';
	AN2 <= '1';
	AN3 <= '0';
	
	LD0 <= BTN0;

end Behavioral;