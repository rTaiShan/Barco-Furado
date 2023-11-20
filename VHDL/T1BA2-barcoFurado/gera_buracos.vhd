-- Arquivo   : gera_buracos.vhd
-- Projeto   : Semana 02 - Projeto do Jogo do Barco Furado
--------------------------------------------------------------------
-- Descricao : Componente do fluxo de dados do circuito
--             desenvolvido para a semana 2.
--------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     11/03/2023  1.0     Raul Tai          versao inicial
--------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;

entity gera_buracos is
	port(
		clock			 : in  std_logic;
		reset 		 : in  std_logic;
		enable 	    : in  std_logic;
		dificuldade  : in  std_logic_vector(1 downto 0);
		db_buracos_in: in  std_logic_vector(3 downto 0);
		db_buracos   : in  std_logic; -- Quando ativo, buracos <= db_buracos_in
		buracos		 : out std_logic_vector(3 downto 0);
		trocou_buraco : out std_logic
	);
end entity gera_buracos;

architecture comportamental of gera_buracos is
signal s_buracos : std_logic_vector(3 downto 0);
signal s_registra_buracos, s_move, s_add, s_zero_buracos, s_um_buraco, s_dois_buracos, s_faz_algo : std_logic;

component gera_buracos_df is
	port(
		clock			  	  : in  std_logic;
		reset				  : in  std_logic;
		registra_buracos : in  std_logic;
		move				  : in  std_logic;
		add				  : in  std_logic;
		dificuldade 	  : in  std_logic_vector(1 downto 0);
		buracos		  	  : out std_logic_vector(3 downto 0);
		zero_buracos  	  : out std_logic;
		um_buraco  	  	  : out std_logic;
		dois_buracos  	  : out std_logic;
		faz_algo			  : out std_logic;
		trocou_buraco    : out std_logic
	);
end component;


component gera_buracos_uc is
	port(
		clock			  	  : in  std_logic;
		reset 			  : in  std_logic;
		zero_buracos  	  : in  std_logic;
		um_buraco  	  	  : in  std_logic;
		dois_buracos  	  : in  std_logic;
		faz_algo			  : in  std_logic;
		registra_buracos : out std_logic;
		move				  : out std_logic;
		add				  : out std_logic
	);
end component;

begin

buracos <= db_buracos_in when db_buracos='1' and enable='1' else
			  s_buracos when db_buracos='0' and enable='1' else
			  "0000";

df : gera_buracos_df
	port map(
		clock => clock,
		reset => reset,
		registra_buracos => s_registra_buracos,
		move => s_move,
		add => s_add,
		dificuldade => dificuldade,
		buracos => s_buracos,
		zero_buracos => s_zero_buracos,
		um_buraco => s_um_buraco,
		dois_buracos => s_dois_buracos,
		faz_algo => s_faz_algo,
		trocou_buraco => trocou_buraco
	);
	
uc : gera_buracos_uc
	port map(
		clock => clock,
		reset => reset,
		registra_buracos => s_registra_buracos,
		move => s_move,
		add => s_add,
		zero_buracos => s_zero_buracos,
		um_buraco => s_um_buraco,
		dois_buracos => s_dois_buracos,
		faz_algo => s_faz_algo
	);

				  
end architecture;