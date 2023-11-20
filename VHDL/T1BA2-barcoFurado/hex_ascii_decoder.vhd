library ieee;
use ieee.std_logic_1164.all;

entity hex_ascii_decoder is
	port (
		hex : in std_logic_vector(3 downto 0);
		ascii : out std_logic_vector(6 downto 0)
	);
end entity;

architecture behavioral of hex_ascii_decoder is
begin
	with hex select
	ascii <= "0110000" when "0000", -- 0
				"0110001" when "0001", -- 1
				"0110010" when "0010", -- 2
				"0110011" when "0011", -- 3
				"0110100" when "0100", -- 4
				"0110101" when "0101", -- 5
				"0110110" when "0110", -- 6
				"0110111" when "0111", -- 7
				"0111000" when "1000", -- 8
				"0111001" when "1001", -- 9
				"1000001" when "1010", -- A
				"1000010" when "1011", -- B
				"1000011" when "1100", -- C
				"1000100" when "1101", -- D
				"1000101" when "1110", -- E
				"1000110" when "1111", -- F
				"0000000" when others;
end architecture;