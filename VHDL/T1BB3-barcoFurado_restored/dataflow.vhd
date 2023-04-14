--------------------------------------------------------------------
-- Arquivo   : dataflow.vhd
-- Projeto   : Semana 02 - Projeto do Jogo do Barco Furado
--------------------------------------------------------------------
-- Descricao : Fluxo de dados do circuito desenvolvido para
--             a semana 2, adaptado do circuito da semana 1.
--------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     11/03/2023  1.0     Raul Tai          versao inicial
--     17/03/2023  2.0     Vinicius Viana    adaptacao semana 2
--------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity dataflow is
	port(
		clock            : in  std_logic;
		reset				  : in  std_logic;
		jogando		     : in  std_logic;
		dificuldade      : in  std_logic_vector(1 downto 0);
		botoes           : in  std_logic_vector(3 downto 0);
		buracos_in 	     : in  std_logic_vector(3 downto 0);
		db_buracos		  : in std_logic; --Se ativo, buracos <= buracos_in
		zera_agua	     : in  std_logic;
		decrementa	 	 : in  std_logic;
		incrementa_1	 : in  std_logic;
		incrementa_2	 : in  std_logic;
		zera_tempo	     : in  std_logic;
	   buracos          : out std_logic_vector(3 downto 0);
		sem_buracos	     : out std_logic;
		um_buraco	     : out std_logic;
		varios_buracos   : out std_logic;
		fim_agua   	     : out std_logic;
		nivel_agua_0	 : out std_logic_vector(3 downto 0);
		nivel_agua_1	 : out std_logic_vector(3 downto 0);
		fim_tempo	     : out std_logic
	);
end entity dataflow;

architecture comportamental of dataflow is
	signal s_buracos, s_gera_buracos : std_logic_vector(3 downto 0);
	signal s_pulse: std_logic;

	component busca_buracos is 
		port(
		botoes       : in  std_logic_vector(3 downto 0);
		buracos 	 : in  std_logic_vector(3 downto 0);
		nao_tem		 : out std_logic;
		tem_um	  	 : out std_logic;
		tem_varios	 : out std_logic
	);
	end component;
	
	component contador_custom is
		generic (
        constant maxM: integer := 256 -- modulo maximo do contador
    );
    port (
        clock   	  : in  std_logic;
        zera_as 	  : in  std_logic;
        zera_s  	  : in  std_logic;
        incrementa_1  : in  std_logic;
	    incrementa_2  : in  std_logic;
	    decrementa    : in  std_logic;
	    dificuldade   : in  std_logic_vector(1 downto 0);
        Q       	  : out std_logic_vector(natural(ceil(log2(real(maxM)))) downto 0);
	    nivel_agua_0  : out std_logic_vector(3 downto 0);
	    nivel_agua_1  : out std_logic_vector(3 downto 0);
        fim     	  : out std_logic
    );
	 end component;
	 
	 component contador_m is
		 generic (
			  constant M: integer := 100 -- modulo do contador
		 );
		 port (
			  clock   : in  std_logic;
			  zera_as : in  std_logic;
			  zera_s  : in  std_logic;
			  conta   : in  std_logic;
			  Q       : out std_logic_vector(natural(ceil(log2(real(M))))-1 downto 0);
			  fim     : out std_logic;
			  meio    : out std_logic
		 );
	 end component;
	 
	 component gera_buracos is
		port(
			clock			 : in  std_logic;
			reset 		 : in  std_logic;
			enable 		 : in  std_logic;
			dificuldade  : in  std_logic_vector(1 downto 0);
			db_buracos_in: in  std_logic_vector(3 downto 0);
			db_buracos   : in  std_logic; -- Quando ativo, buracos <= db_buracos_in
			buracos		 : out std_logic_vector(3 downto 0)
		);
	end component;

begin
	buracos <= s_buracos;

	CONTA_TEMPO : contador_m
		generic map(
			--	M => 10000  -- Versão de debug (10 segundos)
			   M => 60000	
			)
		port map(
			clock   => clock,
			zera_as => zera_tempo, 
			zera_s  => '0', 
			conta   => '1',
			Q       => open,
			fim     => fim_tempo, 
			meio    => open
		);

	PULSE_GENERATOR: contador_m
	    generic map(
			    M => 32
		)	
		port map(
			clock   => clock,
			zera_as => zera_tempo,
			zera_s  => '0',
			conta   => '1',
			Q       => open,
			fim     => s_pulse,
			meio    => open
		);
		
	CONTA_AGUA : contador_custom
		generic map(
			maxM => 256
		)
		port map(
			clock => s_pulse,
			zera_as => zera_agua,
			zera_s => '0',
			incrementa_1 => incrementa_1,
			incrementa_2 => incrementa_2,
			decrementa  => decrementa,
			dificuldade => "00",
			Q => open,
			nivel_agua_0 => nivel_agua_0,
			nivel_agua_1 => nivel_agua_1,
			fim => fim_agua
		);
		
	BUSCA_FUROS : busca_buracos
		port map(
			botoes => botoes,
			buracos => s_buracos,
			nao_tem => sem_buracos,
			tem_um => um_buraco,
			tem_varios => varios_buracos
		);
		
	gerador : gera_buracos
		port map(
			clock => clock,
			reset => reset,
			enable => jogando,
			dificuldade => dificuldade,
			db_buracos_in => buracos_in,
			db_buracos => db_buracos, -- Quando ativo, buracos <= db_buracos_in
			buracos =>s_buracos
		);
end architecture;
