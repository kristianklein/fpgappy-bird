
-- VHDL Instantiation Created from source file bcd2sevenseg.vhd -- 11:29:48 11/08/2018
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT bcd2sevenseg
	PORT(
		bcd : IN std_logic_vector(3 downto 0);          
		sevenseg : OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;

	Inst_bcd2sevenseg: bcd2sevenseg PORT MAP(
		bcd => ,
		sevenseg => 
	);


