--------------------------------------------------------------------
-- Arquivo   : unidade_controle.vhd
-- Projeto   : Semana 01 - Projeto do Jogo do Barco Furado
--------------------------------------------------------------------
-- Descricao : Unidade de controle do circuito desenvolvido para
--             a semana 1.
--------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     11/03/2023  1.0     Raul Tai          versao inicial
--------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle is
	port(
		clock            : in  std_logic;
		iniciar          : in  std_logic;
		reset            : in  std_logic;
		sem_buracos      : in  std_logic;
		um_buraco	 : in  std_logic;
		varios_buracos   : in  std_logic;
		fim_agua   	 : in  std_logic;
		fim_tempo        : in  std_logic;
		pronto		 : out std_logic;
		vitoria		 : out std_logic;
		derrota		 : out std_logic;
		zera_agua	 : out std_logic;
		decrementa	 : out std_logic;
		incrementa_1	 : out std_logic;
		incrementa_2	 : out std_logic;
		zera_tempo	 : out std_logic;
		jogando      : out std_logic;
		db_estado	 : out std_logic_vector(3 downto 0)
	);
end entity unidade_controle;

architecture comportamental of unidade_controle is
	type t_estado is (inicial, inicializa_elementos, em_jogo, final_vitoria, final_derrota);
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
	
	-- logica de proximo estado
	Eprox <=
                  inicial               when  Eatual=inicial and iniciar='0' else
		  inicializa_elementos  when  Eatual=inicial and iniciar='1' else
		  em_jogo 		when  Eatual=inicializa_elementos else
		  em_jogo		when  Eatual=em_jogo and (fim_tempo or fim_agua)='0' else
		  final_vitoria 	when  Eatual=em_jogo and fim_tempo='1' else
		  final_derrota 	when  Eatual=em_jogo and fim_agua='1' else
		  final_vitoria	        when  Eatual=final_vitoria and iniciar='0' else
                  inicializa_elementos  when  Eatual=final_vitoria and iniciar='1' else
	          final_derrota         when  Eatual=final_derrota and iniciar='0' else
	          inicializa_elementos  when  Eatual=final_derrota and iniciar='1' else
		  inicial;
	
	-- logica de saída
	with Eatual select
        pronto     <=  '1' when final_vitoria | final_derrota,
                       '0' when others;
	with Eatual select
        vitoria    <=  '1' when final_vitoria,
                       '0' when others;
	with Eatual select
        derrota    <=  '1' when final_derrota,
                       '0' when others;
	with Eatual select
        zera_agua  <=  '1' when inicializa_elementos,
                       '0' when others;
							 
	with Eatual select
        zera_tempo <=  '1' when inicializa_elementos,
                       '0' when others;
                       
        with Eatual select
        decrementa <= sem_buracos when em_jogo,
                       '0' when others;
                      
        with Eatual select
	incrementa_1 <= um_buraco when em_jogo,
	               '0' when others;
	               
	with Eatual select
	incrementa_2 <= varios_buracos when em_jogo,
	              '0' when others;
					  
	with Eatual select
	jogando <= '1' when em_jogo,
				  '0' when others;
	
	-- saida de depuracao (db_estado)
	with Eatual select
        db_estado  <=  "0000" when inicial,		  --0 -> 0, comeco
		       "0101" when final_vitoria,         --5 -> S, Sucesso
		       "1101" when final_derrota,         --D -> D, Derrota
                       "0001" when others;		  --1	-> "Un", Undefined

end architecture;


			
