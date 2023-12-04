--------------------------------------------------------------------
-- Arquivo   : circuito_semana_1.vhd
-- Projeto   : Semana 01 - Projeto do Jogo do Barco Furado
--------------------------------------------------------------------
-- Descricao : Circuito desenvolvido para
--             a semana 1.
--------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     11/03/2023  1.0     Raul Tai          versao inicial
--------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;

entity circuito_semana_1 is 
	port(
		clock            : in  std_logic;
		reset            : in  std_logic;
		iniciar          : in  std_logic;
		jogar            : in  std_logic;
		dificuldade	 : in  std_logic_vector(1 downto 0);
		botoes           : in  std_logic_vector(3 downto 0);
		buracos_in 	 : in  std_logic_vector(3 downto 0);
		db_buracos		  : in std_logic;
		pronto           : out std_logic;
		vitoria          : out std_logic;
	   derrota          : out std_logic;
	   leds	         : out std_logic_vector(3 downto 0);
	   buzzer_i	 : out std_logic;
		nivel_agua_0	 : out std_logic_vector(6 downto 0);
		nivel_agua_1	 : out std_logic_vector(6 downto 0);
		db_estado        : out std_logic_vector(6 downto 0);
		db_clock	 : out std_logic;
		led_externo   : out std_logic_vector(3 downto 0);
		saida_serial : out std_logic
	);
end entity;

architecture comportamental of circuito_semana_1 is
	signal s_estado 	: std_logic_vector(3 downto 0);
	signal s_nivel_agua_0 	: std_logic_vector(3 downto 0);
	signal s_nivel_agua_1 	: std_logic_vector(3 downto 0);
	signal s_buracos 	: std_logic_vector(3 downto 0);
	signal s_zera_agua	: std_logic;
	signal s_decrementa	: std_logic;
	signal s_incrementa_1	: std_logic;
	signal s_incrementa_2	: std_logic;
	signal s_zera_tempo	: std_logic;
	signal s_sem_buracos	: std_logic;
	signal s_um_buraco	: std_logic;
	signal s_varios_buracos	: std_logic;
	signal s_fim_agua	: std_logic;
	signal s_fim_tempo	: std_logic;
	signal s_jogando		: std_logic;
	signal s_botoes: std_logic_vector(3 downto 0);
	signal s_buzzer_en: std_logic;
	signal s_vitoria, s_derrota : std_logic;
	signal s_contador_agua : std_logic_vector(7 downto 0);
	signal s_contador_tempo : std_logic_vector(11 downto 0);
	
	component hexa7seg is 
		port(
			hexa : in  std_logic_vector(3 downto 0);
			sseg : out std_logic_vector(6 downto 0)
      );
	end component;
	
	component dataflow is
		port(
			clock            : in  std_logic;
			reset			 : in  std_logic;
			jogando		 : in  std_logic;
			dificuldade	 : in  std_logic_vector(1 downto 0);
			botoes           : in  std_logic_vector(3 downto 0);
			buracos_in 	 : in  std_logic_vector(3 downto 0);
			db_buracos		  : in std_logic;
			zera_agua	 : in  std_logic;
			decrementa	 : in  std_logic;
			incrementa_1	 : in  std_logic;
			incrementa_2	 : in  std_logic;
			zera_tempo	 : in  std_logic;
			buzzer_en		 : in  std_logic;
			buzzer_i		 : out std_logic;
			buracos          : out std_logic_vector(3 downto 0);
			sem_buracos	 : out std_logic;
			um_buraco	 : out std_logic;
			varios_buracos   : out std_logic;
			fim_agua   	 : out std_logic;
			nivel_agua_0	 : out std_logic_vector(3 downto 0);
			nivel_agua_1	 : out std_logic_vector(3 downto 0);
			fim_tempo	 : out std_logic;
			contador_agua : out std_logic_vector(7 downto 0);
			contador_tempo : out std_logic_vector(11 downto 0)
		);
	end component;

	
	component unidade_controle is
		port(
			clock             : in  std_logic;
			iniciar           : in  std_logic;
			reset             : in  std_logic;
			sem_buracos	  : in  std_logic;
			um_buraco	  : in  std_logic;
			varios_buracos    : in  std_logic;
			fim_agua   	  : in  std_logic;
			fim_tempo	  : in  std_logic;
			pronto		  : out std_logic;
			vitoria		  : out std_logic;
			derrota		  : out std_logic;
			zera_agua	  : out std_logic;
			decrementa	  : out std_logic;
			incrementa_1	  : out std_logic;
			incrementa_2	  : out std_logic;
			zera_tempo	  : out std_logic;
			jogando 		  : out std_logic;
			buzzer_en	 : out std_logic;
			db_estado	  : out std_logic_vector(3 downto 0)
		);
	end component;
	
	component transmissor is
	port (
		clock : in std_logic;
		reset : in std_logic;
		jogar : in std_logic;
		vitoria : in std_logic;
		derrota : in std_logic;
		dificuldade : in std_logic_vector(1 downto 0);
		botoes : in std_logic_vector(3 downto 0);
		buracos : in std_logic_vector(3 downto 0);
		contador_tempo : in std_logic_vector(11 downto 0);
		contador_agua : in std_logic_vector(7 downto 0);
		saida_serial : out std_logic;
		db_saida_serial : out std_logic
	);
