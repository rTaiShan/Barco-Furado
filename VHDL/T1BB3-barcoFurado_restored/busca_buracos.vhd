--------------------------------------------------------------------
-- Arquivo   : busca_buracos.vhd
-- Projeto   : Semana 01 - Projeto do Jogo do Barco Furado
--------------------------------------------------------------------
-- Descricao : Componente do fluxo de dados do circuito
--             desenvolvido para a semana 1.
--------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     11/03/2023  1.0     Raul Tai          versao inicial
--------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;

entity busca_buracos is
	port(
		botoes           : in  std_logic_vector(3 downto 0);
		buracos 	 : in  std_logic_vector(3 downto 0);
		nao_tem		 : out std_logic;
		tem_um	         : out std_logic;
		tem_varios	 : out std_logic
	);
end entity busca_buracos;

architecture estrutural of busca_buracos is
signal buracos_abertos : std_logic_vector(3 downto 0);
signal s_nao_tem : std_logic;
signal s_tem_um  : std_logic;

begin
	nao_tem <= s_nao_tem;
	tem_um <= s_tem_um;
	buracos_abertos <= (buracos(3) and (not botoes(3))) & (buracos(2) and (not botoes(2))) & (buracos(1) and (not botoes(1))) & (buracos(0) and (not botoes(0)));
	
	s_nao_tem <= '1' when buracos_abertos="0000" else
				    '0';
				  
	s_tem_um <= '1' when (buracos_abertos="1000" or buracos_abertos="0100" or buracos_abertos="0010" or buracos_abertos="0001") else
					'0';
					
	tem_varios <= '1' when (s_nao_tem='0') and (s_tem_um='0') else
					  '0';
					  
end architecture;
