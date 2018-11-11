----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:10:15 11/08/2018 
-- Design Name: 
-- Module Name:    display_driver - Behavioral 
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

entity display_driver is
    Port ( bcd : in  STD_LOGIC_VECTOR (15 downto 0);
           dp_vector : in  STD_LOGIC_VECTOR (3 downto 0);
           clock : in  STD_LOGIC;
           seven_segment : out  STD_LOGIC_VECTOR (6 downto 0);
           anodes : out  STD_LOGIC_VECTOR (3 downto 0);
           dp : out  STD_LOGIC);
end display_driver;

architecture Structural of display_driver is
	-- COMPONENTS
	COMPONENT clockscaler_1k
	PORT(
		clock : IN std_logic;          
		clock_1k : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT counter_2bit
	PORT(
		clock : IN std_logic;          
		output : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;
	
	COMPONENT mux_16to4
	PORT(
		input : IN std_logic_vector(15 downto 0);
		sel : IN std_logic_vector(1 downto 0);          
		output : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	COMPONENT mux_4to1
	PORT(
		input : IN std_logic_vector(3 downto 0);
		sel : IN std_logic_vector(1 downto 0);          
		output : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT anode_encoder
	PORT(
		input : IN std_logic_vector(1 downto 0);          
		output : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	COMPONENT bcd2sevenseg
	PORT(
		bcd : IN std_logic_vector(3 downto 0);          
		sevenseg : OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;

	-- SIGNALS
	SIGNAL scaled_clock : STD_LOGIC;
	SIGNAL bcd_mux : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL sel_sig : STD_LOGIC_VECTOR (1 DOWNTO 0);
begin
	-- INSTANTIATIONS
	Inst_clockscaler_1k: clockscaler_1k PORT MAP(
		clock => clock,
		clock_1k => scaled_clock
	);
	
	Inst_counter_2bit: counter_2bit PORT MAP(
		clock => scaled_clock,
		output => sel_sig
	);

	Inst_mux_16to4: mux_16to4 PORT MAP(
		input => bcd,
		output => bcd_mux,
		sel => sel_sig
	);

	Inst_mux_4to1: mux_4to1 PORT MAP(
		input => dp_vector,
		output => dp,
		sel => sel_sig
	);
	
	Inst_anode_encoder: anode_encoder PORT MAP(
		input => sel_sig,
		output => anodes
	);
	
	Inst_bcd2sevenseg: bcd2sevenseg PORT MAP(
		bcd => bcd_mux,
		sevenseg => seven_segment
	);

end Structural;