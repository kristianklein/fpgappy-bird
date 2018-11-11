
-- VHDL Instantiation Created from source file binary2bcd.vhd -- 23:51:54 11/11/2018
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT binary2bcd
	PORT(
		binary : IN std_logic_vector(11 downto 0);          
		bcd : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	Inst_binary2bcd: binary2bcd PORT MAP(
		binary => ,
		bcd => 
	);


