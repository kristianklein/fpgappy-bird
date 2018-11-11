
-- VHDL Instantiation Created from source file display_driver.vhd -- 17:10:27 11/11/2018
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT display_driver
	PORT(
		bcd : IN std_logic_vector(15 downto 0);
		dp_vector : IN std_logic_vector(3 downto 0);
		CLK : IN std_logic;          
		seven_segment : OUT std_logic_vector(6 downto 0);
		anodes : OUT std_logic_vector(3 downto 0);
		dp : OUT std_logic
		);
	END COMPONENT;

	Inst_display_driver: display_driver PORT MAP(
		bcd => ,
		dp_vector => ,
		CLK => ,
		seven_segment => ,
		anodes => ,
		dp => 
	);


