----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Opgave: gør den følgende VHDL kode færdig således at den opfylder timingen til
-- PmodAD1 og giver et interface til en bruger - med mulighed for at starte en konvertering
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adc_interface is
    Port ( Clk :   in  STD_LOGIC;  -- System clock (50 MHz)
           Start : in  STD_LOGIC;  -- Start skift 0->1 starter en konvertering
           Done : out  STD_LOGIC;  -- Done=1 Angiver at konverteringen er færdig
			  SClk:  out  STD_LOGIC;  -- Seriel Clock til ADC
			  CS:    out  STD_LOGIC;  -- Chip Select til ADC (starter og stopper konverteringen)
			  D0:    in   STD_LOGIC;  -- Burde kaldes for D1 - data bit fra ADC0
			  D1:    in   STD_LOGIC;  -- Burde kaldes for D2 - data bit fra ADC1
           AD1 :  out  STD_LOGIC_VECTOR (11 downto 0);   -- 12 bit AD data #1
           AD2 :  out  STD_LOGIC_VECTOR (11 downto 0));  -- 12 bit AD data #2
end adc_interface;

architecture Behavioral of adc_interface is
	type   States is ( Reset,     -- Start tilstand første gang
	                   Idle, 	   -- Der ventes på Start signal
							 S0,        -- SClk <= '0'
							 S1,        -- SClk <= '1'
							 ADC_Done);	-- Indiker at ADc er færdig					
	signal State: States := Reset;
	
	signal Count: integer range 0 to 16 := 0;
	-- Midlertidige skifteregistere til modtagelse af databit fra D0 og D1
	signal Temp1, Temp2: STD_LOGIC_VECTOR( 11 downto 0) := "000000000000";
	
begin

   -- Denne process bruger en Finite state machine til overholde timingen og
	-- på den måde hente 2x12bit data fra PmodAD1
	adc_interface_process: process( Clk)
		Variable Scale: integer range 0 to 7; -- 12,5 MHz og 25 MHz ved Clk= 50 MHz
		VARIABLE bit_counter : INTEGER RANGE 0 TO 16 := 0;
	begin
		if rising_edge(Clk) then
			Scale := Scale + 1;
			if Scale > 3 then -- Nedscalering af Clk fra 50 MHz til 12,5 MHz (evt)
            Scale := 0;
				
				case State is
					when Reset =>
						CS   <= '1';
						Done <= '0';
						SClk <= '1';
						State <= Idle; --<<< Skift tilstand >>>
						
					--===== Afvent at en konvertering startes med Start='1'	
					when Idle =>
						IF (start = '1') THEN
							bit_counter := 0;
							CS <= '0';
							SClk <= '1';
							Done <= '0';
							State <= S0;
						END IF;
						
			      --====== Lav et SClk 1->0 skift ==============================
					-- Læs et databit fra D0 og D1 (skift databit i shriftreg.)
					when S0 =>
						
						Temp1 <= Temp1(10 DOWNTO 0) & D0;
						Temp2 <= Temp2(10 DOWNTO 0) & D1;
						bit_counter := bit_counter + 1;
						
						SClk <= '0';

						State <= S1; --<<< Skift tilstand >>>
					
			      --====== Lav et SClk 0->1 skift ==============================	
					-- Hold styr på hvor mange databit der er modtaget
					-- Send midtidlige registre ud som færdige data (2x12-bit)
					-- Sæt Done='1'
					when S1 =>
						SClk <= '1';
						
						IF (bit_counter = 16) THEN -- Konvertering færdig (4 nuller + 12 data bits)
							AD1 <= Temp1;
							AD2 <= Temp2;
							Done <= '1';
							CS <= '1';
							State <= ADC_Done;
						ELSE
							SClk <= '1';
							State <= S0;
						END IF;


					--======  Afvent at Start='0' ==================================	
					when ADC_Done =>
						if Start='0' then
							State <= Idle; --<<< Skift tilstand >>>
						end if;	
						
					when others =>
							State <= Reset;
				end case;	
			end if;
		end if;
	end process;
	
	
	
	
	
	
	
	
--							if Count=16 then
--							State <= ADC_Done; --<<< Skift tilstand >>>
--						else
--							State <= S0; --<<< Skift tilstand >>>
--						end if;
	
end Behavioral;
