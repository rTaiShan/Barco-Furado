library ieee;
use ieee.std_logic_1164.all;

entity detector_trapaca is
	port (
		clock : in std_logic;
		reset : in std_logic;
		trocou_buraco : in std_logic;
		botoes : in std_logic_vector(3 downto 0);
		buracos : in std_logic_vector(3 downto 0);
		tem_trapaca : out std_logic
	);
end entity;

architecture behavioral of detector_trapaca is

signal botoes_apertados, botoes_apertados_anteriormente, botoes_totais : std_logic_vector(3 downto 0);

begin
	botoes_apertados <= botoes and buracos; -- Botoes apertados com certeza: Buraco aberto E botao apertado
	botoes_totais <= botoes_apertados or botoes_apertados_anteriormente; -- Uniao dos botoes
	-- TODO IMPORTANTE: Adicionar delay entre verificação de cheat e abertura de buraco
	
	-- Operacao
	-- trocou_buraco = 1
	-- Aguarda abertura do servo
	-- Se (botoes apertados registrados + botoes apertados atualmente) possuir mais de 2 bits ativos, tem_trapaca = 1


end architecture;
