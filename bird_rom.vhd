library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bird_rom is
    Port ( adr : in  STD_LOGIC_VECTOR (7 downto 0);
           dout : out  STD_LOGIC_VECTOR (7 downto 0));
end bird_rom;

architecture Behavioral of bird_rom is
  CONSTANT BACKGROUND : STD_LOGIC_VECTOR (7 DOWNTO 0) := "01001011";
  CONSTANT BLACK : STD_LOGIC_VECTOR (7 DOWNTO 0) := "00000000";
  CONSTANT WHITE : STD_LOGIC_VECTOR (7 DOWNTO 0) := "11111111";
  CONSTANT YELLOW : STD_LOGIC_VECTOR (7 DOWNTO 0) := "11111100";
  CONSTANT ORANGE : STD_LOGIC_VECTOR (7 DOWNTO 0) := "10110100";
  CONSTANT RED : STD_LOGIC_VECTOR (7 DOWNTO 0) := "11100000";
begin
  -- 17 x 12 pixels
  WITH adr SELECT
    -- Remember: Image starts with pixel 0
    dout <= BLACK WHEN "00000110", -- Line 0
            BLACK WHEN "00000111", 
            BLACK WHEN "00001000",
            BLACK WHEN "00001001",
            BLACK WHEN "00001010",
            BLACK WHEN "00001011",
            BLACK WHEN "00010101", -- Line 1
            BLACK WHEN "00010110",
            YELLOW WHEN "00010111",
            YELLOW WHEN "00011000",
            YELLOW WHEN "00011001",
            BLACK WHEN "00011010",
            WHITE WHEN "00011011",
            WHITE WHEN "00011100",
            BLACK WHEN "00011101",
            BLACK WHEN "00100101", -- Line 2
            YELLOW WHEN "00100110",
            YELLOW WHEN "00100111",
            YELLOW WHEN "00101000",
            YELLOW WHEN "00101001",
            BLACK WHEN "00101010",
            WHITE WHEN "00101011",
            WHITE WHEN "00101100",
            WHITE WHEN "00101101",
            WHITE WHEN "00101110",
            BLACK WHEN "00101111",
            BLACK WHEN "00110100", -- Line 3
            BLACK WHEN "00110101",
            BLACK WHEN "00110110",
            BLACK WHEN "00110111",
            YELLOW WHEN "00111000",
            YELLOW WHEN "00111001",
            YELLOW WHEN "00111010",
            BLACK WHEN "00111011",
            WHITE WHEN "00111100",
            WHITE WHEN "00111101",
            WHITE WHEN "00111110",
            BLACK WHEN "00111111",
            WHITE WHEN "01000000",
            BLACK WHEN "01000001",
            BLACK WHEN "01000100", -- Line 4
            WHITE WHEN "01000101",
            WHITE WHEN "01000110",
            WHITE WHEN "01000111",
            WHITE WHEN "01001000",
            BLACK WHEN "01001001",
            YELLOW WHEN "01001010",
            YELLOW WHEN "01001011",
            BLACK WHEN "01001100",
            WHITE WHEN "01001101",
            WHITE WHEN "01001110",
            WHITE WHEN "01001111",
            BLACK WHEN "01010000",
            WHITE WHEN "01010001",
            BLACK WHEN "01010010",
            BLACK WHEN "01010101", -- Line 5
            WHITE WHEN "01010110",
            WHITE WHEN "01010111",
            WHITE WHEN "01011000",
            WHITE WHEN "01011001",
            WHITE WHEN "01011010",
            BLACK WHEN "01011011",
            YELLOW WHEN "01011100",
            YELLOW WHEN "01011101",
            BLACK WHEN "01011110",
            WHITE WHEN "01011111",
            WHITE WHEN "01100000",
            WHITE WHEN "01100001",
            WHITE WHEN "01100010",
            BLACK WHEN "01100011",
            BLACK WHEN "01100110", -- Line 6
            YELLOW WHEN "01100111",
            WHITE WHEN "01101000",
            WHITE WHEN "01101001",
            WHITE WHEN "01101010",
            YELLOW WHEN "01101011",
            BLACK WHEN "01101100",
            YELLOW WHEN "01101101",
            YELLOW WHEN "01101110",
            YELLOW WHEN "01101111",
            BLACK WHEN "01110000",
            BLACK WHEN "01110001",
            BLACK WHEN "01110010",
            BLACK WHEN "01110011",
            BLACK WHEN "01110100",
            BLACK WHEN "01110101",
            BLACK WHEN "01111000", -- Line 7
            YELLOW WHEN "01111001",
            YELLOW WHEN "01111010",
            YELLOW WHEN "01111011",
            BLACK WHEN "01111100",
            YELLOW WHEN "01111101",
            YELLOW WHEN "01111110",
            YELLOW WHEN "01111111",
            BLACK WHEN "10000000",
            RED WHEN "10000001",
            RED WHEN "10000010",
            RED WHEN "10000011",
            RED WHEN "10000100",
            RED WHEN "10000101",
            RED WHEN "10000110",
            BLACK WHEN "10000111",
            BLACK WHEN "10001010", -- Line 8
            BLACK WHEN "10001011",
            BLACK WHEN "10001100",
            ORANGE WHEN "10001101",
            ORANGE WHEN "10001110",
            ORANGE WHEN "10001111",
            BLACK WHEN "10010000",
            RED WHEN "10010001",
            BLACK WHEN "10010010",
            BLACK WHEN "10010011",
            BLACK WHEN "10010100",
            BLACK WHEN "10010101",
            BLACK WHEN "10010110",
            BLACK WHEN "10010111",
            BLACK WHEN "10011011", --Line 9 (10011011)
            ORANGE WHEN "10011100",
            ORANGE WHEN "10011101",
            ORANGE WHEN "10011110",
            ORANGE WHEN "10011111",
            ORANGE WHEN "10100000",
            ORANGE WHEN "10100001",
            BLACK WHEN "10100010",
            RED WHEN "10100011",
            RED WHEN "10100100",
            RED WHEN "10100101",
            RED WHEN "10100110",
            RED WHEN "10100111",
            BLACK WHEN "10101000",
            BLACK WHEN "10101101", -- Line 10 (10101101)
            BLACK WHEN "10101110",
            ORANGE WHEN "10101111",
            ORANGE WHEN "10110000",
            ORANGE WHEN "10110001",
            ORANGE WHEN "10110010",
            ORANGE WHEN "10110011",
            BLACK WHEN "10110100",
            BLACK WHEN "10110101",
            BLACK WHEN "10110110",
            BLACK WHEN "10110111",
            BLACK WHEN "10111000",
            BLACK WHEN "11000000", -- Line 11
            BLACK WHEN "11000001",
            BLACK WHEN "11000010",
            BLACK WHEN "11000011",
            BLACK WHEN "11000100",
            BACKGROUND WHEN OTHERS;
    

end Behavioral;

