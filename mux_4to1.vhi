
-- VHDL Instantiation Created from source file mux_4to1.vhd -- 11:20:35 11/08/2018
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT mux_4to1
	PORT(
		input : IN std_logic_vector(3 downto 0);
		sel : IN std_logic_vector(1 downto 0);          
		output : OUT std_logic
		);
	END COMPONENT;

	Inst_mux_4to1: mux_4to1 PORT MAP(
		input => ,
		output => ,
		sel => 
	);


