library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_test is
    Port ( AN0,AN1,AN2,AN3 : out  STD_LOGIC;
           CA,CB,CC,CD,CE,CF,CG : out  STD_LOGIC;
					 DP : out STD_LOGIC;
					 CLK : in STD_LOGIC);
end display_test;

architecture Behavioral of display_test is
	COMPONENT display_driver
	PORT(
		bcd : IN std_logic_vector(15 downto 0);
		dp_vector : IN std_logic_vector(3 downto 0);
		clock : IN std_logic;          
		seven_segment : OUT std_logic_vector(6 downto 0);
		anodes : OUT std_logic_vector(3 downto 0);
		dp : OUT std_logic
		);
	END COMPONENT;
	
	SIGNAL bcd_sig : STD_LOGIC_VECTOR (15 DOWNTO 0) := "0000000100100011";
	SIGNAL anode_sig : STD_LOGIC_VECTOR (3 downto 0);
	SIGNAL seven_seg_sig : STD_LOGIC_VECTOR (6 downto 0);
	SIGNAL dp_sig : STD_LOGIC_VECTOR (3 downto 0) := "0000";
begin
	Inst_display_driver: display_driver PORT MAP(
		bcd => bcd_sig,
		dp_vector => dp_sig,
		clock => CLK,
		seven_segment => seven_seg_sig,
		anodes => anode_sig,
		dp => DP
	);
	
	(CA,CB,CC,CD,CE,CF,CG) <= seven_seg_sig;
	(AN3,AN2,AN1,AN0) <= anode_sig;

end Behavioral;

