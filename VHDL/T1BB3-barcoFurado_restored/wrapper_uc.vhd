library ieee;
use ieee.std_logic_1164.all;

entity wrapper_uc is 
	port(
		clock        : in  std_logic;
		reset 		 : in  std_logic;
		jogar 		 : in  std_logic;
		pronto 		 : in  std_logic;
		fim_contagem : in std_logic;
		led_select 	 : out std_logic;
		reseta_jogo  	  : out  std_logic;
		inicia_jogo		  : out  std_logic;
		conta_regressivo : out  std_logic;
		zera_contagem : out  std_logic
	);
end entity;


architecture comportamental of wrapper_uc is
type t_estado is (inicial, aguarda_contagem, reseta, inicia, joga);
signal Eatual: t_estado := inicial;
signal Eprox: t_estado := inicial;


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
		inicial   when Eatual=inicial and jogar='0' else
		aguarda_contagem when Eatual=inicial and jogar='1' else
		aguarda_contagem when Eatual=aguarda_contagem and fim_contagem='0' else
		reseta when Eatual=aguarda_contagem and fim_contagem='1' else
		inicia when Eatual=reseta else
		joga when Eatual=inicia else
		joga when Eatual=joga and pronto='0' else
		inicial when Eatual=joga and pronto='1' else
		inicial;
		
	 with Eatual select
		reseta_jogo <= '1' when reseta,
							'0' when others;
							
	 
	 with Eatual select
		inicia_jogo <= '1' when inicia,
							'0' when others;
							
	 
	 with Eatual select
		conta_regressivo <= '1' when aguarda_contagem,
								  '0' when others;
								  
	 
	 with Eatual select
		 zera_contagem <= '0' when aguarda_contagem,
								'1' when others;
								
	 with Eatual select
		 led_select <= '1' when aguarda_contagem,
							'0' when others;
	
				  
end architecture;