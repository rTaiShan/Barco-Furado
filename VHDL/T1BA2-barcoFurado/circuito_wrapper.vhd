library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity circuito_wrapper is
	port (
		clock : in std_logic;
		jogar : in std_logic;
		botoes : in std_logic_vector(3 downto 0);
		dificuldade : in std_logic_vector(1 downto 0);
		reset : in std_logic;
		buracos_led : out std_logic_vector(3 downto 0);
		vitoria_led : out std_logic;
		derrota_led : out std_logic;
		db_estado : out std_logic_vector(6 downto 0);
		db_clock : out std_logic;
		nivel_agua_0, nivel_agua_1 : out std_logic_vector(6 downto 0)
	);
end entity;

architecture comportamental of circuito_wrapper is

	signal s_reseta_jogo, s_inicia_jogo, s_conta_regressivo, s_zera_contagem, s_led_select, s_fim_contagem, s_pronto : std_logic;

	component wrapper_uc is
		port (
			clock : in std_logic;
			reset : in std_logic;
			jogar : in std_logic;
			pronto : in std_logic;
			fim_contagem : in std_logic;
			led_select : out std_logic;
			reseta_jogo : out std_logic;
			inicia_jogo : out std_logic;
			conta_regressivo : out std_logic;
			zera_contagem : out std_logic
		);
	end component;

	component wrapper_df is
		port (
			clock : in std_logic;
			reset : in std_logic;
			iniciar : in std_logic;
			botoes : in std_logic_vector(3 downto 0);
			dificuldade : in std_logic_vector(1 downto 0);

			conta_regressivo : in std_logic;
			zera_contagem : in std_logic;
			led_select : in std_logic;

			buracos_led : out std_logic_vector(3 downto 0);
			vitoria_led : out std_logic;
			derrota_led : out std_logic;

			fim_contagem : out std_logic;
			pronto : out std_logic;

			db_estado : out std_logic_vector(6 downto 0);
			db_clock : out std_logic;
			nivel_agua_0, nivel_agua_1 : out std_logic_vector(6 downto 0)
		);
	end component;
begin

	db_clock <= clock;
	df : wrapper_df
	port map(
		clock => clock,
		reset => s_reseta_jogo,
		iniciar => s_inicia_jogo,
		botoes => botoes,
		dificuldade => dificuldade,

		conta_regressivo => s_conta_regressivo,
		zera_contagem => s_zera_contagem,
		led_select => s_led_select,

		buracos_led => buracos_led,
		vitoria_led => vitoria_led,
		derrota_led => derrota_led,

		fim_contagem => s_fim_contagem,
		pronto => s_pronto,
		nivel_agua_0 => nivel_agua_0,
		nivel_agua_1 => nivel_agua_1,
		db_estado => db_estado,
		db_clock => open
	);

	uc : wrapper_uc
	port map(
		clock => clock,
		reset => reset,
		jogar => jogar,
		pronto => s_pronto,
		led_select => s_led_select,
		fim_contagem => s_fim_contagem,
		reseta_jogo => s_reseta_jogo,
		inicia_jogo => s_inicia_jogo,
		conta_regressivo => s_conta_regressivo,
		zera_contagem => s_zera_contagem
	);
end architecture;