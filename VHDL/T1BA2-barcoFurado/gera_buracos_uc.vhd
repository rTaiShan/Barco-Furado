-- Arquivo   : gera_buracos_uc.vhd
-- Projeto   : Semana 02 - Projeto do Jogo do Barco Furado
--------------------------------------------------------------------
-- Descricao : Componente da unidade de controle do componente
--             gera_buracos.
--------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     11/03/2023  1.0     Raul Tai          versao inicial
--------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;

entity gera_buracos_uc is
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
end entity gera_buracos_uc;

architecture comportamental of gera_buracos_uc is
type t_estado is (inicial, e_move, e_add);
signal Eatual, Eprox: t_estado;


begin
	-- memoria de estado
    process (clock,reset)
    begin
        if reset='1' then
            Eatual <= inicial;
        elsif clock'event and clock = '1' then
            Eatual <= Eprox; 
        end if;
    end process;
	 
	 -- logica de transicao
	 Eprox <=
		inicial   when Eatual=inicial and faz_algo='0' else
		e_move    when Eatual=inicial and faz_algo='1' and dois_buracos='1' else
		e_add     when Eatual=inicial and faz_algo='1' and (zero_buracos='1' or um_buraco='1') else
		inicial;
	
	with Eatual select
        registra_buracos	<= '1' when e_move | e_add,
										'0' when others;
										
	with Eatual select
        move	<= '1' when e_move,
						'0' when others;
						
	with Eatual select
        add	<= '1' when e_add,
					'0' when others;
	
				  
end architecture;