end component;

begin
	leds <= s_buracos;
	led_externo <= s_buracos;
	db_clock <= clock;
	--s_botoes <= not(botoes);
	s_botoes <= (botoes); -- depuração duração do jogo

	HEX_Estado : hexa7seg 
		port map(
			hexa => s_estado,
			sseg => db_estado
		);

	HEX_Nivel_Agua_0 : hexa7seg
		port map(
			hexa => s_nivel_agua_0,
			sseg => nivel_agua_0
		);

	HEX_Nivel_Agua_1 : hexa7seg
		port map(
			hexa => s_nivel_agua_1,
			sseg => nivel_agua_1
		);
		
	DF : dataflow
		port map(
			clock => clock,
			reset => reset,
			jogando => s_jogando,
			dificuldade => dificuldade,
			botoes => s_botoes,
			buracos_in => buracos_in,
			zera_agua => s_zera_agua,
			decrementa => s_decrementa,
			incrementa_1 => s_incrementa_1,
			incrementa_2 => s_incrementa_2,
			zera_tempo => s_zera_tempo,
			buzzer_en => s_buzzer_en,
			buzzer_i => buzzer_i,
			buracos => s_buracos,
			db_buracos => db_buracos,
			sem_buracos => s_sem_buracos,
			um_buraco => s_um_buraco,
			varios_buracos => s_varios_buracos,
			fim_agua => s_fim_agua,
			nivel_agua_0 => s_nivel_agua_0,
			nivel_agua_1 => s_nivel_agua_1,
			fim_tempo => s_fim_tempo,
			contador_agua => s_contador_agua,
			contador_tempo => s_contador_tempo
		);
		
	UC : unidade_controle
		port map(
			clock => clock,
			iniciar => iniciar,
			reset => reset,
			sem_buracos => s_sem_buracos,
			um_buraco => s_um_buraco,
			varios_buracos => s_varios_buracos,
			fim_agua => s_fim_agua,
			fim_tempo => s_fim_tempo,
			pronto => pronto,
			vitoria => s_vitoria,
			derrota => s_derrota,
			zera_agua => s_zera_agua,
			decrementa => s_decrementa,
			incrementa_1 => s_incrementa_1,
			incrementa_2 => s_incrementa_2,
			zera_tempo => s_zera_tempo,
			jogando => s_jogando,
			buzzer_en => s_buzzer_en,
			db_estado => s_estado
		);
		
	TX : transmissor 
	port map(
		clock => clock,
		reset => reset,
		jogar => jogar,
		vitoria => s_vitoria,
		derrota => s_derrota,
		dificuldade => dificuldade,
		botoes => s_botoes,
		buracos => s_buracos,
		contador_tempo => s_contador_tempo,
		contador_agua => s_contador_agua,
		saida_serial => saida_serial,
		db_saida_serial => open
	);
	
	vitoria <= s_vitoria;
	derrota <= s_derrota;

end architecture;
