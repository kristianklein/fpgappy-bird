
-- VHDL Instantiation Created from source file adc_interface.vhd -- 10:17:28 11/22/2018
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT adc_interface
	PORT(
		Clk : IN std_logic;
		Start : IN std_logic;
		D0 : IN std_logic;
		D1 : IN std_logic;          
		Done : OUT std_logic;
		SClk : OUT std_logic;
		CS : OUT std_logic;
		AD1 : OUT std_logic_vector(11 downto 0);
		AD2 : OUT std_logic_vector(11 downto 0)
		);
	END COMPONENT;

	Inst_adc_interface: adc_interface PORT MAP(
		Clk => ,
		Start => ,
		Done => ,
		SClk => ,
		CS => ,
		D0 => ,
		D1 => ,
		AD1 => ,
		AD2 => 
	);


