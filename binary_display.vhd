library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity binary_display is
    Port ( SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7 : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           AN0,AN1,AN2,AN3 : out  STD_LOGIC;
           CA,CB,CC,CD,CE,CF,CG : out  STD_LOGIC;
					 DP : out STD_LOGIC);
end binary_display;

architecture Structural of binary_display is
	-- COMPONENTS
	COMPONENT binary2bcd
	PORT(
		binary : IN std_logic_vector(11 downto 0);          
		bcd : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

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

	-- SIGNALS
	SIGNAL binary_sig : STD_LOGIC_VECTOR (11 DOWNTO 0);
	SIGNAL bcd_sig : STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL seven_seg_sig : STD_LOGIC_VECTOR (6 DOWNTO 0);
	SIGNAL anode_sig : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL dp_sig : STD_LOGIC_VECTOR (3 DOWNTO 0) := "1111";
begin
	-- INSTANTIATIONS
	Inst_binary2bcd: binary2bcd PORT MAP(
		binary => binary_sig,
		bcd => bcd_sig
	);

	Inst_display_driver: display_driver PORT MAP(
		bcd => bcd_sig,
		dp_vector => dp_sig,
		clock => CLK,
		seven_segment => seven_seg_sig,
		anodes => anode_sig,
		dp => DP
	);
	
	-- LOGIC
	binary_sig <= "0000" & SW7 & SW6 & SW5 & SW4 & SW3 & SW2 & SW1 & SW0;
	(AN3, AN2, AN1, AN0) <= anode_sig;
	(CA, CB, CC, CD, CE, CF, CG) <= seven_seg_sig;

end Structural;

