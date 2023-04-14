-- Arquivo   : move_buraco.vhd
-- Projeto   : Semana 02 - Projeto do Jogo do Barco Furado
--------------------------------------------------------------------
-- Descricao : Componente do fluxo de dados do componente
--             gera_buracos.
--------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     11/03/2023  1.0     Raul Tai          versao inicial
--------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;

entity move_buraco is
	port(
		buracos_in			: in  std_logic_vector(3 downto 0);
		move_lsb            : in  std_logic; --Se ativo, move buraco do LSB
		para_onde			: in  std_logic_vector(1 downto 0); --seleciona a posicao de destino
		buracos_out			: out std_logic_vector(3 downto 0)

	);
end entity move_buraco;

architecture comportamental of move_buraco is
signal s_del_pos, s_add_pos : std_logic_vector(3 downto 0);
signal s_del, s_add			 : std_logic_vector(3 downto 0);

begin
	-- definindo buraco que sera movido
	s_del_pos <= "0001" when move_lsb='1' and buracos_in(0)='1' else
					 "1000" when move_lsb='0' and buracos_in(3)='1' else
					 "0010" when (move_lsb='0' and buracos_in="0011") or (move_lsb='1' and (buracos_in="0110" or buracos_in="1010")) else
					 "0100";
	
	-- definindo para onde o buraco ira
	with para_onde select
		s_add_pos <= "0001" when "00",
						 "0010" when "01",
						 "0100" when "10",
						 "1000" when others;
					 
	s_del <= buracos_in and (not s_del_pos);
	s_add <= s_del or s_add_pos;
	buracos_out <= s_add;
	
				  
end architecture;